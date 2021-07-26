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

  // Global state
  address public admin;
  address public floatCapital;
  uint256 public floatPercentage;

  address public longShort;
  address public floatToken;

  // Market specific
  mapping(uint32 => uint256) public marketLaunchIncentivePeriod; // seconds
  mapping(uint32 => uint256) public marketLaunchIncentiveMultipliers; // e18 scale
  mapping(uint32 => uint256) public marketUnstakeFeeBasisPoints;
  mapping(uint32 => uint256) public balanceIncentiveCurveExponent;
  mapping(uint32 => int256) public balanceIncentiveCurveEquilibriumOffset;

  mapping(uint32 => mapping(bool => address)) public syntheticTokens;

  mapping(address => uint32) public marketIndexOfToken;

  // Reward specific
  mapping(uint32 => uint256) public latestRewardIndex;
  mapping(uint32 => mapping(uint256 => RewardState)) public syntheticRewardParams;
  struct RewardState {
    uint256 timestamp;
    uint256 accumulativeFloatPerLongToken;
    uint256 accumulativeFloatPerShortToken;
  }

  // User specific
  mapping(uint32 => mapping(address => uint256)) public userIndexOfLastClaimedReward;
  mapping(address => mapping(address => uint256)) public userAmountStaked;

  // Token shift management
  mapping(uint32 => uint256) public nextTokenShiftIndex;
  // TODO: could pack these two into a struct of two uint128 for storage space optimization.
  mapping(uint256 => uint256) public tokenShiftIndexToStakerStateMapping;
  mapping(uint256 => uint256) public longShortMarketPriceSnapshotIndex;
  mapping(uint32 => mapping(address => uint256)) public shiftIndex;
  // This value is an `int256` so it can represent shifts in either direction.
  // Possitive is a shift from long, negative is a shift from short.
  mapping(uint32 => mapping(address => uint256)) public amountToShiftFromLongUser;
  mapping(uint32 => mapping(address => uint256)) public amountToShiftFromShortUser;

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

  event StateAdded(
    uint32 marketIndex,
    uint256 stateIndex,
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

  event SynthTokensShifted();

  /*╔═════════════════════════════╗
    ║          MODIFIERS          ║
    ╚═════════════════════════════╝*/

  modifier onlyAdmin() virtual {
    require(msg.sender == admin, "not admin");
    _;
  }

  modifier onlyValidSynthetic(address _synth) virtual {
    require(marketIndexOfToken[_synth] != 0, "not valid synth");
    _;
  }

  modifier onlyValidMarket(uint32 marketIndex) {
    require(address(syntheticTokens[marketIndex][true]) != address(0), "not valid market");
    // require(latestRewardIndex[marketIndex] != 0, "not valid market");
    _;
  }

  modifier onlyLongShort() virtual {
    require(msg.sender == address(longShort));
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
    require(
      _admin != address(0) &&
        _floatCapital != address(0) &&
        _longShort != address(0) &&
        _floatToken != address(0)
    );
    admin = _admin;
    floatCapital = _floatCapital;
    longShort = (_longShort);
    floatToken = (_floatToken);

    _changeFloatPercentage(_floatPercentage);

    emit StakerV1(_floatToken, floatPercentage);
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

  function _changeUnstakeFee(uint32 marketIndex, uint256 newMarketUnstakeFeeBasisPoints)
    internal
    virtual
  {
    require(newMarketUnstakeFeeBasisPoints <= 5e16); // 5% fee is the max fee possible.
    marketUnstakeFeeBasisPoints[marketIndex] = newMarketUnstakeFeeBasisPoints;
  }

  function changeUnstakeFee(uint32 marketIndex, uint256 newMarketUnstakeFeeBasisPoints)
    external
    onlyAdmin
  {
    _changeUnstakeFee(marketIndex, newMarketUnstakeFeeBasisPoints);
    emit StakeWithdrawalFeeUpdated(marketIndex, newMarketUnstakeFeeBasisPoints);
  }

  function changeMarketLaunchIncentiveParameters(
    uint32 marketIndex,
    uint256 period,
    uint256 initialMultiplier
  ) external onlyAdmin {
    _changeMarketLaunchIncentiveParameters(marketIndex, period, initialMultiplier);

    emit MarketLaunchIncentiveParametersChanges(marketIndex, period, initialMultiplier);
  }

  function _changeMarketLaunchIncentiveParameters(
    uint32 marketIndex,
    uint256 period,
    uint256 initialMultiplier
  ) internal virtual {
    require(initialMultiplier >= 1e18, "marketLaunchIncentiveMultiplier must be >= 1e181");

    marketLaunchIncentivePeriod[marketIndex] = period;
    marketLaunchIncentiveMultipliers[marketIndex] = initialMultiplier;
  }

  function _changBalanceIncentiveExponent(
    uint32 marketIndex,
    uint256 _balanceIncentiveCurveExponent
  ) internal virtual {
    require(
      _balanceIncentiveCurveExponent > 0 && _balanceIncentiveCurveExponent < 10000,
      "balanceIncentiveCurveExponent out of bounds"
    );

    balanceIncentiveCurveExponent[marketIndex] = _balanceIncentiveCurveExponent;
  }

  function changBalanceIncentiveExponent(uint32 marketIndex, uint256 _balanceIncentiveCurveExponent)
    external
    onlyAdmin
  {
    _changBalanceIncentiveExponent(marketIndex, _balanceIncentiveCurveExponent);

    emit BalanceIncentiveExponentUpdated(marketIndex, _balanceIncentiveCurveExponent);
  }

  function _changBalanceIncentiveEquilibriumOffset(
    uint32 marketIndex,
    int256 _balanceIncentiveCurveEquilibriumOffset
  ) internal virtual {
    // Unreasonable that we would ever shift this more than 90% either way
    require(
      _balanceIncentiveCurveEquilibriumOffset > -9e17 &&
        _balanceIncentiveCurveEquilibriumOffset < 9e17,
      "balanceIncentiveCurveEquilibriumOffset out of bounds"
    );

    balanceIncentiveCurveEquilibriumOffset[marketIndex] = _balanceIncentiveCurveEquilibriumOffset;
  }

  function changBalanceIncentiveEquilibriumOffset(
    uint32 marketIndex,
    int256 _balanceIncentiveCurveEquilibriumOffset
  ) external onlyAdmin {
    _changBalanceIncentiveEquilibriumOffset(marketIndex, _balanceIncentiveCurveEquilibriumOffset);

    emit BalanceIncentiveEquilibriumOffsetUpdated(
      marketIndex,
      _balanceIncentiveCurveEquilibriumOffset
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
    uint256 unstakeFeeBasisPoints,
    uint256 _balanceIncentiveCurveExponent,
    int256 _balanceIncentiveCurveEquilibriumOffset
  ) external override onlyLongShort {
    marketIndexOfToken[longToken] = marketIndex;
    marketIndexOfToken[shortToken] = marketIndex;

    syntheticRewardParams[marketIndex][0].timestamp = block.timestamp;
    syntheticRewardParams[marketIndex][0].accumulativeFloatPerLongToken = 0;
    syntheticRewardParams[marketIndex][0].accumulativeFloatPerShortToken = 0;

    syntheticTokens[marketIndex][true] = longToken;
    syntheticTokens[marketIndex][false] = shortToken;

    _changBalanceIncentiveExponent(marketIndex, _balanceIncentiveCurveExponent);
    _changBalanceIncentiveEquilibriumOffset(marketIndex, _balanceIncentiveCurveEquilibriumOffset);
    _changeMarketLaunchIncentiveParameters(marketIndex, kPeriod, kInitialMultiplier);

    _changeUnstakeFee(marketIndex, unstakeFeeBasisPoints);

    emit MarketAddedToStaker(
      marketIndex,
      unstakeFeeBasisPoints,
      kPeriod,
      kInitialMultiplier,
      _balanceIncentiveCurveExponent,
      _balanceIncentiveCurveEquilibriumOffset
    );

    emit StateAdded(marketIndex, 0, 0, 0);
  }

  /*╔═════════════════════════════════════╗
    ║    GLOBAL REWARD STATE FUNCTIONS    ║
    ╚═════════════════════════════════════╝*/

  /*
   * Returns the K factor parameters for the given market with sensible
   * defaults if they haven't been set yet.
   */
  function _getMarketLaunchIncentiveParameters(uint32 marketIndex)
    internal
    view
    virtual
    returns (uint256, uint256)
  {
    uint256 period = marketLaunchIncentivePeriod[marketIndex];
    uint256 multiplier = marketLaunchIncentiveMultipliers[marketIndex];
    if (multiplier < 1) {
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

    uint256 initialTimestamp = syntheticRewardParams[marketIndex][0].timestamp;

    if (block.timestamp - initialTimestamp <= kPeriod) {
      return
        kInitialMultiplier -
        (((kInitialMultiplier - 1e18) * (block.timestamp - initialTimestamp)) / kPeriod);
    } else {
      return 1e18;
    }
  }

  // TODO: turn this into a library.
  //       make this a simple lookup table with appropriate aproximation
  function getRequiredAmountOfBitShiftForSafeExponentiation(uint256 number, uint256 exponent)
    internal
    pure
    virtual
    returns (uint256 amountOfBitShiftRequired)
  {
    uint256 targetMaxNumberSizeBinaryDigits = 257 / exponent;

    // Note this can be optimised, this gets a quick easy to compute safe upper bound, not the actuall upper bound.
    uint256 targetMaxNumber = 2**targetMaxNumberSizeBinaryDigits;

    while (number >> amountOfBitShiftRequired > targetMaxNumber) {
      ++amountOfBitShiftRequired;
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

    int256 equilibriumOffsetMarketScaled = (balanceIncentiveCurveEquilibriumOffset[marketIndex] *
      int256(totalLocked)) / 1e18;

    uint256 requiredBitShifting = getRequiredAmountOfBitShiftForSafeExponentiation(
      totalLocked,
      balanceIncentiveCurveExponent[marketIndex]
    );

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
        (requiredBitShifting - 1))**balanceIncentiveCurveExponent[marketIndex];

      uint256 denominator = ((totalLocked >> requiredBitShifting) **
        balanceIncentiveCurveExponent[marketIndex]) / 1e18;

      uint256 longRewardUnscaled = (numerator / denominator) / 2;
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
        (requiredBitShifting - 1))**balanceIncentiveCurveExponent[marketIndex];

      uint256 denominator = ((totalLocked >> requiredBitShifting) **
        balanceIncentiveCurveExponent[marketIndex]) / 1e18;

      uint256 shortRewardUnscaled = (numerator / denominator) / 2;
      uint256 longRewardUnscaled = 1e18 - shortRewardUnscaled;

      return (
        (longRewardUnscaled * k * longPrice) / 1e18,
        (shortRewardUnscaled * k * shortPrice) / 1e18
      );
    }
  }

  /*
   * Computes the time since last state point for the given token in seconds.
   */
  function _calculateTimeDelta(uint32 marketIndex) internal view virtual returns (uint256) {
    return
      block.timestamp -
      syntheticRewardParams[marketIndex][latestRewardIndex[marketIndex]].timestamp;
  }

  /*
   * Computes new cumulative sum of 'r' value since last state point. We use
   * cumulative 'r' value to avoid looping during issuance. Note that the
   * cumulative sum is kept in 1e42 scale (!!!) to avoid numerical issues.
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

    // Compute time since last state point for the given token.
    uint256 timeDelta = _calculateTimeDelta(marketIndex);

    // Compute new cumulative 'r' value total.
    return (
      syntheticRewardParams[marketIndex][latestRewardIndex[marketIndex]]
      .accumulativeFloatPerLongToken + (timeDelta * longFloatPerSecond),
      syntheticRewardParams[marketIndex][latestRewardIndex[marketIndex]]
      .accumulativeFloatPerShortToken + (timeDelta * shortFloatPerSecond)
    );
  }

  /*
   * Creates a new state point for the given token and updates indexes.
   */
  function _setRewardObjects(
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

    // Set cumulative 'r' value on new state point.
    syntheticRewardParams[marketIndex][newIndex]
    .accumulativeFloatPerLongToken = newLongAccumaltiveValue;
    syntheticRewardParams[marketIndex][newIndex]
    .accumulativeFloatPerShortToken = newShortAccumulativeValue;

    // Set timestamp on new state point.
    syntheticRewardParams[marketIndex][newIndex].timestamp = block.timestamp;

    // Update latest index to point to new state point.
    latestRewardIndex[marketIndex] = newIndex;

    // TODO STENT why is this called StateAdded? Should be called newFloatValues or something
    emit StateAdded(marketIndex, newIndex, newLongAccumaltiveValue, newShortAccumulativeValue);
  }

  /*
   * Adds new state points for the given long/short tokens. Called by the
   * ILongShort contract whenever there is a state change for a market.
   */
  function addNewStateForFloatRewards(
    uint32 marketIndex,
    uint256 longPrice,
    uint256 shortPrice,
    uint256 longValue,
    uint256 shortValue,
    uint256 longShortMarketPriceSnapshotIndexIfShiftExecuted // This value should be ALWAYS be zero if no shift occured
  ) external override onlyLongShort {
    // Only add a new state point if some time has passed.

    // the `longShortMarketPriceSnapshotIndexIfShiftExecuted` value will be 0 if there is no staker related action in an executed batch
    if (longShortMarketPriceSnapshotIndexIfShiftExecuted > 0) {
      longShortMarketPriceSnapshotIndex[
        nextTokenShiftIndex[marketIndex]
      ] = longShortMarketPriceSnapshotIndexIfShiftExecuted;
      tokenShiftIndexToStakerStateMapping[nextTokenShiftIndex[marketIndex]] =
        latestRewardIndex[marketIndex] +
        1;
      nextTokenShiftIndex[marketIndex] += 1;

      emit SynthTokensShifted();
    }

    // Time delta is fetched twice in below code, can pass through? Which is less gas?
    if (_calculateTimeDelta(marketIndex) > 0) {
      _setRewardObjects(marketIndex, longPrice, shortPrice, longValue, shortValue);
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
      uint256 accumDeltaLong = syntheticRewardParams[marketIndex][rewardIndexTo]
      .accumulativeFloatPerLongToken -
        syntheticRewardParams[marketIndex][rewardIndexFrom].accumulativeFloatPerLongToken;
      floatReward += (accumDeltaLong * amountStakedLong) / FLOAT_ISSUANCE_FIXED_DECIMAL;
    }

    if (amountStakedShort > 0) {
      uint256 accumDeltaShort = syntheticRewardParams[marketIndex][rewardIndexTo]
      .accumulativeFloatPerShortToken -
        syntheticRewardParams[marketIndex][rewardIndexFrom].accumulativeFloatPerShortToken;
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

    uint256 usersShiftIndex = shiftIndex[marketIndex][user];
    // if there is a change in the users tokens held due to a token shift (or possibly another action in the future)
    if (usersShiftIndex > 0 && usersShiftIndex < nextTokenShiftIndex[marketIndex]) {
      floatReward = _calculateAccumulatedFloatInRange(
        marketIndex,
        amountStakedLong,
        amountStakedShort,
        usersLastRewardIndex,
        tokenShiftIndexToStakerStateMapping[usersShiftIndex]
      );

      // Update the users balances
      if (amountToShiftFromLongUser[marketIndex][user] > 0) {
        amountStakedShort += ILongShort(longShort).getAmountSynthTokenShifted(
          marketIndex,
          amountToShiftFromLongUser[marketIndex][user],
          true,
          longShortMarketPriceSnapshotIndex[usersShiftIndex]
        );

        amountStakedLong -= amountToShiftFromLongUser[marketIndex][user];
        amountToShiftFromLongUser[marketIndex][user] = 0;
      }

      if (amountToShiftFromShortUser[marketIndex][user] > 0) {
        amountStakedLong += ILongShort(longShort).getAmountSynthTokenShifted(
          marketIndex,
          amountToShiftFromShortUser[marketIndex][user],
          false,
          longShortMarketPriceSnapshotIndex[usersShiftIndex]
        );

        // TODO: investigate how casting negative numbers works in solidity
        amountStakedShort -= amountToShiftFromShortUser[marketIndex][user];
        amountToShiftFromShortUser[marketIndex][user] = 0;
      }

      // Save the users updated staked amounts
      userAmountStaked[longToken][user] = amountStakedLong;
      userAmountStaked[shortToken][user] = amountStakedShort;

      floatReward += _calculateAccumulatedFloatInRange(
        marketIndex,
        amountStakedLong,
        amountStakedShort,
        tokenShiftIndexToStakerStateMapping[usersShiftIndex],
        latestRewardIndex[marketIndex]
      );

      shiftIndex[marketIndex][user] = 0;
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

  /*
   * A user with synthetic tokens stakes by calling stake on the token
   * contract which calls this function. We need to first update the
   * State of the system before staking to correctly calculate user rewards.
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
    uint256 synthTokensToShift,
    uint32 marketIndex,
    bool isShiftFromLong
  ) external virtual {
    address token = syntheticTokens[marketIndex][isShiftFromLong];
    require(
      userAmountStaked[token][msg.sender] >= synthTokensToShift,
      "Not enough tokens to shift"
    );

    // If the user has outstanding token shift that have already been confirmed in the LongShort
    // contract, execute them first.
    if (shiftIndex[marketIndex][msg.sender] < nextTokenShiftIndex[marketIndex]) {
      _mintAccumulatedFloat(marketIndex, msg.sender);
    }

    if (isShiftFromLong) {
      ILongShort(longShort).shiftPositionFromLongNextPrice(marketIndex, synthTokensToShift);
      amountToShiftFromLongUser[marketIndex][msg.sender] += synthTokensToShift;
    } else {
      ILongShort(longShort).shiftPositionFromShortNextPrice(marketIndex, synthTokensToShift);
      amountToShiftFromShortUser[marketIndex][msg.sender] += synthTokensToShift;
    }

    shiftIndex[marketIndex][msg.sender] = nextTokenShiftIndex[marketIndex];
  }

  /*╔════════════════════════════╗
    ║    WITHDRAWAL & MINTING    ║
    ╚════════════════════════════╝*/

  /*
    Withdraw function.
    Mint user any outstanding float before
    */
  function _withdraw(address token, uint256 amount) internal virtual {
    uint32 marketIndex = marketIndexOfToken[token];
    require(userAmountStaked[token][msg.sender] > 0, "nothing to withdraw");
    _mintAccumulatedFloat(marketIndex, msg.sender);

    userAmountStaked[token][msg.sender] = userAmountStaked[token][msg.sender] - amount;

    // TODO STENT what happens with the fees that are left in this contract?
    uint256 amountFees = (amount * marketUnstakeFeeBasisPoints[marketIndex]) / 1e18;

    IERC20(token).transfer(msg.sender, amount - amountFees);

    emit StakeWithdrawn(msg.sender, address(token), amount);
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
