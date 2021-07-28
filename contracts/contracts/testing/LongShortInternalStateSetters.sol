pragma solidity 0.8.3;

import "../LongShort.sol";

/*
NOTE: This contract is for testing purposes only!
*/

contract LongShortInternalStateSetters is LongShort {
  bool overRideexecuteOutstandingNextPriceSettlements;

  event executeOutstandingNextPriceSettlementsMock(address _user, uint32 _marketIndex);

  function setInitializeMarketParams(
    uint32 marketIndex,
    bool marketIndexValue,
    uint32 _latestMarket,
    address _staker,
    address longAddress,
    address shortAddress
  ) public {
    latestMarket = _latestMarket;
    marketExists[marketIndex] = marketIndexValue;
    staker = (_staker);
    syntheticTokens[marketIndex][
      true /*short*/
    ] = (longAddress);
    syntheticTokens[marketIndex][
      false /*short*/
    ] = (shortAddress);
  }

  function setMarketExistsMulti(uint32[] calldata marketIndexes) external {
    for (uint256 i = 0; i < marketIndexes.length; i++) {
      marketExists[marketIndexes[i]] = true;
    }
  }

  function set_updateSystemStateInternalGlobals(
    uint32 marketIndex,
    uint256 _latestUpdateIndexForMarket,
    uint256 syntheticTokenPriceLong,
    uint256 syntheticTokenPriceShort,
    uint256 _assetPrice,
    uint256 longValue,
    uint256 shortValue,
    address oracleManager,
    address _staker,
    address synthLong,
    address synthShort
  ) public {
    marketExists[marketIndex] = true;
    marketUpdateIndex[marketIndex] = _latestUpdateIndexForMarket;
    syntheticTokenPriceSnapshot[marketIndex][true][
      _latestUpdateIndexForMarket
    ] = syntheticTokenPriceLong;
    syntheticTokenPriceSnapshot[marketIndex][false][
      _latestUpdateIndexForMarket
    ] = syntheticTokenPriceShort;

    syntheticTokenPoolValue[marketIndex][true] = longValue;
    syntheticTokenPoolValue[marketIndex][false] = shortValue;

    assetPrice[marketIndex] = _assetPrice;
    oracleManagers[marketIndex] = oracleManager;

    syntheticTokens[marketIndex][true] = synthLong;
    syntheticTokens[marketIndex][false] = synthShort;

    staker = _staker;
  }

  function setUseexecuteOutstandingNextPriceSettlementsMock(bool shouldUseMock) public {
    overRideexecuteOutstandingNextPriceSettlements = shouldUseMock;
  }

  function _executeOutstandingNextPriceSettlementsMock(address _user, uint32 _marketIndex)
    internal
  {
    emit executeOutstandingNextPriceSettlementsMock(_user, _marketIndex);
  }

  function _executeOutstandingNextPriceSettlementsExposedWithEvent(address user, uint32 marketIndex)
    external
  {
    _executeOutstandingNextPriceSettlements(user, marketIndex);
  }

  function setGetUsersConfirmedButNotSettledBalanceGlobals(
    uint32 marketIndex,
    address user,
    bool isLong,
    uint256 _userCurrentNextPriceUpdateIndex,
    uint256 _marketUpdateIndex,
    uint256 _userNextPriceDepositAmount,
    uint256 _syntheticTokenPriceSnapshot
  ) external {
    marketExists[marketIndex] = true;
    userCurrentNextPriceUpdateIndex[marketIndex][user] = _userCurrentNextPriceUpdateIndex;
    marketUpdateIndex[marketIndex] = _marketUpdateIndex;
    userNextPriceDepositAmount[marketIndex][isLong][user] = _userNextPriceDepositAmount;
    syntheticTokenPriceSnapshot[marketIndex][isLong][
      _marketUpdateIndex
    ] = _syntheticTokenPriceSnapshot;
  }

  function setPerformOustandingBatchedSettlementsGlobals(
    uint32 marketIndex,
    uint256 batchedAmountOfPaymentTokenToDepositLong,
    uint256 batchedAmountOfPaymentTokenToDepositShort,
    uint256 batchedAmountOfSynthTokensToRedeemLong,
    uint256 batchedAmountOfSynthTokensToRedeemShort,
    uint256 batchedAmountOfSynthTokensToShiftFromLong,
    uint256 batchedAmountOfSynthTokensToShiftFromShort
  ) external {
    batchedAmountOfPaymentTokenToDeposit[marketIndex][
      true
    ] = batchedAmountOfPaymentTokenToDepositLong;
    batchedAmountOfPaymentTokenToDeposit[marketIndex][
      false
    ] = batchedAmountOfPaymentTokenToDepositShort;
    batchedAmountOfSynthTokensToRedeem[marketIndex][true] = batchedAmountOfSynthTokensToRedeemLong;
    batchedAmountOfSynthTokensToRedeem[marketIndex][
      false
    ] = batchedAmountOfSynthTokensToRedeemShort;
    batchedAmountOfSynthTokensToShiftMarketSide[marketIndex][
      true
    ] = batchedAmountOfSynthTokensToShiftFromLong;
    batchedAmountOfSynthTokensToShiftMarketSide[marketIndex][
      false
    ] = batchedAmountOfSynthTokensToShiftFromShort;
  }

  function setHandleChangeInSynthTokensTotalSupplyGlobals(
    uint32 marketIndex,
    address longSynthToken,
    address shortSynthToken
  ) external {
    syntheticTokens[marketIndex][true] = longSynthToken;
    syntheticTokens[marketIndex][false] = shortSynthToken;
  }

  function setHandleTotalValueChangeForMarketWithYieldManagerGlobals(
    uint32 marketIndex,
    address yieldManager
  ) external {
    yieldManagers[marketIndex] = yieldManager;
  }

  function setMintNextPriceGlobals(uint32 marketIndex, uint256 _marketUpdateIndex) external {
    marketUpdateIndex[marketIndex] = _marketUpdateIndex;
  }

  function setRedeemNextPriceGlobals(
    uint32 marketIndex,
    uint256 _marketUpdateIndex,
    address syntheticToken,
    bool isLong
  ) external {
    marketUpdateIndex[marketIndex] = _marketUpdateIndex;
    syntheticTokens[marketIndex][isLong] = syntheticToken;
  }

  function setShiftNextPriceGlobals(
    uint32 marketIndex,
    uint256 _marketUpdateIndex,
    address syntheticTokenShiftedFrom,
    bool isShiftFromLong
  ) external {
    marketUpdateIndex[marketIndex] = _marketUpdateIndex;
    syntheticTokens[marketIndex][isShiftFromLong] = syntheticTokenShiftedFrom;
  }

  function setExecuteOutstandingNextPriceMintsGlobals(
    uint32 marketIndex,
    address user,
    bool isLong,
    address syntheticToken,
    uint256 _userNextPriceRedemptionAmount,
    uint256 _userCurrentNextPriceUpdateIndex,
    uint256 _syntheticTokenPriceSnapshot
  ) external {
    userNextPriceDepositAmount[marketIndex][isLong][user] = _userNextPriceRedemptionAmount;
    userCurrentNextPriceUpdateIndex[marketIndex][user] = _userCurrentNextPriceUpdateIndex;
    syntheticTokenPriceSnapshot[marketIndex][isLong][
      _userCurrentNextPriceUpdateIndex
    ] = _syntheticTokenPriceSnapshot;
    syntheticTokens[marketIndex][isLong] = syntheticToken;
  }

  function setExecuteOutstandingNextPriceRedeemsGlobals(
    uint32 marketIndex,
    address user,
    bool isLong,
    address paymentToken,
    uint256 _userNextPriceRedemptionAmount,
    uint256 _userCurrentNextPriceUpdateIndex,
    uint256 _syntheticTokenPriceSnapshot
  ) external {
    userNextPriceRedemptionAmount[marketIndex][isLong][user] = _userNextPriceRedemptionAmount;
    userCurrentNextPriceUpdateIndex[marketIndex][user] = _userCurrentNextPriceUpdateIndex;
    syntheticTokenPriceSnapshot[marketIndex][isLong][
      _userCurrentNextPriceUpdateIndex
    ] = _syntheticTokenPriceSnapshot;
    paymentTokens[marketIndex] = paymentToken;
  }

  function setExecuteOutstandingNextPriceTokenShiftsGlobals(
    uint32 marketIndex,
    address user,
    bool isShiftFromLong,
    address syntheticTokenShiftedTo,
    uint256 _userNextPrice_amountSynthToShiftFromMarketSide,
    uint256 _userCurrentNextPriceUpdateIndex,
    uint256 _syntheticTokenPriceSnapshotShiftedFrom,
    uint256 _syntheticTokenPriceSnapshotShiftedTo
  ) external {
    userNextPrice_amountSynthToShiftFromMarketSide[marketIndex][isShiftFromLong][
      user
    ] = _userNextPrice_amountSynthToShiftFromMarketSide;
    userCurrentNextPriceUpdateIndex[marketIndex][user] = _userCurrentNextPriceUpdateIndex;
    syntheticTokenPriceSnapshot[marketIndex][isShiftFromLong][
      _userCurrentNextPriceUpdateIndex
    ] = _syntheticTokenPriceSnapshotShiftedFrom;
    syntheticTokenPriceSnapshot[marketIndex][!isShiftFromLong][
      _userCurrentNextPriceUpdateIndex
    ] = _syntheticTokenPriceSnapshotShiftedTo;
    syntheticTokens[marketIndex][!isShiftFromLong] = syntheticTokenShiftedTo;
  }

  function setExecuteOutstandingNextPriceSettlementsGlobals(
    uint32 marketIndex,
    address user,
    uint256 _userCurrentNextPriceUpdateIndex,
    uint256 _marketUpdateIndex
  ) external {
    userCurrentNextPriceUpdateIndex[marketIndex][user] = _userCurrentNextPriceUpdateIndex;
    marketUpdateIndex[marketIndex] = _marketUpdateIndex;
  }
}
