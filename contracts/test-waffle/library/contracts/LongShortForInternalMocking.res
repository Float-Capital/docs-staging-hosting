@@ocaml.warning("-32")
open ContractHelpers
type t = {address: Ethers.ethAddress}
let contractName = "LongShortForInternalMocking"

let at: Ethers.ethAddress => JsPromise.t<t> = contractAddress =>
  attachToContract(contractName, ~contractAddress)->Obj.magic

let make: unit => JsPromise.t<t> = () => deployContract0(contractName)->Obj.magic

type _adjustMarketBasedOnNewAssetPriceMockReturn
@send
external _adjustMarketBasedOnNewAssetPriceMock: (
  t,
  int,
  Ethers.BigNumber.t,
) => JsPromise.t<_adjustMarketBasedOnNewAssetPriceMockReturn> =
  "_adjustMarketBasedOnNewAssetPriceMock"

type _burnSynthTokensForRedemptionMockReturn
@send
external _burnSynthTokensForRedemptionMock: (
  t,
  int,
  Ethers.BigNumber.t,
  Ethers.BigNumber.t,
) => JsPromise.t<_burnSynthTokensForRedemptionMockReturn> = "_burnSynthTokensForRedemptionMock"

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
  bool,
) => JsPromise.t<_executeNextPriceMintsIfTheyExistMockReturn> =
  "_executeNextPriceMintsIfTheyExistMock"

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

type _getSyntheticTokenPriceMockReturn = Ethers.BigNumber.t
@send
external _getSyntheticTokenPriceMock: (
  t,
  int,
  bool,
) => JsPromise.t<_getSyntheticTokenPriceMockReturn> = "_getSyntheticTokenPriceMock"

type _handleBatchedDepositSettlementMockReturn
@send
external _handleBatchedDepositSettlementMock: (
  t,
  int,
  bool,
  Ethers.BigNumber.t,
) => JsPromise.t<_handleBatchedDepositSettlementMockReturn> = "_handleBatchedDepositSettlementMock"

type _handleBatchedRedeemSettlementMockReturn
@send
external _handleBatchedRedeemSettlementMock: (
  t,
  int,
  Ethers.BigNumber.t,
  Ethers.BigNumber.t,
) => JsPromise.t<_handleBatchedRedeemSettlementMockReturn> = "_handleBatchedRedeemSettlementMock"

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

type _performOustandingSettlementsMockReturn
@send
external _performOustandingSettlementsMock: (
  t,
  int,
  Ethers.BigNumber.t,
  Ethers.BigNumber.t,
  Ethers.BigNumber.t,
) => JsPromise.t<_performOustandingSettlementsMockReturn> = "_performOustandingSettlementsMock"

type _redeemNextPriceMockReturn
@send
external _redeemNextPriceMock: (
  t,
  int,
  Ethers.BigNumber.t,
  bool,
) => JsPromise.t<_redeemNextPriceMockReturn> = "_redeemNextPriceMock"

type _saveSyntheticTokenPriceSnapshotsMockReturn
@send
external _saveSyntheticTokenPriceSnapshotsMock: (
  t,
  int,
  Ethers.BigNumber.t,
  Ethers.BigNumber.t,
  Ethers.BigNumber.t,
) => JsPromise.t<_saveSyntheticTokenPriceSnapshotsMockReturn> =
  "_saveSyntheticTokenPriceSnapshotsMock"

type _seedMarketInitiallyMockReturn
@send
external _seedMarketInitiallyMock: (
  t,
  Ethers.BigNumber.t,
  int,
) => JsPromise.t<_seedMarketInitiallyMockReturn> = "_seedMarketInitiallyMock"

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

type getLongPcntForLongVsShortSplitMockReturn = Ethers.BigNumber.t
@send
external getLongPcntForLongVsShortSplitMock: (
  t,
  int,
) => JsPromise.t<getLongPcntForLongVsShortSplitMockReturn> = "getLongPcntForLongVsShortSplitMock"

type getMarketPcntForTreasuryVsMarketSplitMockReturn = Ethers.BigNumber.t
@send
external getMarketPcntForTreasuryVsMarketSplitMock: (
  t,
  int,
) => JsPromise.t<getMarketPcntForTreasuryVsMarketSplitMockReturn> =
  "getMarketPcntForTreasuryVsMarketSplitMock"

type getMarketSplitMockReturn = {
  longAmount: Ethers.BigNumber.t,
  shortAmount: Ethers.BigNumber.t,
}
@send
external getMarketSplitMock: (t, int, Ethers.BigNumber.t) => JsPromise.t<getMarketSplitMockReturn> =
  "getMarketSplitMock"

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
  bool,
) => JsPromise.t<getUsersPendingBalanceMockReturn> = "getUsersPendingBalanceMock"

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

type updateSystemStateMarketMockReturn
@send
external updateSystemStateMarketMock: (t, int) => JsPromise.t<updateSystemStateMarketMockReturn> =
  "updateSystemStateMarketMock"
