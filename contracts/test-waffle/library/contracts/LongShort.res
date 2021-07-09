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

type adminReturn = Ethers.ethAddress
@send
external admin: t => JsPromise.t<adminReturn> = "admin"

type assetPriceReturn = Ethers.BigNumber.t
@send
external assetPrice: (t, int) => JsPromise.t<assetPriceReturn> = "assetPrice"

type batchedAmountOfSynthTokensToRedeemReturn = Ethers.BigNumber.t
@send
external batchedAmountOfSynthTokensToRedeem: (
  t,
  int,
  bool,
) => JsPromise.t<batchedAmountOfSynthTokensToRedeemReturn> = "batchedAmountOfSynthTokensToRedeem"

type batchedAmountOfTokensToDepositReturn = Ethers.BigNumber.t
@send
external batchedAmountOfTokensToDeposit: (
  t,
  int,
  bool,
) => JsPromise.t<batchedAmountOfTokensToDepositReturn> = "batchedAmountOfTokensToDeposit"

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

type getUsersConfirmedButNotSettledBalanceReturn = Ethers.BigNumber.t
@send
external getUsersConfirmedButNotSettledBalance: (
  t,
  ~user: Ethers.ethAddress,
  ~marketIndex: int,
  ~isLong: bool,
) => JsPromise.t<getUsersConfirmedButNotSettledBalanceReturn> =
  "getUsersConfirmedButNotSettledBalance"

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

type yieldManagersReturn = Ethers.ethAddress
@send
external yieldManagers: (t, int) => JsPromise.t<yieldManagersReturn> = "yieldManagers"

module Exposed = {
  let contractName = "LongShortInternalsExposed"

  let make: unit => JsPromise.t<t> = () => deployContract0(contractName)->Obj.magic

  type dEAD_ADDRESSReturn = Ethers.ethAddress
  @send
  external dEAD_ADDRESS: t => JsPromise.t<dEAD_ADDRESSReturn> = "DEAD_ADDRESS"

  @send
  external _executeOutstandingNextPriceSettlementsExposed: (
    t,
    ~user: Ethers.ethAddress,
    ~marketIndex: int,
  ) => JsPromise.t<transaction> = "_executeOutstandingNextPriceSettlementsExposed"

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

  type batchedAmountOfSynthTokensToRedeemReturn = Ethers.BigNumber.t
  @send
  external batchedAmountOfSynthTokensToRedeem: (
    t,
    int,
    bool,
  ) => JsPromise.t<batchedAmountOfSynthTokensToRedeemReturn> = "batchedAmountOfSynthTokensToRedeem"

  type batchedAmountOfTokensToDepositReturn = Ethers.BigNumber.t
  @send
  external batchedAmountOfTokensToDeposit: (
    t,
    int,
    bool,
  ) => JsPromise.t<batchedAmountOfTokensToDepositReturn> = "batchedAmountOfTokensToDeposit"

  @send
  external changeAdmin: (t, ~admin: Ethers.ethAddress) => JsPromise.t<transaction> = "changeAdmin"

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
  external executeOutstandingNextPriceSettlementsUser: (
    t,
    ~user: Ethers.ethAddress,
    ~marketIndex: int,
  ) => JsPromise.t<transaction> = "executeOutstandingNextPriceSettlementsUser"

  type getUsersConfirmedButNotSettledBalanceReturn = Ethers.BigNumber.t
  @send
  external getUsersConfirmedButNotSettledBalance: (
    t,
    ~user: Ethers.ethAddress,
    ~marketIndex: int,
    ~isLong: bool,
  ) => JsPromise.t<getUsersConfirmedButNotSettledBalanceReturn> =
    "getUsersConfirmedButNotSettledBalance"

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
  external setInitializeMarketParams: (
    t,
    ~marketIndex: int,
    ~marketIndexValue: bool,
    ~latestMarket: int,
    ~staker: Ethers.ethAddress,
    ~longAddress: Ethers.ethAddress,
    ~shortAddress: Ethers.ethAddress,
  ) => JsPromise.t<transaction> = "setInitializeMarketParams"

  @send
  external setMocker: (t, ~mocker: Ethers.ethAddress) => JsPromise.t<transaction> = "setMocker"

  @send
  external setUseexecuteOutstandingNextPriceSettlementsMock: (
    t,
    ~shouldUseMock: bool,
  ) => JsPromise.t<transaction> = "setUseexecuteOutstandingNextPriceSettlementsMock"

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

  @send
  external transferFundsToYieldManager: (
    t,
    ~marketIndex: int,
    ~amount: Ethers.BigNumber.t,
  ) => JsPromise.t<transaction> = "transferFundsToYieldManager"

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
  external updateSystemState: (t, ~marketIndex: int) => JsPromise.t<transaction> =
    "updateSystemState"

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
