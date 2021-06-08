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
    mapping(uint32 => uint256) public totalValueLockedInMarket;
    mapping(uint32 => uint256) public totalValueLockedInYieldManager;
    mapping(uint32 => uint256) public totalValueReservedForTreasury;
    mapping(uint32 => uint256) public assetPrice;
    mapping(MarketSide => mapping(uint32 => uint256))
        public syntheticTokenPrice; // NOTE: cannot deprecate this value and use the marketStateSnapshot values instead since these values change inbetween assetPrice updates (when yield is collected)
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

    ////////////////////////////////////
    /////////// EVENTS /////////////////
    ////////////////////////////////////

    event V1(
        address admin,
        address treasury,
        address tokenFactory,
        address staker
    );

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

    event LongMinted(
        uint32 marketIndex,
        uint256 depositAdded,
        uint256 finalDepositAmount,
        uint256 tokensMinted,
        address user
    );

    event LazyLongMinted(
        uint32 marketIndex,
        uint256 depositAdded,
        address user,
        uint256 totalBatchedDepositAmount,
        uint256 oracleUpdateIndex
    );

    event LazyLongStaked(
        uint32 marketIndex,
        uint256 depositAdded,
        address user,
        uint256 totalBatchedDepositAmount,
        uint256 oracleUpdateIndex
    );

    event ShortMinted(
        uint32 marketIndex,
        uint256 depositAdded,
        uint256 finalDepositAmount,
        uint256 tokensMinted,
        address user
    );

    event LazyShortMinted(
        uint32 marketIndex,
        uint256 depositAdded,
        address user,
        uint256 totalBatchedDepositAmount,
        uint256 oracleUpdateIndex
    );

    event LazyShortStaked(
        uint32 marketIndex,
        uint256 depositAdded,
        address user,
        uint256 totalBatchedDepositAmount,
        uint256 oracleUpdateIndex
    );

    event LongRedeem(
        uint32 marketIndex,
        uint256 tokensRedeemed,
        uint256 valueOfRedemption,
        uint256 finalRedeemValue,
        address user
    );

    event ShortRedeem(
        uint32 marketIndex,
        uint256 tokensRedeemed,
        uint256 valueOfRedemption,
        uint256 finalRedeemValue,
        address user
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

    modifier refreshSystemState(uint32 marketIndex) {
        _updateSystemStateInternal(marketIndex);
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

        emit ShortMinted(
            marketIndex,
            initialMarketSeed,
            initialMarketSeed,
            initialMarketSeed,
            DEAD_ADDRESS
        );
        emit LongMinted(
            marketIndex,
            initialMarketSeed,
            initialMarketSeed,
            initialMarketSeed,
            DEAD_ADDRESS
        );
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
        assert(totalValueLockedInMarket[marketIndex] != 0);

        uint256 marketPcnt; // fixed-precision scale of 10000
        if (
            syntheticTokenBackedValue[MarketSide.Long][marketIndex] >
            syntheticTokenBackedValue[MarketSide.Short][marketIndex]
        ) {
            marketPcnt =
                ((syntheticTokenBackedValue[MarketSide.Long][marketIndex] -
                    syntheticTokenBackedValue[MarketSide.Short][marketIndex]) *
                    10000) /
                totalValueLockedInMarket[marketIndex];
        } else {
            marketPcnt =
                ((syntheticTokenBackedValue[MarketSide.Short][marketIndex] -
                    syntheticTokenBackedValue[MarketSide.Long][marketIndex]) *
                    10000) /
                totalValueLockedInMarket[marketIndex];
        }

        marketAmount = (marketPcnt * amount) / 10000;
        treasuryAmount = amount - marketAmount;
        require(amount == marketAmount + treasuryAmount);

        return (marketAmount, treasuryAmount);
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
        assert(totalValueLockedInMarket[marketIndex] != 0);

        // The percentage value that a position receives depends on the amount
        // of total market value taken up by the _opposite_ position.
        uint256 longPcnt =
            (syntheticTokenBackedValue[MarketSide.Short][marketIndex] * 10000) /
            // TODO STENT inefficiency here. Just use totalValueLockedInMarket[marketIndex]
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

    /**
     * Controls what happens with mint/redeem fees.
     */
    function _feesMechanism(uint32 marketIndex, uint256 totalFees) internal {
        // Market gets a bigger share if the market is more imbalanced.
        (uint256 marketAmount, uint256 treasuryAmount) =
            getTreasurySplit(marketIndex, totalFees);

        // Do a logical transfer from market funds into treasury.
        // TODO STENT this is a bit confusion.
        //   This function (_feesMechanism) assumes that the fees are already in totalValueLockedInMarket
        //   but not in syntheticTokenBackedValue[MarketSide.Long][marketIndex] which is confusiong.
        //   It is also a source of errors because if you do not add the fees to totalValueLockedInMarket
        //   first AND then call this function in the same transaction then you will have
        //   Long + Short != totalValueLockedInMarket
        totalValueLockedInMarket[marketIndex] -= treasuryAmount;
        totalValueReservedForTreasury[marketIndex] += treasuryAmount;

        // Splits mostly to the weaker position to incentivise balance.
        (uint256 longAmount, uint256 shortAmount) =
            getMarketSplit(marketIndex, marketAmount);
        syntheticTokenBackedValue[MarketSide.Long][marketIndex] += longAmount;
        syntheticTokenBackedValue[MarketSide.Short][marketIndex] += shortAmount;

        emit FeesLevied(marketIndex, totalFees);
    }

    /**
     * Controls what happens with accrued yield manager interest.
     */
    function _claimAndDistributeYield(uint32 marketIndex) internal {
        uint256 amount =
            yieldManagers[marketIndex].getTotalHeld() -
                totalValueLockedInYieldManager[marketIndex];

        // Market gets a bigger share if the market is more imbalanced.
        if (amount > 0) {
            (uint256 marketAmount, uint256 treasuryAmount) =
                getTreasurySplit(marketIndex, amount);

            // We keep the interest locked in the yield manager, but update our
            // bookkeeping to logically simulate moving the funds around.
            totalValueLockedInYieldManager[marketIndex] += amount;
            totalValueLockedInMarket[marketIndex] += marketAmount;
            totalValueReservedForTreasury[marketIndex] += treasuryAmount;

            // Splits mostly to the weaker position to incentivise balance.
            (uint256 longAmount, uint256 shortAmount) =
                getMarketSplit(marketIndex, marketAmount);
            syntheticTokenBackedValue[MarketSide.Long][marketIndex] += longAmount;
            syntheticTokenBackedValue[MarketSide.Short][marketIndex] += shortAmount;
        }
    }

    function _minimum(
        uint256 A,
        uint256 B
    ) internal view returns (int256) {
        if (A < B) {
            return int256(A);
        } else {
            return int256(B);
        }
    }

    function _adjustMarketBasedOnNewAssetPrice(uint32 marketIndex, int256 newAssetPrice)
        internal
        returns (bool didUpdate)
    {
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

        int256 valueChange = percentageChangeE18 * min / TEN_TO_THE_18_SIGNED;

        if (valueChange > 0) {
            syntheticTokenBackedValue[MarketSide.Long][marketIndex] += uint256(valueChange);
            syntheticTokenBackedValue[MarketSide.Short][marketIndex] -= uint256(valueChange);
        } else {
            syntheticTokenBackedValue[MarketSide.Long][marketIndex] -= uint256(valueChange*-1);
            syntheticTokenBackedValue[MarketSide.Short][marketIndex] += uint256(valueChange*-1);
        }

        return true;
    }

    function handleBatchedDepositSettlement(
        uint32 marketIndex,
        MarketSide syntheticTokenType
    ) internal {
        // Deposit funds and compute fees.
        NextActionValues storage currentMarketBatchedLazyDeposit =
            batchedLazyDeposit[marketIndex][syntheticTokenType];
        uint256 totalAmount =
            currentMarketBatchedLazyDeposit.mintAmount +
                currentMarketBatchedLazyDeposit.mintAndStakeAmount;

        if (totalAmount > 0) {
            _transferFundsToYieldManager(marketIndex, totalAmount);

            // NOTE: no fees are calculated, but if they are desired in the future they can be added here.

            // Distribute fees across the market.
            // TODO STENT CONCERN1
            _refreshTokenPrices(marketIndex);

            // Mint long tokens with remaining value.
            uint256 numberOfTokens =
                (totalAmount * TEN_TO_THE_18) /
                    syntheticTokenPrice[syntheticTokenType][marketIndex];

            syntheticTokens[syntheticTokenType][marketIndex].mint(
                address(this),
                numberOfTokens
            );

            syntheticTokenBackedValue[syntheticTokenType][marketIndex] += totalAmount;

            if (currentMarketBatchedLazyDeposit.mintAndStakeAmount > 0) {
                // NOTE: no fees are calculated, but if they are desired in the future they can be added here.

                uint256 amountToStake =
                    (currentMarketBatchedLazyDeposit.mintAndStakeAmount *
                        TEN_TO_THE_18) /
                        syntheticTokenPrice[syntheticTokenType][marketIndex];

                staker.stakeFromMintBatched(
                    marketIndex,
                    amountToStake,
                    latestUpdateIndex[marketIndex],
                    syntheticTokenType
                );

                // reset all values
                currentMarketBatchedLazyDeposit.mintAmount = 0;
                currentMarketBatchedLazyDeposit.mintAndStakeAmount = 0;
            }
            // TODO: add events
        }
    }

    function snapshopPriceChangeForNextPriceExecution(uint32 marketIndex)
        internal
    {
        uint256 newLatestPriceStateIndex = latestUpdateIndex[marketIndex] + 1;
        latestUpdateIndex[marketIndex] = newLatestPriceStateIndex;

        // NOTE: we can't just merge these two values since the 'yield' has an effect on the token price inbetween oracle updates.
        marketStateSnapshot[marketIndex][newLatestPriceStateIndex][
            MarketSide.Long
        ] = syntheticTokenPrice[MarketSide.Long][marketIndex];
        marketStateSnapshot[marketIndex][newLatestPriceStateIndex][
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

        // If a negative int is return this should fail.
        int256 newAssetPrice = oracleManagers[marketIndex].updatePrice();

        // TODO STENT move this into the price function
        emit PriceUpdate(
            marketIndex,
            assetPrice[marketIndex],
            uint256(newAssetPrice),
            msg.sender
        );

        bool priceChanged = false;
        // Adjusts long and short values based on price movements.
        priceChanged = _adjustMarketBasedOnNewAssetPrice(marketIndex, newAssetPrice);

        // Distribute accrued yield manager interest.
        _claimAndDistributeYield(marketIndex);

        // TODO STENT CONCERN1
        _refreshTokenPrices(marketIndex);
        assetPrice[marketIndex] = uint256(newAssetPrice);
        if (priceChanged) {
            snapshopPriceChangeForNextPriceExecution(marketIndex);

            handleBatchedDepositSettlement(marketIndex, MarketSide.Long);
            handleBatchedDepositSettlement(marketIndex, MarketSide.Short);
            handleBatchedLazyRedeems(marketIndex);
        }

        emit ValueLockedInSystem(
            marketIndex,
            totalValueLockedInMarket[marketIndex],
            syntheticTokenBackedValue[MarketSide.Long][marketIndex],
            syntheticTokenBackedValue[MarketSide.Short][marketIndex]
        );

        // Invariant: long/short values should never differ from total value.
        assert(
            syntheticTokenBackedValue[MarketSide.Long][marketIndex] +
                syntheticTokenBackedValue[MarketSide.Short][marketIndex] ==
                totalValueLockedInMarket[marketIndex]
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

    /*
     * Locks funds from the sender into the given market.
     */
    function _transferFundsToYieldManager(uint32 marketIndex, uint256 amount)
        internal
    {
        // Update global value state.
        totalValueLockedInMarket[marketIndex] =
            totalValueLockedInMarket[marketIndex] +
            amount;
        _transferToYieldManager(marketIndex, amount);
    }

    function _depositFunds(uint32 marketIndex, uint256 amount) internal {
        fundTokens[marketIndex].transferFrom(msg.sender, address(this), amount);
    }

    function _lockFundsInMarket(uint32 marketIndex, uint256 amount) internal {
        _depositFunds(marketIndex, amount);
        _transferFundsToYieldManager(marketIndex, amount);
    }

    /*
     * Returns locked funds from the market to the sender.
     */
    function _withdrawFunds(
        uint32 marketIndex,
        uint256 amount,
        address user
    ) internal {
        assert(totalValueLockedInMarket[marketIndex] >= amount);

        _transferFromYieldManager(marketIndex, amount);

        // Transfer funds to the sender.
        fundTokens[marketIndex].transfer(user, amount);

        // Update market state.
        // TODO STENT is this totalValueLockedInMarket variable even used properly? It's a pain to update it
        //     and a source of error in future updates
        totalValueLockedInMarket[marketIndex] =
            totalValueLockedInMarket[marketIndex] -
            amount;
    }

    /*
     * Transfers locked funds from LongShort into the yield manager.
     */
    // TODO STENT this is only called in one place, might as well move this code there
    function _transferToYieldManager(uint32 marketIndex, uint256 amount)
        internal
    {
        fundTokens[marketIndex].approve(
            address(yieldManagers[marketIndex]),
            amount
        );
        yieldManagers[marketIndex].depositToken(amount);

        // Update market state.

        totalValueLockedInYieldManager[marketIndex] += amount;

        // Invariant: yield managers should never have more locked funds
        // than the combined value of the market and dao funds.
        // TODO STENT this check seems wierd. What happens if this fails? What is the recovery? Should it be an assert
        require(
            totalValueLockedInYieldManager[marketIndex] <=
                totalValueLockedInMarket[marketIndex] +
                    totalValueReservedForTreasury[marketIndex]
        );
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
                totalValueLockedInMarket[marketIndex] +
                    totalValueReservedForTreasury[marketIndex]
        );
    }

    /**
     * Calculates fees for the given mint/redeem amount. Users are penalised
     * with higher fees for imbalancing the market.
     */
    // TODO STENT look at this again
    function _getFeesGeneral(
        uint32 marketIndex,
        uint256 delta, // 1e18
        MarketSide synthTokenGainingDominance,
        MarketSide synthTokenLosingDominance,
        uint256 baseFee,
        uint256 penultyFees
    ) internal view returns (uint256) {
        uint256 baseFee = (delta * baseFee) / feeUnitsOfPrecision;

        if (
            syntheticTokenBackedValue[synthTokenGainingDominance][
                marketIndex
            ] >=
            syntheticTokenBackedValue[synthTokenLosingDominance][marketIndex]
        ) {
            // All funds are causing imbalance
            return baseFee + ((delta * penultyFees) / feeUnitsOfPrecision);
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
                (amountImbalancing * penultyFees) / feeUnitsOfPrecision;

            return baseFee + penaltyFee;
        } else {
            return baseFee;
        }
    }

    function _getFeesForMint(
        uint32 marketIndex,
        uint256 amount, // 1e18
        MarketSide syntheticTokenType
    ) internal view returns (uint256) {
        MarketSide otherSideSynthType = getOtherSynthType(syntheticTokenType);

        return
            _getFeesGeneral(
                marketIndex,
                amount,
                syntheticTokenType,
                otherSideSynthType,
                baseEntryFee[marketIndex],
                badLiquidityEntryFee[marketIndex]
            );
    }

    function _getFeesForRedeem(
        uint32 marketIndex,
        uint256 amount, // 1e18
        MarketSide syntheticTokenType
    ) internal view returns (uint256) {
        MarketSide otherSideSynthType = getOtherSynthType(syntheticTokenType);

        return
            _getFeesGeneral(
                marketIndex,
                amount,
                otherSideSynthType,
                syntheticTokenType,
                baseExitFee[marketIndex],
                badLiquidityExitFee[marketIndex]
            );
    }

    ////////////////////////////////////
    /////////// MINT TOKENS ////////////
    ////////////////////////////////////

    /**
     * Create a long position
     */
    function mintLong(uint32 marketIndex, uint256 amount)
        external
        refreshSystemState(marketIndex)
    {
        // Deposit funds and compute fees.
        _lockFundsInMarket(marketIndex, amount);

        _mint(marketIndex, amount, msg.sender, msg.sender, MarketSide.Long);
    }

    /**
     * Creates a short position
     */
    function mintShort(uint32 marketIndex, uint256 amount)
        external
        refreshSystemState(marketIndex)
    {
        // Deposit funds and compute fees.
        _lockFundsInMarket(marketIndex, amount);

        _mint(marketIndex, amount, msg.sender, msg.sender, MarketSide.Short);
    }

    /**
     * Creates a long position and stakes it
     */
    function mintLongAndStake(uint32 marketIndex, uint256 amount)
        external
        refreshSystemState(marketIndex)
    {
        // Deposit funds and compute fees.
        _lockFundsInMarket(marketIndex, amount);

        uint256 tokensMinted =
            _mint(
                marketIndex,
                amount,
                msg.sender,
                address(staker),
                MarketSide.Long
            );

        staker.stakeFromMint(
            syntheticTokens[MarketSide.Long][marketIndex],
            tokensMinted,
            msg.sender
        );
    }

    /**
     * Creates a short position and stakes it
     */
    function mintShortAndStake(uint32 marketIndex, uint256 amount)
        external
        refreshSystemState(marketIndex)
    {
        // Deposit funds and compute fees.
        _lockFundsInMarket(marketIndex, amount);

        uint256 tokensMinted =
            _mint(
                marketIndex,
                amount,
                msg.sender,
                address(staker),
                MarketSide.Short
            );

        staker.stakeFromMint(
            syntheticTokens[MarketSide.Short][marketIndex],
            tokensMinted,
            msg.sender
        );
    }

    function _mint(
        uint32 marketIndex,
        uint256 amount,
        address user,
        address transferTo,
        MarketSide syntheticTokenType
    ) internal returns (uint256) {
        uint256 fees = _getFeesForMint(marketIndex, amount, syntheticTokenType);
        uint256 remaining = amount - fees;

        // Distribute fees across the market - (do this before minting tokens so that user doesn't get the fees)
        _feesMechanism(marketIndex, fees);
        // TODO STENT CONCERN1
        _refreshTokenPrices(marketIndex);

        // Mint short tokens with remaining value.
        uint256 tokens =
            (remaining * TEN_TO_THE_18) /
                syntheticTokenPrice[syntheticTokenType][marketIndex];
        syntheticTokens[syntheticTokenType][marketIndex].mint(
            transferTo,
            tokens
        );
        syntheticTokenBackedValue[syntheticTokenType][marketIndex] += remaining;

        // TODO: combine these
        if (syntheticTokenType == MarketSide.Long) {
            emit LongMinted(marketIndex, amount, remaining, tokens, user);
        } else {
            emit ShortMinted(marketIndex, amount, remaining, tokens, user);
        }

        emit ValueLockedInSystem(
            marketIndex,
            totalValueLockedInMarket[marketIndex],
            syntheticTokenBackedValue[MarketSide.Long][marketIndex],
            syntheticTokenBackedValue[MarketSide.Short][marketIndex]
        );
        return tokens;
    }

    ////////////////////////////////////
    /////////// REDEEM TOKENS //////////
    ////////////////////////////////////

    function _redeem(
        uint32 marketIndex,
        uint256 tokensToRedeem,
        MarketSide syntheticTokenType
    ) internal refreshSystemState(marketIndex) {
        // Only this contract has permission to call this function
        syntheticTokens[syntheticTokenType][marketIndex].synthRedeemBurn(
            msg.sender,
            tokensToRedeem
        );

        // Compute fees.
        uint256 amount =
            (tokensToRedeem *
                syntheticTokenPrice[syntheticTokenType][marketIndex]) /
                TEN_TO_THE_18;
        uint256 fees =
            _getFeesForRedeem(marketIndex, amount, syntheticTokenType);
        uint256 remaining = amount - fees;

        // Distribute fees across the market.
        _feesMechanism(marketIndex, fees);

        // Withdraw funds with remaining amount.
        syntheticTokenBackedValue[syntheticTokenType][marketIndex] -= amount;
        _withdrawFunds(marketIndex, remaining, msg.sender);
        // TODO STENT CONCERN1
        _refreshTokenPrices(marketIndex);

        // TODO: Combine these events
        if (syntheticTokenType == MarketSide.Long) {
            emit LongRedeem(
                marketIndex,
                tokensToRedeem,
                amount,
                remaining,
                msg.sender
            );
        } else {
            emit ShortRedeem(
                marketIndex,
                tokensToRedeem,
                amount,
                remaining,
                msg.sender
            );
        }

        emit ValueLockedInSystem(
            marketIndex,
            totalValueLockedInMarket[marketIndex],
            syntheticTokenBackedValue[MarketSide.Long][marketIndex],
            syntheticTokenBackedValue[MarketSide.Short][marketIndex]
        );
    }

    function redeemLong(uint32 marketIndex, uint256 tokensToRedeem)
        external
        override
    {
        _redeem(marketIndex, tokensToRedeem, MarketSide.Long);
    }

    function redeemLongAll(uint32 marketIndex) external {
        uint256 tokensToRedeem =
            syntheticTokens[MarketSide.Long][marketIndex].balanceOf(msg.sender);
        _redeem(marketIndex, tokensToRedeem, MarketSide.Long);
    }

    function redeemShort(uint32 marketIndex, uint256 tokensToRedeem)
        external
        override
    {
        _redeem(marketIndex, tokensToRedeem, MarketSide.Short);
    }

    function redeemShortAll(uint32 marketIndex) external {
        uint256 tokensToRedeem =
            syntheticTokens[MarketSide.Short][marketIndex].balanceOf(
                msg.sender
            );
        _redeem(marketIndex, tokensToRedeem, MarketSide.Short);
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

    // TODO: use the MarketSide enum for long/short values
    struct NextActionValues {
        uint256 mintAmount;
        uint256 mintAndStakeAmount;
    }
    struct UserLazyDeposit {
        uint256 usersCurrentUpdateIndex;
        mapping(MarketSide => NextActionValues) nextActionValues;
    }

    mapping(uint32 => uint256) public latestUpdateIndex;
    mapping(uint32 => mapping(uint256 => mapping(MarketSide => uint256)))
        public marketStateSnapshot;
    mapping(uint32 => mapping(MarketSide => NextActionValues))
        public batchedLazyDeposit;
    mapping(uint32 => mapping(address => UserLazyDeposit))
        public userLazyActions;

    // Add setters for these values
    uint256 public percentageAvailableForEarlyExitNumerator = 80000;
    uint256 public percentageAvailableForEarlyExitDenominator = 100000;

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
        UserLazyDeposit storage currentUserDeposits =
            userLazyActions[marketIndex][user];

        if (
            currentUserDeposits.usersCurrentUpdateIndex <=
            latestUpdateIndex[marketIndex]
        ) {
            // Update is still lazy but not past the next oracle update - display the amount the user would get if they executed immediately
            // NOTE: if we ever add fees for minting - we would add them here!
            uint256 remaining =
                currentUserDeposits.nextActionValues[syntheticTokenType]
                    .mintAmount;

            uint256 tokens =
                (remaining * TEN_TO_THE_18) /
                    syntheticTokenPrice[syntheticTokenType][marketIndex];

            return tokens;
        } else {
            return 0;
        }
    }

    function _executeLazyMintsIfTheyExist(
        uint32 marketIndex,
        address user,
        MarketSide syntheticTokenType,
        UserLazyDeposit storage currentUserDeposits
    ) internal {
        if (
            currentUserDeposits.nextActionValues[syntheticTokenType]
                .mintAmount != 0
        ) {
            uint256 tokensToMint =
                (((
                    currentUserDeposits.nextActionValues[syntheticTokenType]
                        .mintAmount
                ) * TEN_TO_THE_18) /
                    marketStateSnapshot[marketIndex][
                        latestUpdateIndex[marketIndex]
                    ][syntheticTokenType]);

            syntheticTokens[syntheticTokenType][marketIndex].transfer(
                user,
                tokensToMint
            );

            currentUserDeposits.nextActionValues[syntheticTokenType]
                .mintAmount = 0;
        }
    }

    function _executeOutstandingLazySettlementsAction(
        address user,
        uint32 marketIndex,
        UserLazyDeposit storage currentUserDeposits
    ) internal {
        _executeLazyMintsIfTheyExist(
            marketIndex,
            user,
            MarketSide.Long,
            currentUserDeposits
        );
        _executeLazyMintsIfTheyExist(
            marketIndex,
            user,
            MarketSide.Short,
            currentUserDeposits
        );

        if (
            currentUserDeposits.nextActionValues[MarketSide.Long]
                .mintAndStakeAmount !=
            0 ||
            currentUserDeposits.nextActionValues[MarketSide.Short]
                .mintAndStakeAmount !=
            0
        ) {
            uint256 tokensToStakeShort =
                ((currentUserDeposits.nextActionValues[MarketSide.Short]
                    .mintAndStakeAmount * TEN_TO_THE_18) /
                    marketStateSnapshot[marketIndex][
                        latestUpdateIndex[marketIndex]
                    ][MarketSide.Short]);
            uint256 tokensToStakeLong =
                ((currentUserDeposits.nextActionValues[MarketSide.Long]
                    .mintAndStakeAmount * TEN_TO_THE_18) /
                    marketStateSnapshot[marketIndex][
                        latestUpdateIndex[marketIndex]
                    ][MarketSide.Long]);
            staker.transferBatchStakeToUser(
                tokensToStakeLong,
                tokensToStakeShort,
                marketIndex,
                currentUserDeposits.usersCurrentUpdateIndex,
                user
            );

            // TODO: do the accounting for the user
            currentUserDeposits.nextActionValues[MarketSide.Long]
                .mintAndStakeAmount = 0;
            currentUserDeposits.nextActionValues[MarketSide.Short]
                .mintAndStakeAmount = 0;
        }
        currentUserDeposits.usersCurrentUpdateIndex = 0;
    }

    // TODO: modify this function (or make a different version) that takes in the desired useage and does either partial or full "early use"
    // TODO: WARNING!! This function is re-entrancy vulnerable if the synthetic token has any execution hooks
    function _executeOutstandingLazySettlements(
        address user,
        uint32 marketIndex // TODO: make this internal ?
    ) internal {
        UserLazyDeposit storage currentUserDeposits =
            userLazyActions[marketIndex][user];

        if (
            currentUserDeposits.usersCurrentUpdateIndex <=
            latestUpdateIndex[marketIndex] &&
            currentUserDeposits.usersCurrentUpdateIndex != 0 // NOTE: this conditional isn't strictly necessary (all the users deposit amounts will be zero too)
        ) {
            _executeOutstandingLazySettlementsAction(
                user,
                marketIndex,
                currentUserDeposits
            );
        }
        // TODO: add events
    }

    function executeOutstandingLazySettlementsSynth(
        address user,
        uint32 marketIndex,
        MarketSide syntheticTokenType
    )
        external
        override
        isCorrectSynth(
            marketIndex,
            syntheticTokenType,
            ISyntheticToken(msg.sender)
        )
    {
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

        batchedLazyDeposit[marketIndex][syntheticTokenType]
            .mintAmount += amount;
        userLazyActions[marketIndex][msg.sender].nextActionValues[
            syntheticTokenType
        ]
            .mintAmount += amount;
        userLazyActions[marketIndex][msg.sender].usersCurrentUpdateIndex =
            latestUpdateIndex[marketIndex] +
            1;
    }

    function mintLongLazy(uint32 marketIndex, uint256 amount) external {
        _mintLazy(marketIndex, amount, MarketSide.Long);
        // TODO: share event with short side

        emit LazyLongMinted(
            marketIndex,
            amount,
            msg.sender,
            batchedLazyDeposit[marketIndex][MarketSide.Long].mintAmount,
            latestUpdateIndex[marketIndex] + 1
        );
    }

    function mintShortLazy(uint32 marketIndex, uint256 amount) external {
        _mintLazy(marketIndex, amount, MarketSide.Short);
        // TODO: add events
    }

    function mintAndStakeLazy(
        uint32 marketIndex,
        uint256 amount,
        MarketSide syntheticTokenType
    ) internal executeOutstandingLazySettlements(msg.sender, marketIndex) {
        fundTokens[marketIndex].transferFrom(msg.sender, address(this), amount);

        batchedLazyDeposit[marketIndex][syntheticTokenType]
            .mintAndStakeAmount += amount;
        userLazyActions[marketIndex][msg.sender].nextActionValues[
            MarketSide.Short
        ]
            .mintAndStakeAmount += amount;

        userLazyActions[marketIndex][msg.sender].usersCurrentUpdateIndex =
            latestUpdateIndex[marketIndex] +
            1;
        // TODO: add events
    }

    function mintLongAndStakeLazy(uint32 marketIndex, uint256 amount) external {
        mintAndStakeLazy(marketIndex, amount, MarketSide.Long);
    }

    function mintShortAndStakeLazy(uint32 marketIndex, uint256 amount)
        external
    {
        mintAndStakeLazy(marketIndex, amount, MarketSide.Short);
    }

    struct UserLazyRedeem {
        mapping(MarketSide => uint256) redemptions;
        uint256 usersCurrentUpdateIndex;
    }

    struct BatchedLazyRedeem {
        uint256 redemptions;
        uint256 totalWithdrawn;
    }

    mapping(uint32 => mapping(address => UserLazyRedeem))
        public userLazyRedeems;
    mapping(uint32 => mapping(uint256 => mapping(MarketSide => BatchedLazyRedeem)))
        public batchedLazyRedeems;

    function _executeOutstandingLazyRedeems(address user, uint32 marketIndex)
        internal
    {
        UserLazyRedeem storage currentUserRedeems =
            userLazyRedeems[marketIndex][msg.sender];

        if (
            currentUserRedeems.usersCurrentUpdateIndex != 0 &&
            currentUserRedeems.usersCurrentUpdateIndex <=
            latestUpdateIndex[marketIndex]
        ) {
            BatchedLazyRedeem storage batchLong =
                batchedLazyRedeems[marketIndex][
                    currentUserRedeems.usersCurrentUpdateIndex
                ][MarketSide.Long];
            BatchedLazyRedeem storage batchShort =
                batchedLazyRedeems[marketIndex][
                    currentUserRedeems.usersCurrentUpdateIndex
                ][MarketSide.Short];
            if (currentUserRedeems.redemptions[MarketSide.Long] > 0) {
                fundTokens[marketIndex].transfer(
                    user,
                    (batchLong.totalWithdrawn *
                        currentUserRedeems.redemptions[MarketSide.Long]) /
                        batchLong.redemptions
                );
                currentUserRedeems.redemptions[MarketSide.Long] = 0;
            }
            if (currentUserRedeems.redemptions[MarketSide.Short] > 0) {
                fundTokens[marketIndex].transfer(
                    user,
                    (batchShort.totalWithdrawn *
                        currentUserRedeems.redemptions[MarketSide.Short]) /
                        batchShort.redemptions
                );
                currentUserRedeems.redemptions[MarketSide.Short] = 0;
            }
            currentUserRedeems.usersCurrentUpdateIndex = 0;
        }
    }

    modifier executeOutstandingLazyRedeems(address user, uint32 marketIndex) {
        _executeOutstandingLazyRedeems(user, marketIndex);
        _;
    }

    function redeemLongLazy(uint32 marketIndex, uint256 tokensToRedeem)
        external
        executeOutstandingLazyRedeems(msg.sender, marketIndex)
    {
        syntheticTokens[MarketSide.Long][marketIndex].transferFrom(
            msg.sender,
            address(this),
            tokensToRedeem
        );
        uint256 nextUpdateIndex = latestUpdateIndex[marketIndex] + 1;

        userLazyRedeems[marketIndex][msg.sender].redemptions[
            MarketSide.Long
        ] += tokensToRedeem;
        userLazyRedeems[marketIndex][msg.sender]
            .usersCurrentUpdateIndex = nextUpdateIndex;

        batchedLazyRedeems[marketIndex][nextUpdateIndex][MarketSide.Long]
            .redemptions += tokensToRedeem;
    }

    function redeemShortLazy(uint32 marketIndex, uint256 tokensToRedeem)
        external
        executeOutstandingLazyRedeems(msg.sender, marketIndex)
    {
        syntheticTokens[MarketSide.Short][marketIndex].transferFrom(
            msg.sender,
            address(this),
            tokensToRedeem
        );
        uint256 nextUpdateIndex = latestUpdateIndex[marketIndex] + 1;

        userLazyRedeems[marketIndex][msg.sender].redemptions[
            MarketSide.Short
        ] += tokensToRedeem;
        userLazyRedeems[marketIndex][msg.sender]
            .usersCurrentUpdateIndex = nextUpdateIndex;

        batchedLazyRedeems[marketIndex][nextUpdateIndex][MarketSide.Short]
            .redemptions += tokensToRedeem;
    }

    function handleBatchedLazyRedeems(uint32 marketIndex) public {
        BatchedLazyRedeem storage batchLong =
            batchedLazyRedeems[marketIndex][latestUpdateIndex[marketIndex]][
                MarketSide.Long
            ];
        BatchedLazyRedeem storage batchShort =
            batchedLazyRedeems[marketIndex][latestUpdateIndex[marketIndex]][
                MarketSide.Short
            ];

        if (batchLong.redemptions > 0) {
            syntheticTokens[MarketSide.Long][marketIndex].synthRedeemBurn(
                address(this),
                batchLong.redemptions
            );
        }

        if (batchShort.redemptions > 0) {
            syntheticTokens[MarketSide.Short][marketIndex].synthRedeemBurn(
                address(this),
                batchShort.redemptions
            );
        }
        uint256 longAmountToRedeem =
            (batchLong.redemptions *
                syntheticTokenPrice[MarketSide.Long][marketIndex]) /
                TEN_TO_THE_18;

        uint256 shortAmountToRedeem =
            (batchShort.redemptions *
                syntheticTokenPrice[MarketSide.Short][marketIndex]) /
                TEN_TO_THE_18;

        uint256 totalFeesLong = 0;

        uint256 totalFeesShort = 0;

        // penalty fee is shared equally between
        // all users on the side that ends up causing an imbalance in the
        // batch.
        if (longAmountToRedeem > shortAmountToRedeem) {
            uint256 delta = longAmountToRedeem - shortAmountToRedeem;
            totalFeesLong = _getFeesGeneral(
                marketIndex,
                delta,
                MarketSide.Long,
                MarketSide.Short,
                0,
                badLiquidityExitFee[marketIndex]
            );
        } else {
            uint256 delta = shortAmountToRedeem - longAmountToRedeem;
            totalFeesShort = _getFeesGeneral(
                marketIndex,
                delta,
                MarketSide.Short,
                MarketSide.Long,
                0,
                badLiquidityExitFee[marketIndex]
            );
        }

        batchLong.totalWithdrawn = longAmountToRedeem - totalFeesLong;
        batchShort.totalWithdrawn = shortAmountToRedeem - totalFeesShort;

        _feesMechanism(marketIndex, totalFeesLong + totalFeesShort);

        syntheticTokenBackedValue[MarketSide.Long][
            marketIndex
        ] -= longAmountToRedeem;
        syntheticTokenBackedValue[MarketSide.Short][
            marketIndex
        ] -= shortAmountToRedeem;

        _withdrawFunds(
            marketIndex,
            batchLong.totalWithdrawn + batchShort.totalWithdrawn,
            address(this)
        );

        // TODO STENT CONCERN1
        _refreshTokenPrices(marketIndex);
    }
}
