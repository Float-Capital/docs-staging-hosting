@@ocaml.warning("-32")
open ContractHelpers
type t = {address: Ethers.ethAddress}
let contractName = "Staker"

let at: Ethers.ethAddress => JsPromise.t<t> = contractAddress =>
  attachToContract(contractName, ~contractAddress)->Obj.magic

let make: unit => JsPromise.t<t> = () => deployContract0(contractName)->Obj.magic

type fLOAT_ISSUANCE_FIXED_DECIMALReturn = Ethers.BigNumber.t
@send
external fLOAT_ISSUANCE_FIXED_DECIMAL: t => JsPromise.t<fLOAT_ISSUANCE_FIXED_DECIMALReturn> =
  "FLOAT_ISSUANCE_FIXED_DECIMAL"

type tEN_TO_THE_18Return = Ethers.BigNumber.t
@send
external tEN_TO_THE_18: t => JsPromise.t<tEN_TO_THE_18Return> = "TEN_TO_THE_18"

@send
external addNewStakingFund: (
  t,
  ~marketIndex: int,
  ~longToken: Ethers.ethAddress,
  ~shortToken: Ethers.ethAddress,
  ~kInitialMultiplier: Ethers.BigNumber.t,
  ~kPeriod: Ethers.BigNumber.t,
  ~unstakeFeeBasisPoints: Ethers.BigNumber.t,
) => JsPromise.t<transaction> = "addNewStakingFund"

@send
external addNewStateForFloatRewards: (
  t,
  ~marketIndex: int,
  ~longPrice: Ethers.BigNumber.t,
  ~shortPrice: Ethers.BigNumber.t,
  ~longValue: Ethers.BigNumber.t,
  ~shortValue: Ethers.BigNumber.t,
) => JsPromise.t<transaction> = "addNewStateForFloatRewards"

type adminReturn = Ethers.ethAddress
@send
external admin: t => JsPromise.t<adminReturn> = "admin"

@send
external changeAdmin: (t, ~admin: Ethers.ethAddress) => JsPromise.t<transaction> = "changeAdmin"

@send
external changeFloatPercentage: (
  t,
  ~newFloatPercentage: Ethers.BigNumber.t,
) => JsPromise.t<transaction> = "changeFloatPercentage"

@send
external changeMarketLaunchIncentiveParameters: (
  t,
  ~marketIndex: int,
  ~period: Ethers.BigNumber.t,
  ~initialMultiplier: Ethers.BigNumber.t,
) => JsPromise.t<transaction> = "changeMarketLaunchIncentiveParameters"

@send
external changeUnstakeFee: (
  t,
  ~marketIndex: int,
  ~newMarketUnstakeFeeBasisPoints: Ethers.BigNumber.t,
) => JsPromise.t<transaction> = "changeUnstakeFee"

@send
external claimFloatCustom: (t, ~marketIndexes: array<int>) => JsPromise.t<transaction> =
  "claimFloatCustom"

type floatCapitalReturn = Ethers.ethAddress
@send
external floatCapital: t => JsPromise.t<floatCapitalReturn> = "floatCapital"

type floatPercentageReturn = Ethers.BigNumber.t
@send
external floatPercentage: t => JsPromise.t<floatPercentageReturn> = "floatPercentage"

type floatTokenReturn = Ethers.ethAddress
@send
external floatToken: t => JsPromise.t<floatTokenReturn> = "floatToken"

@send
external initialize: (
  t,
  ~admin: Ethers.ethAddress,
  ~longShortCoreContract: Ethers.ethAddress,
  ~floatToken: Ethers.ethAddress,
  ~floatCapital: Ethers.ethAddress,
  ~floatPercentage: Ethers.BigNumber.t,
) => JsPromise.t<transaction> = "initialize"

type latestRewardIndexReturn = Ethers.BigNumber.t
@send
external latestRewardIndex: (t, int) => JsPromise.t<latestRewardIndexReturn> = "latestRewardIndex"

type longShortCoreContractReturn = Ethers.ethAddress
@send
external longShortCoreContract: t => JsPromise.t<longShortCoreContractReturn> =
  "longShortCoreContract"

type marketIndexOfTokenReturn = int
@send
external marketIndexOfToken: (t, Ethers.ethAddress) => JsPromise.t<marketIndexOfTokenReturn> =
  "marketIndexOfToken"

type marketLaunchIncentiveMultipliersReturn = Ethers.BigNumber.t
@send
external marketLaunchIncentiveMultipliers: (
  t,
  int,
) => JsPromise.t<marketLaunchIncentiveMultipliersReturn> = "marketLaunchIncentiveMultipliers"

type marketLaunchIncentivePeriodReturn = Ethers.BigNumber.t
@send
external marketLaunchIncentivePeriod: (t, int) => JsPromise.t<marketLaunchIncentivePeriodReturn> =
  "marketLaunchIncentivePeriod"

type marketUnstakeFeeBasisPointsReturn = Ethers.BigNumber.t
@send
external marketUnstakeFeeBasisPoints: (t, int) => JsPromise.t<marketUnstakeFeeBasisPointsReturn> =
  "marketUnstakeFeeBasisPoints"

@send
external stakeFromUser: (
  t,
  ~from: Ethers.ethAddress,
  ~amount: Ethers.BigNumber.t,
) => JsPromise.t<transaction> = "stakeFromUser"

type syntheticRewardParamsReturn = {
  timestamp: Ethers.BigNumber.t,
  accumulativeFloatPerLongToken: Ethers.BigNumber.t,
  accumulativeFloatPerShortToken: Ethers.BigNumber.t,
}
@send
external syntheticRewardParams: (
  t,
  int,
  Ethers.BigNumber.t,
) => JsPromise.t<syntheticRewardParamsReturn> = "syntheticRewardParams"

type syntheticTokensReturn = Ethers.ethAddress
@send
external syntheticTokens: (t, int, bool) => JsPromise.t<syntheticTokensReturn> = "syntheticTokens"

type userAmountStakedReturn = Ethers.BigNumber.t
@send
external userAmountStaked: (
  t,
  Ethers.ethAddress,
  Ethers.ethAddress,
) => JsPromise.t<userAmountStakedReturn> = "userAmountStaked"

type userIndexOfLastClaimedRewardReturn = Ethers.BigNumber.t
@send
external userIndexOfLastClaimedReward: (
  t,
  int,
  Ethers.ethAddress,
) => JsPromise.t<userIndexOfLastClaimedRewardReturn> = "userIndexOfLastClaimedReward"

@send
external withdraw: (
  t,
  ~token: Ethers.ethAddress,
  ~amount: Ethers.BigNumber.t,
) => JsPromise.t<transaction> = "withdraw"

@send
external withdrawAll: (t, ~token: Ethers.ethAddress) => JsPromise.t<transaction> = "withdrawAll"

module Exposed = {
  let contractName = "StakerInternalsExposed"

  let make: unit => JsPromise.t<t> = () => deployContract0(contractName)->Obj.magic

  type fLOAT_ISSUANCE_FIXED_DECIMALReturn = Ethers.BigNumber.t
  @send
  external fLOAT_ISSUANCE_FIXED_DECIMAL: t => JsPromise.t<fLOAT_ISSUANCE_FIXED_DECIMALReturn> =
    "FLOAT_ISSUANCE_FIXED_DECIMAL"

  type tEN_TO_THE_18Return = Ethers.BigNumber.t
  @send
  external tEN_TO_THE_18: t => JsPromise.t<tEN_TO_THE_18Return> = "TEN_TO_THE_18"

  @send
  external _changeMarketLaunchIncentiveParametersExternal: (
    t,
    ~marketIndex: int,
    ~period: Ethers.BigNumber.t,
    ~initialMultiplier: Ethers.BigNumber.t,
  ) => JsPromise.t<transaction> = "_changeMarketLaunchIncentiveParametersExternal"

  @send
  external _claimFloatExternal: (t, ~marketIndex: array<int>) => JsPromise.t<transaction> =
    "_claimFloatExternal"

  @send
  external _mintFloatExternal: (
    t,
    ~user: Ethers.ethAddress,
    ~floatToMint: Ethers.BigNumber.t,
  ) => JsPromise.t<transaction> = "_mintFloatExternal"

  @send
  external _stakeExternal: (
    t,
    ~token: Ethers.ethAddress,
    ~amount: Ethers.BigNumber.t,
    ~user: Ethers.ethAddress,
  ) => JsPromise.t<transaction> = "_stakeExternal"

  @send
  external _withdrawExternal: (
    t,
    ~token: Ethers.ethAddress,
    ~amount: Ethers.BigNumber.t,
  ) => JsPromise.t<transaction> = "_withdrawExternal"

  @send
  external addNewStakingFund: (
    t,
    ~marketIndex: int,
    ~longToken: Ethers.ethAddress,
    ~shortToken: Ethers.ethAddress,
    ~kInitialMultiplier: Ethers.BigNumber.t,
    ~kPeriod: Ethers.BigNumber.t,
    ~unstakeFeeBasisPoints: Ethers.BigNumber.t,
  ) => JsPromise.t<transaction> = "addNewStakingFund"

  @send
  external addNewStateForFloatRewards: (
    t,
    ~marketIndex: int,
    ~longPrice: Ethers.BigNumber.t,
    ~shortPrice: Ethers.BigNumber.t,
    ~longValue: Ethers.BigNumber.t,
    ~shortValue: Ethers.BigNumber.t,
  ) => JsPromise.t<transaction> = "addNewStateForFloatRewards"

  type adminReturn = Ethers.ethAddress
  @send
  external admin: t => JsPromise.t<adminReturn> = "admin"

  @send
  external calculateAccumulatedFloatExposed: (
    t,
    ~marketIndex: int,
    ~user: Ethers.ethAddress,
  ) => JsPromise.t<transaction> = "calculateAccumulatedFloatExposed"

  type calculateAccumulatedFloatExposedReturn = {
    longFloatReward: Ethers.BigNumber.t,
    shortFloatReward: Ethers.BigNumber.t,
  }
  @send @scope("callStatic")
  external calculateAccumulatedFloatExposedCall: (
    t,
    ~marketIndex: int,
    ~user: Ethers.ethAddress,
  ) => JsPromise.t<calculateAccumulatedFloatExposedReturn> = "calculateAccumulatedFloatExposed"

  type calculateFloatPerSecondExposedReturn = {
    longFloatPerSecond: Ethers.BigNumber.t,
    shortFloatPerSecond: Ethers.BigNumber.t,
  }
  @send
  external calculateFloatPerSecondExposed: (
    t,
    ~marketIndex: int,
    ~longPrice: Ethers.BigNumber.t,
    ~shortPrice: Ethers.BigNumber.t,
    ~longValue: Ethers.BigNumber.t,
    ~shortValue: Ethers.BigNumber.t,
  ) => JsPromise.t<calculateFloatPerSecondExposedReturn> = "calculateFloatPerSecondExposed"

  type calculateNewCumulativeRateExposedReturn = {
    longCumulativeRates: Ethers.BigNumber.t,
    shortCumulativeRates: Ethers.BigNumber.t,
  }
  @send
  external calculateNewCumulativeRateExposed: (
    t,
    ~marketIndex: int,
    ~longPrice: Ethers.BigNumber.t,
    ~shortPrice: Ethers.BigNumber.t,
    ~longValue: Ethers.BigNumber.t,
    ~shortValue: Ethers.BigNumber.t,
  ) => JsPromise.t<calculateNewCumulativeRateExposedReturn> = "calculateNewCumulativeRateExposed"

  type calculateTimeDeltaExposedReturn = Ethers.BigNumber.t
  @send
  external calculateTimeDeltaExposed: (
    t,
    ~marketIndex: int,
  ) => JsPromise.t<calculateTimeDeltaExposedReturn> = "calculateTimeDeltaExposed"

  @send
  external changeAdmin: (t, ~admin: Ethers.ethAddress) => JsPromise.t<transaction> = "changeAdmin"

  @send
  external changeFloatPercentage: (
    t,
    ~newFloatPercentage: Ethers.BigNumber.t,
  ) => JsPromise.t<transaction> = "changeFloatPercentage"

  @send
  external changeMarketLaunchIncentiveParameters: (
    t,
    ~marketIndex: int,
    ~period: Ethers.BigNumber.t,
    ~initialMultiplier: Ethers.BigNumber.t,
  ) => JsPromise.t<transaction> = "changeMarketLaunchIncentiveParameters"

  @send
  external changeUnstakeFee: (
    t,
    ~marketIndex: int,
    ~newMarketUnstakeFeeBasisPoints: Ethers.BigNumber.t,
  ) => JsPromise.t<transaction> = "changeUnstakeFee"

  @send
  external claimFloatCustom: (t, ~marketIndexes: array<int>) => JsPromise.t<transaction> =
    "claimFloatCustom"

  type floatCapitalReturn = Ethers.ethAddress
  @send
  external floatCapital: t => JsPromise.t<floatCapitalReturn> = "floatCapital"

  type floatPercentageReturn = Ethers.BigNumber.t
  @send
  external floatPercentage: t => JsPromise.t<floatPercentageReturn> = "floatPercentage"

  type floatTokenReturn = Ethers.ethAddress
  @send
  external floatToken: t => JsPromise.t<floatTokenReturn> = "floatToken"

  type getKValueExternalReturn = Ethers.BigNumber.t
  @send
  external getKValueExternal: (t, ~marketIndex: int) => JsPromise.t<getKValueExternalReturn> =
    "getKValueExternal"

  type getMarketLaunchIncentiveParametersExternalReturn = {
    param0: Ethers.BigNumber.t,
    param1: Ethers.BigNumber.t,
  }
  @send
  external getMarketLaunchIncentiveParametersExternal: (
    t,
    ~marketIndex: int,
  ) => JsPromise.t<getMarketLaunchIncentiveParametersExternalReturn> =
    "getMarketLaunchIncentiveParametersExternal"

  @send
  external initialize: (
    t,
    ~admin: Ethers.ethAddress,
    ~longShortCoreContract: Ethers.ethAddress,
    ~floatToken: Ethers.ethAddress,
    ~floatCapital: Ethers.ethAddress,
    ~floatPercentage: Ethers.BigNumber.t,
  ) => JsPromise.t<transaction> = "initialize"

  type latestRewardIndexReturn = Ethers.BigNumber.t
  @send
  external latestRewardIndex: (t, int) => JsPromise.t<latestRewardIndexReturn> = "latestRewardIndex"

  type longShortCoreContractReturn = Ethers.ethAddress
  @send
  external longShortCoreContract: t => JsPromise.t<longShortCoreContractReturn> =
    "longShortCoreContract"

  type marketIndexOfTokenReturn = int
  @send
  external marketIndexOfToken: (t, Ethers.ethAddress) => JsPromise.t<marketIndexOfTokenReturn> =
    "marketIndexOfToken"

  type marketLaunchIncentiveMultipliersReturn = Ethers.BigNumber.t
  @send
  external marketLaunchIncentiveMultipliers: (
    t,
    int,
  ) => JsPromise.t<marketLaunchIncentiveMultipliersReturn> = "marketLaunchIncentiveMultipliers"

  type marketLaunchIncentivePeriodReturn = Ethers.BigNumber.t
  @send
  external marketLaunchIncentivePeriod: (t, int) => JsPromise.t<marketLaunchIncentivePeriodReturn> =
    "marketLaunchIncentivePeriod"

  type marketUnstakeFeeBasisPointsReturn = Ethers.BigNumber.t
  @send
  external marketUnstakeFeeBasisPoints: (t, int) => JsPromise.t<marketUnstakeFeeBasisPointsReturn> =
    "marketUnstakeFeeBasisPoints"

  @send
  external mintAccumulatedFloatExternal: (
    t,
    ~marketIndex: int,
    ~user: Ethers.ethAddress,
  ) => JsPromise.t<transaction> = "mintAccumulatedFloatExternal"

  @send
  external setAddNewStakingFundParams: (
    t,
    ~marketIndex: int,
    ~longToken: Ethers.ethAddress,
    ~shortToken: Ethers.ethAddress,
    ~mockAddress: Ethers.ethAddress,
  ) => JsPromise.t<transaction> = "setAddNewStakingFundParams"

  @send
  external setCalculateNewCumulativeRateParams: (
    t,
    ~marketIndex: int,
    ~latestRewardIndexForMarket: Ethers.BigNumber.t,
    ~accumFloatLong: Ethers.BigNumber.t,
    ~accumFloatShort: Ethers.BigNumber.t,
  ) => JsPromise.t<transaction> = "setCalculateNewCumulativeRateParams"

  @send
  external setCalculateTimeDeltaParams: (
    t,
    ~marketIndex: int,
    ~latestRewardIndexForMarket: Ethers.BigNumber.t,
    ~timestamp: Ethers.BigNumber.t,
  ) => JsPromise.t<transaction> = "setCalculateTimeDeltaParams"

  @send
  external setClaimFloatCustomParams: (
    t,
    ~longshort: Ethers.ethAddress,
  ) => JsPromise.t<transaction> = "setClaimFloatCustomParams"

  @send
  external setFloatRewardCalcParams: (
    t,
    ~marketIndex: int,
    ~longToken: Ethers.ethAddress,
    ~shortToken: Ethers.ethAddress,
    ~newLatestRewardIndex: Ethers.BigNumber.t,
    ~user: Ethers.ethAddress,
    ~usersLatestClaimedReward: Ethers.BigNumber.t,
    ~accumulativeFloatPerTokenLatestLong: Ethers.BigNumber.t,
    ~accumulativeFloatPerTokenLatestShort: Ethers.BigNumber.t,
    ~accumulativeFloatPerTokenUserLong: Ethers.BigNumber.t,
    ~accumulativeFloatPerTokenUserShort: Ethers.BigNumber.t,
    ~newUserAmountStakedLong: Ethers.BigNumber.t,
    ~newUserAmountStakedShort: Ethers.BigNumber.t,
  ) => JsPromise.t<transaction> = "setFloatRewardCalcParams"

  @send
  external setFunctionToNotMock: (t, ~functionToNotMock: string) => JsPromise.t<transaction> =
    "setFunctionToNotMock"

  @send
  external setGetKValueParams: (
    t,
    ~marketIndex: int,
    ~timestamp: Ethers.BigNumber.t,
  ) => JsPromise.t<transaction> = "setGetKValueParams"

  @send
  external setGetMarketLaunchIncentiveParametersParams: (
    t,
    ~marketIndex: int,
    ~period: Ethers.BigNumber.t,
    ~multiplier: Ethers.BigNumber.t,
  ) => JsPromise.t<transaction> = "setGetMarketLaunchIncentiveParametersParams"

  @send
  external setMintAccumulatedFloatAndClaimFloatParams: (
    t,
    ~marketIndex: int,
    ~latestRewardIndexForMarket: Ethers.BigNumber.t,
  ) => JsPromise.t<transaction> = "setMintAccumulatedFloatAndClaimFloatParams"

  @send
  external setMocker: (t, ~mocker: Ethers.ethAddress) => JsPromise.t<transaction> = "setMocker"

  @send
  external setRewardObjectsExternal: (
    t,
    ~marketIndex: int,
    ~longPrice: Ethers.BigNumber.t,
    ~shortPrice: Ethers.BigNumber.t,
    ~longValue: Ethers.BigNumber.t,
    ~shortValue: Ethers.BigNumber.t,
  ) => JsPromise.t<transaction> = "setRewardObjectsExternal"

  @send
  external setSetRewardObjectsParams: (
    t,
    ~marketIndex: int,
    ~latestRewardIndexForMarket: Ethers.BigNumber.t,
  ) => JsPromise.t<transaction> = "setSetRewardObjectsParams"

  @send
  external setStakeFromUserParams: (
    t,
    ~longshort: Ethers.ethAddress,
    ~token: Ethers.ethAddress,
    ~marketIndexForToken: int,
  ) => JsPromise.t<transaction> = "setStakeFromUserParams"

  @send
  external set_mintFloatParams: (
    t,
    ~floatToken: Ethers.ethAddress,
    ~floatPercentage: int,
  ) => JsPromise.t<transaction> = "set_mintFloatParams"

  @send
  external set_stakeParams: (
    t,
    ~user: Ethers.ethAddress,
    ~marketIndex: int,
    ~latestRewardIndex: Ethers.BigNumber.t,
    ~token: Ethers.ethAddress,
    ~userAmountStaked: Ethers.BigNumber.t,
    ~userLastRewardIndex: Ethers.BigNumber.t,
  ) => JsPromise.t<transaction> = "set_stakeParams"

  @send
  external set_updateStateParams: (
    t,
    ~longShort: Ethers.ethAddress,
    ~token: Ethers.ethAddress,
    ~tokenMarketIndex: int,
  ) => JsPromise.t<transaction> = "set_updateStateParams"

  @send
  external stakeFromUser: (
    t,
    ~from: Ethers.ethAddress,
    ~amount: Ethers.BigNumber.t,
  ) => JsPromise.t<transaction> = "stakeFromUser"

  type syntheticRewardParamsReturn = {
    timestamp: Ethers.BigNumber.t,
    accumulativeFloatPerLongToken: Ethers.BigNumber.t,
    accumulativeFloatPerShortToken: Ethers.BigNumber.t,
  }
  @send
  external syntheticRewardParams: (
    t,
    int,
    Ethers.BigNumber.t,
  ) => JsPromise.t<syntheticRewardParamsReturn> = "syntheticRewardParams"

  type syntheticTokensReturn = Ethers.ethAddress
  @send
  external syntheticTokens: (t, int, bool) => JsPromise.t<syntheticTokensReturn> = "syntheticTokens"

  type userAmountStakedReturn = Ethers.BigNumber.t
  @send
  external userAmountStaked: (
    t,
    Ethers.ethAddress,
    Ethers.ethAddress,
  ) => JsPromise.t<userAmountStakedReturn> = "userAmountStaked"

  type userIndexOfLastClaimedRewardReturn = Ethers.BigNumber.t
  @send
  external userIndexOfLastClaimedReward: (
    t,
    int,
    Ethers.ethAddress,
  ) => JsPromise.t<userIndexOfLastClaimedRewardReturn> = "userIndexOfLastClaimedReward"

  @send
  external withdraw: (
    t,
    ~token: Ethers.ethAddress,
    ~amount: Ethers.BigNumber.t,
  ) => JsPromise.t<transaction> = "withdraw"

  @send
  external withdrawAll: (t, ~token: Ethers.ethAddress) => JsPromise.t<transaction> = "withdrawAll"
}
