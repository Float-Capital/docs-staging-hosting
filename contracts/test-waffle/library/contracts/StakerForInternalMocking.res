@@ocaml.warning("-32")
open ContractHelpers
type t = {address: Ethers.ethAddress}
let contractName = "StakerForInternalMocking"

let at: Ethers.ethAddress => JsPromise.t<t> = contractAddress =>
  attachToContract(contractName, ~contractAddress)->Obj.magic

let make: unit => JsPromise.t<t> = () => deployContract0(contractName)->Obj.magic

type _calculateAccumulatedFloatInRangeMockReturn = Ethers.BigNumber.t
@send
external _calculateAccumulatedFloatInRangeMock: (
  t,
  int,
  Ethers.BigNumber.t,
  Ethers.BigNumber.t,
  Ethers.BigNumber.t,
  Ethers.BigNumber.t,
) => JsPromise.t<_calculateAccumulatedFloatInRangeMockReturn> =
  "_calculateAccumulatedFloatInRangeMock"

type _calculateAccumulatedFloatMockReturn = Ethers.BigNumber.t
@send
external _calculateAccumulatedFloatMock: (
  t,
  int,
  Ethers.ethAddress,
) => JsPromise.t<_calculateAccumulatedFloatMockReturn> = "_calculateAccumulatedFloatMock"

type _calculateFloatPerSecondMockReturn = {
  longFloatPerSecond: Ethers.BigNumber.t,
  shortFloatPerSecond: Ethers.BigNumber.t,
}
@send
external _calculateFloatPerSecondMock: (
  t,
  int,
  Ethers.BigNumber.t,
  Ethers.BigNumber.t,
  Ethers.BigNumber.t,
  Ethers.BigNumber.t,
) => JsPromise.t<_calculateFloatPerSecondMockReturn> = "_calculateFloatPerSecondMock"

type _calculateNewCumulativeIssuancePerStakedSynthMockReturn = {
  longCumulativeRates: Ethers.BigNumber.t,
  shortCumulativeRates: Ethers.BigNumber.t,
}
@send
external _calculateNewCumulativeIssuancePerStakedSynthMock: (
  t,
  int,
  Ethers.BigNumber.t,
  Ethers.BigNumber.t,
  Ethers.BigNumber.t,
  Ethers.BigNumber.t,
) => JsPromise.t<_calculateNewCumulativeIssuancePerStakedSynthMockReturn> =
  "_calculateNewCumulativeIssuancePerStakedSynthMock"

type _calculateTimeDeltaMockReturn = Ethers.BigNumber.t
@send
external _calculateTimeDeltaMock: (t, int) => JsPromise.t<_calculateTimeDeltaMockReturn> =
  "_calculateTimeDeltaMock"

type _changBalanceIncentiveEquilibriumOffsetMockReturn
@send
external _changBalanceIncentiveEquilibriumOffsetMock: (
  t,
  int,
  Ethers.BigNumber.t,
) => JsPromise.t<_changBalanceIncentiveEquilibriumOffsetMockReturn> =
  "_changBalanceIncentiveEquilibriumOffsetMock"

type _changBalanceIncentiveExponentMockReturn
@send
external _changBalanceIncentiveExponentMock: (
  t,
  int,
  Ethers.BigNumber.t,
) => JsPromise.t<_changBalanceIncentiveExponentMockReturn> = "_changBalanceIncentiveExponentMock"

type _changeFloatPercentageMockReturn
@send
external _changeFloatPercentageMock: (
  t,
  Ethers.BigNumber.t,
) => JsPromise.t<_changeFloatPercentageMockReturn> = "_changeFloatPercentageMock"

type _changeMarketLaunchIncentiveParametersMockReturn
@send
external _changeMarketLaunchIncentiveParametersMock: (
  t,
  int,
  Ethers.BigNumber.t,
  Ethers.BigNumber.t,
) => JsPromise.t<_changeMarketLaunchIncentiveParametersMockReturn> =
  "_changeMarketLaunchIncentiveParametersMock"

type _changeUnstakeFeeMockReturn
@send
external _changeUnstakeFeeMock: (
  t,
  int,
  Ethers.BigNumber.t,
) => JsPromise.t<_changeUnstakeFeeMockReturn> = "_changeUnstakeFeeMock"

type _getKValueMockReturn = Ethers.BigNumber.t
@send
external _getKValueMock: (t, int) => JsPromise.t<_getKValueMockReturn> = "_getKValueMock"

type _getMarketLaunchIncentiveParametersMockReturn = {
  param0: Ethers.BigNumber.t,
  param1: Ethers.BigNumber.t,
}
@send
external _getMarketLaunchIncentiveParametersMock: (
  t,
  int,
) => JsPromise.t<_getMarketLaunchIncentiveParametersMockReturn> =
  "_getMarketLaunchIncentiveParametersMock"

type _mintAccumulatedFloatMockReturn
@send
external _mintAccumulatedFloatMock: (
  t,
  int,
  Ethers.ethAddress,
) => JsPromise.t<_mintAccumulatedFloatMockReturn> = "_mintAccumulatedFloatMock"

type _mintAccumulatedFloatMultiMockReturn
@send
external _mintAccumulatedFloatMultiMock: (
  t,
  array<int>,
  Ethers.ethAddress,
) => JsPromise.t<_mintAccumulatedFloatMultiMockReturn> = "_mintAccumulatedFloatMultiMock"

type _mintFloatMockReturn
@send
external _mintFloatMock: (
  t,
  Ethers.ethAddress,
  Ethers.BigNumber.t,
) => JsPromise.t<_mintFloatMockReturn> = "_mintFloatMock"

type _setRewardObjectsMockReturn
@send
external _setRewardObjectsMock: (
  t,
  int,
  Ethers.BigNumber.t,
  Ethers.BigNumber.t,
  Ethers.BigNumber.t,
  Ethers.BigNumber.t,
) => JsPromise.t<_setRewardObjectsMockReturn> = "_setRewardObjectsMock"

type _stakeMockReturn
@send
external _stakeMock: (
  t,
  Ethers.ethAddress,
  Ethers.BigNumber.t,
  Ethers.ethAddress,
) => JsPromise.t<_stakeMockReturn> = "_stakeMock"

type _withdrawMockReturn
@send
external _withdrawMock: (
  t,
  Ethers.ethAddress,
  Ethers.BigNumber.t,
) => JsPromise.t<_withdrawMockReturn> = "_withdrawMock"

type initializeMockReturn
@send
external initializeMock: (
  t,
  Ethers.ethAddress,
  Ethers.ethAddress,
  Ethers.ethAddress,
  Ethers.ethAddress,
  Ethers.BigNumber.t,
) => JsPromise.t<initializeMockReturn> = "initializeMock"

type shiftTokensMockReturn
@send
external shiftTokensMock: (t, Ethers.BigNumber.t, int, bool) => JsPromise.t<shiftTokensMockReturn> =
  "shiftTokensMock"

type stakeFromUserMockReturn
@send
external stakeFromUserMock: (
  t,
  Ethers.ethAddress,
  Ethers.BigNumber.t,
) => JsPromise.t<stakeFromUserMockReturn> = "stakeFromUserMock"
