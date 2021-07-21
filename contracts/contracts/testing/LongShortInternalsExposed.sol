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

  function setClaimAndDistributeYieldGlobals(
    uint32 marketIndex,
    address yieldManager,
    uint256 syntheticTokenPoolValueLong,
    uint256 syntheticTokenPoolValueShort
  ) external {
    yieldManagers[marketIndex] = IYieldManager(yieldManager);
    syntheticTokenPoolValue[marketIndex][true] = syntheticTokenPoolValueLong;
    syntheticTokenPoolValue[marketIndex][false] = syntheticTokenPoolValueShort;
  }
}
