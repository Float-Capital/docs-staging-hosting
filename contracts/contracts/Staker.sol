// SPDX-License-Identifier: BUSL-1.1

pragma solidity 0.8.3;

import "hardhat/console.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC20/presets/ERC20PresetMinterPauserUpgradeable.sol";

import "./interfaces/IFloatToken.sol";
import "./interfaces/ILongShort.sol";
import "./interfaces/IStaker.sol";
import "./interfaces/ISyntheticToken.sol";

contract Staker is IStaker, Initializable {
  /*╔═════════════════════════════╗
    ║          VARIABLES          ║
    ╚═════════════════════════════╝*/

  // Fixed-precision constants
  uint256 public constant FLOAT_ISSUANCE_FIXED_DECIMAL = 1e42;
  // 2^52 ~= 4.5e15
  // With an exponent of 5, the largest total liquidity possible in a market (to avoid integer overflow on exponentiation) is ~10^31 or 10 Trillion (10^13)
  // NOTE: this also means if the total market value is less than 2^52 there will be a division by zero error
  uint256 public constant safeExponentBitShifting = 52;

  // Global state
  address public admin;
  address public floatCapital;
  uint256 public floatPercentage;

  address public longShort;
  address public floatToken;

  // Market specific
  mapping(uint32 => uint256) public marketLaunchIncentive_period; // seconds
  mapping(uint32 => uint256) public marketLaunchIncentive_multipliers; // e18 scale
  mapping(uint32 => uint256) public marketUnstakeFeeBasis_points;
  mapping(uint32 => uint256) public balanceIncentive_curveExponent;
  mapping(uint32 => int256) public balanceIncentiveCurve_equilibriumOffset;

  mapping(uint32 => mapping(bool => address)) public syntheticTokens;

  mapping(address => uint32) public marketIndexOfToken;

  // Reward specific
  mapping(uint32 => uint256) public latestRewardIndex;
  mapping(uint32 => mapping(uint256 => AccumulativeIssuancePerStakedSynthSnapshot))
    public accumulativeFloatPerSyntheticTokenSnapshots;
  struct AccumulativeIssuancePerStakedSynthSnapshot {
    uint256 timestamp;
    uint256 accumulativeFloatPerSyntheticToken_long;
    uint256 accumulativeFloatPerSyntheticToken_short;
  }

  // User specific
  mapping(uint32 => mapping(address => uint256)) public userIndexOfLastClaimedReward;
  mapping(address => mapping(address => uint256)) public userAmountStaked;

  // Token shift management
  mapping(uint32 => uint256) public batched_stakerNextTokenShiftIndex;
  /**
  @notice Used to link a token shift to a staker state
  @dev tokenShiftIndex => accumulativeFloatIssuanceSnapshotIndex
    POSSIBLE OPTIMIZATION - could pack stakerTokenShiftIndex_to_accumulativeFloatIssuanceSnapshotIndex_mapping and stakerTokenShiftIndex_to_longShortMarketPriceSnapshotIndex_mapping into a struct of two uint128 for storage space optimization.
  */
  mapping(uint256 => uint256)
    public stakerTokenShiftIndex_to_accumulativeFloatIssuanceSnapshotIndex_mapping;
  /// @notice Used to fetch the price from LongShort at that point in time
  /// @dev tokenShiftIndex => longShortMarketPriceSnapshotIndex
  mapping(uint256 => uint256)
    public stakerTokenShiftIndex_to_longShortMarketPriceSnapshotIndex_mapping;
  /// @dev marketIndex => usersAddress => stakerTokenShiftIndex
  mapping(uint32 => mapping(address => uint256))
    public userNextPrice_stakedSyntheticTokenShiftIndex;
  /// @dev marketIndex => usersAddress => amountUserRequestedToShiftAwayFromLongOnNextUpdate
  mapping(uint32 => mapping(address => uint256))
    public userNextPrice_amountStakedSyntheticToken_toShiftAwayFrom_long;
  /// @dev marketIndex => usersAddress => amountUserRequestedToShiftAwayFromShortOnNextUpdate
  mapping(uint32 => mapping(address => uint256))
    public userNextPrice_amountStakedSyntheticToken_toShiftAwayFrom_short;

  /*╔════════════════════════════╗
    ║           EVENTS           ║
    ╚════════════════════════════╝*/

  event StakerV1(address floatToken, uint256 floatPercentage);

  event MarketAddedToStaker(
    uint32 marketIndex,
    uint256 exitFeeBasisPoints,
    uint256 period,
    uint256 multiplier,
    uint256 balanceIncentiveExponent,
    int256 balanceIncentiveEquilibriumOffset
  );

  event AccumulativeIssuancePerStakedSynthSnapshotCreated(
    uint32 marketIndex,
    uint256 accumulativeFloatIssuanceSnapshotIndex,
    uint256 accumulativeLong,
    uint256 accumulativeShort
  );

  event StakeAdded(address user, address token, uint256 amount, uint256 lastMintIndex);

  event StakeWithdrawn(address user, address token, uint256 amount);

  // TODO: remove `FloatMinted` and replace it with `FloatMintedNew`
  event FloatMinted(
    address user,
    uint32 marketIndex,
    uint256 amountLong,
    uint256 amountShort,
    uint256 lastMintIndex
  );

  // Note: the `amountFloatMinted` isn't strictly needed by the graph, but it is good to add it to validate calculations are accurate.
  event FloatMintedNew(address user, uint32 marketIndex, uint256 amountFloatMinted);

  event MarketLaunchIncentiveParametersChanges(
    uint32 marketIndex,
    uint256 period,
    uint256 multiplier
  );

  event StakeWithdrawalFeeUpdated(uint32 marketIndex, uint256 stakeWithdralFee);

  event BalanceIncentiveExponentUpdated(uint32 marketIndex, uint256 balanceIncentiveExponent);

  event BalanceIncentiveEquilibriumOffsetUpdated(
    uint32 marketIndex,
    int256 balanceIncentiveEquilibriumOffset
  );

  event FloatPercentageUpdated(uint256 floatPercentage);

  event SyntheticTokensShifted();

  /*╔═════════════════════════════╗
    ║          MODIFIERS          ║
    ╚═════════════════════════════╝*/

  function onlyAdminModifierLogic() internal virtual {
    require(msg.sender == admin, "not admin");
  }

  modifier onlyAdmin() {
    onlyAdminModifierLogic();
    _;
  }

  function onlyValidSyntheticModifierLogic(address _synth) internal virtual {
    require(marketIndexOfToken[_synth] != 0, "not valid synth");
  }

  modifier onlyValidSynthetic(address _synth) {
    onlyValidSyntheticModifierLogic(_synth);
    _;
  }

  function onlyValidMarketModifierLogic(uint32 marketIndex) internal virtual {
    require(address(syntheticTokens[marketIndex][true]) != address(0), "not valid market");
  }

  modifier onlyValidMarket(uint32 marketIndex) {
    onlyValidMarketModifierLogic(marketIndex);
    _;
  }

  function onlyLongShortModifierLogic() internal virtual {
    require(msg.sender == address(longShort), "not long short");
  }

  modifier onlyLongShort() {
    onlyLongShortModifierLogic();
    _;
  }

  /*╔═════════════════════════════╗
    ║       CONTRACT SET-UP       ║
    ╚═════════════════════════════╝*/

  function initialize(
    address _admin,
    address _longShort,
    address _floatToken,
    address _floatCapital,
    uint256 _floatPercentage
  ) public virtual initializer {
    admin = _admin;
    floatCapital = _floatCapital;
    longShort = _longShort;
    floatToken = _floatToken;

    _changeFloatPercentage(_floatPercentage);

    emit StakerV1(_floatToken, _floatPercentage);
  }

  /*╔═════════════════════════════╗
    ║       MULTI-SIG ADMIN       ║
    ╚═════════════════════════════╝*/

  function changeAdmin(address _admin) external onlyAdmin {
    admin = _admin;
  }

  function _changeFloatPercentage(uint256 newFloatPercentage) internal virtual {
    require(newFloatPercentage <= 1e18 && newFloatPercentage > 0); // less than 100% and greater than 0%
    floatPercentage = newFloatPercentage;
  }

  function changeFloatPercentage(uint256 newFloatPercentage) external onlyAdmin {
    _changeFloatPercentage(newFloatPercentage);
    emit FloatPercentageUpdated(newFloatPercentage);
  }

  function _changeUnstakeFee(uint32 marketIndex, uint256 newMarketUnstakeFee_e18) internal virtual {
    require(newMarketUnstakeFee_e18 <= 5e16); // 5% fee is the max fee possible.
    marketUnstakeFeeBasis_points[marketIndex] = newMarketUnstakeFee_e18;
  }

  function changeUnstakeFee(uint32 marketIndex, uint256 newMarketUnstakeFee_e18)
    external
    onlyAdmin
  {
    _changeUnstakeFee(marketIndex, newMarketUnstakeFee_e18);
    emit StakeWithdrawalFeeUpdated(marketIndex, newMarketUnstakeFee_e18);
  }

  function _changeMarketLaunchIncentiveParameters(
    uint32 marketIndex,
    uint256 period,
    uint256 initialMultiplier
  ) internal virtual {
    require(initialMultiplier >= 1e18, "marketLaunchIncentiveMultiplier must be >= 1e18");

    marketLaunchIncentive_period[marketIndex] = period;
    marketLaunchIncentive_multipliers[marketIndex] = initialMultiplier;
  }

  function changeMarketLaunchIncentiveParameters(
    uint32 marketIndex,
    uint256 period,
    uint256 initialMultiplier
  ) external onlyAdmin {
    _changeMarketLaunchIncentiveParameters(marketIndex, period, initialMultiplier);

    emit MarketLaunchIncentiveParametersChanges(marketIndex, period, initialMultiplier);
  }

  function _changeBalanceIncentiveExponent(
    uint32 marketIndex,
    uint256 _balanceIncentive_curveExponent
  ) internal virtual {
    require(
      // The exponent has to be less than 5 in these versions of the contracts.
      _balanceIncentive_curveExponent > 0 && _balanceIncentive_curveExponent < 6,
      "balanceIncentive_curveExponent out of bounds"
    );

    balanceIncentive_curveExponent[marketIndex] = _balanceIncentive_curveExponent;
  }

  function changeBalanceIncentiveExponent(
    uint32 marketIndex,
    uint256 _balanceIncentive_curveExponent
  ) external onlyAdmin {
    _changeBalanceIncentiveExponent(marketIndex, _balanceIncentive_curveExponent);

    emit BalanceIncentiveExponentUpdated(marketIndex, _balanceIncentive_curveExponent);
  }

  function _changeBalanceIncentiveEquilibriumOffset(
    uint32 marketIndex,
    int256 _balanceIncentiveCurve_equilibriumOffset
  ) internal virtual {
    // Unreasonable that we would ever shift this more than 90% either way
    require(
      _balanceIncentiveCurve_equilibriumOffset > -9e17 &&
        _balanceIncentiveCurve_equilibriumOffset < 9e17,
      "balanceIncentiveCurve_equilibriumOffset out of bounds"
    );

    balanceIncentiveCurve_equilibriumOffset[marketIndex] = _balanceIncentiveCurve_equilibriumOffset;
  }

  function changeBalanceIncentiveEquilibriumOffset(
    uint32 marketIndex,
    int256 _balanceIncentiveCurve_equilibriumOffset
  ) external onlyAdmin {
    _changeBalanceIncentiveEquilibriumOffset(marketIndex, _balanceIncentiveCurve_equilibriumOffset);

    emit BalanceIncentiveEquilibriumOffsetUpdated(
      marketIndex,
      _balanceIncentiveCurve_equilibriumOffset
    );
  }

  /*╔═════════════════════════════╗
    ║        STAKING SETUP        ║
    ╚═════════════════════════════╝*/

  function addNewStakingFund(
    uint32 marketIndex,
    address longToken,
    address shortToken,
    uint256 kInitialMultiplier,
    uint256 kPeriod,
    uint256 unstakeFee_e18,
    uint256 _balanceIncentive_curveExponent,
    int256 _balanceIncentiveCurve_equilibriumOffset
  ) external override onlyLongShort {
    marketIndexOfToken[longToken] = marketIndex;
    marketIndexOfToken[shortToken] = marketIndex;

    accumulativeFloatPerSyntheticTokenSnapshots[marketIndex][0].timestamp = block.timestamp;
    accumulativeFloatPerSyntheticTokenSnapshots[marketIndex][0]
      .accumulativeFloatPerSyntheticToken_long = 0;
    accumulativeFloatPerSyntheticTokenSnapshots[marketIndex][0]
      .accumulativeFloatPerSyntheticToken_short = 0;

    syntheticTokens[marketIndex][true] = longToken;
    syntheticTokens[marketIndex][false] = shortToken;

    _changeBalanceIncentiveExponent(marketIndex, _balanceIncentive_curveExponent);
    _changeBalanceIncentiveEquilibriumOffset(marketIndex, _balanceIncentiveCurve_equilibriumOffset);
    _changeMarketLaunchIncentiveParameters(marketIndex, kPeriod, kInitialMultiplier);

    _changeUnstakeFee(marketIndex, unstakeFee_e18);

    // Rather start this at 1 to prevent confusion.
    batched_stakerNextTokenShiftIndex[marketIndex] = 1;

    emit MarketAddedToStaker(
      marketIndex,
      unstakeFee_e18,
      kPeriod,
      kInitialMultiplier,
      _balanceIncentive_curveExponent,
      _balanceIncentiveCurve_equilibriumOffset
    );

    emit AccumulativeIssuancePerStakedSynthSnapshotCreated(marketIndex, 0, 0, 0);
  }

  /*╔═════════════════════════════════════════════════════════════════════════╗
    ║    GLOBAL FLT REWARD ACCUMULATION CALCULATION AND TRACKING FUNCTIONS    ║
    ╚═════════════════════════════════════════════════════════════════════════╝*/

  /**
  @notice Returns the K factor parameters for the given market with sensible
  defaults if they haven't been set yet.
  @param marketIndex The market to change the parameters for.
  @return period The period for which the k factor applies for in seconds.
  @return multiplier The multiplier on Float generation in this period.
  */
  function _getMarketLaunchIncentiveParameters(uint32 marketIndex)
    internal
    view
    virtual
    returns (uint256, uint256)
  {
    uint256 period = marketLaunchIncentive_period[marketIndex];
    uint256 multiplier = marketLaunchIncentive_multipliers[marketIndex];
    if (multiplier < 1e18) {
      multiplier = 1e18; // multiplier of 1 by default
    }

    return (period, multiplier);
  }

  // TODO: rename 'k' into 'incentiveMultiplier' or something else more descriptive.
  function _getKValue(uint32 marketIndex) internal view virtual returns (uint256) {
    // Parameters controlling the float issuance multiplier.
    (uint256 kPeriod, uint256 kInitialMultiplier) = _getMarketLaunchIncentiveParameters(
      marketIndex
    );

    // Sanity check - under normal circumstances, the multipliers should
    // *never* be set to a value < 1e18, as there are guards against this.
    assert(kInitialMultiplier >= 1e18);

    uint256 initialTimestamp = accumulativeFloatPerSyntheticTokenSnapshots[marketIndex][0]
      .timestamp;

    if (block.timestamp - initialTimestamp <= kPeriod) {
      return
        kInitialMultiplier -
        (((kInitialMultiplier - 1e18) * (block.timestamp - initialTimestamp)) / kPeriod);
    } else {
      return 1e18;
    }
  }

  /*
   * Computes the current 'r' value, i.e. the number of float tokens a user
   * earns per second for every longshort token they've staked. The returned
   * value has a fixed decimal scale of 1e42 (!!!) for numerical stability.
   * The return values are float per second per synthetic token (hence the
   * requirement to multiply by price)
   *  -- here is the graph of the curve used: https://www.desmos.com/calculator/vg7jlmn4mn
   */
  function _calculateFloatPerSecond(
    uint32 marketIndex,
    uint256 longPrice,
    uint256 shortPrice,
    uint256 longValue,
    uint256 shortValue
  ) internal view virtual returns (uint256 longFloatPerSecond, uint256 shortFloatPerSecond) {
    // Markets cannot be or become empty (since they are seeded with non-withdrawable capital)
    assert(longValue != 0 && shortValue != 0);

    // A float issuance multiplier that starts high and decreases linearly
    // over time to a value of 1. This incentivises users to stake early.
    uint256 k = _getKValue(marketIndex);

    uint256 totalLocked = (longValue + shortValue);

    // we need to scale this number by the totalLocked so that the offset remains consistent accross market size

    int256 equilibriumOffsetMarketScaled = (balanceIncentiveCurve_equilibriumOffset[marketIndex] *
      int256(totalLocked)) / 1e18;

    // Float is scaled by the percentage of the total market value held in
    // the opposite position. This incentivises users to stake on the
    // weaker position.
    if (int256(shortValue) - equilibriumOffsetMarketScaled < int256(longValue)) {
      if (equilibriumOffsetMarketScaled >= int256(shortValue)) {
        // edge case: imbalanced far past the equilibrium offset - full rewards go to short token
        //            extremeley unlikely to happen in practice
        return (0, 1e18 * k * shortPrice);
      }

      uint256 numerator = (uint256(int256(shortValue) - equilibriumOffsetMarketScaled) >>
        (safeExponentBitShifting - 1))**balanceIncentive_curveExponent[marketIndex];

      uint256 denominator = ((totalLocked >> safeExponentBitShifting) **
        balanceIncentive_curveExponent[marketIndex]);

      // NOTE: `x * 5e17` == `(x * 10e18) / 2`
      uint256 longRewardUnscaled = (numerator * 5e17) / denominator;
      uint256 shortRewardUnscaled = 1e18 - longRewardUnscaled;

      return (
        (longRewardUnscaled * k * longPrice) / 1e18,
        (shortRewardUnscaled * k * shortPrice) / 1e18
      );
    } else {
      if (-equilibriumOffsetMarketScaled >= int256(longValue)) {
        // edge case: imbalanced far past the equilibrium offset - full rewards go to long token
        //            extremeley unlikely to happen in practice
        return (1e18 * k * longPrice, 0);
      }

      uint256 numerator = (uint256(int256(longValue) + equilibriumOffsetMarketScaled) >>
        (safeExponentBitShifting - 1))**balanceIncentive_curveExponent[marketIndex];

      uint256 denominator = ((totalLocked >> safeExponentBitShifting) **
        balanceIncentive_curveExponent[marketIndex]);

      // NOTE: `x * 5e17` == `(x * 10e18) / 2`
      uint256 shortRewardUnscaled = (numerator * 5e17) / denominator;
      uint256 longRewardUnscaled = 1e18 - shortRewardUnscaled;

      return (
        (longRewardUnscaled * k * longPrice) / 1e18,
        (shortRewardUnscaled * k * shortPrice) / 1e18
      );
    }
  }

  /**
  @notice Computes the time since last accumulativeIssuancePerStakedSynthSnapshot for the given market in seconds.
  @param marketIndex The market referred to.
  @return The time difference in seconds
  */
  function _calculateTimeDeltaFromLastAccumulativeIssuancePerStakedSynthSnapshot(uint32 marketIndex)
    internal
    view
    virtual
    returns (uint256)
  {
    return
      block.timestamp -
      accumulativeFloatPerSyntheticTokenSnapshots[marketIndex][latestRewardIndex[marketIndex]]
        .timestamp;
  }

  /**
  @notice Computes new cumulative sum of 'r' value since last accumulativeIssuancePerStakedSynthSnapshot. We use
  cumulative 'r' value to avoid looping during issuance. Note that the
  cumulative sum is kept in 1e42 scale (!!!) to avoid numerical issues.
  @param shortValue The value locked in the short side of the market.
  @param longValue The value locked in the long side of the market.
  @param shortPrice The price of the short token as defined in LongShort.sol
  @param longPrice The price of the long token as defined in LongShort.sol
  @param marketIndex An identifier for the market.
  @return longCumulativeRates The long cumulative sum.
  @return shortCumulativeRates The short cumulative sum.
  */
  function _calculateNewCumulativeIssuancePerStakedSynth(
    uint32 marketIndex,
    uint256 longPrice,
    uint256 shortPrice,
    uint256 longValue,
    uint256 shortValue
  ) internal view virtual returns (uint256 longCumulativeRates, uint256 shortCumulativeRates) {
    // Compute the current 'r' value for float issuance per second.
    (uint256 longFloatPerSecond, uint256 shortFloatPerSecond) = _calculateFloatPerSecond(
      marketIndex,
      longPrice,
      shortPrice,
      longValue,
      shortValue
    );

    // Compute time since last accumulativeIssuancePerStakedSynthSnapshot for the given token.
    uint256 timeDelta = _calculateTimeDeltaFromLastAccumulativeIssuancePerStakedSynthSnapshot(
      marketIndex
    );

    // Compute new cumulative 'r' value total.
    return (
      accumulativeFloatPerSyntheticTokenSnapshots[marketIndex][latestRewardIndex[marketIndex]]
        .accumulativeFloatPerSyntheticToken_long + (timeDelta * longFloatPerSecond),
      accumulativeFloatPerSyntheticTokenSnapshots[marketIndex][latestRewardIndex[marketIndex]]
        .accumulativeFloatPerSyntheticToken_short + (timeDelta * shortFloatPerSecond)
    );
  }

  /**
  @notice Creates a new accumulativeIssuancePerStakedSynthSnapshot for the given token and updates indexes.
  @param shortValue The value locked in the short side of the market.
  @param longValue The value locked in the long side of the market.
  @param shortPrice The price of the short token as defined in LongShort.sol
  @param longPrice The price of the long token as defined in LongShort.sol
  @param marketIndex An identifier for the market.
  */
  function _setCurrentAccumulativeIssuancePerStakeStakedSynthSnapshot(
    uint32 marketIndex,
    uint256 longPrice,
    uint256 shortPrice,
    uint256 longValue,
    uint256 shortValue
  ) internal virtual {
    (
      uint256 newLongAccumaltiveValue,
      uint256 newShortAccumulativeValue
    ) = _calculateNewCumulativeIssuancePerStakedSynth(
        marketIndex,
        longPrice,
        shortPrice,
        longValue,
        shortValue
      );

    uint256 newIndex = latestRewardIndex[marketIndex] + 1;

    // Set cumulative 'r' value on new accumulativeIssuancePerStakedSynthSnapshot.
    accumulativeFloatPerSyntheticTokenSnapshots[marketIndex][newIndex]
      .accumulativeFloatPerSyntheticToken_long = newLongAccumaltiveValue;
    accumulativeFloatPerSyntheticTokenSnapshots[marketIndex][newIndex]
      .accumulativeFloatPerSyntheticToken_short = newShortAccumulativeValue;

    // Set timestamp on new accumulativeIssuancePerStakedSynthSnapshot.
    accumulativeFloatPerSyntheticTokenSnapshots[marketIndex][newIndex].timestamp = block.timestamp;

    // Update latest index to point to new accumulativeIssuancePerStakedSynthSnapshot.
    latestRewardIndex[marketIndex] = newIndex;

    emit AccumulativeIssuancePerStakedSynthSnapshotCreated(
      marketIndex,
      newIndex,
      newLongAccumaltiveValue,
      newShortAccumulativeValue
    );
  }

  /**
  @notice Adds new accumulativeIssuancePerStakedSynthSnapshots for the given long/short tokens. Called by the
  ILongShort contract whenever there is a state change for a market.
  @param stakerTokenShiftIndex_to_longShortMarketPriceSnapshotIndex_mappingIfShiftExecuted Mapping from this contracts shifts to LongShort.sols
  @param shortValue The value locked in the short side of the market.
  @param longValue The value locked in the long side of the market.
  @param shortPrice The price of the short token as defined in LongShort.sol
  @param longPrice The price of the long token as defined in LongShort.sol
  @param marketIndex An identifier for the market.
  */
  function pushUpdatedMarketPricesToUpdateFloatIssuanceCalculations(
    uint32 marketIndex,
    uint256 longPrice,
    uint256 shortPrice,
    uint256 longValue,
    uint256 shortValue,
    uint256 stakerTokenShiftIndex_to_longShortMarketPriceSnapshotIndex_mappingIfShiftExecuted // This value should be ALWAYS be zero if no shift occured
  ) external override onlyLongShort {
    // Only add a new accumulativeIssuancePerStakedSynthSnapshot if some time has passed.

    // the `stakerTokenShiftIndex_to_longShortMarketPriceSnapshotIndex_mappingIfShiftExecuted` value will be 0 if there is no staker related action in an executed batch
    if (stakerTokenShiftIndex_to_longShortMarketPriceSnapshotIndex_mappingIfShiftExecuted > 0) {
      stakerTokenShiftIndex_to_longShortMarketPriceSnapshotIndex_mapping[
        batched_stakerNextTokenShiftIndex[marketIndex]
      ] = stakerTokenShiftIndex_to_longShortMarketPriceSnapshotIndex_mappingIfShiftExecuted;
      stakerTokenShiftIndex_to_accumulativeFloatIssuanceSnapshotIndex_mapping[
        batched_stakerNextTokenShiftIndex[marketIndex]
      ] = latestRewardIndex[marketIndex] + 1;
      batched_stakerNextTokenShiftIndex[marketIndex] += 1;

      emit SyntheticTokensShifted();
    }

    // Time delta is fetched twice in below code, can pass through? Which is less gas?
    if (_calculateTimeDeltaFromLastAccumulativeIssuancePerStakedSynthSnapshot(marketIndex) > 0) {
      _setCurrentAccumulativeIssuancePerStakeStakedSynthSnapshot(
        marketIndex,
        longPrice,
        shortPrice,
        longValue,
        shortValue
      );
    }
  }

  /*╔═══════════════════════════════════╗
    ║    USER REWARD STATE FUNCTIONS    ║
    ╚═══════════════════════════════════╝*/

  /// @dev Calculates the accumulated float in a specific range of staker snapshots
  function _calculateAccumulatedFloatInRange(
    uint32 marketIndex,
    uint256 amountStakedLong,
    uint256 amountStakedShort,
    uint256 rewardIndexFrom,
    uint256 rewardIndexTo
  ) internal view virtual returns (uint256 floatReward) {
    if (amountStakedLong > 0) {
      uint256 accumDeltaLong = accumulativeFloatPerSyntheticTokenSnapshots[marketIndex][
        rewardIndexTo
      ].accumulativeFloatPerSyntheticToken_long -
        accumulativeFloatPerSyntheticTokenSnapshots[marketIndex][rewardIndexFrom]
          .accumulativeFloatPerSyntheticToken_long;
      floatReward += (accumDeltaLong * amountStakedLong) / FLOAT_ISSUANCE_FIXED_DECIMAL;
    }

    if (amountStakedShort > 0) {
      uint256 accumDeltaShort = accumulativeFloatPerSyntheticTokenSnapshots[marketIndex][
        rewardIndexTo
      ].accumulativeFloatPerSyntheticToken_short -
        accumulativeFloatPerSyntheticTokenSnapshots[marketIndex][rewardIndexFrom]
          .accumulativeFloatPerSyntheticToken_short;
      floatReward += (accumDeltaShort * amountStakedShort) / FLOAT_ISSUANCE_FIXED_DECIMAL;
    }
  }

  function _calculateAccumulatedFloat(uint32 marketIndex, address user)
    internal
    virtual
    returns (uint256 floatReward)
  {
    address longToken = syntheticTokens[marketIndex][true];
    address shortToken = syntheticTokens[marketIndex][false];

    uint256 amountStakedLong = userAmountStaked[longToken][user];
    uint256 amountStakedShort = userAmountStaked[shortToken][user];

    uint256 usersLastRewardIndex = userIndexOfLastClaimedReward[marketIndex][user];

    // Don't do the calculation and return zero immediately if there is no change
    if (usersLastRewardIndex == latestRewardIndex[marketIndex]) {
      return 0;
    }

    uint256 usersShiftIndex = userNextPrice_stakedSyntheticTokenShiftIndex[marketIndex][user];
    // if there is a change in the users tokens held due to a token shift (or possibly another action in the future)
    if (usersShiftIndex > 0 && usersShiftIndex < batched_stakerNextTokenShiftIndex[marketIndex]) {
      floatReward = _calculateAccumulatedFloatInRange(
        marketIndex,
        amountStakedLong,
        amountStakedShort,
        usersLastRewardIndex,
        stakerTokenShiftIndex_to_accumulativeFloatIssuanceSnapshotIndex_mapping[usersShiftIndex]
      );

      // Update the users balances
      if (userNextPrice_amountStakedSyntheticToken_toShiftAwayFrom_long[marketIndex][user] > 0) {
        amountStakedShort += ILongShort(longShort).getAmountSyntheticTokenToMintOnTargetSide(
          marketIndex,
          userNextPrice_amountStakedSyntheticToken_toShiftAwayFrom_long[marketIndex][user],
          true,
          stakerTokenShiftIndex_to_longShortMarketPriceSnapshotIndex_mapping[usersShiftIndex]
        );

        amountStakedLong -= userNextPrice_amountStakedSyntheticToken_toShiftAwayFrom_long[
          marketIndex
        ][user];
        userNextPrice_amountStakedSyntheticToken_toShiftAwayFrom_long[marketIndex][user] = 0;
      }

      if (userNextPrice_amountStakedSyntheticToken_toShiftAwayFrom_short[marketIndex][user] > 0) {
        amountStakedLong += ILongShort(longShort).getAmountSyntheticTokenToMintOnTargetSide(
          marketIndex,
          userNextPrice_amountStakedSyntheticToken_toShiftAwayFrom_short[marketIndex][user],
          false,
          stakerTokenShiftIndex_to_longShortMarketPriceSnapshotIndex_mapping[usersShiftIndex]
        );

        // TODO: investigate how casting negative numbers works in solidity
        amountStakedShort -= userNextPrice_amountStakedSyntheticToken_toShiftAwayFrom_short[
          marketIndex
        ][user];
        userNextPrice_amountStakedSyntheticToken_toShiftAwayFrom_short[marketIndex][user] = 0;
      }

      // Save the users updated staked amounts
      userAmountStaked[longToken][user] = amountStakedLong;
      userAmountStaked[shortToken][user] = amountStakedShort;

      floatReward += _calculateAccumulatedFloatInRange(
        marketIndex,
        amountStakedLong,
        amountStakedShort,
        stakerTokenShiftIndex_to_accumulativeFloatIssuanceSnapshotIndex_mapping[usersShiftIndex],
        latestRewardIndex[marketIndex]
      );

      userNextPrice_stakedSyntheticTokenShiftIndex[marketIndex][user] = 0;
    } else {
      floatReward = _calculateAccumulatedFloatInRange(
        marketIndex,
        amountStakedLong,
        amountStakedShort,
        usersLastRewardIndex,
        latestRewardIndex[marketIndex]
      );
    }
  }

  function _mintFloat(address user, uint256 floatToMint) internal virtual {
    IFloatToken(floatToken).mint(user, floatToMint);
    IFloatToken(floatToken).mint(floatCapital, (floatToMint * floatPercentage) / 1e18);
  }

  function _mintAccumulatedFloat(uint32 marketIndex, address user) internal virtual {
    uint256 floatToMint = _calculateAccumulatedFloat(marketIndex, user);

    if (floatToMint > 0) {
      // Set the user has claimed up until now, stops them setting this forward
      userIndexOfLastClaimedReward[marketIndex][user] = latestRewardIndex[marketIndex];

      _mintFloat(user, floatToMint);
      // TODO: remove `FloatMinted` and replace it with `FloatMintedNew`
      emit FloatMinted(
        user,
        marketIndex,
        floatToMint,
        0, /*Setting this to zero has no effect on the graph, just here so the graph doesn't break in the mean time*/
        latestRewardIndex[marketIndex]
      );
      emit FloatMintedNew(user, marketIndex, floatToMint);
    }
  }

  function _mintAccumulatedFloatMulti(uint32[] calldata marketIndexes, address user)
    internal
    virtual
  {
    uint256 floatTotal = 0;
    for (uint256 i = 0; i < marketIndexes.length; i++) {
      uint256 floatToMint = _calculateAccumulatedFloat(marketIndexes[i], user);

      if (floatToMint > 0) {
        // Set the user has claimed up until now, stops them setting this forward
        userIndexOfLastClaimedReward[marketIndexes[i]][user] = latestRewardIndex[marketIndexes[i]];

        floatTotal += floatToMint;

        // TODO: remove `FloatMinted` and replace it with `FloatMintedNew`
        emit FloatMinted(
          user,
          marketIndexes[i],
          floatToMint,
          0, /*Setting this to zero has no effect on the graph, just here so the graph doesn't break in the mean time*/
          latestRewardIndex[marketIndexes[i]]
        );
        emit FloatMintedNew(user, marketIndexes[i], floatToMint);
      }
    }
    if (floatTotal > 0) {
      _mintFloat(user, floatTotal);
    }
  }

  function claimFloatCustom(uint32[] calldata marketIndexes) external {
    ILongShort(longShort).updateSystemStateMulti(marketIndexes);
    _mintAccumulatedFloatMulti(marketIndexes, msg.sender);
  }

  function claimFloatCustomFor(uint32[] calldata marketIndexes, address user) external {
    // Unbounded loop - users are responsible for paying their own gas costs on these and it doesn't effect the rest of the system.
    // No need to imposea limit.
    ILongShort(longShort).updateSystemStateMulti(marketIndexes);
    _mintAccumulatedFloatMulti(marketIndexes, user);
  }

  /*╔═══════════════════════╗
    ║        STAKING        ║
    ╚═══════════════════════╝*/

  /**
  @notice A user with synthetic tokens stakes by calling stake on the token
  contract which calls this function. We need to first update the
  State of the system before staking to correctly calculate user rewards.
  @param amount Amount to stake.
  @param from Address to stake for.
  */
  function stakeFromUser(address from, uint256 amount)
    public
    virtual
    override
    onlyValidSynthetic((msg.sender))
  {
    ILongShort(longShort).updateSystemState(marketIndexOfToken[(msg.sender)]);
    _stake((msg.sender), amount, from);
  }

  function _stake(
    address token,
    uint256 amount,
    address user
  ) internal virtual {
    uint32 marketIndex = marketIndexOfToken[token];

    // If they already have staked and have rewards due, mint these.
    if (
      userIndexOfLastClaimedReward[marketIndex][user] != 0 &&
      userIndexOfLastClaimedReward[marketIndex][user] < latestRewardIndex[marketIndex]
    ) {
      _mintAccumulatedFloat(marketIndex, user);
    }

    userAmountStaked[token][user] = userAmountStaked[token][user] + amount;

    userIndexOfLastClaimedReward[marketIndex][user] = latestRewardIndex[marketIndex];

    emit StakeAdded(user, address(token), amount, userIndexOfLastClaimedReward[marketIndex][user]);
  }

  // Token shifting
  function shiftTokens(
    uint256 amountSyntheticTokensToShift,
    uint32 marketIndex,
    bool isShiftFromLong
  ) external virtual {
    address token = syntheticTokens[marketIndex][isShiftFromLong];
    require(
      userAmountStaked[token][msg.sender] >= amountSyntheticTokensToShift,
      "Not enough tokens to shift"
    );

    // If the user has outstanding token shift that have already been confirmed in the LongShort
    // contract, execute them first.
    if (
      userNextPrice_stakedSyntheticTokenShiftIndex[marketIndex][msg.sender] != 0 &&
      userNextPrice_stakedSyntheticTokenShiftIndex[marketIndex][msg.sender] <
      batched_stakerNextTokenShiftIndex[marketIndex]
    ) {
      _mintAccumulatedFloat(marketIndex, msg.sender);
    }

    if (isShiftFromLong) {
      ILongShort(longShort).shiftPositionFromLongNextPrice(
        marketIndex,
        amountSyntheticTokensToShift
      );
      userNextPrice_amountStakedSyntheticToken_toShiftAwayFrom_long[marketIndex][
        msg.sender
      ] += amountSyntheticTokensToShift;
    } else {
      ILongShort(longShort).shiftPositionFromShortNextPrice(
        marketIndex,
        amountSyntheticTokensToShift
      );
      userNextPrice_amountStakedSyntheticToken_toShiftAwayFrom_short[marketIndex][
        msg.sender
      ] += amountSyntheticTokensToShift;
    }

    userNextPrice_stakedSyntheticTokenShiftIndex[marketIndex][
      msg.sender
    ] = batched_stakerNextTokenShiftIndex[marketIndex];
  }

  /*╔════════════════════════════╗
    ║    WITHDRAWAL & MINTING    ║
    ╚════════════════════════════╝*/

  /**
  @notice Withdraw function.
  Mint user any outstanding float before
  @param amount Amount to withdraw.
  @param token Synthetic token that was staked.
  */
  function _withdraw(address token, uint256 amount) internal virtual {
    uint32 marketIndex = marketIndexOfToken[token];
    require(userAmountStaked[token][msg.sender] > 0, "nothing to withdraw");
    _mintAccumulatedFloat(marketIndex, msg.sender);

    userAmountStaked[token][msg.sender] = userAmountStaked[token][msg.sender] - amount;

    // TODO STENT what happens with the fees that are left in this contract?
    uint256 amountFees = (amount * marketUnstakeFeeBasis_points[marketIndex]) / 1e18;

    IERC20(token).transfer(msg.sender, amount - amountFees);

    emit StakeWithdrawn(msg.sender, token, amount);
  }

  function withdraw(address token, uint256 amount) external {
    // TODO: possibly make a 'updateSystemState' (and 'updateSystemStateMulti') modifiers?
    ILongShort(longShort).updateSystemState(marketIndexOfToken[token]);

    _withdraw(token, amount);
  }

  function withdrawAll(address token) external {
    ILongShort(longShort).updateSystemState(marketIndexOfToken[token]);

    _withdraw(token, userAmountStaked[token][msg.sender]);
  }
}
