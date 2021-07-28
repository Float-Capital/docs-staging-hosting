// SPDX-License-Identifier: BUSL-1.1

pragma solidity 0.8.3;

import "../Staker.sol";

/*
NOTE: This contract is for testing purposes only!
*/

contract StakerInternalStateSetters is Staker {
  ///////////////////////////////////////////////
  //////////// Test Helper Functions ////////////
  ///////////////////////////////////////////////
  // TODO: remove parts of this function that aren't necessary for the updated `_calculateAccumulatedFloat` funciton
  function setFloatRewardCalcParams(
    uint32 marketIndex,
    address longToken,
    address shortToken,
    uint256 newLatestRewardIndex,
    address user,
    uint256 usersLatestClaimedReward,
    uint256 accumulativeFloatPerTokenLatestLong,
    uint256 accumulativeFloatPerTokenLatestShort,
    uint256 accumulativeFloatPerTokenUserLong,
    uint256 accumulativeFloatPerTokenUserShort,
    uint256 newUserAmountStakedLong,
    uint256 newUserAmountStakedShort
  ) public {
    latestRewardIndex[marketIndex] = newLatestRewardIndex;
    userIndexOfLastClaimedReward[marketIndex][user] = usersLatestClaimedReward;
    syntheticTokens[marketIndex][true] = longToken;
    syntheticTokens[marketIndex][false] = shortToken;

    syntheticRewardParams[marketIndex][newLatestRewardIndex]
    .accumulativeFloatPerLongToken = accumulativeFloatPerTokenLatestLong;

    syntheticRewardParams[marketIndex][usersLatestClaimedReward]
    .accumulativeFloatPerLongToken = accumulativeFloatPerTokenUserLong;

    syntheticRewardParams[marketIndex][newLatestRewardIndex]
    .accumulativeFloatPerShortToken = accumulativeFloatPerTokenLatestShort;

    syntheticRewardParams[marketIndex][usersLatestClaimedReward]
    .accumulativeFloatPerShortToken = accumulativeFloatPerTokenUserShort;

    userAmountStaked[longToken][user] = newUserAmountStakedLong;
    userAmountStaked[shortToken][user] = newUserAmountStakedShort;
  }

  function setCalculateAccumulatedFloatInRangeGlobals(
    uint32 marketIndex,
    uint256 rewardIndexTo,
    uint256 rewardIndexFrom,
    uint256 syntheticRewardToLongToken,
    uint256 syntheticRewardFromLongToken,
    uint256 syntheticRewardToShortToken,
    uint256 syntheticRewardFromShortToken
  ) public {
    syntheticRewardParams[marketIndex][rewardIndexTo]
    .accumulativeFloatPerLongToken = syntheticRewardToLongToken;
    syntheticRewardParams[marketIndex][rewardIndexTo]
    .accumulativeFloatPerShortToken = syntheticRewardToShortToken;
    syntheticRewardParams[marketIndex][rewardIndexFrom]
    .accumulativeFloatPerLongToken = syntheticRewardFromLongToken;
    syntheticRewardParams[marketIndex][rewardIndexFrom]
    .accumulativeFloatPerShortToken = syntheticRewardFromShortToken;
  }

  function setShiftParams(
    uint32 marketIndex,
    address user,
    uint256 shiftAmountLong,
    uint256 shiftAmountShort,
    uint256 _shiftIndex,
    uint256 _nextTokenShiftIndex,
    uint256 _longShortMarketPriceSnapshotIndex,
    uint256 _tokenShiftIndexToStakerStateMapping
  ) public {
    shiftIndex[marketIndex][user] = _shiftIndex;
    amountToShiftFromLongUser[marketIndex][user] = shiftAmountLong;
    amountToShiftFromShortUser[marketIndex][user] = shiftAmountShort;
    nextTokenShiftIndex[marketIndex] = _nextTokenShiftIndex;
    longShortMarketPriceSnapshotIndex[_shiftIndex] = _longShortMarketPriceSnapshotIndex;
    tokenShiftIndexToStakerStateMapping[_shiftIndex] = _tokenShiftIndexToStakerStateMapping;
  }

  function setShiftTokensParams(
    uint32 marketIndex,
    bool isShiftFromLong,
    address user,
    uint256 synthTokensToShift,
    uint256 _userAmountStaked,
    uint256 _shiftIndex,
    uint256 _nextTokenShiftIndex,
    address syntheticToken
  ) public {
    shiftIndex[marketIndex][user] = _shiftIndex;
    nextTokenShiftIndex[marketIndex] = _nextTokenShiftIndex;

    if (isShiftFromLong) {
      amountToShiftFromLongUser[marketIndex][user] = synthTokensToShift;
    } else {
      amountToShiftFromShortUser[marketIndex][user] = synthTokensToShift;
    }

    syntheticTokens[marketIndex][isShiftFromLong] = syntheticToken;
    userAmountStaked[syntheticToken][user] = _userAmountStaked;
  }

  function setLongShort(address _longShort) public {
    longShort = _longShort;
  }

  function setAddNewStakingFundParams(
    uint32 marketIndex,
    address longToken,
    address shortToken,
    address mockAddress,
    address longShortAddress
  ) public {
    longShort = address(longShortAddress);
    marketIndexOfToken[longToken] = marketIndex;
    marketIndexOfToken[shortToken] = marketIndex;

    syntheticRewardParams[marketIndex][0].timestamp = 0; // don't test with 0
    syntheticRewardParams[marketIndex][0].accumulativeFloatPerLongToken = 1;
    syntheticRewardParams[marketIndex][0].accumulativeFloatPerShortToken = 1;

    syntheticTokens[marketIndex][true] = mockAddress;
    syntheticTokens[marketIndex][false] = mockAddress;
  }

  function setAddNewStateForFloatRewardsGlobals(
    uint32 marketIndex,
    uint256 _nextTokenShiftIndex,
    uint256 _latestRewardIndex
  ) external {
    nextTokenShiftIndex[marketIndex] = _nextTokenShiftIndex;
    latestRewardIndex[marketIndex] = _latestRewardIndex;
  }

  function setGetMarketLaunchIncentiveParametersParams(
    uint32 marketIndex,
    uint256 period,
    uint256 multiplier
  ) external {
    marketLaunchIncentivePeriod[marketIndex] = period;
    marketLaunchIncentiveMultipliers[marketIndex] = multiplier;
  }

  function setGetKValueParams(uint32 marketIndex, uint256 timestamp) external {
    syntheticRewardParams[marketIndex][0].timestamp = timestamp;
  }

  function setStakeFromUserParams(
    address longshort,
    address token,
    uint32 marketIndexForToken
  ) external {
    longShort = address(longshort);
    marketIndexOfToken[token] = marketIndexForToken;
  }

  function setCalculateTimeDeltaParams(
    uint32 marketIndex,
    uint256 latestRewardIndexForMarket,
    uint256 timestamp
  ) external {
    latestRewardIndex[marketIndex] = latestRewardIndexForMarket;
    syntheticRewardParams[marketIndex][latestRewardIndexForMarket].timestamp = timestamp;
  }

  function setCalculateNewCumulativeRateParams(
    uint32 marketIndex,
    uint256 latestRewardIndexForMarket,
    uint256 accumFloatLong,
    uint256 accumFloatShort
  ) external {
    latestRewardIndex[marketIndex] = latestRewardIndexForMarket;
    syntheticRewardParams[marketIndex][latestRewardIndex[marketIndex]]
    .accumulativeFloatPerLongToken = accumFloatLong;

    syntheticRewardParams[marketIndex][latestRewardIndex[marketIndex]]
    .accumulativeFloatPerShortToken = accumFloatShort;
  }

  function setSetRewardObjectsParams(uint32 marketIndex, uint256 latestRewardIndexForMarket)
    external
  {
    latestRewardIndex[marketIndex] = latestRewardIndexForMarket;
  }

  function set_updateStateParams(
    address _longShort,
    address token,
    uint32 tokenMarketIndex
  ) public {
    longShort = _longShort;
    marketIndexOfToken[token] = tokenMarketIndex;
  }

  function set_mintFloatParams(address _floatToken, uint16 _floatPercentage) public {
    floatToken = _floatToken;
    floatPercentage = _floatPercentage;
  }

  function setMintAccumulatedFloatAndClaimFloatParams(
    uint32 marketIndex,
    uint256 latestRewardIndexForMarket
  ) public {
    latestRewardIndex[marketIndex] = latestRewardIndexForMarket;
  }

  function set_stakeParams(
    address user,
    uint32 marketIndex,
    uint256 _latestRewardIndex,
    address token,
    uint256 _userAmountStaked,
    uint256 userLastRewardIndex
  ) external {
    marketIndexOfToken[token] = marketIndex;
    latestRewardIndex[marketIndex] = _latestRewardIndex;
    userAmountStaked[token][user] = _userAmountStaked;
    userIndexOfLastClaimedReward[marketIndex][user] = userLastRewardIndex;
  }

  ///////////////////////////////////////////////////////
  //////////// Functions for Experimentation ////////////
  ///////////////////////////////////////////////////////

  function getRequiredAmountOfBitShiftForSafeExponentiationPerfect(uint256 number, uint256 exponent)
    external
    pure
    returns (uint256 amountOfBitShiftRequired)
  {
    uint256 targetMaxNumberSizeBinaryDigits = 257 / exponent;

    // Note this can be optimised, this gets a quick easy to compute safe upper bound, not the actuall upper bound.
    uint256 targetMaxNumber = 2**targetMaxNumberSizeBinaryDigits;

    while (number >> amountOfBitShiftRequired > targetMaxNumber) {
      ++amountOfBitShiftRequired;
    }
  }
}
