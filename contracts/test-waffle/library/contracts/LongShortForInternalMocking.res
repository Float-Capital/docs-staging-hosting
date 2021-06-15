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

type _calculateBatchedLazyFeesMockReturn = {
  totalFeesLong: Ethers.BigNumber.t,
  totalFeesShort: Ethers.BigNumber.t,
}
@send
external _calculateBatchedLazyFeesMock: (
  t,
  int,
  Ethers.BigNumber.t,
  Ethers.BigNumber.t,
) => JsPromise.t<_calculateBatchedLazyFeesMockReturn> = "_calculateBatchedLazyFeesMock"

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

type _executeLazyMintsIfTheyExistMockReturn
@send
external _executeLazyMintsIfTheyExistMock: (
  t,
  int,
  Ethers.ethAddress,
  int,
) => JsPromise.t<_executeLazyMintsIfTheyExistMockReturn> = "_executeLazyMintsIfTheyExistMock"

type _executeOutstandingLazyRedeemsMockReturn
@send
external _executeOutstandingLazyRedeemsMock: (
  t,
  int,
  Ethers.ethAddress,
  int,
) => JsPromise.t<_executeOutstandingLazyRedeemsMockReturn> = "_executeOutstandingLazyRedeemsMock"

type _executeOutstandingLazySettlementsActionMockReturn
@send
external _executeOutstandingLazySettlementsActionMock: (
  t,
  Ethers.ethAddress,
  int,
) => JsPromise.t<_executeOutstandingLazySettlementsActionMockReturn> =
  "_executeOutstandingLazySettlementsActionMock"

type _executeOutstandingLazySettlementsMockReturn
@send
external _executeOutstandingLazySettlementsMock: (
  t,
  Ethers.ethAddress,
  int,
) => JsPromise.t<_executeOutstandingLazySettlementsMockReturn> =
  "_executeOutstandingLazySettlementsMock"

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

type _handleBatchedLazyRedeemMockReturn
@send
external _handleBatchedLazyRedeemMock: (
  t,
  int,
  int,
  Ethers.BigNumber.t,
) => JsPromise.t<_handleBatchedLazyRedeemMockReturn> = "_handleBatchedLazyRedeemMock"

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

type _mintLazyMockReturn
@send
external _mintLazyMock: (t, int, Ethers.BigNumber.t, int) => JsPromise.t<_mintLazyMockReturn> =
  "_mintLazyMock"

type _redeemLazyMockReturn
@send
external _redeemLazyMock: (t, int, Ethers.BigNumber.t, int) => JsPromise.t<_redeemLazyMockReturn> =
  "_redeemLazyMock"

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

type executeOutstandingLazySettlementsMockReturn
@send
external executeOutstandingLazySettlementsMock: (
  t,
  Ethers.ethAddress,
  int,
) => JsPromise.t<executeOutstandingLazySettlementsMockReturn> =
  "executeOutstandingLazySettlementsMock"

type executeOutstandingLazySettlementsUserMockReturn
@send
external executeOutstandingLazySettlementsUserMock: (
  t,
  Ethers.ethAddress,
  int,
) => JsPromise.t<executeOutstandingLazySettlementsUserMockReturn> =
  "executeOutstandingLazySettlementsUserMock"

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

type handleBatchedLazyRedeemsMockReturn
@send
external handleBatchedLazyRedeemsMock: (t, int) => JsPromise.t<handleBatchedLazyRedeemsMockReturn> =
  "handleBatchedLazyRedeemsMock"

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

type mintLongLazyMockReturn
@send
external mintLongLazyMock: (t, int, Ethers.BigNumber.t) => JsPromise.t<mintLongLazyMockReturn> =
  "mintLongLazyMock"

type mintShortLazyMockReturn
@send
external mintShortLazyMock: (t, int, Ethers.BigNumber.t) => JsPromise.t<mintShortLazyMockReturn> =
  "mintShortLazyMock"

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

type redeemLongLazyMockReturn
@send
external redeemLongLazyMock: (t, int, Ethers.BigNumber.t) => JsPromise.t<redeemLongLazyMockReturn> =
  "redeemLongLazyMock"

type redeemShortLazyMockReturn
@send
external redeemShortLazyMock: (
  t,
  int,
  Ethers.BigNumber.t,
) => JsPromise.t<redeemShortLazyMockReturn> = "redeemShortLazyMock"

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
