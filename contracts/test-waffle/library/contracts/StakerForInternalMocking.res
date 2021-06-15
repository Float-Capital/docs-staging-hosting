@@ocaml.warning("-32")
open ContractHelpers
type t = {address: Ethers.ethAddress}
let contractName = "StakerForInternalMocking"

let at: Ethers.ethAddress => JsPromise.t<t> = contractAddress =>
  attachToContract(contractName, ~contractAddress)->Obj.magic

let make: unit => JsPromise.t<t> = () => deployContract0(contractName)->Obj.magic

type _changeMarketLaunchIncentiveParametersMockReturn
@send
external _changeMarketLaunchIncentiveParametersMock: (
  t,
  int,
  Ethers.BigNumber.t,
  Ethers.BigNumber.t,
) => JsPromise.t<_changeMarketLaunchIncentiveParametersMockReturn> =
  "_changeMarketLaunchIncentiveParametersMock"

type _claimFloatMockReturn
@send
external _claimFloatMock: (t, array<int>) => JsPromise.t<_claimFloatMockReturn> = "_claimFloatMock"

type _mintFloatMockReturn
@send
external _mintFloatMock: (
  t,
  Ethers.ethAddress,
  Ethers.BigNumber.t,
) => JsPromise.t<_mintFloatMockReturn> = "_mintFloatMock"

type _stakeMockReturn
@send
external _stakeMock: (
  t,
  Ethers.ethAddress,
  Ethers.BigNumber.t,
  Ethers.ethAddress,
) => JsPromise.t<_stakeMockReturn> = "_stakeMock"

type _updateStateMockReturn
@send
external _updateStateMock: (t, Ethers.ethAddress) => JsPromise.t<_updateStateMockReturn> =
  "_updateStateMock"

type _withdrawMockReturn
@send
external _withdrawMock: (
  t,
  Ethers.ethAddress,
  Ethers.BigNumber.t,
) => JsPromise.t<_withdrawMockReturn> = "_withdrawMock"

type addNewStakingFundMockReturn
@send
external addNewStakingFundMock: (
  t,
  int,
  Ethers.ethAddress,
  Ethers.ethAddress,
  Ethers.BigNumber.t,
  Ethers.BigNumber.t,
) => JsPromise.t<addNewStakingFundMockReturn> = "addNewStakingFundMock"

type addNewStateForFloatRewardsMockReturn
@send
external addNewStateForFloatRewardsMock: (
  t,
  int,
  Ethers.BigNumber.t,
  Ethers.BigNumber.t,
  Ethers.BigNumber.t,
  Ethers.BigNumber.t,
) => JsPromise.t<addNewStateForFloatRewardsMockReturn> = "addNewStateForFloatRewardsMock"

type calculateAccumulatedFloatHelperMockReturn = {
  longFloatReward: Ethers.BigNumber.t,
  shortFloatReward: Ethers.BigNumber.t,
}
@send
external calculateAccumulatedFloatHelperMock: (
  t,
  int,
  Ethers.ethAddress,
  Ethers.BigNumber.t,
  Ethers.BigNumber.t,
  Ethers.BigNumber.t,
) => JsPromise.t<calculateAccumulatedFloatHelperMockReturn> = "calculateAccumulatedFloatHelperMock"

type calculateAccumulatedFloatMockReturn = {
  longFloatReward: Ethers.BigNumber.t,
  shortFloatReward: Ethers.BigNumber.t,
}
@send
external calculateAccumulatedFloatMock: (
  t,
  int,
  Ethers.ethAddress,
) => JsPromise.t<calculateAccumulatedFloatMockReturn> = "calculateAccumulatedFloatMock"

type calculateFloatPerSecondMockReturn = {
  longFloatPerSecond: Ethers.BigNumber.t,
  shortFloatPerSecond: Ethers.BigNumber.t,
}
@send
external calculateFloatPerSecondMock: (
  t,
  Ethers.BigNumber.t,
  Ethers.BigNumber.t,
  Ethers.BigNumber.t,
  Ethers.BigNumber.t,
  int,
) => JsPromise.t<calculateFloatPerSecondMockReturn> = "calculateFloatPerSecondMock"

type calculateNewCumulativeRateMockReturn = {
  longCumulativeRates: Ethers.BigNumber.t,
  shortCumulativeRates: Ethers.BigNumber.t,
}
@send
external calculateNewCumulativeRateMock: (
  t,
  Ethers.BigNumber.t,
  Ethers.BigNumber.t,
  Ethers.BigNumber.t,
  Ethers.BigNumber.t,
  int,
) => JsPromise.t<calculateNewCumulativeRateMockReturn> = "calculateNewCumulativeRateMock"

type calculateTimeDeltaMockReturn = Ethers.BigNumber.t
@send
external calculateTimeDeltaMock: (t, int) => JsPromise.t<calculateTimeDeltaMockReturn> =
  "calculateTimeDeltaMock"

type changeAdminMockReturn
@send
external changeAdminMock: (t, Ethers.ethAddress) => JsPromise.t<changeAdminMockReturn> =
  "changeAdminMock"

type changeFloatPercentageMockReturn
@send
external changeFloatPercentageMock: (t, int) => JsPromise.t<changeFloatPercentageMockReturn> =
  "changeFloatPercentageMock"

type changeMarketLaunchIncentiveParametersMockReturn
@send
external changeMarketLaunchIncentiveParametersMock: (
  t,
  int,
  Ethers.BigNumber.t,
  Ethers.BigNumber.t,
) => JsPromise.t<changeMarketLaunchIncentiveParametersMockReturn> =
  "changeMarketLaunchIncentiveParametersMock"

type claimFloatCustomMockReturn
@send
external claimFloatCustomMock: (t, array<int>) => JsPromise.t<claimFloatCustomMockReturn> =
  "claimFloatCustomMock"

type getKValueMockReturn = Ethers.BigNumber.t
@send
external getKValueMock: (t, int) => JsPromise.t<getKValueMockReturn> = "getKValueMock"

type getMarketLaunchIncentiveParametersMockReturn = {
  param0: Ethers.BigNumber.t,
  param1: Ethers.BigNumber.t,
}
@send
external getMarketLaunchIncentiveParametersMock: (
  t,
  int,
) => JsPromise.t<getMarketLaunchIncentiveParametersMockReturn> =
  "getMarketLaunchIncentiveParametersMock"

type initializeMockReturn
@send
external initializeMock: (
  t,
  Ethers.ethAddress,
  Ethers.ethAddress,
  Ethers.ethAddress,
  Ethers.ethAddress,
) => JsPromise.t<initializeMockReturn> = "initializeMock"

type mintAccumulatedFloatMockReturn
@send
external mintAccumulatedFloatMock: (
  t,
  int,
  Ethers.ethAddress,
) => JsPromise.t<mintAccumulatedFloatMockReturn> = "mintAccumulatedFloatMock"

type onlyAdminMockReturn
@send
external onlyAdminMock: t => JsPromise.t<onlyAdminMockReturn> = "onlyAdminMock"

type onlyFloatMockReturn
@send
external onlyFloatMock: t => JsPromise.t<onlyFloatMockReturn> = "onlyFloatMock"

type onlyValidMarketMockReturn
@send
external onlyValidMarketMock: (t, int) => JsPromise.t<onlyValidMarketMockReturn> =
  "onlyValidMarketMock"

type onlyValidSyntheticMockReturn
@send
external onlyValidSyntheticMock: (
  t,
  Ethers.ethAddress,
) => JsPromise.t<onlyValidSyntheticMockReturn> = "onlyValidSyntheticMock"

type setRewardObjectsMockReturn
@send
external setRewardObjectsMock: (
  t,
  Ethers.BigNumber.t,
  Ethers.BigNumber.t,
  Ethers.BigNumber.t,
  Ethers.BigNumber.t,
  int,
) => JsPromise.t<setRewardObjectsMockReturn> = "setRewardObjectsMock"

type stakeFromUserMockReturn
@send
external stakeFromUserMock: (
  t,
  Ethers.ethAddress,
  Ethers.BigNumber.t,
) => JsPromise.t<stakeFromUserMockReturn> = "stakeFromUserMock"

type withdrawAllMockReturn
@send
external withdrawAllMock: (t, Ethers.ethAddress) => JsPromise.t<withdrawAllMockReturn> =
  "withdrawAllMock"

type withdrawMockReturn
@send
external withdrawMock: (
  t,
  Ethers.ethAddress,
  Ethers.BigNumber.t,
) => JsPromise.t<withdrawMockReturn> = "withdrawMock"
