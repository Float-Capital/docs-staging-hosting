@@ocaml.warning("-32")
open ContractHelpers
type t = {address: Ethers.ethAddress}
let contractName = "LongShort"

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

type batchedLazyPaymentTokenToDepositReturn = Ethers.BigNumber.t
@send
external batchedLazyPaymentTokenToDeposit: (
  t,
  int,
  int,
) => JsPromise.t<batchedLazyPaymentTokenToDepositReturn> = "batchedLazyPaymentTokenToDeposit"

type batchedLazySynthToRedeemReturn = Ethers.BigNumber.t
@send
external batchedLazySynthToRedeem: (t, int, int) => JsPromise.t<batchedLazySynthToRedeemReturn> =
  "batchedLazySynthToRedeem"

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
external executeOutstandingLazySettlementsUser: (
  t,
  ~user: Ethers.ethAddress,
  ~marketIndex: int,
) => JsPromise.t<transaction> = "executeOutstandingLazySettlementsUser"

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
  ~syntheticTokenType: int,
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

type latestUpdateIndexReturn = Ethers.BigNumber.t
@send
external latestUpdateIndex: (t, int) => JsPromise.t<latestUpdateIndexReturn> = "latestUpdateIndex"

type marketExistsReturn = bool
@send
external marketExists: (t, int) => JsPromise.t<marketExistsReturn> = "marketExists"

@send
external mintLongLazy: (
  t,
  ~marketIndex: int,
  ~amount: Ethers.BigNumber.t,
) => JsPromise.t<transaction> = "mintLongLazy"

type mintPriceSnapshotReturn = Ethers.BigNumber.t
@send
external mintPriceSnapshot: (
  t,
  int,
  Ethers.BigNumber.t,
  int,
) => JsPromise.t<mintPriceSnapshotReturn> = "mintPriceSnapshot"

@send
external mintShortLazy: (
  t,
  ~marketIndex: int,
  ~amount: Ethers.BigNumber.t,
) => JsPromise.t<transaction> = "mintShortLazy"

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
external redeemLongLazy: (
  t,
  ~marketIndex: int,
  ~tokensToRedeem: Ethers.BigNumber.t,
) => JsPromise.t<transaction> = "redeemLongLazy"

type redeemPriceSnapshotReturn = Ethers.BigNumber.t
@send
external redeemPriceSnapshot: (
  t,
  int,
  Ethers.BigNumber.t,
  int,
) => JsPromise.t<redeemPriceSnapshotReturn> = "redeemPriceSnapshot"

@send
external redeemShortLazy: (
  t,
  ~marketIndex: int,
  ~tokensToRedeem: Ethers.BigNumber.t,
) => JsPromise.t<transaction> = "redeemShortLazy"

type stakerReturn = Ethers.ethAddress
@send
external staker: t => JsPromise.t<stakerReturn> = "staker"

type syntheticTokenBackedValueReturn = Ethers.BigNumber.t
@send
external syntheticTokenBackedValue: (t, int, int) => JsPromise.t<syntheticTokenBackedValueReturn> =
  "syntheticTokenBackedValue"

type syntheticTokenPriceReturn = Ethers.BigNumber.t
@send
external syntheticTokenPrice: (t, int, int) => JsPromise.t<syntheticTokenPriceReturn> =
  "syntheticTokenPrice"

type syntheticTokensReturn = Ethers.ethAddress
@send
external syntheticTokens: (t, int, int) => JsPromise.t<syntheticTokensReturn> = "syntheticTokens"

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

type userCurrentLazyUpdateIndexReturn = Ethers.BigNumber.t
@send
external userCurrentLazyUpdateIndex: (
  t,
  int,
  Ethers.ethAddress,
) => JsPromise.t<userCurrentLazyUpdateIndexReturn> = "userCurrentLazyUpdateIndex"

type userLazyDepositAmountsReturn = Ethers.BigNumber.t
@send
external userLazyDepositAmounts: (
  t,
  int,
  Ethers.ethAddress,
  int,
) => JsPromise.t<userLazyDepositAmountsReturn> = "userLazyDepositAmounts"

type userLazyRedemptionsReturn = Ethers.BigNumber.t
@send
external userLazyRedemptions: (
  t,
  int,
  Ethers.ethAddress,
  int,
) => JsPromise.t<userLazyRedemptionsReturn> = "userLazyRedemptions"

type yieldManagersReturn = Ethers.ethAddress
@send
external yieldManagers: (t, int) => JsPromise.t<yieldManagersReturn> = "yieldManagers"

module Exposed = {
  let contractName = "LongShortInternalsExposed"

  let make: unit => JsPromise.t<t> = () => deployContract0(contractName)->Obj.magic

  type dEAD_ADDRESSReturn = Ethers.ethAddress
  @send
  external dEAD_ADDRESS: t => JsPromise.t<dEAD_ADDRESSReturn> = "DEAD_ADDRESS"

  type tEN_TO_THE_18Return = Ethers.BigNumber.t
  @send
  external tEN_TO_THE_18: t => JsPromise.t<tEN_TO_THE_18Return> = "TEN_TO_THE_18"

  type tEN_TO_THE_18_SIGNEDReturn = Ethers.BigNumber.t
  @send
  external tEN_TO_THE_18_SIGNED: t => JsPromise.t<tEN_TO_THE_18_SIGNEDReturn> =
    "TEN_TO_THE_18_SIGNED"

  @send
  external _executeOutstandingLazySettlementsExposed: (
    t,
    ~user: Ethers.ethAddress,
    ~marketIndex: int,
  ) => JsPromise.t<transaction> = "_executeOutstandingLazySettlementsExposed"

  @send
  external _updateSystemState: (t, ~marketIndex: int) => JsPromise.t<transaction> =
    "_updateSystemState"

  @send
  external _updateSystemStateMulti: (t, ~marketIndexes: array<int>) => JsPromise.t<transaction> =
    "_updateSystemStateMulti"

  @send
  external adjustMarketBasedOnNewAssetPrice: (
    t,
    ~marketIndex: int,
    ~newAssetPrice: Ethers.BigNumber.t,
  ) => JsPromise.t<transaction> = "adjustMarketBasedOnNewAssetPrice"

  type adjustMarketBasedOnNewAssetPriceReturn = bool
  @send @scope("callStatic")
  external adjustMarketBasedOnNewAssetPriceCall: (
    t,
    ~marketIndex: int,
    ~newAssetPrice: Ethers.BigNumber.t,
  ) => JsPromise.t<adjustMarketBasedOnNewAssetPriceReturn> = "adjustMarketBasedOnNewAssetPrice"

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

  type batchedLazyPaymentTokenToDepositReturn = Ethers.BigNumber.t
  @send
  external batchedLazyPaymentTokenToDeposit: (
    t,
    int,
    int,
  ) => JsPromise.t<batchedLazyPaymentTokenToDepositReturn> = "batchedLazyPaymentTokenToDeposit"

  type batchedLazySynthToRedeemReturn = Ethers.BigNumber.t
  @send
  external batchedLazySynthToRedeem: (t, int, int) => JsPromise.t<batchedLazySynthToRedeemReturn> =
    "batchedLazySynthToRedeem"

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
  external claimAndDistributeYield: (t, ~marketIndex: int) => JsPromise.t<transaction> =
    "claimAndDistributeYield"

  @send
  external depositFunds: (
    t,
    ~marketIndex: int,
    ~amount: Ethers.BigNumber.t,
  ) => JsPromise.t<transaction> = "depositFunds"

  @send
  external executeOutstandingLazySettlementsUser: (
    t,
    ~user: Ethers.ethAddress,
    ~marketIndex: int,
  ) => JsPromise.t<transaction> = "executeOutstandingLazySettlementsUser"

  type feeUnitsOfPrecisionReturn = Ethers.BigNumber.t
  @send
  external feeUnitsOfPrecision: t => JsPromise.t<feeUnitsOfPrecisionReturn> = "feeUnitsOfPrecision"

  @send
  external feesMechanism: (
    t,
    ~marketIndex: int,
    ~totalFees: Ethers.BigNumber.t,
  ) => JsPromise.t<transaction> = "feesMechanism"

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
    ~syntheticTokenType: int,
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

  type latestUpdateIndexReturn = Ethers.BigNumber.t
  @send
  external latestUpdateIndex: (t, int) => JsPromise.t<latestUpdateIndexReturn> = "latestUpdateIndex"

  type marketExistsReturn = bool
  @send
  external marketExists: (t, int) => JsPromise.t<marketExistsReturn> = "marketExists"

  type minimumReturn = Ethers.BigNumber.t
  @send
  external minimum: (
    t,
    ~liquidityOfPositionA: Ethers.BigNumber.t,
    ~liquidityOfPositionB: Ethers.BigNumber.t,
  ) => JsPromise.t<minimumReturn> = "minimum"

  @send
  external mintLongLazy: (
    t,
    ~marketIndex: int,
    ~amount: Ethers.BigNumber.t,
  ) => JsPromise.t<transaction> = "mintLongLazy"

  type mintPriceSnapshotReturn = Ethers.BigNumber.t
  @send
  external mintPriceSnapshot: (
    t,
    int,
    Ethers.BigNumber.t,
    int,
  ) => JsPromise.t<mintPriceSnapshotReturn> = "mintPriceSnapshot"

  @send
  external mintShortLazy: (
    t,
    ~marketIndex: int,
    ~amount: Ethers.BigNumber.t,
  ) => JsPromise.t<transaction> = "mintShortLazy"

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
  external redeemLongLazy: (
    t,
    ~marketIndex: int,
    ~tokensToRedeem: Ethers.BigNumber.t,
  ) => JsPromise.t<transaction> = "redeemLongLazy"

  type redeemPriceSnapshotReturn = Ethers.BigNumber.t
  @send
  external redeemPriceSnapshot: (
    t,
    int,
    Ethers.BigNumber.t,
    int,
  ) => JsPromise.t<redeemPriceSnapshotReturn> = "redeemPriceSnapshot"

  @send
  external redeemShortLazy: (
    t,
    ~marketIndex: int,
    ~tokensToRedeem: Ethers.BigNumber.t,
  ) => JsPromise.t<transaction> = "redeemShortLazy"

  @send
  external refreshTokenPrices: (t, ~marketIndex: int) => JsPromise.t<transaction> =
    "refreshTokenPrices"

  @send
  external setUseexecuteOutstandingLazySettlementsMock: (
    t,
    ~shouldUseMock: bool,
  ) => JsPromise.t<transaction> = "setUseexecuteOutstandingLazySettlementsMock"

  type stakerReturn = Ethers.ethAddress
  @send
  external staker: t => JsPromise.t<stakerReturn> = "staker"

  type syntheticTokenBackedValueReturn = Ethers.BigNumber.t
  @send
  external syntheticTokenBackedValue: (
    t,
    int,
    int,
  ) => JsPromise.t<syntheticTokenBackedValueReturn> = "syntheticTokenBackedValue"

  type syntheticTokenPriceReturn = Ethers.BigNumber.t
  @send
  external syntheticTokenPrice: (t, int, int) => JsPromise.t<syntheticTokenPriceReturn> =
    "syntheticTokenPrice"

  type syntheticTokensReturn = Ethers.ethAddress
  @send
  external syntheticTokens: (t, int, int) => JsPromise.t<syntheticTokensReturn> = "syntheticTokens"

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
  external transferFromYieldManager: (
    t,
    ~marketIndex: int,
    ~amount: Ethers.BigNumber.t,
  ) => JsPromise.t<transaction> = "transferFromYieldManager"

  @send
  external transferFundsToYieldManager: (
    t,
    ~marketIndex: int,
    ~amount: Ethers.BigNumber.t,
  ) => JsPromise.t<transaction> = "transferFundsToYieldManager"

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

  type userCurrentLazyUpdateIndexReturn = Ethers.BigNumber.t
  @send
  external userCurrentLazyUpdateIndex: (
    t,
    int,
    Ethers.ethAddress,
  ) => JsPromise.t<userCurrentLazyUpdateIndexReturn> = "userCurrentLazyUpdateIndex"

  type userLazyDepositAmountsReturn = Ethers.BigNumber.t
  @send
  external userLazyDepositAmounts: (
    t,
    int,
    Ethers.ethAddress,
    int,
  ) => JsPromise.t<userLazyDepositAmountsReturn> = "userLazyDepositAmounts"

  type userLazyRedemptionsReturn = Ethers.BigNumber.t
  @send
  external userLazyRedemptions: (
    t,
    int,
    Ethers.ethAddress,
    int,
  ) => JsPromise.t<userLazyRedemptionsReturn> = "userLazyRedemptions"

  @send
  external withdrawFunds: (
    t,
    ~marketIndex: int,
    ~amountLong: Ethers.BigNumber.t,
    ~amountShort: Ethers.BigNumber.t,
    ~user: Ethers.ethAddress,
  ) => JsPromise.t<transaction> = "withdrawFunds"

  type yieldManagersReturn = Ethers.ethAddress
  @send
  external yieldManagers: (t, int) => JsPromise.t<yieldManagersReturn> = "yieldManagers"
}
