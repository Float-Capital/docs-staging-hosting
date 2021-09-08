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

@send
external _calculateAccumulatedFloatExposed: (
  t,
  ~marketIndex: int,
  ~user: Ethers.ethAddress,
) => JsPromise.t<transaction> = "_calculateAccumulatedFloatExposed"

type _calculateAccumulatedFloatExposedReturn = Ethers.BigNumber.t
@send @scope("callStatic")
external _calculateAccumulatedFloatExposedCall: (
  t,
  ~marketIndex: int,
  ~user: Ethers.ethAddress,
) => JsPromise.t<_calculateAccumulatedFloatExposedReturn> = "_calculateAccumulatedFloatExposed"

type _calculateAccumulatedFloatInRangeExposedReturn = Ethers.BigNumber.t
@send
external _calculateAccumulatedFloatInRangeExposed: (
  t,
  ~marketIndex: int,
  ~amountStakedLong: Ethers.BigNumber.t,
  ~amountStakedShort: Ethers.BigNumber.t,
  ~rewardIndexFrom: Ethers.BigNumber.t,
  ~rewardIndexTo: Ethers.BigNumber.t,
) => JsPromise.t<_calculateAccumulatedFloatInRangeExposedReturn> =
  "_calculateAccumulatedFloatInRangeExposed"

type _calculateFloatPerSecondExposedReturn = {
  longFloatPerSecond: Ethers.BigNumber.t,
  shortFloatPerSecond: Ethers.BigNumber.t,
}
@send
external _calculateFloatPerSecondExposed: (
  t,
  ~marketIndex: int,
  ~longPrice: Ethers.BigNumber.t,
  ~shortPrice: Ethers.BigNumber.t,
  ~longValue: Ethers.BigNumber.t,
  ~shortValue: Ethers.BigNumber.t,
) => JsPromise.t<_calculateFloatPerSecondExposedReturn> = "_calculateFloatPerSecondExposed"

type _calculateNewCumulativeIssuancePerStakedSynthExposedReturn = {
  longCumulativeRates: Ethers.BigNumber.t,
  shortCumulativeRates: Ethers.BigNumber.t,
}
@send
external _calculateNewCumulativeIssuancePerStakedSynthExposed: (
  t,
  ~marketIndex: int,
  ~longPrice: Ethers.BigNumber.t,
  ~shortPrice: Ethers.BigNumber.t,
  ~longValue: Ethers.BigNumber.t,
  ~shortValue: Ethers.BigNumber.t,
) => JsPromise.t<_calculateNewCumulativeIssuancePerStakedSynthExposedReturn> =
  "_calculateNewCumulativeIssuancePerStakedSynthExposed"

type _calculateTimeDeltaExposedReturn = Ethers.BigNumber.t
@send
external _calculateTimeDeltaExposed: (
  t,
  ~marketIndex: int,
) => JsPromise.t<_calculateTimeDeltaExposedReturn> = "_calculateTimeDeltaExposed"

@send
external _changBalanceIncentiveEquilibriumOffsetExposed: (
  t,
  ~marketIndex: int,
  ~balanceIncentiveCurveEquilibriumOffset: Ethers.BigNumber.t,
) => JsPromise.t<transaction> = "_changBalanceIncentiveEquilibriumOffsetExposed"

@send
external _changBalanceIncentiveExponentExposed: (
  t,
  ~marketIndex: int,
  ~balanceIncentiveCurveExponent: Ethers.BigNumber.t,
) => JsPromise.t<transaction> = "_changBalanceIncentiveExponentExposed"

@send
external _changeFloatPercentageExposed: (
  t,
  ~newFloatPercentage: Ethers.BigNumber.t,
) => JsPromise.t<transaction> = "_changeFloatPercentageExposed"

@send
external _changeMarketLaunchIncentiveParametersExposed: (
  t,
  ~marketIndex: int,
  ~period: Ethers.BigNumber.t,
  ~initialMultiplier: Ethers.BigNumber.t,
) => JsPromise.t<transaction> = "_changeMarketLaunchIncentiveParametersExposed"

@send
external _changeUnstakeFeeExposed: (
  t,
  ~marketIndex: int,
  ~newMarketUnstakeFeeBasisPoints: Ethers.BigNumber.t,
) => JsPromise.t<transaction> = "_changeUnstakeFeeExposed"

type _getKValueExposedReturn = Ethers.BigNumber.t
@send
external _getKValueExposed: (t, ~marketIndex: int) => JsPromise.t<_getKValueExposedReturn> =
  "_getKValueExposed"

type _getMarketLaunchIncentiveParametersExposedReturn = {
  param0: Ethers.BigNumber.t,
  param1: Ethers.BigNumber.t,
}
@send
external _getMarketLaunchIncentiveParametersExposed: (
  t,
  ~marketIndex: int,
) => JsPromise.t<_getMarketLaunchIncentiveParametersExposedReturn> =
  "_getMarketLaunchIncentiveParametersExposed"

@send
external _mintAccumulatedFloatExposed: (
  t,
  ~marketIndex: int,
  ~user: Ethers.ethAddress,
) => JsPromise.t<transaction> = "_mintAccumulatedFloatExposed"

@send
external _mintAccumulatedFloatMultiExposed: (
  t,
  ~marketIndexes: array<int>,
  ~user: Ethers.ethAddress,
) => JsPromise.t<transaction> = "_mintAccumulatedFloatMultiExposed"

@send
external _mintFloatExposed: (
  t,
  ~user: Ethers.ethAddress,
  ~floatToMint: Ethers.BigNumber.t,
) => JsPromise.t<transaction> = "_mintFloatExposed"

@send
external _setRewardObjectsExposed: (
  t,
  ~marketIndex: int,
  ~longPrice: Ethers.BigNumber.t,
  ~shortPrice: Ethers.BigNumber.t,
  ~longValue: Ethers.BigNumber.t,
  ~shortValue: Ethers.BigNumber.t,
) => JsPromise.t<transaction> = "_setRewardObjectsExposed"

@send
external _stakeExposed: (
  t,
  ~token: Ethers.ethAddress,
  ~amount: Ethers.BigNumber.t,
  ~user: Ethers.ethAddress,
) => JsPromise.t<transaction> = "_stakeExposed"

@send
external _withdrawExposed: (
  t,
  ~token: Ethers.ethAddress,
  ~amount: Ethers.BigNumber.t,
) => JsPromise.t<transaction> = "_withdrawExposed"

@send
external addNewStakingFund: (
  t,
  ~marketIndex: int,
  ~longToken: Ethers.ethAddress,
  ~shortToken: Ethers.ethAddress,
  ~kInitialMultiplier: Ethers.BigNumber.t,
  ~kPeriod: Ethers.BigNumber.t,
  ~unstakeFeeBasisPoints: Ethers.BigNumber.t,
  ~balanceIncentiveCurveExponent: Ethers.BigNumber.t,
  ~balanceIncentiveCurveEquilibriumOffset: Ethers.BigNumber.t,
) => JsPromise.t<transaction> = "addNewStakingFund"

@send
external addNewStateForFloatRewards: (
  t,
  ~marketIndex: int,
  ~longPrice: Ethers.BigNumber.t,
  ~shortPrice: Ethers.BigNumber.t,
  ~longValue: Ethers.BigNumber.t,
  ~shortValue: Ethers.BigNumber.t,
  ~longShortMarketPriceSnapshotIndexIfShiftExecuted: Ethers.BigNumber.t,
) => JsPromise.t<transaction> = "addNewStateForFloatRewards"

type adminReturn = Ethers.ethAddress
@send
external admin: t => JsPromise.t<adminReturn> = "admin"

type amountToShiftFromLongUserReturn = Ethers.BigNumber.t
@send
external amountToShiftFromLongUser: (
  t,
  int,
  Ethers.ethAddress,
) => JsPromise.t<amountToShiftFromLongUserReturn> = "amountToShiftFromLongUser"

type amountToShiftFromShortUserReturn = Ethers.BigNumber.t
@send
external amountToShiftFromShortUser: (
  t,
  int,
  Ethers.ethAddress,
) => JsPromise.t<amountToShiftFromShortUserReturn> = "amountToShiftFromShortUser"

type balanceIncentiveCurveEquilibriumOffsetReturn = Ethers.BigNumber.t
@send
external balanceIncentiveCurveEquilibriumOffset: (
  t,
  int,
) => JsPromise.t<balanceIncentiveCurveEquilibriumOffsetReturn> =
  "balanceIncentiveCurveEquilibriumOffset"

type balanceIncentiveCurveExponentReturn = Ethers.BigNumber.t
@send
external balanceIncentiveCurveExponent: (
  t,
  int,
) => JsPromise.t<balanceIncentiveCurveExponentReturn> = "balanceIncentiveCurveExponent"

@send
external changBalanceIncentiveEquilibriumOffset: (
  t,
  ~marketIndex: int,
  ~balanceIncentiveCurveEquilibriumOffset: Ethers.BigNumber.t,
) => JsPromise.t<transaction> = "changBalanceIncentiveEquilibriumOffset"

@send
external changBalanceIncentiveExponent: (
  t,
  ~marketIndex: int,
  ~balanceIncentiveCurveExponent: Ethers.BigNumber.t,
) => JsPromise.t<transaction> = "changBalanceIncentiveExponent"

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

@send
external claimFloatCustomFor: (
  t,
  ~marketIndexes: array<int>,
  ~user: Ethers.ethAddress,
) => JsPromise.t<transaction> = "claimFloatCustomFor"

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
  ~longShort: Ethers.ethAddress,
  ~floatToken: Ethers.ethAddress,
  ~floatCapital: Ethers.ethAddress,
  ~floatPercentage: Ethers.BigNumber.t,
) => JsPromise.t<transaction> = "initialize"

type latestRewardIndexReturn = Ethers.BigNumber.t
@send
external latestRewardIndex: (t, int) => JsPromise.t<latestRewardIndexReturn> = "latestRewardIndex"

type longShortReturn = Ethers.ethAddress
@send
external longShort: t => JsPromise.t<longShortReturn> = "longShort"

type longShortMarketPriceSnapshotIndexReturn = Ethers.BigNumber.t
@send
external longShortMarketPriceSnapshotIndex: (
  t,
  Ethers.BigNumber.t,
) => JsPromise.t<longShortMarketPriceSnapshotIndexReturn> = "longShortMarketPriceSnapshotIndex"

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

type nextTokenShiftIndexReturn = Ethers.BigNumber.t
@send
external nextTokenShiftIndex: (t, int) => JsPromise.t<nextTokenShiftIndexReturn> =
  "nextTokenShiftIndex"

type safeExponentBitShiftingReturn = Ethers.BigNumber.t
@send
external safeExponentBitShifting: t => JsPromise.t<safeExponentBitShiftingReturn> =
  "safeExponentBitShifting"

@send
external setFunctionToNotMock: (t, ~functionToNotMock: string) => JsPromise.t<transaction> =
  "setFunctionToNotMock"

@send
external setMocker: (t, ~mocker: Ethers.ethAddress) => JsPromise.t<transaction> = "setMocker"

type shiftIndexReturn = Ethers.BigNumber.t
@send
external shiftIndex: (t, int, Ethers.ethAddress) => JsPromise.t<shiftIndexReturn> = "shiftIndex"

@send
external shiftTokens: (
  t,
  ~synthTokensToShift: Ethers.BigNumber.t,
  ~marketIndex: int,
  ~isShiftFromLong: bool,
) => JsPromise.t<transaction> = "shiftTokens"

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

type tokenShiftIndexToStakerStateMappingReturn = Ethers.BigNumber.t
@send
external tokenShiftIndexToStakerStateMapping: (
  t,
  Ethers.BigNumber.t,
) => JsPromise.t<tokenShiftIndexToStakerStateMappingReturn> = "tokenShiftIndexToStakerStateMapping"

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
