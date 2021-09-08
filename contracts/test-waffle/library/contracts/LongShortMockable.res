@@ocaml.warning("-32")
open ContractHelpers
type t = {address: Ethers.ethAddress}
let contractName = "LongShortMockable"

let at: Ethers.ethAddress => JsPromise.t<t> = contractAddress =>
  attachToContract(contractName, ~contractAddress)->Obj.magic

let make: unit => JsPromise.t<t> = () => deployContract0(contractName)->Obj.magic

type dEAD_ADDRESSReturn = Ethers.ethAddress
@send
external dEAD_ADDRESS: t => JsPromise.t<dEAD_ADDRESSReturn> = "DEAD_ADDRESS"

@send
external _claimAndDistributeYieldThenRebalanceMarketExposed: (
  t,
  ~marketIndex: int,
  ~newAssetPrice: Ethers.BigNumber.t,
  ~oldAssetPrice: Ethers.BigNumber.t,
) => JsPromise.t<transaction> = "_claimAndDistributeYieldThenRebalanceMarketExposed"

type _claimAndDistributeYieldThenRebalanceMarketExposedReturn = {
  longValue: Ethers.BigNumber.t,
  shortValue: Ethers.BigNumber.t,
}
@send @scope("callStatic")
external _claimAndDistributeYieldThenRebalanceMarketExposedCall: (
  t,
  ~marketIndex: int,
  ~newAssetPrice: Ethers.BigNumber.t,
  ~oldAssetPrice: Ethers.BigNumber.t,
) => JsPromise.t<_claimAndDistributeYieldThenRebalanceMarketExposedReturn> =
  "_claimAndDistributeYieldThenRebalanceMarketExposed"

@send
external _depositFundsExposed: (
  t,
  ~marketIndex: int,
  ~amount: Ethers.BigNumber.t,
) => JsPromise.t<transaction> = "_depositFundsExposed"

@send
external _executeOutstandingNextPriceMintsExposed: (
  t,
  ~marketIndex: int,
  ~user: Ethers.ethAddress,
  ~isLong: bool,
) => JsPromise.t<transaction> = "_executeOutstandingNextPriceMintsExposed"

@send
external _executeOutstandingNextPriceRedeemsExposed: (
  t,
  ~marketIndex: int,
  ~user: Ethers.ethAddress,
  ~isLong: bool,
) => JsPromise.t<transaction> = "_executeOutstandingNextPriceRedeemsExposed"

@send
external _executeOutstandingNextPriceSettlementsExposed: (
  t,
  ~user: Ethers.ethAddress,
  ~marketIndex: int,
) => JsPromise.t<transaction> = "_executeOutstandingNextPriceSettlementsExposed"

@send
external _executeOutstandingNextPriceTokenShiftsExposed: (
  t,
  ~marketIndex: int,
  ~user: Ethers.ethAddress,
  ~isShiftFromLong: bool,
) => JsPromise.t<transaction> = "_executeOutstandingNextPriceTokenShiftsExposed"

type _getAmountPaymentTokenExposedReturn = Ethers.BigNumber.t
@send
external _getAmountPaymentTokenExposed: (
  t,
  ~amountSynthToken: Ethers.BigNumber.t,
  ~price: Ethers.BigNumber.t,
) => JsPromise.t<_getAmountPaymentTokenExposedReturn> = "_getAmountPaymentTokenExposed"

type _getAmountSynthTokenExposedReturn = Ethers.BigNumber.t
@send
external _getAmountSynthTokenExposed: (
  t,
  ~amountPaymentToken: Ethers.BigNumber.t,
  ~price: Ethers.BigNumber.t,
) => JsPromise.t<_getAmountSynthTokenExposedReturn> = "_getAmountSynthTokenExposed"

type _getMinExposedReturn = Ethers.BigNumber.t
@send
external _getMinExposed: (
  t,
  ~a: Ethers.BigNumber.t,
  ~b: Ethers.BigNumber.t,
) => JsPromise.t<_getMinExposedReturn> = "_getMinExposed"

type _getSyntheticTokenPriceExposedReturn = Ethers.BigNumber.t
@send
external _getSyntheticTokenPriceExposed: (
  t,
  ~amountPaymentToken: Ethers.BigNumber.t,
  ~amountSynthToken: Ethers.BigNumber.t,
) => JsPromise.t<_getSyntheticTokenPriceExposedReturn> = "_getSyntheticTokenPriceExposed"

type _getYieldSplitExposedReturn = {
  isLongSideUnderbalanced: bool,
  treasuryPercentE18: Ethers.BigNumber.t,
}
@send
external _getYieldSplitExposed: (
  t,
  ~longValue: Ethers.BigNumber.t,
  ~shortValue: Ethers.BigNumber.t,
  ~totalValueLockedInMarket: Ethers.BigNumber.t,
) => JsPromise.t<_getYieldSplitExposedReturn> = "_getYieldSplitExposed"

@send
external _handleChangeInSynthTokensTotalSupplyExposed: (
  t,
  ~marketIndex: int,
  ~isLong: bool,
  ~changeInSynthTokensTotalSupply: Ethers.BigNumber.t,
) => JsPromise.t<transaction> = "_handleChangeInSynthTokensTotalSupplyExposed"

@send
external _handleTotalValueChangeForMarketWithYieldManagerExposed: (
  t,
  ~marketIndex: int,
  ~totalValueChangeForMarket: Ethers.BigNumber.t,
) => JsPromise.t<transaction> = "_handleTotalValueChangeForMarketWithYieldManagerExposed"

@send
external _lockFundsInMarketExposed: (
  t,
  ~marketIndex: int,
  ~amount: Ethers.BigNumber.t,
) => JsPromise.t<transaction> = "_lockFundsInMarketExposed"

@send
external _mintNextPriceExposed: (
  t,
  ~marketIndex: int,
  ~amount: Ethers.BigNumber.t,
  ~isLong: bool,
) => JsPromise.t<transaction> = "_mintNextPriceExposed"

@send
external _performOustandingBatchedSettlementsExposed: (
  t,
  ~marketIndex: int,
  ~syntheticTokenPriceLong: Ethers.BigNumber.t,
  ~syntheticTokenPriceShort: Ethers.BigNumber.t,
) => JsPromise.t<transaction> = "_performOustandingBatchedSettlementsExposed"

type _performOustandingBatchedSettlementsExposedReturn = {
  valueChangeForLong: Ethers.BigNumber.t,
  valueChangeForShort: Ethers.BigNumber.t,
}
@send @scope("callStatic")
external _performOustandingBatchedSettlementsExposedCall: (
  t,
  ~marketIndex: int,
  ~syntheticTokenPriceLong: Ethers.BigNumber.t,
  ~syntheticTokenPriceShort: Ethers.BigNumber.t,
) => JsPromise.t<_performOustandingBatchedSettlementsExposedReturn> =
  "_performOustandingBatchedSettlementsExposed"

@send
external _redeemNextPriceExposed: (
  t,
  ~marketIndex: int,
  ~tokensToRedeem: Ethers.BigNumber.t,
  ~isLong: bool,
) => JsPromise.t<transaction> = "_redeemNextPriceExposed"

@send
external _seedMarketInitiallyExposed: (
  t,
  ~initialMarketSeed: Ethers.BigNumber.t,
  ~marketIndex: int,
) => JsPromise.t<transaction> = "_seedMarketInitiallyExposed"

@send
external _shiftPositionNextPriceExposed: (
  t,
  ~marketIndex: int,
  ~synthTokensToShift: Ethers.BigNumber.t,
  ~isShiftFromLong: bool,
) => JsPromise.t<transaction> = "_shiftPositionNextPriceExposed"

@send
external _updateSystemStateInternalExposed: (t, ~marketIndex: int) => JsPromise.t<transaction> =
  "_updateSystemStateInternalExposed"

type adminReturn = Ethers.ethAddress
@send
external admin: t => JsPromise.t<adminReturn> = "admin"

type assetPriceReturn = Ethers.BigNumber.t
@send
external assetPrice: (t, int) => JsPromise.t<assetPriceReturn> = "assetPrice"

type batchedAmountOfPaymentTokenToDepositReturn = Ethers.BigNumber.t
@send
external batchedAmountOfPaymentTokenToDeposit: (
  t,
  int,
  bool,
) => JsPromise.t<batchedAmountOfPaymentTokenToDepositReturn> =
  "batchedAmountOfPaymentTokenToDeposit"

type batchedAmountOfSynthTokensToRedeemReturn = Ethers.BigNumber.t
@send
external batchedAmountOfSynthTokensToRedeem: (
  t,
  int,
  bool,
) => JsPromise.t<batchedAmountOfSynthTokensToRedeemReturn> = "batchedAmountOfSynthTokensToRedeem"

type batchedAmountOfSynthTokensToShiftMarketSideReturn = Ethers.BigNumber.t
@send
external batchedAmountOfSynthTokensToShiftMarketSide: (
  t,
  int,
  bool,
) => JsPromise.t<batchedAmountOfSynthTokensToShiftMarketSideReturn> =
  "batchedAmountOfSynthTokensToShiftMarketSide"

@send
external changeAdmin: (t, ~admin: Ethers.ethAddress) => JsPromise.t<transaction> = "changeAdmin"

@send
external changeTreasury: (t, ~treasury: Ethers.ethAddress) => JsPromise.t<transaction> =
  "changeTreasury"

@send
external executeOutstandingNextPriceSettlementsUser: (
  t,
  ~user: Ethers.ethAddress,
  ~marketIndex: int,
) => JsPromise.t<transaction> = "executeOutstandingNextPriceSettlementsUser"

@send
external executeOutstandingNextPriceSettlementsUserMulti: (
  t,
  ~user: Ethers.ethAddress,
  ~marketIndexes: array<int>,
) => JsPromise.t<transaction> = "executeOutstandingNextPriceSettlementsUserMulti"

type getAmountSynthTokenShiftedReturn = Ethers.BigNumber.t
@send
external getAmountSynthTokenShifted: (
  t,
  ~marketIndex: int,
  ~amountSynthTokenShifted: Ethers.BigNumber.t,
  ~isShiftFromLong: bool,
  ~priceSnapshotIndex: Ethers.BigNumber.t,
) => JsPromise.t<getAmountSynthTokenShiftedReturn> = "getAmountSynthTokenShifted"

type getUsersConfirmedButNotSettledSynthBalanceReturn = Ethers.BigNumber.t
@send
external getUsersConfirmedButNotSettledSynthBalance: (
  t,
  ~user: Ethers.ethAddress,
  ~marketIndex: int,
  ~isLong: bool,
) => JsPromise.t<getUsersConfirmedButNotSettledSynthBalanceReturn> =
  "getUsersConfirmedButNotSettledSynthBalance"

@send
external initialize: (
  t,
  ~admin: Ethers.ethAddress,
  ~treasury: Ethers.ethAddress,
  ~tokenFactory: Ethers.ethAddress,
  ~staker: Ethers.ethAddress,
) => JsPromise.t<transaction> = "initialize"

@send
external initializeMarket: (
  t,
  ~marketIndex: int,
  ~kInitialMultiplier: Ethers.BigNumber.t,
  ~kPeriod: Ethers.BigNumber.t,
  ~unstakeFeeBasisPoints: Ethers.BigNumber.t,
  ~initialMarketSeed: Ethers.BigNumber.t,
  ~balanceIncentiveCurveExponent: Ethers.BigNumber.t,
  ~balanceIncentiveCurveEquilibriumOffset: Ethers.BigNumber.t,
) => JsPromise.t<transaction> = "initializeMarket"

type latestMarketReturn = int
@send
external latestMarket: t => JsPromise.t<latestMarketReturn> = "latestMarket"

type marketExistsReturn = bool
@send
external marketExists: (t, int) => JsPromise.t<marketExistsReturn> = "marketExists"

type marketUpdateIndexReturn = Ethers.BigNumber.t
@send
external marketUpdateIndex: (t, int) => JsPromise.t<marketUpdateIndexReturn> = "marketUpdateIndex"

@send
external mintLongNextPrice: (
  t,
  ~marketIndex: int,
  ~amount: Ethers.BigNumber.t,
) => JsPromise.t<transaction> = "mintLongNextPrice"

@send
external mintShortNextPrice: (
  t,
  ~marketIndex: int,
  ~amount: Ethers.BigNumber.t,
) => JsPromise.t<transaction> = "mintShortNextPrice"

@send
external newSyntheticMarket: (
  t,
  ~syntheticName: string,
  ~syntheticSymbol: string,
  ~paymentToken: Ethers.ethAddress,
  ~oracleManager: Ethers.ethAddress,
  ~yieldManager: Ethers.ethAddress,
) => JsPromise.t<transaction> = "newSyntheticMarket"

type oracleManagersReturn = Ethers.ethAddress
@send
external oracleManagers: (t, int) => JsPromise.t<oracleManagersReturn> = "oracleManagers"

type paymentTokensReturn = Ethers.ethAddress
@send
external paymentTokens: (t, int) => JsPromise.t<paymentTokensReturn> = "paymentTokens"

@send
external redeemLongNextPrice: (
  t,
  ~marketIndex: int,
  ~tokensToRedeem: Ethers.BigNumber.t,
) => JsPromise.t<transaction> = "redeemLongNextPrice"

@send
external redeemShortNextPrice: (
  t,
  ~marketIndex: int,
  ~tokensToRedeem: Ethers.BigNumber.t,
) => JsPromise.t<transaction> = "redeemShortNextPrice"

@send
external setFunctionToNotMock: (t, ~functionToNotMock: string) => JsPromise.t<transaction> =
  "setFunctionToNotMock"

@send
external setMocker: (t, ~mocker: Ethers.ethAddress) => JsPromise.t<transaction> = "setMocker"

@send
external shiftPositionFromLongNextPrice: (
  t,
  ~marketIndex: int,
  ~synthTokensToShift: Ethers.BigNumber.t,
) => JsPromise.t<transaction> = "shiftPositionFromLongNextPrice"

@send
external shiftPositionFromShortNextPrice: (
  t,
  ~marketIndex: int,
  ~synthTokensToShift: Ethers.BigNumber.t,
) => JsPromise.t<transaction> = "shiftPositionFromShortNextPrice"

type stakerReturn = Ethers.ethAddress
@send
external staker: t => JsPromise.t<stakerReturn> = "staker"

type syntheticTokenPoolValueReturn = Ethers.BigNumber.t
@send
external syntheticTokenPoolValue: (t, int, bool) => JsPromise.t<syntheticTokenPoolValueReturn> =
  "syntheticTokenPoolValue"

type syntheticTokenPriceSnapshotReturn = Ethers.BigNumber.t
@send
external syntheticTokenPriceSnapshot: (
  t,
  int,
  bool,
  Ethers.BigNumber.t,
) => JsPromise.t<syntheticTokenPriceSnapshotReturn> = "syntheticTokenPriceSnapshot"

type syntheticTokensReturn = Ethers.ethAddress
@send
external syntheticTokens: (t, int, bool) => JsPromise.t<syntheticTokensReturn> = "syntheticTokens"

type tokenFactoryReturn = Ethers.ethAddress
@send
external tokenFactory: t => JsPromise.t<tokenFactoryReturn> = "tokenFactory"

type treasuryReturn = Ethers.ethAddress
@send
external treasury: t => JsPromise.t<treasuryReturn> = "treasury"

@send
external updateMarketOracle: (
  t,
  ~marketIndex: int,
  ~newOracleManager: Ethers.ethAddress,
) => JsPromise.t<transaction> = "updateMarketOracle"

@send
external updateSystemState: (t, ~marketIndex: int) => JsPromise.t<transaction> = "updateSystemState"

@send
external updateSystemStateMulti: (t, ~marketIndexes: array<int>) => JsPromise.t<transaction> =
  "updateSystemStateMulti"

type userCurrentNextPriceUpdateIndexReturn = Ethers.BigNumber.t
@send
external userCurrentNextPriceUpdateIndex: (
  t,
  int,
  Ethers.ethAddress,
) => JsPromise.t<userCurrentNextPriceUpdateIndexReturn> = "userCurrentNextPriceUpdateIndex"

type userNextPriceDepositAmountReturn = Ethers.BigNumber.t
@send
external userNextPriceDepositAmount: (
  t,
  int,
  bool,
  Ethers.ethAddress,
) => JsPromise.t<userNextPriceDepositAmountReturn> = "userNextPriceDepositAmount"

type userNextPriceRedemptionAmountReturn = Ethers.BigNumber.t
@send
external userNextPriceRedemptionAmount: (
  t,
  int,
  bool,
  Ethers.ethAddress,
) => JsPromise.t<userNextPriceRedemptionAmountReturn> = "userNextPriceRedemptionAmount"

type userNextPrice_amountSynthToShiftFromMarketSideReturn = Ethers.BigNumber.t
@send
external userNextPrice_amountSynthToShiftFromMarketSide: (
  t,
  int,
  bool,
  Ethers.ethAddress,
) => JsPromise.t<userNextPrice_amountSynthToShiftFromMarketSideReturn> =
  "userNextPrice_amountSynthToShiftFromMarketSide"

type yieldManagersReturn = Ethers.ethAddress
@send
external yieldManagers: (t, int) => JsPromise.t<yieldManagersReturn> = "yieldManagers"
