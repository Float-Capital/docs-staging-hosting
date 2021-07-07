@@ocaml.warning("-32")
open ContractHelpers
type t = {address: Ethers.ethAddress}
let contractName = "StakerMockable"

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
external changeFloatPercentage: (t, ~newFloatPercentage: int) => JsPromise.t<transaction> =
  "changeFloatPercentage"

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

type floatPercentageReturn = int
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
external setFunctionToNotMock: (t, ~functionToNotMock: string) => JsPromise.t<transaction> =
  "setFunctionToNotMock"

@send
external setMocker: (t, ~mocker: Ethers.ethAddress) => JsPromise.t<transaction> = "setMocker"

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
