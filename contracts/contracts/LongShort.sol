// SPDX-License-Identifier: BUSL-1.1

pragma solidity 0.8.3;

import "hardhat/console.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@chainlink/contracts/src/v0.6/interfaces/AggregatorV3Interface.sol";

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
    mapping(uint32 => uint256) public longValue;
    mapping(uint32 => uint256) public shortValue;
    mapping(uint32 => uint256) public totalValueLockedInMarket;
    mapping(uint32 => uint256) public totalValueLockedInYieldManager;
    mapping(uint32 => uint256) public totalValueReservedForTreasury;
    mapping(uint32 => uint256) public assetPrice;
    mapping(uint32 => uint256) public longTokenPrice; // NOTE: cannot deprecate this value and use the marketStateSnapshot values instead since these values change inbetween assetPrice updates (when yield is collected)
    mapping(uint32 => uint256) public shortTokenPrice; // NOTE: cannot deprecate this value and use the marketStateSnapshot values instead since these values change inbetween assetPrice updates (when yield is collected)
    mapping(uint32 => IERC20) public fundTokens;
    mapping(uint32 => IYieldManager) public yieldManagers;
    mapping(uint32 => IOracleManager) public oracleManagers;
    uint256[45] private __marketStateGap;

    // Synthetic long/short tokens users can mint and redeem.
    mapping(uint32 => ISyntheticToken) public longTokens;
    mapping(uint32 => ISyntheticToken) public shortTokens;
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
        longTokens[latestMarket] = ISyntheticToken(
            tokenFactory.createTokenLong(
                syntheticName,
                syntheticSymbol,
                address(staker)
            )
        );

        // Create new synthetic short token.
        shortTokens[latestMarket] = ISyntheticToken(
            tokenFactory.createTokenShort(
                syntheticName,
                syntheticSymbol,
                address(staker)
            )
        );

        // Initial market state.
        longTokenPrice[latestMarket] = TEN_TO_THE_18;
        shortTokenPrice[latestMarket] = TEN_TO_THE_18;
        fundTokens[latestMarket] = IERC20(_fundToken);
        yieldManagers[latestMarket] = IYieldManager(_yieldManager);
        oracleManagers[latestMarket] = IOracleManager(_oracleManager);
        assetPrice[latestMarket] = uint256(getLatestPrice(latestMarket));

        emit SyntheticTokenCreated(
            latestMarket,
            address(longTokens[latestMarket]),
            address(shortTokens[latestMarket]),
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
            longTokens[marketIndex],
            shortTokens[marketIndex],
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
        if (shortValue[marketIndex] >= longValue[marketIndex]) {
            return TEN_TO_THE_18;
        } else {
            return
                (shortValue[marketIndex] * TEN_TO_THE_18) /
                longValue[marketIndex];
        }
    }

    /**
     * Returns % of short position that is filled
     * zero div error if both are zero
     */
    function getShortBeta(uint32 marketIndex) public view returns (uint256) {
        if (longValue[marketIndex] >= shortValue[marketIndex]) {
            return TEN_TO_THE_18;
        } else {
            return
                (longValue[marketIndex] * TEN_TO_THE_18) /
                shortValue[marketIndex];
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
        if (longValue[marketIndex] > shortValue[marketIndex]) {
            marketPcnt =
                ((longValue[marketIndex] - shortValue[marketIndex]) * 10000) /
                totalValueLockedInMarket[marketIndex];
        } else {
            marketPcnt =
                ((shortValue[marketIndex] - longValue[marketIndex]) * 10000) /
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
        if (longValue[marketIndex] == 0 && shortValue[marketIndex] == 0) {
            longAmount = amount / 2;
            shortAmount = amount - longAmount;
            return (longAmount, shortAmount);
        }

        // The percentage value that a position receives depends on the amount
        // of total market value taken up by the _opposite_ position.
        uint256 longPcnt =
            (shortValue[marketIndex] * 10000) /
                (longValue[marketIndex] + shortValue[marketIndex]);

        longAmount = (amount * longPcnt) / 10000;
        shortAmount = amount - longAmount;
        return (longAmount, shortAmount);
    }

    /**
     * Adjusts the long/short token prices according to supply and value.
     */
    function _refreshTokensPrice(uint32 marketIndex) internal {
        uint256 longTokenSupply = longTokens[marketIndex].totalSupply();
        if (longTokenSupply > 0) {
            longTokenPrice[marketIndex] =
                (longValue[marketIndex] * TEN_TO_THE_18) /
                longTokenSupply;
        }

        uint256 shortTokenSupply = shortTokens[marketIndex].totalSupply();
        if (shortTokenSupply > 0) {
            shortTokenPrice[marketIndex] =
                (shortValue[marketIndex] * TEN_TO_THE_18) /
                shortTokenSupply;
        }

        emit TokenPriceRefreshed(
            marketIndex,
            longTokenPrice[marketIndex],
            shortTokenPrice[marketIndex]
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
        longValue[marketIndex] = longValue[marketIndex] + longAmount;
        shortValue[marketIndex] = shortValue[marketIndex] + shortAmount;

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
            longValue[marketIndex] = longValue[marketIndex] + longAmount;
            shortValue[marketIndex] = shortValue[marketIndex] + shortAmount;
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
            _minimum(longValue[marketIndex], shortValue[marketIndex]);

        // Long gains
        if (newPrice > assetPrice[marketIndex]) {
            valueChange = _calculateValueChangeForPriceMechanism(
                marketIndex,
                newPrice,
                assetPrice[marketIndex],
                baseValueExposure
            );
            longValue[marketIndex] = longValue[marketIndex] + valueChange;
            shortValue[marketIndex] = shortValue[marketIndex] - valueChange;
        } else {
            valueChange = _calculateValueChangeForPriceMechanism(
                marketIndex,
                assetPrice[marketIndex],
                newPrice,
                baseValueExposure
            );
            longValue[marketIndex] = longValue[marketIndex] - valueChange;
            shortValue[marketIndex] = shortValue[marketIndex] + valueChange;
        }
        return true;
    }

    function handleBatchedDepositLong(uint32 marketIndex)
        internal
        returns (uint256 tokensLong)
    {
        // LongSide
        // Deposit funds and compute fees.
        BatchedLazyDeposit storage currentMarketBatchedLazyDeposit =
            batchedLazyDeposit[marketIndex];
        uint256 totalAmountLong =
            currentMarketBatchedLazyDeposit.mintLong +
                currentMarketBatchedLazyDeposit.mintAndStakeLong;

        if (totalAmountLong > 0) {
            _depositFunds(marketIndex, totalAmountLong);
            uint256 feesLong =
                _getFeesForAction(marketIndex, totalAmountLong, true, true);
            uint256 remainingLong = totalAmountLong - feesLong;

            // Distribute fees across the market.
            _feesMechanism(marketIndex, feesLong);
            _refreshTokensPrice(marketIndex);

            // Mint long tokens with remaining value.
            tokensLong =
                (remainingLong * TEN_TO_THE_18) /
                longTokenPrice[marketIndex];
            // TODO: we must modify Synth ERC20 so that this addrdess (`address(this)`) shows a `balanceOf` of zero and the balance is correctly added to the users in the batch's `balanceOf`
            longTokens[marketIndex].mint(address(this), tokensLong);
            longValue[marketIndex] = longValue[marketIndex] + remainingLong;
            if (currentMarketBatchedLazyDeposit.mintAndStakeLong > 0) {
                uint256 feesLongStake =
                    _getFeesForAction(
                        marketIndex,
                        currentMarketBatchedLazyDeposit.mintAndStakeLong,
                        true,
                        true
                    );
                uint256 tokensToStakeLong =
                    currentMarketBatchedLazyDeposit.mintAndStakeLong -
                        feesLongStake;

                // TODO: we must modify staker so that the view function for the users stake shows them having the stake (and not the LongShort contract)
                staker.stakeFromMintBatched(
                    marketIndex,
                    tokensToStakeLong,
                    latestUpdateIndex[marketIndex],
                    true
                );

                // reset all values
                currentMarketBatchedLazyDeposit.mintLong = 0;
                currentMarketBatchedLazyDeposit.mintAndStakeLong = 0;
            }
            // TODO: add events
        }
    }

    function handleBatchedDepositShort(uint32 marketIndex)
        internal
        returns (uint256 tokensShort)
    {
        // ShortSide
        // Deposit funds and compute fees.
        BatchedLazyDeposit storage currentMarketBatchedLazyDeposit =
            batchedLazyDeposit[marketIndex];
        uint256 totalAmountShort =
            currentMarketBatchedLazyDeposit.mintShort +
                currentMarketBatchedLazyDeposit.mintAndStakeShort;
        if (totalAmountShort > 0) {
            _depositFunds(marketIndex, totalAmountShort);
            uint256 feesShort =
                _getFeesForAction(marketIndex, totalAmountShort, true, true);
            uint256 remainingShort = totalAmountShort - feesShort;

            // Distribute fees across the market.
            _feesMechanism(marketIndex, feesShort);
            _refreshTokensPrice(marketIndex);

            // Mint long tokens with remaining value.
            tokensShort =
                (remainingShort * TEN_TO_THE_18) /
                longTokenPrice[marketIndex];
            longTokens[marketIndex].mint(address(this), tokensShort);
            longValue[marketIndex] = longValue[marketIndex] + remainingShort;

            if (currentMarketBatchedLazyDeposit.mintAndStakeShort > 0) {
                uint256 feesShortStake =
                    _getFeesForAction(
                        marketIndex,
                        currentMarketBatchedLazyDeposit.mintAndStakeShort,
                        true,
                        true
                    );
                uint256 tokensToStakeShort =
                    currentMarketBatchedLazyDeposit.mintAndStakeShort -
                        feesShortStake;
                staker.stakeFromMintBatched(
                    marketIndex,
                    tokensToStakeShort,
                    latestUpdateIndex[marketIndex],
                    false
                );

                // reset all values
                currentMarketBatchedLazyDeposit.mintShort = 0;
                currentMarketBatchedLazyDeposit.mintAndStakeShort = 0;
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
            longTokenPrice[marketIndex],
            shortTokenPrice[marketIndex],
            longValue[marketIndex],
            shortValue[marketIndex]
        );

        // turn this into an assert (markets will be seeded)
        if (longValue[marketIndex] == 0 && shortValue[marketIndex] == 0) {
            return;
        }
        // TODO - should never happen - seed markets
        // assert(longValue[marketIndex] != 0 && shortValue[marketIndex] != 0);

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
        if (longValue[marketIndex] > 0 && shortValue[marketIndex] > 0) {
            // TODO: this should always be true due to market setup seed.
            priceChanged = _priceChangeMechanism(marketIndex, newPrice);
        }

        // Distibute accrued yield manager interest.
        _yieldMechanism(marketIndex);

        _refreshTokensPrice(marketIndex);

        if (priceChanged) {
            assetPrice[marketIndex] = newPrice;

            uint256 newLatestPriceStateIndex =
                latestUpdateIndex[marketIndex] + 1;
            latestUpdateIndex[marketIndex] = newLatestPriceStateIndex;

            MarketStateSnapshotStruct storage stateStruct =
                marketStateSnapshot[marketIndex][newLatestPriceStateIndex];
            stateStruct.tokenPriceLong = longTokenPrice[marketIndex];
            stateStruct.tokenPriceShort = shortTokenPrice[marketIndex];

            uint256 totalAmountLongMinted =
                handleBatchedDepositLong(marketIndex);
            uint256 totalAmountShortMinted =
                handleBatchedDepositShort(marketIndex);

            // TODO: might be inefficient doing it like this, maybe don't even run the `handleBatchedDepositLong` function if there is nothing to mint.
            if (totalAmountLongMinted != 0) {
                // TODO: math inaccurate - need to divide by 10^18 or something. Basically this is almost right, but needs scrutiny!!
                stateStruct.tokenPriceLongWithFees =
                    ((batchedLazyDeposit[marketIndex].mintLong +
                        batchedLazyDeposit[marketIndex].mintAndStakeLong) *
                        TEN_TO_THE_18) /
                    totalAmountLongMinted;
            }
            if (totalAmountShortMinted != 0) {
                stateStruct.tokenPriceShortWithFees =
                    ((batchedLazyDeposit[marketIndex].mintShort +
                        batchedLazyDeposit[marketIndex].mintAndStakeShort) *
                        TEN_TO_THE_18) /
                    totalAmountShortMinted;
            }
        }

        emit ValueLockedInSystem(
            marketIndex,
            totalValueLockedInMarket[marketIndex],
            longValue[marketIndex],
            shortValue[marketIndex]
        );

        // Invariant: long/short values should never differ from total value.
        assert(
            longValue[marketIndex] + shortValue[marketIndex] ==
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
    function _depositFunds(uint32 marketIndex, uint256 amount) internal {
        fundTokens[marketIndex].transferFrom(msg.sender, address(this), amount);

        // Update global value state.
        totalValueLockedInMarket[marketIndex] =
            totalValueLockedInMarket[marketIndex] +
            amount;

        _transferToYieldManager(marketIndex, amount);
    }

    /*
     * Returns locked funds from the market to the sender.
     */
    function _withdrawFunds(uint32 marketIndex, uint256 amount) internal {
        require(totalValueLockedInMarket[marketIndex] >= amount);

        _transferFromYieldManager(marketIndex, amount);

        // Transfer funds to the sender.
        fundTokens[marketIndex].transfer(msg.sender, amount);

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
    function _getFeesForAction(
        uint32 marketIndex,
        uint256 amount, // 1e18
        bool isMint, // true for mint, false for redeem
        bool isLong // true for long side, false for short side
    ) internal view returns (uint256) {
        uint256 _longValue = longValue[marketIndex];
        uint256 _shortValue = shortValue[marketIndex];

        // Edge-case: no penalties for minting in a 1-sided market.
        // TODO: Is this what we want for new markets?
        if (isMint && (_longValue == 0 || _shortValue == 0)) {
            return _getFeesForAmounts(marketIndex, amount, 0, isMint);
        }

        // Compute amount that can be spent before higher fees.
        uint256 feeGap = 0;
        bool isLongMintOrShortRedeem = isMint == isLong;
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
        _mintLong(marketIndex, amount, msg.sender, msg.sender);
    }

    /**
     * Creates a short position
     */
    function mintShort(uint32 marketIndex, uint256 amount)
        external
        refreshSystemState(marketIndex)
    {
        _mintShort(marketIndex, amount, msg.sender, msg.sender);
    }

    /**
     * Creates a long position and stakes it
     */
    function mintLongAndStake(uint32 marketIndex, uint256 amount)
        external
        refreshSystemState(marketIndex)
    {
        uint256 tokensMinted =
            _mintLong(marketIndex, amount, msg.sender, address(staker));

        staker.stakeFromMint(longTokens[marketIndex], tokensMinted, msg.sender);
    }

    /**
     * Creates a short position and stakes it
     */
    function mintShortAndStake(uint32 marketIndex, uint256 amount)
        external
        refreshSystemState(marketIndex)
    {
        uint256 tokensMinted =
            _mintShort(marketIndex, amount, msg.sender, address(staker));

        staker.stakeFromMint(
            shortTokens[marketIndex],
            tokensMinted,
            msg.sender
        );
    }

    function _mintLong(
        uint32 marketIndex,
        uint256 amount,
        address user,
        address transferTo
    ) internal returns (uint256) {
        // Deposit funds and compute fees.
        _depositFunds(marketIndex, amount);
        uint256 fees = _getFeesForAction(marketIndex, amount, true, true);
        uint256 remaining = amount - fees;

        // Distribute fees across the market.
        _feesMechanism(marketIndex, fees);
        _refreshTokensPrice(marketIndex);

        // Mint long tokens with remaining value.
        uint256 tokens =
            (remaining * TEN_TO_THE_18) / longTokenPrice[marketIndex];
        longTokens[marketIndex].mint(transferTo, tokens);
        longValue[marketIndex] = longValue[marketIndex] + remaining;

        emit LongMinted(marketIndex, amount, remaining, tokens, user);

        emit ValueLockedInSystem(
            marketIndex,
            totalValueLockedInMarket[marketIndex],
            longValue[marketIndex],
            shortValue[marketIndex]
        );
        return tokens;
    }

    function _mintShort(
        uint32 marketIndex,
        uint256 amount,
        address user,
        address transferTo
    ) internal returns (uint256) {
        // Deposit funds and compute fees.
        _depositFunds(marketIndex, amount);
        uint256 fees = _getFeesForAction(marketIndex, amount, true, false);
        uint256 remaining = amount - fees;

        // Distribute fees across the market.
        _feesMechanism(marketIndex, fees);
        _refreshTokensPrice(marketIndex);

        // Mint short tokens with remaining value.
        uint256 tokens =
            (remaining * TEN_TO_THE_18) / shortTokenPrice[marketIndex];
        shortTokens[marketIndex].mint(transferTo, tokens);
        shortValue[marketIndex] = shortValue[marketIndex] + remaining;

        emit ShortMinted(marketIndex, amount, remaining, tokens, user);

        emit ValueLockedInSystem(
            marketIndex,
            totalValueLockedInMarket[marketIndex],
            longValue[marketIndex],
            shortValue[marketIndex]
        );
        return tokens;
    }

    ////////////////////////////////////
    /////////// REDEEM TOKENS //////////
    ////////////////////////////////////

    function _redeemLong(uint32 marketIndex, uint256 tokensToRedeem)
        internal
        refreshSystemState(marketIndex)
    {
        // Only this contract has permission to call this function
        longTokens[marketIndex].synthRedeemBurn(msg.sender, tokensToRedeem);

        // Compute fees.
        uint256 amount =
            (tokensToRedeem * longTokenPrice[marketIndex]) / TEN_TO_THE_18;
        uint256 fees = _getFeesForAction(marketIndex, amount, false, true);
        uint256 remaining = amount - fees;

        // Distribute fees across the market.
        _feesMechanism(marketIndex, fees);

        // Withdraw funds with remaining amount.
        longValue[marketIndex] = longValue[marketIndex] - amount;
        _withdrawFunds(marketIndex, remaining);
        _refreshTokensPrice(marketIndex);

        emit LongRedeem(
            marketIndex,
            tokensToRedeem,
            amount,
            remaining,
            msg.sender
        );

        emit ValueLockedInSystem(
            marketIndex,
            totalValueLockedInMarket[marketIndex],
            longValue[marketIndex],
            shortValue[marketIndex]
        );
    }

    function _redeemShort(uint32 marketIndex, uint256 tokensToRedeem)
        internal
        refreshSystemState(marketIndex)
    {
        // Only this contract has permission to call this function
        shortTokens[marketIndex].synthRedeemBurn(msg.sender, tokensToRedeem);

        // Compute fees.
        uint256 amount =
            (tokensToRedeem * shortTokenPrice[marketIndex]) / TEN_TO_THE_18;
        uint256 fees = _getFeesForAction(marketIndex, amount, false, false);
        uint256 remaining = amount - fees;

        // Distribute fees across the market.
        _feesMechanism(marketIndex, fees);

        // Withdraw funds with remaining amount.
        shortValue[marketIndex] = shortValue[marketIndex] - amount;
        _withdrawFunds(marketIndex, remaining);
        _refreshTokensPrice(marketIndex);

        emit ShortRedeem(
            marketIndex,
            tokensToRedeem,
            amount,
            remaining,
            msg.sender
        );

        emit ValueLockedInSystem(
            marketIndex,
            totalValueLockedInMarket[marketIndex],
            longValue[marketIndex],
            shortValue[marketIndex]
        );
    }

    function redeemLong(uint32 marketIndex, uint256 tokensToRedeem)
        external
        override
    {
        _redeemLong(marketIndex, tokensToRedeem);
    }

    function redeemLongAll(uint32 marketIndex) external {
        uint256 tokensToRedeem = longTokens[marketIndex].balanceOf(msg.sender);
        _redeemLong(marketIndex, tokensToRedeem);
    }

    function redeemShort(uint32 marketIndex, uint256 tokensToRedeem)
        external
        override
    {
        _redeemShort(marketIndex, tokensToRedeem);
    }

    function redeemShortAll(uint32 marketIndex) external {
        uint256 tokensToRedeem = shortTokens[marketIndex].balanceOf(msg.sender);
        _redeemShort(marketIndex, tokensToRedeem);
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

    struct UserLazyDeposit {
        uint256 usersCurrentUpdateIndex;
        uint256 mintLong;
        uint256 mintShort;
        uint256 mintAndStakeLong;
        uint256 mintAndStakeShort;
    }
    struct BatchedLazyDeposit {
        uint256 mintLong;
        uint256 mintShort;
        uint256 mintAndStakeLong;
        uint256 mintAndStakeShort;
    }
    struct MarketStateSnapshotStruct {
        uint256 tokenPriceLong;
        uint256 tokenPriceShort;
        // QUESTION? possible to compress this into two uint128 values?
        // TODO: Optimise this - just putting this here to get things to work.
        uint256 tokenPriceLongWithFees;
        uint256 tokenPriceShortWithFees;
    }

    mapping(uint32 => uint256) public latestUpdateIndex;
    mapping(uint32 => mapping(uint256 => MarketStateSnapshotStruct)) public marketStateSnapshot;
    mapping(uint32 => BatchedLazyDeposit) public batchedLazyDeposit;
    mapping(uint32 => mapping(address => UserLazyDeposit)) public userLazyActions;

    function _executeOutstandingLazyDeposits(address user, uint32 marketIndex)
        internal
    {
        UserLazyDeposit storage currentUserDeposits =
            userLazyActions[marketIndex][msg.sender];

        if (
            currentUserDeposits.usersCurrentUpdateIndex <
            latestUpdateIndex[marketIndex] &&
            currentUserDeposits.usersCurrentUpdateIndex != 0 // NOTE: this conditional isn't strictly necessary (all the users deposit amounts will be zero too)
        ) {
            if (currentUserDeposits.mintLong != 0) {
                longTokens[marketIndex].transferFrom(
                    address(this),
                    msg.sender,
                    currentUserDeposits.mintLong
                );

                currentUserDeposits.mintLong = 0;
            }
            if (currentUserDeposits.mintShort != 0) {
                // currentUserDeposits.mintShort
                shortTokens[marketIndex].transferFrom(
                    address(this),
                    msg.sender,
                    currentUserDeposits.mintShort
                );
                currentUserDeposits.mintShort = 0;
            }
            if (
                currentUserDeposits.mintAndStakeLong != 0 ||
                currentUserDeposits.mintAndStakeShort != 0
            ) {
                staker.transferBatchStakeToUser(
                    currentUserDeposits.mintAndStakeLong,
                    currentUserDeposits.mintAndStakeShort,
                    marketIndex,
                    currentUserDeposits.usersCurrentUpdateIndex,
                    user
                );
                // TODO: do the accounting for the user
                currentUserDeposits.mintAndStakeLong = 0;
                currentUserDeposits.mintAndStakeShort = 0;
            }

            currentUserDeposits.usersCurrentUpdateIndex = 0;
        }
        // TODO: add events
    }

    modifier executeOutstandingLazyDeposits(address user, uint32 marketIndex)
        virtual {
        _executeOutstandingLazyDeposits(user, marketIndex);

        _;
    }

    function mintLongLazy(uint32 marketIndex, uint256 amount)
        external
        executeOutstandingLazyDeposits(msg.sender, marketIndex)
    {
        // TODO: pre-deposit them into the market?
        //    - for now not doing that for simplicity, don't gain that much doing so either just more expensive tx (for very little yield)
        fundTokens[marketIndex].transferFrom(msg.sender, address(this), amount);

        batchedLazyDeposit[marketIndex].mintLong += amount;
        userLazyActions[marketIndex][msg.sender].mintLong += amount;
        userLazyActions[marketIndex][msg.sender].usersCurrentUpdateIndex =
            latestUpdateIndex[marketIndex] +
            1;
        // TODO: add events

        emit LazyLongMinted(
            marketIndex,
            amount,
            msg.sender,
            batchedLazyDeposit[marketIndex].mintLong,
            latestUpdateIndex[marketIndex] + 1
        );
    }

    function mintShortLazy(uint32 marketIndex, uint256 amount)
        external
        executeOutstandingLazyDeposits(msg.sender, marketIndex)
    {
        fundTokens[marketIndex].transferFrom(msg.sender, address(this), amount);

        batchedLazyDeposit[marketIndex].mintShort += amount;
        userLazyActions[marketIndex][msg.sender].mintShort += amount;

        userLazyActions[marketIndex][msg.sender].usersCurrentUpdateIndex =
            latestUpdateIndex[marketIndex] +
            1;
        // TODO: add events
    }

    function mintLongAndStakeLazy(uint32 marketIndex, uint256 amount)
        external
        executeOutstandingLazyDeposits(msg.sender, marketIndex)
    {
        fundTokens[marketIndex].transferFrom(msg.sender, address(this), amount);

        batchedLazyDeposit[marketIndex].mintAndStakeLong += amount;
        userLazyActions[marketIndex][msg.sender].mintAndStakeShort += amount;

        userLazyActions[marketIndex][msg.sender].usersCurrentUpdateIndex =
            latestUpdateIndex[marketIndex] +
            1;
        // TODO: add events
    }

    function mintShortAndStakeLazy(uint32 marketIndex, uint256 amount)
        external
        executeOutstandingLazyDeposits(msg.sender, marketIndex)
    {
        fundTokens[marketIndex].transferFrom(msg.sender, address(this), amount);

        batchedLazyDeposit[marketIndex].mintAndStakeShort += amount;
        userLazyActions[marketIndex][msg.sender].mintAndStakeShort += amount;

        userLazyActions[marketIndex][msg.sender].usersCurrentUpdateIndex =
            latestUpdateIndex[marketIndex] +
            1;
        // TODO: add events
    }
}
