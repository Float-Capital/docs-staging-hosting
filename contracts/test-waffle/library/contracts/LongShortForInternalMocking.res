@@ocaml.warning("-32")
open ContractHelpers
type t = {address: Ethers.ethAddress}
let contractName = "LongShortForInternalMocking"

let at: Ethers.ethAddress => JsPromise.t<t> = contractAddress =>
  attachToContract(contractName, ~contractAddress)->Obj.magic

let make: unit => JsPromise.t<t> = () => deployContract0(contractName)->Obj.magic

type _adjustMarketBasedOnNewAssetPriceMockReturn = bool
@send
external _adjustMarketBasedOnNewAssetPriceMock: (
  t,
  int,
  Ethers.BigNumber.t,
) => JsPromise.t<_adjustMarketBasedOnNewAssetPriceMockReturn> =
  "_adjustMarketBasedOnNewAssetPriceMock"

type _calculateBatchedNextPriceFeesMockReturn = {
  totalFeesLong: Ethers.BigNumber.t,
  totalFeesShort: Ethers.BigNumber.t,
}
@send
external _calculateBatchedNextPriceFeesMock: (
  t,
  int,
  Ethers.BigNumber.t,
  Ethers.BigNumber.t,
) => JsPromise.t<_calculateBatchedNextPriceFeesMockReturn> = "_calculateBatchedNextPriceFeesMock"

type _changeFeesMockReturn
@send
external _changeFeesMock: (
  t,
  int,
  Ethers.BigNumber.t,
  Ethers.BigNumber.t,
  Ethers.BigNumber.t,
  Ethers.BigNumber.t,
) => JsPromise.t<_changeFeesMockReturn> = "_changeFeesMock"

type _claimAndDistributeYieldMockReturn
@send
external _claimAndDistributeYieldMock: (t, int) => JsPromise.t<_claimAndDistributeYieldMockReturn> =
  "_claimAndDistributeYieldMock"

type _depositFundsMockReturn
@send
external _depositFundsMock: (t, int, Ethers.BigNumber.t) => JsPromise.t<_depositFundsMockReturn> =
  "_depositFundsMock"

type _distributeMarketAmountMockReturn
@send
external _distributeMarketAmountMock: (
  t,
  int,
  Ethers.BigNumber.t,
) => JsPromise.t<_distributeMarketAmountMockReturn> = "_distributeMarketAmountMock"

type _executeNextPriceMintsIfTheyExistMockReturn
@send
external _executeNextPriceMintsIfTheyExistMock: (
  t,
  int,
  Ethers.ethAddress,
  int,
) => JsPromise.t<_executeNextPriceMintsIfTheyExistMockReturn> =
  "_executeNextPriceMintsIfTheyExistMock"

type _executeOutstandingNextPriceRedeemsMockReturn
@send
external _executeOutstandingNextPriceRedeemsMock: (
  t,
  int,
  Ethers.ethAddress,
  int,
) => JsPromise.t<_executeOutstandingNextPriceRedeemsMockReturn> =
  "_executeOutstandingNextPriceRedeemsMock"

type _executeOutstandingNextPriceSettlementsActionMockReturn
@send
external _executeOutstandingNextPriceSettlementsActionMock: (
  t,
  Ethers.ethAddress,
  int,
) => JsPromise.t<_executeOutstandingNextPriceSettlementsActionMockReturn> =
  "_executeOutstandingNextPriceSettlementsActionMock"

type _executeOutstandingNextPriceSettlementsMockReturn
@send
external _executeOutstandingNextPriceSettlementsMock: (
  t,
  Ethers.ethAddress,
  int,
) => JsPromise.t<_executeOutstandingNextPriceSettlementsMockReturn> =
  "_executeOutstandingNextPriceSettlementsMock"

type _feesMechanismMockReturn
@send
external _feesMechanismMock: (t, int, Ethers.BigNumber.t) => JsPromise.t<_feesMechanismMockReturn> =
  "_feesMechanismMock"

type _getFeesGeneralMockReturn = Ethers.BigNumber.t
@send
external _getFeesGeneralMock: (
  t,
  int,
  Ethers.BigNumber.t,
  int,
  int,
  Ethers.BigNumber.t,
  Ethers.BigNumber.t,
) => JsPromise.t<_getFeesGeneralMockReturn> = "_getFeesGeneralMock"

type _handleBatchedNextPriceRedeemMockReturn
@send
external _handleBatchedNextPriceRedeemMock: (
  t,
  int,
  int,
  Ethers.BigNumber.t,
) => JsPromise.t<_handleBatchedNextPriceRedeemMockReturn> = "_handleBatchedNextPriceRedeemMock"

type _lockFundsInMarketMockReturn
@send
external _lockFundsInMarketMock: (
  t,
  int,
  Ethers.BigNumber.t,
) => JsPromise.t<_lockFundsInMarketMockReturn> = "_lockFundsInMarketMock"

type _minimumMockReturn = Ethers.BigNumber.t
@send
external _minimumMock: (
  t,
  Ethers.BigNumber.t,
  Ethers.BigNumber.t,
) => JsPromise.t<_minimumMockReturn> = "_minimumMock"

type _mintNextPriceMockReturn
@send
external _mintNextPriceMock: (
  t,
  int,
  Ethers.BigNumber.t,
  int,
) => JsPromise.t<_mintNextPriceMockReturn> = "_mintNextPriceMock"

type _redeemNextPriceMockReturn
@send
external _redeemNextPriceMock: (
  t,
  int,
  Ethers.BigNumber.t,
  int,
) => JsPromise.t<_redeemNextPriceMockReturn> = "_redeemNextPriceMock"

type _refreshTokenPricesMockReturn
@send
external _refreshTokenPricesMock: (t, int) => JsPromise.t<_refreshTokenPricesMockReturn> =
  "_refreshTokenPricesMock"

type _transferFromYieldManagerMockReturn
@send
external _transferFromYieldManagerMock: (
  t,
  int,
  Ethers.BigNumber.t,
) => JsPromise.t<_transferFromYieldManagerMockReturn> = "_transferFromYieldManagerMock"

type _transferFundsToYieldManagerMockReturn
@send
external _transferFundsToYieldManagerMock: (
  t,
  int,
  Ethers.BigNumber.t,
) => JsPromise.t<_transferFundsToYieldManagerMockReturn> = "_transferFundsToYieldManagerMock"

type _updateSystemStateInternalMockReturn
@send
external _updateSystemStateInternalMock: (
  t,
  int,
) => JsPromise.t<_updateSystemStateInternalMockReturn> = "_updateSystemStateInternalMock"

type _updateSystemStateMockReturn
@send
external _updateSystemStateMock: (t, int) => JsPromise.t<_updateSystemStateMockReturn> =
  "_updateSystemStateMock"

type _updateSystemStateMultiMockReturn
@send
external _updateSystemStateMultiMock: (
  t,
  array<int>,
) => JsPromise.t<_updateSystemStateMultiMockReturn> = "_updateSystemStateMultiMock"

type _withdrawFundsMockReturn
@send
external _withdrawFundsMock: (
  t,
  int,
  Ethers.BigNumber.t,
  Ethers.BigNumber.t,
  Ethers.ethAddress,
) => JsPromise.t<_withdrawFundsMockReturn> = "_withdrawFundsMock"

type adminOnlyMockReturn
@send
external adminOnlyMock: t => JsPromise.t<adminOnlyMockReturn> = "adminOnlyMock"

type assertMarketExistsMockReturn
@send
external assertMarketExistsMock: (t, int) => JsPromise.t<assertMarketExistsMockReturn> =
  "assertMarketExistsMock"

type calculateRedeemPriceSnapshotMockReturn = Ethers.BigNumber.t
@send
external calculateRedeemPriceSnapshotMock: (
  t,
  int,
  Ethers.BigNumber.t,
  int,
) => JsPromise.t<calculateRedeemPriceSnapshotMockReturn> = "calculateRedeemPriceSnapshotMock"

type changeAdminMockReturn
@send
external changeAdminMock: (t, Ethers.ethAddress) => JsPromise.t<changeAdminMockReturn> =
  "changeAdminMock"

type changeFeesMockReturn
@send
external changeFeesMock: (
  t,
  int,
  Ethers.BigNumber.t,
  Ethers.BigNumber.t,
  Ethers.BigNumber.t,
  Ethers.BigNumber.t,
) => JsPromise.t<changeFeesMockReturn> = "changeFeesMock"

type changeTreasuryMockReturn
@send
external changeTreasuryMock: (t, Ethers.ethAddress) => JsPromise.t<changeTreasuryMockReturn> =
  "changeTreasuryMock"

type executeOutstandingNextPriceSettlementsMockReturn
@send
external executeOutstandingNextPriceSettlementsMock: (
  t,
  Ethers.ethAddress,
  int,
) => JsPromise.t<executeOutstandingNextPriceSettlementsMockReturn> =
  "executeOutstandingNextPriceSettlementsMock"

type executeOutstandingNextPriceSettlementsUserMockReturn
@send
external executeOutstandingNextPriceSettlementsUserMock: (
  t,
  Ethers.ethAddress,
  int,
) => JsPromise.t<executeOutstandingNextPriceSettlementsUserMockReturn> =
  "executeOutstandingNextPriceSettlementsUserMock"

type getAmountPaymentTokenMockReturn = Ethers.BigNumber.t
@send
external getAmountPaymentTokenMock: (
  t,
  Ethers.BigNumber.t,
  Ethers.BigNumber.t,
) => JsPromise.t<getAmountPaymentTokenMockReturn> = "getAmountPaymentTokenMock"

type getAmountSynthTokenMockReturn = Ethers.BigNumber.t
@send
external getAmountSynthTokenMock: (
  t,
  Ethers.BigNumber.t,
  Ethers.BigNumber.t,
) => JsPromise.t<getAmountSynthTokenMockReturn> = "getAmountSynthTokenMock"

type getMarketSplitMockReturn = {
  longAmount: Ethers.BigNumber.t,
  shortAmount: Ethers.BigNumber.t,
}
@send
external getMarketSplitMock: (t, int, Ethers.BigNumber.t) => JsPromise.t<getMarketSplitMockReturn> =
  "getMarketSplitMock"

type getOtherSynthTypeMockReturn = int
@send
external getOtherSynthTypeMock: (t, int) => JsPromise.t<getOtherSynthTypeMockReturn> =
  "getOtherSynthTypeMock"

type getPriceMockReturn = Ethers.BigNumber.t
@send
external getPriceMock: (
  t,
  Ethers.BigNumber.t,
  Ethers.BigNumber.t,
) => JsPromise.t<getPriceMockReturn> = "getPriceMock"

type getTreasurySplitMockReturn = {
  marketAmount: Ethers.BigNumber.t,
  treasuryAmount: Ethers.BigNumber.t,
}
@send
external getTreasurySplitMock: (
  t,
  int,
  Ethers.BigNumber.t,
) => JsPromise.t<getTreasurySplitMockReturn> = "getTreasurySplitMock"

type getUsersPendingBalanceMockReturn = Ethers.BigNumber.t
@send
external getUsersPendingBalanceMock: (
  t,
  Ethers.ethAddress,
  int,
  int,
) => JsPromise.t<getUsersPendingBalanceMockReturn> = "getUsersPendingBalanceMock"

type handleBatchedDepositSettlementMockReturn
@send
external handleBatchedDepositSettlementMock: (
  t,
  int,
  int,
) => JsPromise.t<handleBatchedDepositSettlementMockReturn> = "handleBatchedDepositSettlementMock"

type handleBatchedNextPriceRedeemsMockReturn
@send
external handleBatchedNextPriceRedeemsMock: (
  t,
  int,
) => JsPromise.t<handleBatchedNextPriceRedeemsMockReturn> = "handleBatchedNextPriceRedeemsMock"

type initializeMarketMockReturn
@send
external initializeMarketMock: (
  t,
  int,
  Ethers.BigNumber.t,
  Ethers.BigNumber.t,
  Ethers.BigNumber.t,
  Ethers.BigNumber.t,
  Ethers.BigNumber.t,
  Ethers.BigNumber.t,
  Ethers.BigNumber.t,
) => JsPromise.t<initializeMarketMockReturn> = "initializeMarketMock"

type initializeMockReturn
@send
external initializeMock: (
  t,
  Ethers.ethAddress,
  Ethers.ethAddress,
  Ethers.ethAddress,
  Ethers.ethAddress,
) => JsPromise.t<initializeMockReturn> = "initializeMock"

type isCorrectSynthMockReturn
@send
external isCorrectSynthMock: (
  t,
  int,
  int,
  Ethers.ethAddress,
) => JsPromise.t<isCorrectSynthMockReturn> = "isCorrectSynthMock"

type mintLongNextPriceMockReturn
@send
external mintLongNextPriceMock: (
  t,
  int,
  Ethers.BigNumber.t,
) => JsPromise.t<mintLongNextPriceMockReturn> = "mintLongNextPriceMock"

type mintShortNextPriceMockReturn
@send
external mintShortNextPriceMock: (
  t,
  int,
  Ethers.BigNumber.t,
) => JsPromise.t<mintShortNextPriceMockReturn> = "mintShortNextPriceMock"

type newSyntheticMarketMockReturn
@send
external newSyntheticMarketMock: (
  t,
  string,
  string,
  Ethers.ethAddress,
  Ethers.ethAddress,
  Ethers.ethAddress,
) => JsPromise.t<newSyntheticMarketMockReturn> = "newSyntheticMarketMock"

type redeemLongNextPriceMockReturn
@send
external redeemLongNextPriceMock: (
  t,
  int,
  Ethers.BigNumber.t,
) => JsPromise.t<redeemLongNextPriceMockReturn> = "redeemLongNextPriceMock"

type redeemShortNextPriceMockReturn
@send
external redeemShortNextPriceMock: (
  t,
  int,
  Ethers.BigNumber.t,
) => JsPromise.t<redeemShortNextPriceMockReturn> = "redeemShortNextPriceMock"

type seedMarketInitiallyMockReturn
@send
external seedMarketInitiallyMock: (
  t,
  Ethers.BigNumber.t,
  int,
) => JsPromise.t<seedMarketInitiallyMockReturn> = "seedMarketInitiallyMock"

type snapshotPriceChangeForNextPriceExecutionMockReturn
@send
external snapshotPriceChangeForNextPriceExecutionMock: (
  t,
  int,
  Ethers.BigNumber.t,
) => JsPromise.t<snapshotPriceChangeForNextPriceExecutionMockReturn> =
  "snapshotPriceChangeForNextPriceExecutionMock"

type transferTreasuryFundsMockReturn
@send
external transferTreasuryFundsMock: (t, int) => JsPromise.t<transferTreasuryFundsMockReturn> =
  "transferTreasuryFundsMock"

type treasuryOnlyMockReturn
@send
external treasuryOnlyMock: t => JsPromise.t<treasuryOnlyMockReturn> = "treasuryOnlyMock"

type updateMarketOracleMockReturn
@send
external updateMarketOracleMock: (
  t,
  int,
  Ethers.ethAddress,
) => JsPromise.t<updateMarketOracleMockReturn> = "updateMarketOracleMock"
