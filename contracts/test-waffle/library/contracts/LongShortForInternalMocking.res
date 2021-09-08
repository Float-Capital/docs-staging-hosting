@@ocaml.warning("-32")
open ContractHelpers
type t = {address: Ethers.ethAddress}
let contractName = "LongShortForInternalMocking"

let at: Ethers.ethAddress => JsPromise.t<t> = contractAddress =>
  attachToContract(contractName, ~contractAddress)->Obj.magic

let make: unit => JsPromise.t<t> = () => deployContract0(contractName)->Obj.magic

type _claimAndDistributeYieldThenRebalanceMarketMockReturn = {
  longValue: Ethers.BigNumber.t,
  shortValue: Ethers.BigNumber.t,
}
@send
external _claimAndDistributeYieldThenRebalanceMarketMock: (
  t,
  int,
  Ethers.BigNumber.t,
  Ethers.BigNumber.t,
) => JsPromise.t<_claimAndDistributeYieldThenRebalanceMarketMockReturn> =
  "_claimAndDistributeYieldThenRebalanceMarketMock"

type _depositFundsMockReturn
@send
external _depositFundsMock: (t, int, Ethers.BigNumber.t) => JsPromise.t<_depositFundsMockReturn> =
  "_depositFundsMock"

type _executeOutstandingNextPriceMintsMockReturn
@send
external _executeOutstandingNextPriceMintsMock: (
  t,
  int,
  Ethers.ethAddress,
  bool,
) => JsPromise.t<_executeOutstandingNextPriceMintsMockReturn> =
  "_executeOutstandingNextPriceMintsMock"

type _executeOutstandingNextPriceRedeemsMockReturn
@send
external _executeOutstandingNextPriceRedeemsMock: (
  t,
  int,
  Ethers.ethAddress,
  bool,
) => JsPromise.t<_executeOutstandingNextPriceRedeemsMockReturn> =
  "_executeOutstandingNextPriceRedeemsMock"

type _executeOutstandingNextPriceSettlementsMockReturn
@send
external _executeOutstandingNextPriceSettlementsMock: (
  t,
  Ethers.ethAddress,
  int,
) => JsPromise.t<_executeOutstandingNextPriceSettlementsMockReturn> =
  "_executeOutstandingNextPriceSettlementsMock"

type _executeOutstandingNextPriceTokenShiftsMockReturn
@send
external _executeOutstandingNextPriceTokenShiftsMock: (
  t,
  int,
  Ethers.ethAddress,
  bool,
) => JsPromise.t<_executeOutstandingNextPriceTokenShiftsMockReturn> =
  "_executeOutstandingNextPriceTokenShiftsMock"

type _getAmountPaymentTokenMockReturn = Ethers.BigNumber.t
@send
external _getAmountPaymentTokenMock: (
  t,
  Ethers.BigNumber.t,
  Ethers.BigNumber.t,
) => JsPromise.t<_getAmountPaymentTokenMockReturn> = "_getAmountPaymentTokenMock"

type _getAmountSynthTokenMockReturn = Ethers.BigNumber.t
@send
external _getAmountSynthTokenMock: (
  t,
  Ethers.BigNumber.t,
  Ethers.BigNumber.t,
) => JsPromise.t<_getAmountSynthTokenMockReturn> = "_getAmountSynthTokenMock"

type _getMinMockReturn = Ethers.BigNumber.t
@send
external _getMinMock: (
  t,
  Ethers.BigNumber.t,
  Ethers.BigNumber.t,
) => JsPromise.t<_getMinMockReturn> = "_getMinMock"

type _getSyntheticTokenPriceMockReturn = Ethers.BigNumber.t
@send
external _getSyntheticTokenPriceMock: (
  t,
  Ethers.BigNumber.t,
  Ethers.BigNumber.t,
) => JsPromise.t<_getSyntheticTokenPriceMockReturn> = "_getSyntheticTokenPriceMock"

type _getYieldSplitMockReturn = {
  isLongSideUnderbalanced: bool,
  treasuryPercentE18: Ethers.BigNumber.t,
}
@send
external _getYieldSplitMock: (
  t,
  Ethers.BigNumber.t,
  Ethers.BigNumber.t,
  Ethers.BigNumber.t,
) => JsPromise.t<_getYieldSplitMockReturn> = "_getYieldSplitMock"

type _handleChangeInSynthTokensTotalSupplyMockReturn
@send
external _handleChangeInSynthTokensTotalSupplyMock: (
  t,
  int,
  bool,
  Ethers.BigNumber.t,
) => JsPromise.t<_handleChangeInSynthTokensTotalSupplyMockReturn> =
  "_handleChangeInSynthTokensTotalSupplyMock"

type _handleTotalValueChangeForMarketWithYieldManagerMockReturn
@send
external _handleTotalValueChangeForMarketWithYieldManagerMock: (
  t,
  int,
  Ethers.BigNumber.t,
) => JsPromise.t<_handleTotalValueChangeForMarketWithYieldManagerMockReturn> =
  "_handleTotalValueChangeForMarketWithYieldManagerMock"

type _lockFundsInMarketMockReturn
@send
external _lockFundsInMarketMock: (
  t,
  int,
  Ethers.BigNumber.t,
) => JsPromise.t<_lockFundsInMarketMockReturn> = "_lockFundsInMarketMock"

type _mintNextPriceMockReturn
@send
external _mintNextPriceMock: (
  t,
  int,
  Ethers.BigNumber.t,
  bool,
) => JsPromise.t<_mintNextPriceMockReturn> = "_mintNextPriceMock"

type _performOustandingBatchedSettlementsMockReturn = {
  valueChangeForLong: Ethers.BigNumber.t,
  valueChangeForShort: Ethers.BigNumber.t,
}
@send
external _performOustandingBatchedSettlementsMock: (
  t,
  int,
  Ethers.BigNumber.t,
  Ethers.BigNumber.t,
) => JsPromise.t<_performOustandingBatchedSettlementsMockReturn> =
  "_performOustandingBatchedSettlementsMock"

type _redeemNextPriceMockReturn
@send
external _redeemNextPriceMock: (
  t,
  int,
  Ethers.BigNumber.t,
  bool,
) => JsPromise.t<_redeemNextPriceMockReturn> = "_redeemNextPriceMock"

type _seedMarketInitiallyMockReturn
@send
external _seedMarketInitiallyMock: (
  t,
  Ethers.BigNumber.t,
  int,
) => JsPromise.t<_seedMarketInitiallyMockReturn> = "_seedMarketInitiallyMock"

type _shiftPositionNextPriceMockReturn
@send
external _shiftPositionNextPriceMock: (
  t,
  int,
  Ethers.BigNumber.t,
  bool,
) => JsPromise.t<_shiftPositionNextPriceMockReturn> = "_shiftPositionNextPriceMock"

type _updateSystemStateInternalMockReturn
@send
external _updateSystemStateInternalMock: (
  t,
  int,
) => JsPromise.t<_updateSystemStateInternalMockReturn> = "_updateSystemStateInternalMock"

type getAmountSynthTokenShiftedMockReturn = Ethers.BigNumber.t
@send
external getAmountSynthTokenShiftedMock: (
  t,
  int,
  Ethers.BigNumber.t,
  bool,
  Ethers.BigNumber.t,
) => JsPromise.t<getAmountSynthTokenShiftedMockReturn> = "getAmountSynthTokenShiftedMock"

type getUsersConfirmedButNotSettledSynthBalanceMockReturn = Ethers.BigNumber.t
@send
external getUsersConfirmedButNotSettledSynthBalanceMock: (
  t,
  Ethers.ethAddress,
  int,
  bool,
) => JsPromise.t<getUsersConfirmedButNotSettledSynthBalanceMockReturn> =
  "getUsersConfirmedButNotSettledSynthBalanceMock"

type initializeMockReturn
@send
external initializeMock: (
  t,
  Ethers.ethAddress,
  Ethers.ethAddress,
  Ethers.ethAddress,
  Ethers.ethAddress,
) => JsPromise.t<initializeMockReturn> = "initializeMock"
