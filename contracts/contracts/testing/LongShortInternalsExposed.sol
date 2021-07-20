pragma solidity 0.8.3;

import "./generated/LongShortMockable.sol";

/*
NOTE: This contract is for testing purposes only!
*/

// TODO: rename this contract to "LongShortInternalStateSettors" and remove all
//       exposed functions since they are part of the 'Mockable' contract now.
//       Also update the contract-interface codegen so that it puts the correct functions as "Exposed".
contract LongShortInternalsExposed is LongShortMockable {
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
    uint256 batchedAmountOfTokensToDepositLong,
    uint256 batchedAmountOfTokensToDepositShort,
    uint256 batchedAmountOfSynthTokensToRedeemLong,
    uint256 batchedAmountOfSynthTokensToRedeemShort
  ) external {
    batchedAmountOfTokensToDeposit[marketIndex][true] = batchedAmountOfTokensToDepositLong;
    batchedAmountOfTokensToDeposit[marketIndex][false] = batchedAmountOfTokensToDepositShort;
    batchedAmountOfSynthTokensToRedeem[marketIndex][true] = batchedAmountOfSynthTokensToRedeemLong;
    batchedAmountOfSynthTokensToRedeem[marketIndex][
      false
    ] = batchedAmountOfSynthTokensToRedeemShort;
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
}
