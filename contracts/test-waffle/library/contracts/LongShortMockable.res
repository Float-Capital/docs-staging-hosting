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

type tEN_TO_THE_18Return = Ethers.BigNumber.t
@send
external tEN_TO_THE_18: t => JsPromise.t<tEN_TO_THE_18Return> = "TEN_TO_THE_18"

type tEN_TO_THE_18_SIGNEDReturn = Ethers.BigNumber.t
@send
external tEN_TO_THE_18_SIGNED: t => JsPromise.t<tEN_TO_THE_18_SIGNEDReturn> = "TEN_TO_THE_18_SIGNED"

@send
external _updateSystemState: (t, ~marketIndex: int) => JsPromise.t<transaction> =
  "_updateSystemState"

@send
external _updateSystemStateMulti: (t, ~marketIndexes: array<int>) => JsPromise.t<transaction> =
  "_updateSystemStateMulti"

type adminReturn = Ethers.ethAddress
@send
external admin: t => JsPromise.t<adminReturn> = "admin"

type assetPriceReturn = Ethers.BigNumber.t
@send
external assetPrice: (t, int) => JsPromise.t<assetPriceReturn> = "assetPrice"

type badLiquidityEntryFeeReturn = Ethers.BigNumber.t
@send
external badLiquidityEntryFee: (t, int) => JsPromise.t<badLiquidityEntryFeeReturn> =
  "badLiquidityEntryFee"

type badLiquidityExitFeeReturn = Ethers.BigNumber.t
@send
external badLiquidityExitFee: (t, int) => JsPromise.t<badLiquidityExitFeeReturn> =
  "badLiquidityExitFee"

type baseEntryFeeReturn = Ethers.BigNumber.t
@send
external baseEntryFee: (t, int) => JsPromise.t<baseEntryFeeReturn> = "baseEntryFee"

type baseExitFeeReturn = Ethers.BigNumber.t
@send
external baseExitFee: (t, int) => JsPromise.t<baseExitFeeReturn> = "baseExitFee"

type batchedNextPriceDepositAmountReturn = Ethers.BigNumber.t
@send
external batchedNextPriceDepositAmount: (
  t,
  int,
  bool,
) => JsPromise.t<batchedNextPriceDepositAmountReturn> = "batchedNextPriceDepositAmount"

type batchedNextPriceSynthRedeemAmountReturn = Ethers.BigNumber.t
@send
external batchedNextPriceSynthRedeemAmount: (
  t,
  int,
  bool,
) => JsPromise.t<batchedNextPriceSynthRedeemAmountReturn> = "batchedNextPriceSynthRedeemAmount"

@send
external changeAdmin: (t, ~admin: Ethers.ethAddress) => JsPromise.t<transaction> = "changeAdmin"

@send
external changeFees: (
  t,
  ~marketIndex: int,
  ~baseEntryFee: Ethers.BigNumber.t,
  ~badLiquidityEntryFee: Ethers.BigNumber.t,
  ~baseExitFee: Ethers.BigNumber.t,
  ~badLiquidityExitFee: Ethers.BigNumber.t,
) => JsPromise.t<transaction> = "changeFees"

@send
external changeTreasury: (t, ~treasury: Ethers.ethAddress) => JsPromise.t<transaction> =
  "changeTreasury"

@send
external executeOutstandingNextPriceSettlementsUser: (
  t,
  ~user: Ethers.ethAddress,
  ~marketIndex: int,
) => JsPromise.t<transaction> = "executeOutstandingNextPriceSettlementsUser"

type feeUnitsOfPrecisionReturn = Ethers.BigNumber.t
@send
external feeUnitsOfPrecision: t => JsPromise.t<feeUnitsOfPrecisionReturn> = "feeUnitsOfPrecision"

type fundTokensReturn = Ethers.ethAddress
@send
external fundTokens: (t, int) => JsPromise.t<fundTokensReturn> = "fundTokens"

type getMarketSplitReturn = {
  longAmount: Ethers.BigNumber.t,
  shortAmount: Ethers.BigNumber.t,
}
@send
external getMarketSplit: (
  t,
  ~marketIndex: int,
  ~amount: Ethers.BigNumber.t,
) => JsPromise.t<getMarketSplitReturn> = "getMarketSplit"

type getTreasurySplitReturn = {
  marketAmount: Ethers.BigNumber.t,
  treasuryAmount: Ethers.BigNumber.t,
}
@send
external getTreasurySplit: (
  t,
  ~marketIndex: int,
  ~amount: Ethers.BigNumber.t,
) => JsPromise.t<getTreasurySplitReturn> = "getTreasurySplit"

type getUsersPendingBalanceReturn = Ethers.BigNumber.t
@send
external getUsersPendingBalance: (
  t,
  ~user: Ethers.ethAddress,
  ~marketIndex: int,
  ~isLong: bool,
) => JsPromise.t<getUsersPendingBalanceReturn> = "getUsersPendingBalance"

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
  ~baseEntryFee: Ethers.BigNumber.t,
  ~badLiquidityEntryFee: Ethers.BigNumber.t,
  ~baseExitFee: Ethers.BigNumber.t,
  ~badLiquidityExitFee: Ethers.BigNumber.t,
  ~kInitialMultiplier: Ethers.BigNumber.t,
  ~kPeriod: Ethers.BigNumber.t,
  ~initialMarketSeed: Ethers.BigNumber.t,
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

type mintPriceSnapshotReturn = Ethers.BigNumber.t
@send
external mintPriceSnapshot: (
  t,
  int,
  bool,
  Ethers.BigNumber.t,
) => JsPromise.t<mintPriceSnapshotReturn> = "mintPriceSnapshot"

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
  ~fundToken: Ethers.ethAddress,
  ~oracleManager: Ethers.ethAddress,
  ~yieldManager: Ethers.ethAddress,
) => JsPromise.t<transaction> = "newSyntheticMarket"

type oracleManagersReturn = Ethers.ethAddress
@send
external oracleManagers: (t, int) => JsPromise.t<oracleManagersReturn> = "oracleManagers"

@send
external redeemLongNextPrice: (
  t,
  ~marketIndex: int,
  ~tokensToRedeem: Ethers.BigNumber.t,
) => JsPromise.t<transaction> = "redeemLongNextPrice"

type redeemPriceSnapshotReturn = Ethers.BigNumber.t
@send
external redeemPriceSnapshot: (
  t,
  int,
  bool,
  Ethers.BigNumber.t,
) => JsPromise.t<redeemPriceSnapshotReturn> = "redeemPriceSnapshot"

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

type stakerReturn = Ethers.ethAddress
@send
external staker: t => JsPromise.t<stakerReturn> = "staker"

type syntheticTokenPoolValueReturn = Ethers.BigNumber.t
@send
external syntheticTokenPoolValue: (t, int, bool) => JsPromise.t<syntheticTokenPoolValueReturn> =
  "syntheticTokenPoolValue"

type syntheticTokenPriceReturn = Ethers.BigNumber.t
@send
external syntheticTokenPrice: (t, int, bool) => JsPromise.t<syntheticTokenPriceReturn> =
  "syntheticTokenPrice"

type syntheticTokensReturn = Ethers.ethAddress
@send
external syntheticTokens: (t, int, bool) => JsPromise.t<syntheticTokensReturn> = "syntheticTokens"

type tokenFactoryReturn = Ethers.ethAddress
@send
external tokenFactory: t => JsPromise.t<tokenFactoryReturn> = "tokenFactory"

type totalValueLockedInYieldManagerReturn = Ethers.BigNumber.t
@send
external totalValueLockedInYieldManager: (
  t,
  int,
) => JsPromise.t<totalValueLockedInYieldManagerReturn> = "totalValueLockedInYieldManager"

type totalValueReservedForTreasuryReturn = Ethers.BigNumber.t
@send
external totalValueReservedForTreasury: (
  t,
  int,
) => JsPromise.t<totalValueReservedForTreasuryReturn> = "totalValueReservedForTreasury"

@send
external transferTreasuryFunds: (t, ~marketIndex: int) => JsPromise.t<transaction> =
  "transferTreasuryFunds"

type treasuryReturn = Ethers.ethAddress
@send
external treasury: t => JsPromise.t<treasuryReturn> = "treasury"

@send
external updateMarketOracle: (
  t,
  ~marketIndex: int,
  ~newOracleManager: Ethers.ethAddress,
) => JsPromise.t<transaction> = "updateMarketOracle"

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

type yieldManagersReturn = Ethers.ethAddress
@send
external yieldManagers: (t, int) => JsPromise.t<yieldManagersReturn> = "yieldManagers"
