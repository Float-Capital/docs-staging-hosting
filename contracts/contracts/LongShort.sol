// SPDX-License-Identifier: BUSL-1.1

pragma solidity 0.8.3;

import "hardhat/console.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

import "./interfaces/ITokenFactory.sol";
import "./interfaces/ISyntheticToken.sol";
import "./interfaces/IStaker.sol";
import "./interfaces/ILongShort.sol";
import "./interfaces/IYieldManager.sol";
import "./interfaces/IOracleManager.sol";

/**
 * @dev {LongShort} contract:
 **** visit https://float.capital *****
 *  - Ability for users to create synthetic long and short positions on value movements
 *  - Value movements could be derived from tradional or alternative asset classes, derivates, binary outcomes, etc...
 *  - Incentive mechansim providing fees to liquidity makers (users on both sides of order book)
 */
contract LongShort is ILongShort, Initializable {
    ////////////////////////////////////
    //////// VARIABLES /////////////////
    ////////////////////////////////////

    // Global state.
    address public admin; // This will likely be the Gnosis safe
    uint32 public latestMarket;
    mapping(uint32 => bool) public marketExists;

    // Treasury contract that accrued fees and yield are sent to.
    address public treasury;

    // Factory for dynamically creating synthetic long/short tokens.
    ITokenFactory public tokenFactory;

    // Staker for controlling governance token issuance.
    IStaker public staker;
    uint256[45] private __globalStateGap;

    // Fixed-precision constants.
    address public constant DEAD_ADDRESS =
        0xf10A7_F10A7_f10A7_F10a7_F10A7_f10a7_F10A7_f10a7;
    uint256 public constant TEN_TO_THE_18 = 1e18;
    int256 public constant TEN_TO_THE_18_SIGNED = 1e18;
    uint256 public constant feeUnitsOfPrecision = 10000;
    uint256[45] private __constantsGap;

    // Market state.
    mapping(MarketSide => mapping(uint32 => uint256))
        public syntheticTokenBackedValue;
    mapping(uint32 => uint256) public totalValueLockedInYieldManager;
    mapping(uint32 => uint256) public totalValueReservedForTreasury;
    mapping(uint32 => uint256) public assetPrice;
    mapping(MarketSide => mapping(uint32 => uint256))
        public syntheticTokenPrice; // NOTE: cannot deprecate this value and use the mintPriceSnapshot values instead since these values change inbetween assetPrice updates (when yield is collected)
    mapping(uint32 => IERC20) public fundTokens;
    mapping(uint32 => IYieldManager) public yieldManagers;
    mapping(uint32 => IOracleManager) public oracleManagers;
    uint256[45] private __marketStateGap;

    // Synthetic long/short tokens users can mint and redeem.
    mapping(MarketSide => mapping(uint32 => ISyntheticToken))
        public syntheticTokens;
    uint256[45] private __marketSynthsGap;

    // Fees for minting/redeeming long/short tokens. Users are penalised
    // with extra fees for imbalancing the market.
    mapping(uint32 => uint256) public baseEntryFee;
    mapping(uint32 => uint256) public badLiquidityEntryFee;
    mapping(uint32 => uint256) public baseExitFee;
    mapping(uint32 => uint256) public badLiquidityExitFee;
    uint256[45] private __feeInfo;

    // The following 3 values update with every price update
    mapping(uint32 => uint256) public latestUpdateIndex;
    // These two can be grouped together in a struct
    mapping(uint32 => mapping(uint256 => mapping(MarketSide => uint256)))
        public mintPriceSnapshot;
    mapping(uint32 => mapping(uint256 => mapping(MarketSide => uint256)))
        public redeemPriceSnapshot;

    // These two can be grouped together in a struct
    mapping(uint32 => mapping(MarketSide => uint256))
        public batchedLazyPaymentTokenToDeposit;
    mapping(uint32 => mapping(MarketSide => uint256))
        public batchedLazySynthToRedeem;

    mapping(uint32 => mapping(address => mapping(MarketSide => uint256)))
        public userLazyRedemptions;
    mapping(uint32 => mapping(address => mapping(MarketSide => uint256)))
        public userLazyDepositAmounts;
    mapping(uint32 => mapping(address => uint256))
        public userCurrentLazyUpdateIndex;

    ////////////////////////////////////
    /////////// EVENTS /////////////////
    ////////////////////////////////////

    event V1(
        address admin,
        address treasury,
        address tokenFactory,
        address staker
    );

    // TODO: make sure this is emmited for batched actions too!
    event ValueLockedInSystem(
        uint32 marketIndex,
        uint256 totalValueLockedInMarket,
        uint256 longValue,
        uint256 shortValue
    );

    event TokenPriceRefreshed(
        uint32 marketIndex,
        uint256 longTokenPrice,
        uint256 shortTokenPrice
    );

    event FeesLevied(uint32 marketIndex, uint256 totalFees);

    event SyntheticTokenCreated(
        uint32 marketIndex,
        address longTokenAddress,
        address shortTokenAddress,
        address fundToken,
        uint256 assetPrice,
        string name,
        string symbol,
        address oracleAddress
    );

    event PriceUpdate(
        uint32 marketIndex,
        uint256 oldPrice,
        uint256 newPrice,
        address user
    );

    event LazyMinted(
        uint32 marketIndex,
        MarketSide syntheticTokenType,
        uint256 depositAdded,
        address user,
        uint256 oracleUpdateIndex
    );

    event FeesChanges(
        uint32 marketIndex,
        uint256 baseEntryFee,
        uint256 badLiquidityEntryFee,
        uint256 baseExitFee,
        uint256 badLiquidityExitFee
    );

    event OracleUpdated(
        uint32 marketIndex,
        address oldOracleAddress,
        address newOracleAddress
    );

    ////////////////////////////////////
    /////////// MODIFIERS //////////////
    ////////////////////////////////////

    /**
     * Necessary to update system state before any contract actions (deposits / withdraws)
     */

    modifier adminOnly() {
        require(msg.sender == admin, "only admin");
        _;
    }

    modifier treasuryOnly() {
        require(msg.sender == treasury, "only treasury");
        _;
    }

    modifier assertMarketExists(uint32 marketIndex) {
        require(marketExists[marketIndex], "market doesn't exist");
        _;
    }

    modifier isCorrectSynth(
        uint32 marketIndex,
        MarketSide syntheticTokenType,
        ISyntheticToken syntheticToken
    ) {
        if (syntheticTokenType == ILongShort.MarketSide.Long) {
            require(
                syntheticTokens[MarketSide.Long][marketIndex] == syntheticToken,
                "Incorrect synthetic token"
            );
        } else {
            require(
                syntheticTokens[MarketSide.Short][marketIndex] ==
                    syntheticToken,
                "Incorrect synthetic token"
            );
        }
        _;
    }

    ////////////////////////////////////
    ///// CONTRACT SET-UP //////////////
    ////////////////////////////////////

    function initialize(
        address _admin,
        address _treasury,
        ITokenFactory _tokenFactory,
        IStaker _staker
    ) public initializer {
        admin = _admin;
        treasury = _treasury;
        tokenFactory = _tokenFactory;
        staker = _staker;

        emit V1(
            _admin,
            address(treasury),
            address(_tokenFactory),
            address(_staker)
        );
    }

    ////////////////////////////////////
    /// MULTISIG ADMIN FUNCTIONS ///////
    ////////////////////////////////////

    function changeAdmin(address _admin) external adminOnly {
        admin = _admin;
    }

    function changeTreasury(address _treasury) external adminOnly {
        treasury = _treasury;
    }

    function changeFees(
        uint32 marketIndex,
        uint256 _baseEntryFee,
        uint256 _badLiquidityEntryFee,
        uint256 _baseExitFee,
        uint256 _badLiquidityExitFee
    ) external adminOnly {
        _changeFees(
            marketIndex,
            _baseEntryFee,
            _baseExitFee,
            _badLiquidityEntryFee,
            _badLiquidityExitFee
        );
    }

    function _changeFees(
        uint32 marketIndex,
        uint256 _baseEntryFee,
        uint256 _badLiquidityEntryFee,
        uint256 _baseExitFee,
        uint256 _badLiquidityExitFee
    ) internal {
        baseEntryFee[marketIndex] = _baseEntryFee;
        baseExitFee[marketIndex] = _baseExitFee;
        badLiquidityEntryFee[marketIndex] = _badLiquidityEntryFee;
        badLiquidityExitFee[marketIndex] = _badLiquidityExitFee;

        emit FeesChanges(
            latestMarket,
            _baseEntryFee,
            _badLiquidityEntryFee,
            _baseExitFee,
            _badLiquidityExitFee
        );
    }

    /**
     * Update oracle for a market
     */
    function updateMarketOracle(uint32 marketIndex, address _newOracleManager)
        external
        adminOnly
    {
        // If not a oracle contract this would break things.. Test's arn't validating this
        // Ie require isOracle interface - ERC165
        address previousOracleManager = address(oracleManagers[marketIndex]);
        oracleManagers[marketIndex] = IOracleManager(_newOracleManager);
        emit OracleUpdated(
            marketIndex,
            previousOracleManager,
            _newOracleManager
        );
    }

    /**
     * Creates an entirely new long/short market tracking an underlying
     * oracle price. Make sure the synthetic names/symbols are unique.
     */
    function newSyntheticMarket(
        string calldata syntheticName,
        string calldata syntheticSymbol,
        address _fundToken,
        address _oracleManager,
        address _yieldManager
    ) external adminOnly {
        latestMarket++;

        // Create new synthetic long token.
        syntheticTokens[MarketSide.Long][latestMarket] = ISyntheticToken(
            tokenFactory.createTokenLong(
                syntheticName,
                syntheticSymbol,
                staker,
                latestMarket
            )
        );

        // Create new synthetic short token.
        syntheticTokens[MarketSide.Short][latestMarket] = ISyntheticToken(
            tokenFactory.createTokenShort(
                syntheticName,
                syntheticSymbol,
                staker,
                latestMarket
            )
        );

        // Initial market state.
        syntheticTokenPrice[MarketSide.Long][latestMarket] = TEN_TO_THE_18;
        syntheticTokenPrice[MarketSide.Short][latestMarket] = TEN_TO_THE_18;
        fundTokens[latestMarket] = IERC20(_fundToken);
        yieldManagers[latestMarket] = IYieldManager(_yieldManager);
        oracleManagers[latestMarket] = IOracleManager(_oracleManager);
        assetPrice[latestMarket] = uint256(
            oracleManagers[latestMarket].updatePrice()
        );

        emit SyntheticTokenCreated(
            latestMarket,
            address(syntheticTokens[MarketSide.Long][latestMarket]),
            address(syntheticTokens[MarketSide.Short][latestMarket]),
            _fundToken,
            assetPrice[latestMarket],
            syntheticName,
            syntheticSymbol,
            _oracleManager
        );
    }

    function seedMarketInitially(uint256 initialMarketSeed, uint32 marketIndex)
        internal
    {
        require(
            // You require at least 10^17 of the underlying payment token to seed the market.
            initialMarketSeed > 0.1 ether,
            "Insufficient value to seed the market"
        );

        _lockFundsInMarket(marketIndex, initialMarketSeed * 2);

        syntheticTokens[MarketSide.Long][marketIndex].mint(
            DEAD_ADDRESS,
            initialMarketSeed
        );
        syntheticTokens[MarketSide.Short][marketIndex].mint(
            DEAD_ADDRESS,
            initialMarketSeed
        );

        syntheticTokenBackedValue[MarketSide.Long][
            marketIndex
        ] = initialMarketSeed;
        syntheticTokenBackedValue[MarketSide.Short][
            marketIndex
        ] = initialMarketSeed;

        // TODO: add suitable event here! (something about initializing the market)
    }

    function initializeMarket(
        uint32 marketIndex,
        uint256 _baseEntryFee,
        uint256 _badLiquidityEntryFee,
        uint256 _baseExitFee,
        uint256 _badLiquidityExitFee,
        uint256 kInitialMultiplier,
        uint256 kPeriod,
        uint256 initialMarketSeed
    ) external adminOnly {
        require(!marketExists[marketIndex] && marketIndex <= latestMarket);

        marketExists[marketIndex] = true;

        _changeFees(
            marketIndex,
            _baseEntryFee,
            _baseExitFee,
            _badLiquidityEntryFee,
            _badLiquidityExitFee
        );

        // Add new staker funds with fresh synthetic tokens.
        staker.addNewStakingFund(
            latestMarket,
            syntheticTokens[MarketSide.Long][marketIndex],
            syntheticTokens[MarketSide.Short][marketIndex],
            kInitialMultiplier,
            kPeriod
        );

        seedMarketInitially(initialMarketSeed, marketIndex);
    }

    ////////////////////////////////////
    //////// HELPER FUNCTIONS //////////
    ////////////////////////////////////

    function getOtherSynthType(MarketSide synthTokenType)
        internal
        view
        returns (MarketSide)
    {
        if (synthTokenType == MarketSide.Long) {
            return MarketSide.Short;
        } else {
            return MarketSide.Long;
        }
    }

    /**
     * Returns the amount of accrued value that should go to the market,
     * and the amount that should be locked into the treasury. To incentivise
     * market balance, more value goes to the market in proportion to how
     * imbalanced it is.
     */
    function getTreasurySplit(uint32 marketIndex, uint256 amount)
        public
        view
        returns (uint256 marketAmount, uint256 treasuryAmount)
    {
        uint256 marketPcnt; // fixed-precision scale of 10000

        uint256 totalValueLockedInMarket =
            syntheticTokenBackedValue[MarketSide.Long][marketIndex] +
                syntheticTokenBackedValue[MarketSide.Short][marketIndex];

        if (
            syntheticTokenBackedValue[MarketSide.Long][marketIndex] >
            syntheticTokenBackedValue[MarketSide.Short][marketIndex]
        ) {
            marketPcnt =
                ((syntheticTokenBackedValue[MarketSide.Long][marketIndex] -
                    syntheticTokenBackedValue[MarketSide.Short][marketIndex]) *
                    10000) /
                totalValueLockedInMarket;
        } else {
            marketPcnt =
                ((syntheticTokenBackedValue[MarketSide.Short][marketIndex] -
                    syntheticTokenBackedValue[MarketSide.Long][marketIndex]) *
                    10000) /
                totalValueLockedInMarket;
        }

        marketAmount = (marketPcnt * amount) / 10000;
        treasuryAmount = amount - marketAmount;
        require(amount == marketAmount + treasuryAmount);

        return (marketAmount, treasuryAmount);
    }

    function getPrice(uint256 amountSynth, uint256 amountPaymentToken)
        internal
        pure
        returns (uint256)
    {
        return (amountPaymentToken * TEN_TO_THE_18) / amountSynth;
    }

    function getAmountPaymentToken(uint256 amountSynth, uint256 price)
        internal
        pure
        returns (uint256)
    {
        return (amountSynth * price) / TEN_TO_THE_18;
    }

    function getAmountSynthToken(uint256 amountPaymentToken, uint256 price)
        internal
        pure
        returns (uint256)
    {
        return (amountPaymentToken * TEN_TO_THE_18) / price;
    }

    /**
     * Returns the amount of accrued value that should go to each side of the
     * market. To incentivise balance, more value goes to the weaker side in
     * proportion to how imbalanced the market is.
     */
    function getMarketSplit(uint32 marketIndex, uint256 amount)
        public
        view
        returns (uint256 longAmount, uint256 shortAmount)
    {
        // The percentage value that a position receives depends on the amount
        // of total market value taken up by the _opposite_ position.
        uint256 longPcnt =
            (syntheticTokenBackedValue[MarketSide.Short][marketIndex] * 10000) /
                (syntheticTokenBackedValue[MarketSide.Long][marketIndex] +
                    syntheticTokenBackedValue[MarketSide.Short][marketIndex]);

        longAmount = (amount * longPcnt) / 10000;
        shortAmount = amount - longAmount;
        return (longAmount, shortAmount);
    }

    /**
     * Adjusts the long/short token prices according to supply and value.
     */
    function _refreshTokenPrices(uint32 marketIndex) internal {
        uint256 longTokenSupply =
            syntheticTokens[MarketSide.Long][marketIndex].totalSupply();

        // supply should never be zero and burn address will always own a small amount
        if (longTokenSupply > 0) {
            syntheticTokenPrice[MarketSide.Long][marketIndex] =
                (syntheticTokenBackedValue[MarketSide.Long][marketIndex] *
                    TEN_TO_THE_18) /
                longTokenSupply;
        }

        uint256 shortTokenSupply =
            syntheticTokens[MarketSide.Short][marketIndex].totalSupply();
        if (shortTokenSupply > 0) {
            syntheticTokenPrice[MarketSide.Short][marketIndex] =
                (syntheticTokenBackedValue[MarketSide.Short][marketIndex] *
                    TEN_TO_THE_18) /
                shortTokenSupply;
        }

        emit TokenPriceRefreshed(
            marketIndex,
            syntheticTokenPrice[MarketSide.Long][marketIndex],
            syntheticTokenPrice[MarketSide.Short][marketIndex]
        );
    }

    function _distributeMarketAmount(uint32 marketIndex, uint256 marketAmount)
        internal
    {
        // Splits mostly to the weaker position to incentivise balance.
        (uint256 longAmount, uint256 shortAmount) =
            getMarketSplit(marketIndex, marketAmount);
        syntheticTokenBackedValue[MarketSide.Long][marketIndex] += longAmount;
        syntheticTokenBackedValue[MarketSide.Short][marketIndex] += shortAmount;
    }

    /**
     * Controls what happens with mint/redeem fees.
     */
    // NOTE: only used in `handleBatchedLazyRedeems`
    function _feesMechanism(uint32 marketIndex, uint256 totalFees) internal {
        // Market gets a bigger share if the market is more imbalanced.
        (uint256 marketAmount, uint256 treasuryAmount) =
            getTreasurySplit(marketIndex, totalFees);

        totalValueReservedForTreasury[marketIndex] += treasuryAmount;

        _distributeMarketAmount(marketIndex, marketAmount);
        emit FeesLevied(marketIndex, totalFees);
    }

    /**
     * Controls what happens with accrued yield manager interest.
     */
    function _claimAndDistributeYield(uint32 marketIndex) internal {
        uint256 amount =
            yieldManagers[marketIndex].getTotalHeld() -
                totalValueLockedInYieldManager[marketIndex];

        if (amount > 0) {
            (uint256 marketAmount, uint256 treasuryAmount) =
                getTreasurySplit(marketIndex, amount);

            // We keep the interest locked in the yield manager, but update our
            // bookkeeping to logically simulate moving the funds around.
            totalValueLockedInYieldManager[marketIndex] += amount;
            totalValueReservedForTreasury[marketIndex] += treasuryAmount;

            _distributeMarketAmount(marketIndex, marketAmount);
        }
    }

    function _minimum(uint256 A, uint256 B) internal view returns (int256) {
        if (A < B) {
            return int256(A);
        } else {
            return int256(B);
        }
    }

    function _adjustMarketBasedOnNewAssetPrice(
        uint32 marketIndex,
        int256 newAssetPrice
    ) internal returns (bool didUpdate) {
        int256 oldAssetPrice = int256(assetPrice[marketIndex]);

        if (oldAssetPrice == newAssetPrice) {
            return false;
        }

        int256 min =
            _minimum(
                syntheticTokenBackedValue[MarketSide.Long][marketIndex],
                syntheticTokenBackedValue[MarketSide.Short][marketIndex]
            );

        int256 percentageChangeE18 =
            ((newAssetPrice - oldAssetPrice) * TEN_TO_THE_18_SIGNED) /
                oldAssetPrice;

        int256 valueChange = (percentageChangeE18 * min) / TEN_TO_THE_18_SIGNED;

        if (valueChange > 0) {
            syntheticTokenBackedValue[MarketSide.Long][marketIndex] += uint256(
                valueChange
            );
            syntheticTokenBackedValue[MarketSide.Short][marketIndex] -= uint256(
                valueChange
            );
        } else {
            syntheticTokenBackedValue[MarketSide.Long][marketIndex] -= uint256(
                valueChange * -1
            );
            syntheticTokenBackedValue[MarketSide.Short][marketIndex] += uint256(
                valueChange * -1
            );
        }

        return true;
    }

    function handleBatchedDepositSettlement(
        uint32 marketIndex,
        MarketSide syntheticTokenType
    ) internal {
        // Deposit funds and compute fees.

        uint256 amountToBatchDeposit =
            batchedLazyPaymentTokenToDeposit[marketIndex][syntheticTokenType];
        if (amountToBatchDeposit > 0) {
            batchedLazyPaymentTokenToDeposit[marketIndex][
                syntheticTokenType
            ] = 0;
            _transferFundsToYieldManager(marketIndex, amountToBatchDeposit);

            // Mint long tokens with remaining value.
            uint256 numberOfTokens =
                (amountToBatchDeposit * TEN_TO_THE_18) /
                    syntheticTokenPrice[syntheticTokenType][marketIndex];

            // TODO STENT there are no token mint events emitted here, but there are on market initialization
            syntheticTokens[syntheticTokenType][marketIndex].mint(
                address(this),
                numberOfTokens
            );

            syntheticTokenBackedValue[syntheticTokenType][
                marketIndex
            ] += amountToBatchDeposit;

            //TODO: Can remove these sanity checks at some point
            uint256 oldTokenLongPrice =
                syntheticTokenPrice[MarketSide.Long][marketIndex];
            uint256 oldTokenShortPrice =
                syntheticTokenPrice[MarketSide.Short][marketIndex];

            // NOTE: no fees are calculated, but if they are desired in the future they can be added here.
            // Distribute fees across the market.
            // TODO STENT CONCERN1
            _refreshTokenPrices(marketIndex);

            assert(
                syntheticTokenPrice[MarketSide.Long][marketIndex] ==
                    oldTokenLongPrice
            );
            assert(
                syntheticTokenPrice[MarketSide.Short][marketIndex] ==
                    oldTokenShortPrice
            );
        }
    }

    function snapshotPriceChangeForNextPriceExecution(uint32 marketIndex)
        internal
    {
        uint256 newLatestPriceStateIndex = latestUpdateIndex[marketIndex] + 1;
        latestUpdateIndex[marketIndex] = newLatestPriceStateIndex;

        // NOTE: we can't just merge these two values since the 'yield' has an effect on the token price inbetween oracle updates.
        mintPriceSnapshot[marketIndex][newLatestPriceStateIndex][
            MarketSide.Long
        ] = syntheticTokenPrice[MarketSide.Long][marketIndex];
        mintPriceSnapshot[marketIndex][newLatestPriceStateIndex][
            MarketSide.Short
        ] = syntheticTokenPrice[MarketSide.Short][marketIndex];
    }

    /**
     * Updates the value of the long and short sides within the system
     * Note this is public. Anyone can call this function.
     */
    function _updateSystemStateInternal(uint32 marketIndex)
        internal
        assertMarketExists(marketIndex)
    {
        // This is called right before any state change!
        // So reward rate can be calculated just in time by
        // staker without needing to be saved
        staker.addNewStateForFloatRewards(
            marketIndex,
            syntheticTokenPrice[MarketSide.Long][marketIndex],
            syntheticTokenPrice[MarketSide.Short][marketIndex],
            syntheticTokenBackedValue[MarketSide.Long][marketIndex],
            syntheticTokenBackedValue[MarketSide.Short][marketIndex]
        );

        assert(
            syntheticTokenBackedValue[MarketSide.Long][marketIndex] != 0 &&
                syntheticTokenBackedValue[MarketSide.Short][marketIndex] != 0
        );

        // Distibute accrued yield first based on current liquidity before price update
        _claimAndDistributeYield(marketIndex);

        // If a negative int is return this should fail.
        int256 newAssetPrice = oracleManagers[marketIndex].updatePrice();

        // TODO STENT move this into the price function
        emit PriceUpdate(
            marketIndex,
            assetPrice[marketIndex],
            uint256(newAssetPrice),
            msg.sender
        );

        // Adjusts long and short values based on price movements.
        bool priceChanged =
            _adjustMarketBasedOnNewAssetPrice(marketIndex, newAssetPrice);

        // TODO STENT CONCERN1
        _refreshTokenPrices(marketIndex);
        assetPrice[marketIndex] = uint256(newAssetPrice);

        if (priceChanged) {
            snapshotPriceChangeForNextPriceExecution(marketIndex);

            handleBatchedDepositSettlement(marketIndex, MarketSide.Long);
            handleBatchedDepositSettlement(marketIndex, MarketSide.Short);
            handleBatchedLazyRedeems(marketIndex);
        }

        emit ValueLockedInSystem(
            marketIndex,
            syntheticTokenBackedValue[MarketSide.Long][marketIndex] +
                syntheticTokenBackedValue[MarketSide.Short][marketIndex],
            syntheticTokenBackedValue[MarketSide.Long][marketIndex],
            syntheticTokenBackedValue[MarketSide.Short][marketIndex]
        );
    }

    function _updateSystemState(uint32 marketIndex) external override {
        _updateSystemStateInternal(marketIndex);
    }

    function _updateSystemStateMulti(uint32[] calldata marketIndexes)
        external
        override
    {
        for (uint256 i = 0; i < marketIndexes.length; i++) {
            _updateSystemStateInternal(marketIndexes[i]);
        }
    }

    function _depositFunds(uint32 marketIndex, uint256 amount) internal {
        fundTokens[marketIndex].transferFrom(msg.sender, address(this), amount);
    }

    // NOTE: Only used in seeding the market.
    function _lockFundsInMarket(uint32 marketIndex, uint256 amount) internal {
        _depositFunds(marketIndex, amount);
        _transferFundsToYieldManager(marketIndex, amount);
    }

    /*
     * Returns locked funds from the market to the sender.
     */
    function _withdrawFunds(
        uint32 marketIndex,
        uint256 amountLong,
        uint256 amountShort,
        address user
    ) internal {
        uint256 totalAmount = amountLong + amountShort;

        assert(
            syntheticTokenBackedValue[MarketSide.Long][marketIndex] >=
                amountLong &&
                syntheticTokenBackedValue[MarketSide.Short][marketIndex] >=
                amountShort
        );

        _transferFromYieldManager(marketIndex, totalAmount);

        // Transfer funds to the sender.
        fundTokens[marketIndex].transfer(user, totalAmount);

        syntheticTokenBackedValue[MarketSide.Long][marketIndex] -= amountLong;
        syntheticTokenBackedValue[MarketSide.Short][marketIndex] -= amountShort;
    }

    /*
     * Transfers locked funds from LongShort into the yield manager.
     */
    // TODO STENT this is only called in one place, might as well move this code there
    function _transferFundsToYieldManager(uint32 marketIndex, uint256 amount)
        internal
    {
        // TODO STENT note there are 2 approvals & 2 transfers here:
        //     1. approve transfer from this contract to yield manager contract
        //     2. transfer from this contract to yield manager contract
        //     3. approve transfer from yield manager contract to lendingPool contract
        //     4. transfer from yield mnager contract to lendingPool contract
        // Surely we can mak this more efficient?
        fundTokens[marketIndex].approve(
            address(yieldManagers[marketIndex]),
            amount
        );
        yieldManagers[marketIndex].depositToken(amount);

        // Update market state.
        totalValueLockedInYieldManager[marketIndex] += amount;
    }

    /*
     * Transfers locked funds from the yield manager into LongShort.
     */
    function _transferFromYieldManager(uint32 marketIndex, uint256 amount)
        internal
    {
        require(totalValueLockedInYieldManager[marketIndex] >= amount);

        // NB there will be issues here if not enough liquidity exists to withdraw
        // Boolean should be returned from yield manager and think how to appropriately handle this
        yieldManagers[marketIndex].withdrawToken(amount);

        // Update market state.
        // TODO STENT why is this amount stored in this cotract? Seems like it should be stored inyield manager contract
        totalValueLockedInYieldManager[marketIndex] -= amount;

        // Invariant: yield managers should never have more locked funds
        // than the combined value of the market and held treasury funds.
        // TODO STENT this check seems wierd. What happens if this fails? What is the recovery? Should it be an assert?
        require(
            totalValueLockedInYieldManager[marketIndex] <=
                syntheticTokenBackedValue[MarketSide.Long][marketIndex] +
                    syntheticTokenBackedValue[MarketSide.Short][marketIndex] +
                    totalValueReservedForTreasury[marketIndex]
        );
    }

    /**
     * Calculates fees for the given mint/redeem amount. Users are penalised
     * with higher fees for imbalancing the market.
     */
    // TODO STENT look at this again
    // TODO: this function was written with immediate price in mind, rework this function to suit latest code
    function _getFeesGeneral(
        uint32 marketIndex,
        uint256 delta, // 1e18
        MarketSide synthTokenGainingDominance,
        MarketSide synthTokenLosingDominance,
        uint256 baseFeePercent,
        uint256 penultyFeePercent
    ) internal view returns (uint256) {
        uint256 baseFee = (delta * baseFeePercent) / feeUnitsOfPrecision;

        if (
            syntheticTokenBackedValue[synthTokenGainingDominance][
                marketIndex
            ] >=
            syntheticTokenBackedValue[synthTokenLosingDominance][marketIndex]
        ) {
            // All funds are causing imbalance
            return
                baseFee + ((delta * penultyFeePercent) / feeUnitsOfPrecision);
        } else if (
            syntheticTokenBackedValue[synthTokenGainingDominance][marketIndex] +
                delta >
            syntheticTokenBackedValue[synthTokenLosingDominance][marketIndex]
        ) {
            uint256 amountImbalancing =
                delta -
                    (syntheticTokenBackedValue[synthTokenLosingDominance][
                        marketIndex
                    ] -
                        syntheticTokenBackedValue[synthTokenGainingDominance][
                            marketIndex
                        ]);
            uint256 penaltyFee =
                (amountImbalancing * penultyFeePercent) / feeUnitsOfPrecision;

            return baseFee + penaltyFee;
        } else {
            return baseFee;
        }
    }

    ////////////////////////////////////
    /////// TREASURY FUNCTIONS /////////
    ////////////////////////////////////

    /*
     * Transfers the reserved treasury funds to the treasury contract. This is
     * done async to avoid putting transfer gas costs on users every time they o
     * pay fees or accrue yield.
     *
     * NOTE: doesn't affect markets, so no state refresh necessary
     */
    function transferTreasuryFunds(uint32 marketIndex) external treasuryOnly {
        // Edge-case: no funds to transfer.
        if (totalValueReservedForTreasury[marketIndex] == 0) {
            return;
        }

        // TODO STENT why is this called? totalValueReservedForTreasury gets value from fees and interest from the yield manager. Why are we then removing that value from the yiled manager?
        _transferFromYieldManager(
            marketIndex,
            totalValueReservedForTreasury[marketIndex]
        );

        // Transfer funds to the treasury.
        fundTokens[marketIndex].transfer(
            treasury,
            totalValueReservedForTreasury[marketIndex]
        );

        // Update global state.
        totalValueReservedForTreasury[marketIndex] = 0;
    }

    ////// LAZY EXEC:
    // Putting all code related to lazy execution below to keep it separate from the rest of the code (for now)

    function getUsersPendingBalance(
        address user,
        uint32 marketIndex,
        MarketSide syntheticTokenType
    )
        external
        view
        override
        assertMarketExists(marketIndex)
        returns (uint256 pendingBalance)
    {
        if (
            userCurrentLazyUpdateIndex[marketIndex][user] <=
            latestUpdateIndex[marketIndex]
        ) {
            // Update is still lazy but not past the next oracle update - display the amount the user would get if they executed immediately
            // NOTE: if we ever add fees for minting - we would add them here!
            uint256 amountPaymentTokenDeposited =
                userLazyDepositAmounts[marketIndex][user][syntheticTokenType];

            uint256 tokens =
                getAmountSynthToken(
                    amountPaymentTokenDeposited,
                    syntheticTokenPrice[syntheticTokenType][marketIndex]
                );

            return tokens;
        } else {
            return 0;
        }
    }

    function _executeLazyMintsIfTheyExist(
        uint32 marketIndex,
        address user,
        MarketSide syntheticTokenType
    ) internal {
        uint256 currentDepositAmount =
            userLazyDepositAmounts[marketIndex][user][syntheticTokenType];
        if (currentDepositAmount != 0) {
            uint256 tokensToMint =
                (currentDepositAmount * TEN_TO_THE_18) /
                    mintPriceSnapshot[marketIndex][
                        userCurrentLazyUpdateIndex[marketIndex][user]
                    ][syntheticTokenType];

            syntheticTokens[syntheticTokenType][marketIndex].transfer(
                user,
                tokensToMint
            );

            userLazyDepositAmounts[marketIndex][user][syntheticTokenType] = 0;
        }
    }

    function _executeOutstandingLazySettlementsAction(
        address user,
        uint32 marketIndex
    ) internal {
        _executeLazyMintsIfTheyExist(marketIndex, user, MarketSide.Long);
        _executeLazyMintsIfTheyExist(marketIndex, user, MarketSide.Short);
        _executeOutstandingLazyRedeems(marketIndex, user, MarketSide.Long);
        _executeOutstandingLazyRedeems(marketIndex, user, MarketSide.Short);

        userCurrentLazyUpdateIndex[marketIndex][user] = 0;
    }

    // TODO: modify this function (or make a different version) that takes in the desired useage and does either partial or full "early use"
    // TODO: WARNING!! This function is re-entrancy vulnerable if the synthetic token has any execution hooks
    function _executeOutstandingLazySettlements(
        address user,
        uint32 marketIndex // TODO: make this internal ?
    ) internal {
        uint256 currentUpdateIndex =
            userCurrentLazyUpdateIndex[marketIndex][user];
        if (
            currentUpdateIndex <= latestUpdateIndex[marketIndex] &&
            currentUpdateIndex != 0 // NOTE: this conditional isn't strictly necessary (all the users deposit amounts will be zero too)
        ) {
            _executeOutstandingLazySettlementsAction(user, marketIndex);
        }
        // TODO: add events
    }

    function executeOutstandingLazySettlementsUser(
        address user,
        uint32 marketIndex
    ) external override {
        // NOTE: this does all the "lazy" actions. This could be simplified to only do the relevant lazy action.
        _executeOutstandingLazySettlements(user, marketIndex);
    }

    modifier executeOutstandingLazySettlements(address user, uint32 marketIndex)
        virtual {
        _executeOutstandingLazySettlements(user, marketIndex);

        _;
    }

    function _mintLazy(
        uint32 marketIndex,
        uint256 amount,
        MarketSide syntheticTokenType
    ) internal executeOutstandingLazySettlements(msg.sender, marketIndex) {
        // TODO: pre-deposit them into YieldManager?
        //    - for now not doing that for simplicity, don't gain that much doing so either just more expensive tx (for very little yield)
        _depositFunds(marketIndex, amount);

        batchedLazyPaymentTokenToDeposit[marketIndex][
            syntheticTokenType
        ] += amount;
        userLazyDepositAmounts[marketIndex][msg.sender][
            syntheticTokenType
        ] += amount;
        userCurrentLazyUpdateIndex[marketIndex][msg.sender] =
            latestUpdateIndex[marketIndex] +
            1;

        emit LazyMinted(
            marketIndex,
            syntheticTokenType,
            amount,
            msg.sender,
            // batchedLazyPaymentTokenToDeposit[marketIndex][MarketSide.Long],
            latestUpdateIndex[marketIndex] + 1
        );
    }

    function mintLongLazy(uint32 marketIndex, uint256 amount) external {
        _mintLazy(marketIndex, amount, MarketSide.Long);
    }

    function mintShortLazy(uint32 marketIndex, uint256 amount) external {
        _mintLazy(marketIndex, amount, MarketSide.Short);
    }

    function _executeOutstandingLazyRedeems(
        uint32 marketIndex,
        address user,
        MarketSide syntheticTokenType
    ) internal {
        uint256 currentRedemptions =
            userLazyRedemptions[marketIndex][user][syntheticTokenType];
        if (currentRedemptions > 0) {
            uint256 amountToRedeem =
                getAmountPaymentToken(
                    currentRedemptions,
                    redeemPriceSnapshot[marketIndex][
                        userCurrentLazyUpdateIndex[marketIndex][user]
                    ][syntheticTokenType]
                );

            uint256 balance = fundTokens[marketIndex].balanceOf(address(this));

            fundTokens[marketIndex].transfer(user, amountToRedeem);
            userLazyRedemptions[marketIndex][user][syntheticTokenType] = 0;
        }
    }

    function _redeemLazy(
        uint32 marketIndex,
        uint256 tokensToRedeem,
        MarketSide syntheticTokenType
    ) internal executeOutstandingLazySettlements(msg.sender, marketIndex) {
        syntheticTokens[syntheticTokenType][marketIndex].transferFrom(
            msg.sender,
            address(this),
            tokensToRedeem
        );
        uint256 nextUpdateIndex = latestUpdateIndex[marketIndex] + 1;

        userLazyRedemptions[marketIndex][msg.sender][
            syntheticTokenType
        ] += tokensToRedeem;
        userCurrentLazyUpdateIndex[marketIndex][msg.sender] = nextUpdateIndex;

        batchedLazySynthToRedeem[marketIndex][
            syntheticTokenType
        ] += tokensToRedeem;
    }

    function redeemLongLazy(uint32 marketIndex, uint256 tokensToRedeem)
        external
    {
        _redeemLazy(marketIndex, tokensToRedeem, MarketSide.Long);
    }

    function redeemShortLazy(uint32 marketIndex, uint256 tokensToRedeem)
        external
    {
        _redeemLazy(marketIndex, tokensToRedeem, MarketSide.Short);
    }

    function _handleBatchedLazyRedeem(
        uint32 marketIndex,
        MarketSide syntheticTokenType,
        uint256 amountSynthToRedeem
    ) internal {
        if (amountSynthToRedeem > 0) {
            syntheticTokens[syntheticTokenType][marketIndex].synthRedeemBurn(
                address(this),
                amountSynthToRedeem
            );
        }
    }

    function _calculateBatchedLazyFees(
        uint32 marketIndex,
        uint256 amountOfPaymentTokenToRedeem,
        uint256 shortAmountOfPaymentTokenToRedeem
    ) internal returns (uint256 totalFeesLong, uint256 totalFeesShort) {
        // penalty fee is shared equally between
        // all users on the side that ends up causing an imbalance in the
        // batch.
        if (amountOfPaymentTokenToRedeem > shortAmountOfPaymentTokenToRedeem) {
            uint256 delta =
                amountOfPaymentTokenToRedeem -
                    shortAmountOfPaymentTokenToRedeem;
            totalFeesLong = _getFeesGeneral(
                marketIndex,
                delta,
                MarketSide.Short,
                MarketSide.Long,
                0,
                badLiquidityExitFee[marketIndex]
            );
        } else {
            uint256 delta =
                shortAmountOfPaymentTokenToRedeem -
                    amountOfPaymentTokenToRedeem;
            totalFeesShort = _getFeesGeneral(
                marketIndex,
                delta,
                MarketSide.Long,
                MarketSide.Short,
                0,
                badLiquidityExitFee[marketIndex]
            );
        }

        _feesMechanism(marketIndex, totalFeesLong + totalFeesShort);
    }

    function calculateRedeemPriceSnapshot(
        uint32 marketIndex,
        uint256 amountOfPaymentTokenToRedeem,
        MarketSide syntheticTokenType
    ) internal returns (uint256 batchLongTotalWithdrawnPaymentToken) {
        if (amountOfPaymentTokenToRedeem > 0) {
            redeemPriceSnapshot[marketIndex][latestUpdateIndex[marketIndex]][
                syntheticTokenType
            ] = getPrice(
                batchedLazySynthToRedeem[marketIndex][syntheticTokenType],
                amountOfPaymentTokenToRedeem
            );

            // NOTE: this is always slightly less than `amountOfPaymentTokenToRedeem` due to rounding errors
            return
                getAmountPaymentToken(
                    batchedLazySynthToRedeem[marketIndex][syntheticTokenType],
                    redeemPriceSnapshot[marketIndex][
                        latestUpdateIndex[marketIndex]
                    ][syntheticTokenType]
                );
        }
    }

    function handleBatchedLazyRedeems(uint32 marketIndex) internal {
        uint256 batchedLazySynthToRedeemLong =
            batchedLazySynthToRedeem[marketIndex][MarketSide.Long];
        uint256 batchedLazySynthToRedeemShort =
            batchedLazySynthToRedeem[marketIndex][MarketSide.Short];

        _handleBatchedLazyRedeem(
            marketIndex,
            MarketSide.Long,
            batchedLazySynthToRedeemLong
        );
        _handleBatchedLazyRedeem(
            marketIndex,
            MarketSide.Short,
            batchedLazySynthToRedeemShort
        );

        uint256 longAmountOfPaymentTokenToRedeem =
            getAmountPaymentToken(
                batchedLazySynthToRedeemLong,
                syntheticTokenPrice[MarketSide.Long][marketIndex]
            );

        uint256 shortAmountOfPaymentTokenToRedeem =
            getAmountPaymentToken(
                batchedLazySynthToRedeemShort,
                syntheticTokenPrice[MarketSide.Short][marketIndex]
            );

        (uint256 totalFeesLong, uint256 totalFeesShort) =
            _calculateBatchedLazyFees(
                marketIndex,
                longAmountOfPaymentTokenToRedeem,
                shortAmountOfPaymentTokenToRedeem
            );

        uint256 batchShortTotalWithdrawnPaymentToken =
            calculateRedeemPriceSnapshot(
                marketIndex,
                shortAmountOfPaymentTokenToRedeem - totalFeesShort,
                MarketSide.Short
            );

        uint256 batchLongTotalWithdrawnPaymentToken =
            calculateRedeemPriceSnapshot(
                marketIndex,
                longAmountOfPaymentTokenToRedeem - totalFeesLong,
                MarketSide.Long
            );

        _withdrawFunds(
            marketIndex,
            batchLongTotalWithdrawnPaymentToken,
            batchShortTotalWithdrawnPaymentToken,
            address(this)
        );

        // TODO STENT CONCERN1
        _refreshTokenPrices(marketIndex);

        batchedLazySynthToRedeem[marketIndex][MarketSide.Long] = 0;
        batchedLazySynthToRedeem[marketIndex][MarketSide.Short] = 0;
    }
}
