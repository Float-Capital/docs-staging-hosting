@@ocaml.warning("-32")
open ContractHelpers
type t = {address: Ethers.ethAddress}
let contractName = "LongShort"

let at: Ethers.ethAddress => JsPromise.t<t> = contractAddress =>
  attachToContract(contractName, ~contractAddress)->Obj.magic

let make: unit => JsPromise.t<t> = () => deployContract0(contractName)->Obj.magic

type tEN_TO_THE_18Return = Ethers.BigNumber.t
@send
external tEN_TO_THE_18: t => JsPromise.t<tEN_TO_THE_18Return> = "TEN_TO_THE_18"

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

type batchedLazyDepositReturn = {
  mintLong: Ethers.BigNumber.t,
  longEarlyClaimed: Ethers.BigNumber.t,
  mintShort: Ethers.BigNumber.t,
  shortEarlyClaimed: Ethers.BigNumber.t,
  mintAndStakeLong: Ethers.BigNumber.t,
  mintAndStakeShort: Ethers.BigNumber.t,
}
@send
external batchedLazyDeposit: (t, int) => JsPromise.t<batchedLazyDepositReturn> =
  "batchedLazyDeposit"

type batchedLazyRedeemsReturn = {
  redeemLong: Ethers.BigNumber.t,
  redeemShort: Ethers.BigNumber.t,
  totalWithdrawnShort: Ethers.BigNumber.t,
  totalWithdrawnLong: Ethers.BigNumber.t,
}
@send
external batchedLazyRedeems: (t, int, Ethers.BigNumber.t) => JsPromise.t<batchedLazyRedeemsReturn> =
  "batchedLazyRedeems"

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
external executeOutstandingLazySettlementsPartialOrCurrentIfNeeded: (
  t,
  ~user: Ethers.ethAddress,
  ~marketIndex: int,
  ~syntheticTokenType: int,
  ~minimumAmountRequired: Ethers.BigNumber.t,
) => JsPromise.t<transaction> = "executeOutstandingLazySettlementsPartialOrCurrentIfNeeded"

@send
external executeOutstandingLazySettlementsSynth: (
  t,
  ~user: Ethers.ethAddress,
  ~marketIndex: int,
  ~syntheticTokenType: int,
) => JsPromise.t<transaction> = "executeOutstandingLazySettlementsSynth"

type feeUnitsOfPrecisionReturn = Ethers.BigNumber.t
@send
external feeUnitsOfPrecision: t => JsPromise.t<feeUnitsOfPrecisionReturn> = "feeUnitsOfPrecision"

type fundTokensReturn = Ethers.ethAddress
@send
external fundTokens: (t, int) => JsPromise.t<fundTokensReturn> = "fundTokens"

type getLongBetaReturn = Ethers.BigNumber.t
@send
external getLongBeta: (t, ~marketIndex: int) => JsPromise.t<getLongBetaReturn> = "getLongBeta"

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

type getShortBetaReturn = Ethers.BigNumber.t
@send
external getShortBeta: (t, ~marketIndex: int) => JsPromise.t<getShortBetaReturn> = "getShortBeta"

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
external handleBatchedLazyRedeems: (t, ~marketIndex: int) => JsPromise.t<transaction> =
  "handleBatchedLazyRedeems"

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

type marketStateSnapshotReturn = {
  tokenPriceLong: Ethers.BigNumber.t,
  tokenPriceShort: Ethers.BigNumber.t,
}
@send
external marketStateSnapshot: (
  t,
  int,
  Ethers.BigNumber.t,
) => JsPromise.t<marketStateSnapshotReturn> = "marketStateSnapshot"

@send
external mintLong: (t, ~marketIndex: int, ~amount: Ethers.BigNumber.t) => JsPromise.t<transaction> =
  "mintLong"

@send
external mintLongAndStake: (
  t,
  ~marketIndex: int,
  ~amount: Ethers.BigNumber.t,
) => JsPromise.t<transaction> = "mintLongAndStake"

@send
external mintLongAndStakeLazy: (
  t,
  ~marketIndex: int,
  ~amount: Ethers.BigNumber.t,
) => JsPromise.t<transaction> = "mintLongAndStakeLazy"

@send
external mintLongLazy: (
  t,
  ~marketIndex: int,
  ~amount: Ethers.BigNumber.t,
) => JsPromise.t<transaction> = "mintLongLazy"

@send
external mintShort: (
  t,
  ~marketIndex: int,
  ~amount: Ethers.BigNumber.t,
) => JsPromise.t<transaction> = "mintShort"

@send
external mintShortAndStake: (
  t,
  ~marketIndex: int,
  ~amount: Ethers.BigNumber.t,
) => JsPromise.t<transaction> = "mintShortAndStake"

@send
external mintShortAndStakeLazy: (
  t,
  ~marketIndex: int,
  ~amount: Ethers.BigNumber.t,
) => JsPromise.t<transaction> = "mintShortAndStakeLazy"

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

type percentageAvailableForEarlyExitDenominatorReturn = Ethers.BigNumber.t
@send
external percentageAvailableForEarlyExitDenominator: t => JsPromise.t<
  percentageAvailableForEarlyExitDenominatorReturn,
> = "percentageAvailableForEarlyExitDenominator"

type percentageAvailableForEarlyExitNumeratorReturn = Ethers.BigNumber.t
@send
external percentageAvailableForEarlyExitNumerator: t => JsPromise.t<
  percentageAvailableForEarlyExitNumeratorReturn,
> = "percentageAvailableForEarlyExitNumerator"

@send
external redeemLong: (
  t,
  ~marketIndex: int,
  ~tokensToRedeem: Ethers.BigNumber.t,
) => JsPromise.t<transaction> = "redeemLong"

@send
external redeemLongAll: (t, ~marketIndex: int) => JsPromise.t<transaction> = "redeemLongAll"

@send
external redeemLongLazy: (
  t,
  ~marketIndex: int,
  ~tokensToRedeem: Ethers.BigNumber.t,
) => JsPromise.t<transaction> = "redeemLongLazy"

@send
external redeemShort: (
  t,
  ~marketIndex: int,
  ~tokensToRedeem: Ethers.BigNumber.t,
) => JsPromise.t<transaction> = "redeemShort"

@send
external redeemShortAll: (t, ~marketIndex: int) => JsPromise.t<transaction> = "redeemShortAll"

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

type totalValueLockedInMarketReturn = Ethers.BigNumber.t
@send
external totalValueLockedInMarket: (t, int) => JsPromise.t<totalValueLockedInMarketReturn> =
  "totalValueLockedInMarket"

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

type userLazyActionsReturn = {
  usersCurrentUpdateIndex: Ethers.BigNumber.t,
  mintLong: Ethers.BigNumber.t,
  longEarlyClaimed: Ethers.BigNumber.t,
  mintShort: Ethers.BigNumber.t,
  shortEarlyClaimed: Ethers.BigNumber.t,
  mintAndStakeLong: Ethers.BigNumber.t,
  mintAndStakeShort: Ethers.BigNumber.t,
}
@send
external userLazyActions: (t, int, Ethers.ethAddress) => JsPromise.t<userLazyActionsReturn> =
  "userLazyActions"

type userLazyRedeemsReturn = {
  redeemLong: Ethers.BigNumber.t,
  redeemShort: Ethers.BigNumber.t,
  usersCurrentUpdateIndex: Ethers.BigNumber.t,
}
@send
external userLazyRedeems: (t, int, Ethers.ethAddress) => JsPromise.t<userLazyRedeemsReturn> =
  "userLazyRedeems"

type yieldManagersReturn = Ethers.ethAddress
@send
external yieldManagers: (t, int) => JsPromise.t<yieldManagersReturn> = "yieldManagers"

module Exposed = {
  let contractName = "LongShortInternalsExposed"

  let make: unit => JsPromise.t<t> = () => deployContract0(contractName)->Obj.magic

  type tEN_TO_THE_18Return = Ethers.BigNumber.t
  @send
  external tEN_TO_THE_18: t => JsPromise.t<tEN_TO_THE_18Return> = "TEN_TO_THE_18"

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

  type batchedLazyDepositReturn = {
    mintLong: Ethers.BigNumber.t,
    longEarlyClaimed: Ethers.BigNumber.t,
    mintShort: Ethers.BigNumber.t,
    shortEarlyClaimed: Ethers.BigNumber.t,
    mintAndStakeLong: Ethers.BigNumber.t,
    mintAndStakeShort: Ethers.BigNumber.t,
  }
  @send
  external batchedLazyDeposit: (t, int) => JsPromise.t<batchedLazyDepositReturn> =
    "batchedLazyDeposit"

  type batchedLazyRedeemsReturn = {
    redeemLong: Ethers.BigNumber.t,
    redeemShort: Ethers.BigNumber.t,
    totalWithdrawnShort: Ethers.BigNumber.t,
    totalWithdrawnLong: Ethers.BigNumber.t,
  }
  @send
  external batchedLazyRedeems: (
    t,
    int,
    Ethers.BigNumber.t,
  ) => JsPromise.t<batchedLazyRedeemsReturn> = "batchedLazyRedeems"

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
  external executeOutstandingLazySettlementsPartialOrCurrentIfNeeded: (
    t,
    ~user: Ethers.ethAddress,
    ~marketIndex: int,
    ~syntheticTokenType: int,
    ~minimumAmountRequired: Ethers.BigNumber.t,
  ) => JsPromise.t<transaction> = "executeOutstandingLazySettlementsPartialOrCurrentIfNeeded"

  @send
  external executeOutstandingLazySettlementsSynth: (
    t,
    ~user: Ethers.ethAddress,
    ~marketIndex: int,
    ~syntheticTokenType: int,
  ) => JsPromise.t<transaction> = "executeOutstandingLazySettlementsSynth"

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

  type getLongBetaReturn = Ethers.BigNumber.t
  @send
  external getLongBeta: (t, ~marketIndex: int) => JsPromise.t<getLongBetaReturn> = "getLongBeta"

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

  type getShortBetaReturn = Ethers.BigNumber.t
  @send
  external getShortBeta: (t, ~marketIndex: int) => JsPromise.t<getShortBetaReturn> = "getShortBeta"

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
  external handleBatchedLazyRedeems: (t, ~marketIndex: int) => JsPromise.t<transaction> =
    "handleBatchedLazyRedeems"

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

  type marketStateSnapshotReturn = {
    tokenPriceLong: Ethers.BigNumber.t,
    tokenPriceShort: Ethers.BigNumber.t,
  }
  @send
  external marketStateSnapshot: (
    t,
    int,
    Ethers.BigNumber.t,
  ) => JsPromise.t<marketStateSnapshotReturn> = "marketStateSnapshot"

  type minimumReturn = Ethers.BigNumber.t
  @send
  external minimum: (
    t,
    ~liquidityOfPositionA: Ethers.BigNumber.t,
    ~liquidityOfPositionB: Ethers.BigNumber.t,
  ) => JsPromise.t<minimumReturn> = "minimum"

  @send
  external mintLong: (
    t,
    ~marketIndex: int,
    ~amount: Ethers.BigNumber.t,
  ) => JsPromise.t<transaction> = "mintLong"

  @send
  external mintLongAndStake: (
    t,
    ~marketIndex: int,
    ~amount: Ethers.BigNumber.t,
  ) => JsPromise.t<transaction> = "mintLongAndStake"

  @send
  external mintLongAndStakeLazy: (
    t,
    ~marketIndex: int,
    ~amount: Ethers.BigNumber.t,
  ) => JsPromise.t<transaction> = "mintLongAndStakeLazy"

  @send
  external mintLongLazy: (
    t,
    ~marketIndex: int,
    ~amount: Ethers.BigNumber.t,
  ) => JsPromise.t<transaction> = "mintLongLazy"

  @send
  external mintShort: (
    t,
    ~marketIndex: int,
    ~amount: Ethers.BigNumber.t,
  ) => JsPromise.t<transaction> = "mintShort"

  @send
  external mintShortAndStake: (
    t,
    ~marketIndex: int,
    ~amount: Ethers.BigNumber.t,
  ) => JsPromise.t<transaction> = "mintShortAndStake"

  @send
  external mintShortAndStakeLazy: (
    t,
    ~marketIndex: int,
    ~amount: Ethers.BigNumber.t,
  ) => JsPromise.t<transaction> = "mintShortAndStakeLazy"

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

  type percentageAvailableForEarlyExitDenominatorReturn = Ethers.BigNumber.t
  @send
  external percentageAvailableForEarlyExitDenominator: t => JsPromise.t<
    percentageAvailableForEarlyExitDenominatorReturn,
  > = "percentageAvailableForEarlyExitDenominator"

  type percentageAvailableForEarlyExitNumeratorReturn = Ethers.BigNumber.t
  @send
  external percentageAvailableForEarlyExitNumerator: t => JsPromise.t<
    percentageAvailableForEarlyExitNumeratorReturn,
  > = "percentageAvailableForEarlyExitNumerator"

  @send
  external redeemLong: (
    t,
    ~marketIndex: int,
    ~tokensToRedeem: Ethers.BigNumber.t,
  ) => JsPromise.t<transaction> = "redeemLong"

  @send
  external redeemLongAll: (t, ~marketIndex: int) => JsPromise.t<transaction> = "redeemLongAll"

  @send
  external redeemLongLazy: (
    t,
    ~marketIndex: int,
    ~tokensToRedeem: Ethers.BigNumber.t,
  ) => JsPromise.t<transaction> = "redeemLongLazy"

  @send
  external redeemShort: (
    t,
    ~marketIndex: int,
    ~tokensToRedeem: Ethers.BigNumber.t,
  ) => JsPromise.t<transaction> = "redeemShort"

  @send
  external redeemShortAll: (t, ~marketIndex: int) => JsPromise.t<transaction> = "redeemShortAll"

  @send
  external redeemShortLazy: (
    t,
    ~marketIndex: int,
    ~tokensToRedeem: Ethers.BigNumber.t,
  ) => JsPromise.t<transaction> = "redeemShortLazy"

  @send
  external refreshTokensPrice: (t, ~marketIndex: int) => JsPromise.t<transaction> =
    "refreshTokensPrice"

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

  type totalValueLockedInMarketReturn = Ethers.BigNumber.t
  @send
  external totalValueLockedInMarket: (t, int) => JsPromise.t<totalValueLockedInMarketReturn> =
    "totalValueLockedInMarket"

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

  type userLazyActionsReturn = {
    usersCurrentUpdateIndex: Ethers.BigNumber.t,
    mintLong: Ethers.BigNumber.t,
    longEarlyClaimed: Ethers.BigNumber.t,
    mintShort: Ethers.BigNumber.t,
    shortEarlyClaimed: Ethers.BigNumber.t,
    mintAndStakeLong: Ethers.BigNumber.t,
    mintAndStakeShort: Ethers.BigNumber.t,
  }
  @send
  external userLazyActions: (t, int, Ethers.ethAddress) => JsPromise.t<userLazyActionsReturn> =
    "userLazyActions"

  type userLazyRedeemsReturn = {
    redeemLong: Ethers.BigNumber.t,
    redeemShort: Ethers.BigNumber.t,
    usersCurrentUpdateIndex: Ethers.BigNumber.t,
  }
  @send
  external userLazyRedeems: (t, int, Ethers.ethAddress) => JsPromise.t<userLazyRedeemsReturn> =
    "userLazyRedeems"

  type yieldManagersReturn = Ethers.ethAddress
  @send
  external yieldManagers: (t, int) => JsPromise.t<yieldManagersReturn> = "yieldManagers"

  @send
  external yieldMechanism: (t, ~marketIndex: int) => JsPromise.t<transaction> = "yieldMechanism"
}
