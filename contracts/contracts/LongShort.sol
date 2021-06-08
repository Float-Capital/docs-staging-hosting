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
    uint256 public constant TEN_TO_THE_18 = 1e18;
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

    modifier doesMarketExist(uint32 marketIndex) {
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
        uint256 _baseExitFee,
        uint256 _badLiquidityEntryFee,
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
        assetPrice[latestMarket] = uint256(getLatestPrice(latestMarket));

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

    function initializeMarket(
        uint32 marketIndex,
        uint256 _baseEntryFee,
        uint256 _badLiquidityEntryFee,
        uint256 _baseExitFee,
        uint256 _badLiquidityExitFee,
        uint256 kInitialMultiplier,
        uint256 kPeriod
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
    }

    ////////////////////////////////////
    //////// HELPER FUNCTIONS //////////
    ////////////////////////////////////

    /**
     * Returns the latest price
     */
    function getLatestPrice(uint32 marketIndex) internal returns (int256) {
        return oracleManagers[marketIndex].updatePrice();
    }

    /**
     * Returns % of long position that is filled
     */
    function getLongBeta(uint32 marketIndex) public view returns (uint256) {
        // TODO account for contract start when these are both zero
        // and an erronous beta of 1 reported.
        if (
            syntheticTokenBackedValue[MarketSide.Short][marketIndex] >=
            syntheticTokenBackedValue[MarketSide.Long][marketIndex]
        ) {
            return TEN_TO_THE_18;
        } else {
            return
                (syntheticTokenBackedValue[MarketSide.Short][marketIndex] *
                    TEN_TO_THE_18) /
                syntheticTokenBackedValue[MarketSide.Long][marketIndex];
        }
    }

    /**
     * Returns % of short position that is filled
     * zero div error if both are zero
     */
    function getShortBeta(uint32 marketIndex) public view returns (uint256) {
        if (
            syntheticTokenBackedValue[MarketSide.Long][marketIndex] >=
            syntheticTokenBackedValue[MarketSide.Short][marketIndex]
        ) {
            return TEN_TO_THE_18;
        } else {
            return
                (syntheticTokenBackedValue[MarketSide.Long][marketIndex] *
                    TEN_TO_THE_18) /
                syntheticTokenBackedValue[MarketSide.Short][marketIndex];
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
        // Edge case: all goes to market when market is empty.
        if (totalValueLockedInMarket[marketIndex] == 0) {
            return (amount, 0);
        }

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
        // Edge case: equal split when market is empty.
        if (
            syntheticTokenBackedValue[MarketSide.Long][marketIndex] == 0 &&
            syntheticTokenBackedValue[MarketSide.Short][marketIndex] == 0
        ) {
            longAmount = amount / 2;
            shortAmount = amount - longAmount;
            return (longAmount, shortAmount);
        }

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
    function _refreshTokensPrice(uint32 marketIndex) internal {
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
        totalValueLockedInMarket[marketIndex] -= treasuryAmount;
        totalValueReservedForTreasury[marketIndex] += treasuryAmount;

        // Splits mostly to the weaker position to incentivise balance.
        (uint256 longAmount, uint256 shortAmount) =
            getMarketSplit(marketIndex, marketAmount);
        syntheticTokenBackedValue[MarketSide.Long][marketIndex] =
            syntheticTokenBackedValue[MarketSide.Long][marketIndex] +
            longAmount;
        syntheticTokenBackedValue[MarketSide.Short][marketIndex] =
            syntheticTokenBackedValue[MarketSide.Short][marketIndex] +
            shortAmount;

        emit FeesLevied(marketIndex, totalFees);
    }

    /**
     * Controls what happens with accrued yield manager interest.
     */
    function _yieldMechanism(uint32 marketIndex) internal {
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
            syntheticTokenBackedValue[MarketSide.Long][marketIndex] =
                syntheticTokenBackedValue[MarketSide.Long][marketIndex] +
                longAmount;
            syntheticTokenBackedValue[MarketSide.Short][marketIndex] =
                syntheticTokenBackedValue[MarketSide.Short][marketIndex] +
                shortAmount;
        }
    }

    function _minimum(
        uint256 liquidityOfPositionA,
        uint256 liquidityOfPositionB
    ) internal view returns (uint256) {
        if (liquidityOfPositionA < liquidityOfPositionB) {
            return liquidityOfPositionA;
        } else {
            return liquidityOfPositionB;
        }
    }

    function _calculateValueChangeForPriceMechanism(
        uint32 marketIndex,
        uint256 assetPriceGreater,
        uint256 assetPriceLess,
        uint256 baseValueExposure
    ) internal view returns (uint256) {
        uint256 valueChange = 0;

        uint256 percentageChange =
            ((assetPriceGreater - assetPriceLess) * TEN_TO_THE_18) /
                assetPrice[marketIndex];

        valueChange = (baseValueExposure * percentageChange) / TEN_TO_THE_18;

        if (valueChange > baseValueExposure) {
            // More than 100% price movement, system liquidation.
            valueChange = baseValueExposure;
        }

        return valueChange;
    }

    function _priceChangeMechanism(uint32 marketIndex, uint256 newPrice)
        internal
        returns (bool didUpdate)
    {
        // If no new price update from oracle, proceed as normal
        if (assetPrice[marketIndex] == newPrice) {
            return false;
        }

        uint256 valueChange = 0;
        uint256 baseValueExposure =
            _minimum(
                syntheticTokenBackedValue[MarketSide.Long][marketIndex],
                syntheticTokenBackedValue[MarketSide.Short][marketIndex]
            );

        // Long gains
        if (newPrice > assetPrice[marketIndex]) {
            valueChange = _calculateValueChangeForPriceMechanism(
                marketIndex,
                newPrice,
                assetPrice[marketIndex],
                baseValueExposure
            );
            syntheticTokenBackedValue[MarketSide.Long][marketIndex] =
                syntheticTokenBackedValue[MarketSide.Long][marketIndex] +
                valueChange;
            syntheticTokenBackedValue[MarketSide.Short][marketIndex] =
                syntheticTokenBackedValue[MarketSide.Short][marketIndex] -
                valueChange;
        } else {
            valueChange = _calculateValueChangeForPriceMechanism(
                marketIndex,
                assetPrice[marketIndex],
                newPrice,
                baseValueExposure
            );
            syntheticTokenBackedValue[MarketSide.Long][marketIndex] =
                syntheticTokenBackedValue[MarketSide.Long][marketIndex] -
                valueChange;
            syntheticTokenBackedValue[MarketSide.Short][marketIndex] =
                syntheticTokenBackedValue[MarketSide.Short][marketIndex] +
                valueChange;
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
                currentMarketBatchedLazyDeposit.mintAndStakeAmount -
                currentMarketBatchedLazyDeposit.mintEarlyClaimed;

        if (totalAmount > 0) {
            _transferFundsToYieldManager(marketIndex, totalAmount);

            // NOTE: no fees are calculated, but if they are desired in the future they can be added here.

            // Distribute fees across the market.
            _refreshTokensPrice(marketIndex);

            // Mint long tokens with remaining value.
            uint256 numberOfTokens =
                (totalAmount * TEN_TO_THE_18) /
                    syntheticTokenPrice[syntheticTokenType][marketIndex];

            syntheticTokens[syntheticTokenType][marketIndex].mint(
                address(this),
                numberOfTokens
            );

            syntheticTokenBackedValue[syntheticTokenType][marketIndex] =
                syntheticTokenBackedValue[syntheticTokenType][marketIndex] +
                totalAmount;

            if (currentMarketBatchedLazyDeposit.mintAndStakeAmount > 0) {
                // TODO: we must modify staker so that the view function for the users stake shows them having the stake (and not the LongShort contract)

                // NOTE: no fees are calculated, but if they are desired in the future they can be added here.

                uint256 amountToStake =
                    (currentMarketBatchedLazyDeposit.mintAndStakeAmount *
                        TEN_TO_THE_18) /
                        syntheticTokenPrice[syntheticTokenType][marketIndex];

                staker.stakeFromMintBatched(
                    marketIndex,
                    amountToStake,
                    latestUpdateIndex[marketIndex],
                    MarketSide.Long
                );

                // reset all values
                currentMarketBatchedLazyDeposit.mintAmount = 0;
                currentMarketBatchedLazyDeposit.mintAndStakeAmount = 0;
            }
            // TODO: add events
        }
    }

    /**
     * Updates the value of the long and short sides within the system
     * Note this is public. Anyone can call this function.
     */
    function _updateSystemStateInternal(uint32 marketIndex)
        internal
        doesMarketExist(marketIndex)
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

        // turn this into an assert (markets will be seeded)
        if (
            syntheticTokenBackedValue[MarketSide.Long][marketIndex] == 0 &&
            syntheticTokenBackedValue[MarketSide.Short][marketIndex] == 0
        ) {
            return;
        }
        // TODO - should never happen - seed markets
        // assert(syntheticTokenBackedValue[MarketSide.Long][marketIndex] != 0 && syntheticTokenBackedValue[MarketSide.Short][marketIndex] != 0);

        // If a negative int is return this should fail.
        uint256 newPrice = uint256(getLatestPrice(marketIndex));
        emit PriceUpdate(
            marketIndex,
            assetPrice[marketIndex],
            newPrice,
            msg.sender
        );

        bool priceChanged = false;
        // Adjusts long and short values based on price movements.
        if (
            syntheticTokenBackedValue[MarketSide.Long][marketIndex] > 0 &&
            syntheticTokenBackedValue[MarketSide.Short][marketIndex] > 0
        ) {
            // TODO: this should always be true due to market setup seed.
            priceChanged = _priceChangeMechanism(marketIndex, newPrice);
        }

        // Distibute accrued yield manager interest.
        _yieldMechanism(marketIndex);

        _refreshTokensPrice(marketIndex);
        assetPrice[marketIndex] = newPrice;
        if (priceChanged) {
            uint256 newLatestPriceStateIndex =
                latestUpdateIndex[marketIndex] + 1;
            latestUpdateIndex[marketIndex] = newLatestPriceStateIndex;

            // NOTE: we can't just merge these two values since the 'yield' has an effect on the token price inbetween oracle updates.
            marketStateSnapshot[marketIndex][newLatestPriceStateIndex][
                MarketSide.Long
            ] = syntheticTokenPrice[MarketSide.Long][marketIndex];
            marketStateSnapshot[marketIndex][newLatestPriceStateIndex][
                MarketSide.Short
            ] = syntheticTokenPrice[MarketSide.Short][marketIndex];

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
        require(totalValueLockedInMarket[marketIndex] >= amount);

        _transferFromYieldManager(marketIndex, amount);

        // Transfer funds to the sender.
        fundTokens[marketIndex].transfer(user, amount);

        // Update market state.
        totalValueLockedInMarket[marketIndex] =
            totalValueLockedInMarket[marketIndex] -
            amount;
    }

    /*
     * Transfers locked funds from LongShort into the yield manager.
     */
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
        // Boolean should be returned from yield manager and think how to approproately handle this
        yieldManagers[marketIndex].withdrawToken(amount);

        // Update market state.
        totalValueLockedInYieldManager[marketIndex] -= amount;

        // Invariant: yield managers should never have more locked funds
        // than the combined value of the market and held treasury funds.
        require(
            totalValueLockedInYieldManager[marketIndex] <=
                totalValueLockedInMarket[marketIndex] +
                    totalValueReservedForTreasury[marketIndex]
        );
    }

    /*
     * Calculates fees for the given base amount and an additional penalty
     * amount that extra fees are paid on. Users are penalised for imbalancing
     * the market.
     */
    function _getFeesForAmounts(
        uint32 marketIndex,
        uint256 baseAmount, // e18
        uint256 penaltyAmount, // e18
        bool isMint // true for mint, false for redeem
    ) internal view returns (uint256) {
        uint256 baseRate = 0; // base fee pcnt paid for all actions
        uint256 penaltyRate = 0; // penalty fee pcnt paid for imbalancing

        if (isMint) {
            baseRate = baseEntryFee[marketIndex];
            penaltyRate = badLiquidityEntryFee[marketIndex];
        } else {
            baseRate = baseExitFee[marketIndex];
            penaltyRate = badLiquidityExitFee[marketIndex];
        }

        uint256 baseFee = (baseAmount * baseRate) / feeUnitsOfPrecision;

        uint256 penaltyFee =
            (penaltyAmount * penaltyRate) / feeUnitsOfPrecision;

        return baseFee + penaltyFee;
    }

    /**
     * Calculates fees for the given mint/redeem amount. Users are penalised
     * with higher fees for imbalancing the market.
     */
    // TODO: look at splitting this function into smaller functions rather than using boolean modifiers.
    function _getFeesForAction(
        uint32 marketIndex,
        uint256 amount, // 1e18
        bool isMint, // true for mint, false for redeem
        MarketSide syntheticTokenType // true for long side, false for short side
    ) internal view returns (uint256) {
        uint256 _longValue =
            syntheticTokenBackedValue[MarketSide.Long][marketIndex];
        uint256 _shortValue =
            syntheticTokenBackedValue[MarketSide.Short][marketIndex];

        // Edge-case: no penalties for minting in a 1-sided market.
        // TODO: Is this what we want for new markets?
        if (isMint && (_longValue == 0 || _shortValue == 0)) {
            return _getFeesForAmounts(marketIndex, amount, 0, isMint);
        }

        // Compute amount that can be spent before higher fees.
        uint256 feeGap = 0;
        bool isLongMintOrShortRedeem =
            isMint == (syntheticTokenType == MarketSide.Long);
        if (isLongMintOrShortRedeem) {
            if (_shortValue > _longValue) {
                feeGap = _shortValue - _longValue;
            }
        } else {
            if (_longValue > _shortValue) {
                feeGap = _longValue - _shortValue;
            }
        }

        if (feeGap >= amount) {
            // Case 1: fee gap is big enough that user pays no penalty fees
            return _getFeesForAmounts(marketIndex, amount, 0, isMint);
        } else {
            // Case 2: user pays penalty fees on the remained after fee gap
            return
                _getFeesForAmounts(
                    marketIndex,
                    amount,
                    amount - feeGap,
                    isMint
                );
        }
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
        uint256 fees =
            _getFeesForAction(marketIndex, amount, true, syntheticTokenType);
        uint256 remaining = amount - fees;

        // Distribute fees across the market.
        _feesMechanism(marketIndex, fees);
        _refreshTokensPrice(marketIndex);

        // Mint short tokens with remaining value.
        uint256 tokens =
            (remaining * TEN_TO_THE_18) /
                syntheticTokenPrice[syntheticTokenType][marketIndex];
        syntheticTokens[syntheticTokenType][marketIndex].mint(
            transferTo,
            tokens
        );
        syntheticTokenBackedValue[syntheticTokenType][marketIndex] =
            syntheticTokenBackedValue[syntheticTokenType][marketIndex] +
            remaining;

        // TODO: combine these
        if (syntheticTokenType == MarketSide.Long) {
            emit ShortMinted(marketIndex, amount, remaining, tokens, user);
        } else {
            emit LongMinted(marketIndex, amount, remaining, tokens, user);
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
            _getFeesForAction(marketIndex, amount, false, syntheticTokenType);
        uint256 remaining = amount - fees;

        // Distribute fees across the market.
        _feesMechanism(marketIndex, fees);

        // Withdraw funds with remaining amount.
        syntheticTokenBackedValue[syntheticTokenType][marketIndex] =
            syntheticTokenBackedValue[syntheticTokenType][marketIndex] -
            amount;
        _withdrawFunds(marketIndex, remaining, msg.sender);
        _refreshTokensPrice(marketIndex);

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
        uint256 mintEarlyClaimed;
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

    // Add getters and setters for these values
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
        doesMarketExist(marketIndex)
        returns (uint256 pendingBalance)
    {
        UserLazyDeposit storage currentUserDeposits =
            userLazyActions[marketIndex][user];

        if (
            currentUserDeposits.usersCurrentUpdateIndex == 0 // NOTE: this conditional isn't strictly necessary (all the users deposit amounts will be zero too)
        ) {
            // No pending updates
            return 0;
        } else if (
            currentUserDeposits.usersCurrentUpdateIndex ==
            latestUpdateIndex[marketIndex] + 1
        ) {
            // Update is still lazy but not past the next oracle update - display the amount the user would get if they executed immediately
            uint256 fees =
                _getFeesForAction(
                    marketIndex,
                    currentUserDeposits.nextActionValues[syntheticTokenType]
                        .mintAmount,
                    true,
                    syntheticTokenType
                );
            uint256 remaining =
                currentUserDeposits.nextActionValues[syntheticTokenType]
                    .mintAmount - fees;

            uint256 tokens =
                (remaining * TEN_TO_THE_18) /
                    syntheticTokenPrice[syntheticTokenType][marketIndex];

            return tokens;
        } else {
            // Lazy period has passed, show the result of the lazy execution
            assert(
                currentUserDeposits.usersCurrentUpdateIndex <=
                    latestUpdateIndex[marketIndex]
            );

            uint256 tokensToMint =
                (currentUserDeposits.nextActionValues[syntheticTokenType]
                    .mintAmount * TEN_TO_THE_18) /
                    marketStateSnapshot[marketIndex][
                        latestUpdateIndex[marketIndex]
                    ][syntheticTokenType];
            return tokensToMint;
        }
    }

    // TODO: modify this function (or make a different version) that takes in the desired useage and does either partial or full "early use"
    // TODO: WARNING!! This function is re-entrancy vulnerable if the synthetic token has any execution hooks
    function _executeOutstandingLazySettlementsAction(
        address user,
        uint32 marketIndex
    ) internal {
        UserLazyDeposit storage currentUserDeposits =
            userLazyActions[marketIndex][user];

        if (
            currentUserDeposits.nextActionValues[MarketSide.Long].mintAmount !=
            0
        ) {
            uint256 tokensToMint =
                (((currentUserDeposits.nextActionValues[MarketSide.Long]
                    .mintAmount -
                    currentUserDeposits.nextActionValues[MarketSide.Long]
                        .mintEarlyClaimed) * TEN_TO_THE_18) /
                    marketStateSnapshot[marketIndex][
                        latestUpdateIndex[marketIndex]
                    ][MarketSide.Long]);
            uint256 balance =
                syntheticTokens[MarketSide.Long][marketIndex].balanceOf(
                    address(this)
                );
            // syntheticTokens[MarketSide.Long][marketIndex].approve(, tokensToMint);
            syntheticTokens[MarketSide.Long][marketIndex].transfer(
                user,
                tokensToMint
            );

            currentUserDeposits.nextActionValues[MarketSide.Long]
                .mintAmount = 0;
        }
        if (
            currentUserDeposits.nextActionValues[MarketSide.Short].mintAmount !=
            0
        ) {
            uint256 tokensToMint =
                (((currentUserDeposits.nextActionValues[MarketSide.Short]
                    .mintAmount -
                    currentUserDeposits.nextActionValues[MarketSide.Short]
                        .mintEarlyClaimed) * TEN_TO_THE_18) /
                    marketStateSnapshot[marketIndex][
                        latestUpdateIndex[marketIndex]
                    ][MarketSide.Short]);
            syntheticTokens[MarketSide.Short][marketIndex].transfer(
                user,
                tokensToMint
            );
            currentUserDeposits.nextActionValues[MarketSide.Short]
                .mintAmount = 0;
        }
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
            _executeOutstandingLazySettlementsAction(user, marketIndex);
        }
        // TODO: add events
    }

    function _getMaxAvailableLazily(
        address user,
        uint32 marketIndex, // TODO: make this internal ?
        MarketSide syntheticTokenType
    )
        internal
        returns (
            uint256 amountPaymentTokenLazyAvailableImmediately,
            uint256 amountSynthTokenLazyAvailableImmediately
        )
    {
        UserLazyDeposit storage currentUserDeposits =
            userLazyActions[marketIndex][user];

        // this function shouldn't be called if the next price has already happened (it means a logical bug somewhere else in the code!)
        assert(
            currentUserDeposits.usersCurrentUpdateIndex <=
                latestUpdateIndex[marketIndex]
        );

        if (syntheticTokenType == ILongShort.MarketSide.Long) {
            amountPaymentTokenLazyAvailableImmediately =
                ((currentUserDeposits.nextActionValues[MarketSide.Long]
                    .mintAmount * percentageAvailableForEarlyExitNumerator) /
                    percentageAvailableForEarlyExitDenominator) -
                currentUserDeposits.nextActionValues[MarketSide.Long]
                    .mintEarlyClaimed;

            amountSynthTokenLazyAvailableImmediately =
                (amountPaymentTokenLazyAvailableImmediately * TEN_TO_THE_18) /
                syntheticTokenPrice[MarketSide.Long][marketIndex];
        } else {
            amountPaymentTokenLazyAvailableImmediately =
                ((currentUserDeposits.nextActionValues[MarketSide.Short]
                    .mintAmount * percentageAvailableForEarlyExitNumerator) /
                    percentageAvailableForEarlyExitDenominator) -
                currentUserDeposits.nextActionValues[MarketSide.Short]
                    .mintEarlyClaimed;

            amountSynthTokenLazyAvailableImmediately =
                (amountPaymentTokenLazyAvailableImmediately * TEN_TO_THE_18) /
                syntheticTokenPrice[MarketSide.Short][marketIndex];
        }
    }

    function _executeOutstandingLazySettlementsPartialOrCurrentIfNeeded(
        address user,
        uint32 marketIndex, // TODO: make this internal ?
        MarketSide syntheticTokenType,
        uint256 minimumAmountRequired
    ) internal {
        UserLazyDeposit storage currentUserDeposits =
            userLazyActions[marketIndex][user];

        if (
            currentUserDeposits.usersCurrentUpdateIndex <=
            latestUpdateIndex[marketIndex] &&
            currentUserDeposits.usersCurrentUpdateIndex != 0 // NOTE: this conditional isn't strictly necessary (all the users deposit amounts will be zero too)
        ) {
            _executeOutstandingLazySettlementsAction(user, marketIndex);
        } else {
            (
                uint256 maxAvailableAmountLazily,
                uint256 maxAvailableSynthLazily
            ) = _getMaxAvailableLazily(user, marketIndex, syntheticTokenType);

            if (maxAvailableSynthLazily < minimumAmountRequired) {
                // Convert to an instant mint
                _transferFundsToYieldManager(
                    marketIndex,
                    currentUserDeposits.nextActionValues[syntheticTokenType]
                        .mintAmount
                );
                _mint(
                    marketIndex,
                    currentUserDeposits.nextActionValues[syntheticTokenType]
                        .mintAmount,
                    user,
                    user,
                    syntheticTokenType
                );

                batchedLazyDeposit[marketIndex][syntheticTokenType]
                    .mintEarlyClaimed -= currentUserDeposits.nextActionValues[
                    syntheticTokenType
                ]
                    .mintEarlyClaimed;
                batchedLazyDeposit[marketIndex][syntheticTokenType]
                    .mintAmount -= currentUserDeposits.nextActionValues[
                    syntheticTokenType
                ]
                    .mintAmount;

                currentUserDeposits.nextActionValues[syntheticTokenType]
                    .mintAmount = 0;
                currentUserDeposits.nextActionValues[syntheticTokenType]
                    .mintEarlyClaimed = 0;
            } else {
                // Credit the user `maxAvailableAmountLazily` they need and do all relevant accounting (might as well give them all of it, right?)
                // TODO: this is common code that happens in multiple places - refactor!

                _transferFundsToYieldManager(
                    marketIndex,
                    maxAvailableAmountLazily
                );
                // Distribute fees across the market.
                _refreshTokensPrice(marketIndex); // NOTE - we refresh the token price BEFORE minting tokens for the user, not after

                syntheticTokens[syntheticTokenType][marketIndex].mint(
                    address(this),
                    maxAvailableSynthLazily
                );

                syntheticTokenBackedValue[syntheticTokenType][marketIndex] =
                    syntheticTokenBackedValue[syntheticTokenType][marketIndex] +
                    maxAvailableAmountLazily;

                currentUserDeposits.nextActionValues[syntheticTokenType]
                    .mintEarlyClaimed += maxAvailableAmountLazily;
                batchedLazyDeposit[marketIndex][syntheticTokenType]
                    .mintEarlyClaimed += maxAvailableAmountLazily;
            }
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

    function executeOutstandingLazySettlementsPartialOrCurrentIfNeeded(
        address user,
        uint32 marketIndex, // TODO: make this internal ?
        MarketSide syntheticTokenType,
        uint256 minimumAmountRequired
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
        _executeOutstandingLazySettlementsPartialOrCurrentIfNeeded(
            user,
            marketIndex,
            syntheticTokenType,
            minimumAmountRequired
        );
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

        uint256 newLongValueIgnoringFees =
            syntheticTokenBackedValue[MarketSide.Long][marketIndex] -
                longAmountToRedeem;
        uint256 newShortValueIgnoringFees =
            syntheticTokenBackedValue[MarketSide.Short][marketIndex] -
                shortAmountToRedeem;

        // penalty fee is shared equally between
        // all users on the side that ends up causing an imbalance in the
        // batch.
        uint256 penaltyAmount =
            (syntheticTokenBackedValue[MarketSide.Long][marketIndex] >=
                syntheticTokenBackedValue[MarketSide.Short][marketIndex] &&
                newShortValueIgnoringFees > newLongValueIgnoringFees)
                ? newShortValueIgnoringFees - newLongValueIgnoringFees
                : (syntheticTokenBackedValue[MarketSide.Short][marketIndex] >=
                    syntheticTokenBackedValue[MarketSide.Long][marketIndex] &&
                    newLongValueIgnoringFees > newShortValueIgnoringFees)
                ? newLongValueIgnoringFees - newShortValueIgnoringFees
                : 0;

        bool penaltyAmountForLong =
            newShortValueIgnoringFees > newLongValueIgnoringFees;

        uint256 totalFeesLong =
            _getFeesForAmounts(
                marketIndex,
                longAmountToRedeem,
                penaltyAmountForLong ? penaltyAmount : 0,
                false
            );

        uint256 totalFeesShort =
            _getFeesForAmounts(
                marketIndex,
                shortAmountToRedeem,
                !penaltyAmountForLong ? penaltyAmount : 0,
                false
            );

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

        _refreshTokensPrice(marketIndex);
    }
}
