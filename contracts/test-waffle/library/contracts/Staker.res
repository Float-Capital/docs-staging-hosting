
@@ocaml.warning("-32")
open SmockGeneral
open ContractHelpers
type t = {address: Ethers.ethAddress}
let contractName = "Staker"

let at: Ethers.ethAddress => JsPromise.t<t> = contractAddress =>
  attachToContract(contractName, ~contractAddress)->Obj.magic

let make: unit => JsPromise.t<t> = () => deployContract0(contractName)->Obj.magic
    let makeSmock: unit => JsPromise.t<t> = () => deployMockContract0(contractName)->Obj.magic

    let setVariable: (t, ~name: string, ~value: 'a) => JsPromise.t<unit> = setVariableRaw
    


  type aDMIN_ROLEReturn = bytes32
  @send
  external aDMIN_ROLE: (
    t,
  ) => JsPromise.t<aDMIN_ROLEReturn> = "ADMIN_ROLE"

  type dEFAULT_ADMIN_ROLEReturn = bytes32
  @send
  external dEFAULT_ADMIN_ROLE: (
    t,
  ) => JsPromise.t<dEFAULT_ADMIN_ROLEReturn> = "DEFAULT_ADMIN_ROLE"

  type dISCOUNT_ROLEReturn = bytes32
  @send
  external dISCOUNT_ROLE: (
    t,
  ) => JsPromise.t<dISCOUNT_ROLEReturn> = "DISCOUNT_ROLE"

  type fLOAT_ISSUANCE_FIXED_DECIMALReturn = Ethers.BigNumber.t
  @send
  external fLOAT_ISSUANCE_FIXED_DECIMAL: (
    t,
  ) => JsPromise.t<fLOAT_ISSUANCE_FIXED_DECIMALReturn> = "FLOAT_ISSUANCE_FIXED_DECIMAL"

  type uPGRADER_ROLEReturn = bytes32
  @send
  external uPGRADER_ROLE: (
    t,
  ) => JsPromise.t<uPGRADER_ROLEReturn> = "UPGRADER_ROLE"

  type accumulativeFloatPerSyntheticTokenSnapshotsReturn = {
timestamp: Ethers.BigNumber.t,
accumulativeFloatPerSyntheticToken_long: Ethers.BigNumber.t,
accumulativeFloatPerSyntheticToken_short: Ethers.BigNumber.t,
    }
  @send
  external accumulativeFloatPerSyntheticTokenSnapshots: (
    t, int, Ethers.BigNumber.t,
  ) => JsPromise.t<accumulativeFloatPerSyntheticTokenSnapshotsReturn> = "accumulativeFloatPerSyntheticTokenSnapshots"

  @send
  external addNewStakingFund: (
    t,~marketIndex: int,~longToken: Ethers.ethAddress,~shortToken: Ethers.ethAddress,~kInitialMultiplier: Ethers.BigNumber.t,~kPeriod: Ethers.BigNumber.t,~unstakeFee_e18: Ethers.BigNumber.t,~balanceIncentiveCurve_exponent: Ethers.BigNumber.t,~balanceIncentiveCurve_equilibriumOffset: Ethers.BigNumber.t,
  ) => JsPromise.t<transaction> = "addNewStakingFund"

  type balanceIncentiveCurve_equilibriumOffsetReturn = Ethers.BigNumber.t
  @send
  external balanceIncentiveCurve_equilibriumOffset: (
    t, int,
  ) => JsPromise.t<balanceIncentiveCurve_equilibriumOffsetReturn> = "balanceIncentiveCurve_equilibriumOffset"

  type balanceIncentiveCurve_exponentReturn = Ethers.BigNumber.t
  @send
  external balanceIncentiveCurve_exponent: (
    t, int,
  ) => JsPromise.t<balanceIncentiveCurve_exponentReturn> = "balanceIncentiveCurve_exponent"

  @send
  external changeBalanceIncentiveParameters: (
    t,~marketIndex: int,~balanceIncentiveCurve_exponent: Ethers.BigNumber.t,~balanceIncentiveCurve_equilibriumOffset: Ethers.BigNumber.t,~safeExponentBitShifting: Ethers.BigNumber.t,
  ) => JsPromise.t<transaction> = "changeBalanceIncentiveParameters"

  @send
  external changeFloatPercentage: (
    t,~newFloatPercentage: Ethers.BigNumber.t,
  ) => JsPromise.t<transaction> = "changeFloatPercentage"

  @send
  external changeUnstakeFee: (
    t,~marketIndex: int,~newMarketUnstakeFee_e18: Ethers.BigNumber.t,
  ) => JsPromise.t<transaction> = "changeUnstakeFee"

  @send
  external claimFloatCustom: (
    t,~marketIndexes: array<int>,
  ) => JsPromise.t<transaction> = "claimFloatCustom"

  @send
  external claimFloatCustomFor: (
    t,~marketIndexes: array<int>,~user: Ethers.ethAddress,
  ) => JsPromise.t<transaction> = "claimFloatCustomFor"

  type floatCapitalReturn = Ethers.ethAddress
  @send
  external floatCapital: (
    t,
  ) => JsPromise.t<floatCapitalReturn> = "floatCapital"

  type floatPercentageReturn = Ethers.BigNumber.t
  @send
  external floatPercentage: (
    t,
  ) => JsPromise.t<floatPercentageReturn> = "floatPercentage"

  type floatTokenReturn = Ethers.ethAddress
  @send
  external floatToken: (
    t,
  ) => JsPromise.t<floatTokenReturn> = "floatToken"

  type floatTreasuryReturn = Ethers.ethAddress
  @send
  external floatTreasury: (
    t,
  ) => JsPromise.t<floatTreasuryReturn> = "floatTreasury"

  type getRoleAdminReturn = bytes32
  @send
  external getRoleAdmin: (
    t,~role: bytes32,
  ) => JsPromise.t<getRoleAdminReturn> = "getRoleAdmin"

  @send
  external grantRole: (
    t,~role: bytes32,~account: Ethers.ethAddress,
  ) => JsPromise.t<transaction> = "grantRole"

  type hasRoleReturn = bool
  @send
  external hasRole: (
    t,~role: bytes32,~account: Ethers.ethAddress,
  ) => JsPromise.t<hasRoleReturn> = "hasRole"

  @send
  external initialize: (
    t,~admin: Ethers.ethAddress,~longShort: Ethers.ethAddress,~floatToken: Ethers.ethAddress,~floatTreasury: Ethers.ethAddress,~floatCapital: Ethers.ethAddress,~discountSigner: Ethers.ethAddress,~floatPercentage: Ethers.BigNumber.t,
  ) => JsPromise.t<transaction> = "initialize"

  type latestRewardIndexReturn = Ethers.BigNumber.t
  @send
  external latestRewardIndex: (
    t, int,
  ) => JsPromise.t<latestRewardIndexReturn> = "latestRewardIndex"

  type longShortReturn = Ethers.ethAddress
  @send
  external longShort: (
    t,
  ) => JsPromise.t<longShortReturn> = "longShort"

  type marketIndexOfTokenReturn = int
  @send
  external marketIndexOfToken: (
    t, Ethers.ethAddress,
  ) => JsPromise.t<marketIndexOfTokenReturn> = "marketIndexOfToken"

  type marketLaunchIncentive_multipliersReturn = Ethers.BigNumber.t
  @send
  external marketLaunchIncentive_multipliers: (
    t, int,
  ) => JsPromise.t<marketLaunchIncentive_multipliersReturn> = "marketLaunchIncentive_multipliers"

  type marketLaunchIncentive_periodReturn = Ethers.BigNumber.t
  @send
  external marketLaunchIncentive_period: (
    t, int,
  ) => JsPromise.t<marketLaunchIncentive_periodReturn> = "marketLaunchIncentive_period"

  type marketUnstakeFee_e18Return = Ethers.BigNumber.t
  @send
  external marketUnstakeFee_e18: (
    t, int,
  ) => JsPromise.t<marketUnstakeFee_e18Return> = "marketUnstakeFee_e18"

  @send
  external pushUpdatedMarketPricesToUpdateFloatIssuanceCalculations: (
    t,~marketIndex: int,~marketUpdateIndex: Ethers.BigNumber.t,~longPrice: Ethers.BigNumber.t,~shortPrice: Ethers.BigNumber.t,~longValue: Ethers.BigNumber.t,~shortValue: Ethers.BigNumber.t,
  ) => JsPromise.t<transaction> = "pushUpdatedMarketPricesToUpdateFloatIssuanceCalculations"

  @send
  external renounceRole: (
    t,~role: bytes32,~account: Ethers.ethAddress,
  ) => JsPromise.t<transaction> = "renounceRole"

  @send
  external revokeRole: (
    t,~role: bytes32,~account: Ethers.ethAddress,
  ) => JsPromise.t<transaction> = "revokeRole"

  type safeExponentBitShiftingReturn = Ethers.BigNumber.t
  @send
  external safeExponentBitShifting: (
    t, int,
  ) => JsPromise.t<safeExponentBitShiftingReturn> = "safeExponentBitShifting"

  @send
  external shiftTokens: (
    t,~amountSyntheticTokensToShift: Ethers.BigNumber.t,~marketIndex: int,~isShiftFromLong: bool,
  ) => JsPromise.t<transaction> = "shiftTokens"

  @send
  external stakeFromUser: (
    t,~from: Ethers.ethAddress,~amount: Ethers.BigNumber.t,
  ) => JsPromise.t<transaction> = "stakeFromUser"

  type supportsInterfaceReturn = bool
  @send
  external supportsInterface: (
    t,~interfaceId: bytes4,
  ) => JsPromise.t<supportsInterfaceReturn> = "supportsInterface"

  type syntheticTokensReturn = Ethers.ethAddress
  @send
  external syntheticTokens: (
    t, int, bool,
  ) => JsPromise.t<syntheticTokensReturn> = "syntheticTokens"

  @send
  external upgradeTo: (
    t,~newImplementation: Ethers.ethAddress,
  ) => JsPromise.t<transaction> = "upgradeTo"

  @send
  external upgradeToAndCall: (
    t,~newImplementation: Ethers.ethAddress,~data: bytes32,
  ) => JsPromise.t<transaction> = "upgradeToAndCall"

  type userAmountStakedReturn = Ethers.BigNumber.t
  @send
  external userAmountStaked: (
    t, Ethers.ethAddress, Ethers.ethAddress,
  ) => JsPromise.t<userAmountStakedReturn> = "userAmountStaked"

  type userIndexOfLastClaimedRewardReturn = Ethers.BigNumber.t
  @send
  external userIndexOfLastClaimedReward: (
    t, int, Ethers.ethAddress,
  ) => JsPromise.t<userIndexOfLastClaimedRewardReturn> = "userIndexOfLastClaimedReward"

  type userNextPrice_amountStakedSyntheticToken_toShiftAwayFromReturn = Ethers.BigNumber.t
  @send
  external userNextPrice_amountStakedSyntheticToken_toShiftAwayFrom: (
    t, int, bool, Ethers.ethAddress,
  ) => JsPromise.t<userNextPrice_amountStakedSyntheticToken_toShiftAwayFromReturn> = "userNextPrice_amountStakedSyntheticToken_toShiftAwayFrom"

  type userNextPrice_stakedSyntheticTokenShiftIndexReturn = Ethers.BigNumber.t
  @send
  external userNextPrice_stakedSyntheticTokenShiftIndex: (
    t, int, Ethers.ethAddress,
  ) => JsPromise.t<userNextPrice_stakedSyntheticTokenShiftIndexReturn> = "userNextPrice_stakedSyntheticTokenShiftIndex"

  type userNonceReturn = int
  @send
  external userNonce: (
    t, Ethers.ethAddress,
  ) => JsPromise.t<userNonceReturn> = "userNonce"

  @send
  external withdraw: (
    t,~marketIndex: int,~isWithdrawFromLong: bool,~amount: Ethers.BigNumber.t,
  ) => JsPromise.t<transaction> = "withdraw"

  @send
  external withdrawAll: (
    t,~marketIndex: int,~isWithdrawFromLong: bool,
  ) => JsPromise.t<transaction> = "withdrawAll"

  @send
  external withdrawWithVoucher: (
    t,~marketIndex: int,~isWithdrawFromLong: bool,~withdrawAmount: Ethers.BigNumber.t,~expiry: Ethers.BigNumber.t,~nonce: Ethers.BigNumber.t,~discountWithdrawFee: Ethers.BigNumber.t,~v: int,~r: bytes32,~s: bytes32,
  ) => JsPromise.t<transaction> = "withdrawWithVoucher"


module Exposed = {
          let contractName = "StakerMockable"

          let make: unit => JsPromise.t<t> = () => deployContract0(contractName)->Obj.magic
    let makeSmock: unit => JsPromise.t<t> = () => deployMockContract0(contractName)->Obj.magic

    let setVariable: (t, ~name: string, ~value: 'a) => JsPromise.t<unit> = setVariableRaw
    
          
  type aDMIN_ROLEReturn = bytes32
  @send
  external aDMIN_ROLE: (
    t,
  ) => JsPromise.t<aDMIN_ROLEReturn> = "ADMIN_ROLE"

  type dEFAULT_ADMIN_ROLEReturn = bytes32
  @send
  external dEFAULT_ADMIN_ROLE: (
    t,
  ) => JsPromise.t<dEFAULT_ADMIN_ROLEReturn> = "DEFAULT_ADMIN_ROLE"

  type dISCOUNT_ROLEReturn = bytes32
  @send
  external dISCOUNT_ROLE: (
    t,
  ) => JsPromise.t<dISCOUNT_ROLEReturn> = "DISCOUNT_ROLE"

  type fLOAT_ISSUANCE_FIXED_DECIMALReturn = Ethers.BigNumber.t
  @send
  external fLOAT_ISSUANCE_FIXED_DECIMAL: (
    t,
  ) => JsPromise.t<fLOAT_ISSUANCE_FIXED_DECIMALReturn> = "FLOAT_ISSUANCE_FIXED_DECIMAL"

  type uPGRADER_ROLEReturn = bytes32
  @send
  external uPGRADER_ROLE: (
    t,
  ) => JsPromise.t<uPGRADER_ROLEReturn> = "UPGRADER_ROLE"

  @send
  external _calculateAccumulatedFloatAndExecuteOutstandingShiftsExposed: (
    t,~marketIndex: int,~user: Ethers.ethAddress,
  ) => JsPromise.t<transaction> = "_calculateAccumulatedFloatAndExecuteOutstandingShiftsExposed"

    type _calculateAccumulatedFloatAndExecuteOutstandingShiftsExposedReturn = Ethers.BigNumber.t
    @send @scope("callStatic")
    external _calculateAccumulatedFloatAndExecuteOutstandingShiftsExposedCall: (
      t,~marketIndex: int,~user: Ethers.ethAddress,
    ) => JsPromise.t<_calculateAccumulatedFloatAndExecuteOutstandingShiftsExposedReturn> = "_calculateAccumulatedFloatAndExecuteOutstandingShiftsExposed"

  type _calculateAccumulatedFloatInRangeExposedReturn = Ethers.BigNumber.t
  @send
  external _calculateAccumulatedFloatInRangeExposed: (
    t,~marketIndex: int,~amountStakedLong: Ethers.BigNumber.t,~amountStakedShort: Ethers.BigNumber.t,~rewardIndexFrom: Ethers.BigNumber.t,~rewardIndexTo: Ethers.BigNumber.t,
  ) => JsPromise.t<_calculateAccumulatedFloatInRangeExposedReturn> = "_calculateAccumulatedFloatInRangeExposed"

  type _calculateFloatPerSecondExposedReturn = {
longFloatPerSecond: Ethers.BigNumber.t,
shortFloatPerSecond: Ethers.BigNumber.t,
    }
  @send
  external _calculateFloatPerSecondExposed: (
    t,~marketIndex: int,~longPrice: Ethers.BigNumber.t,~shortPrice: Ethers.BigNumber.t,~longValue: Ethers.BigNumber.t,~shortValue: Ethers.BigNumber.t,
  ) => JsPromise.t<_calculateFloatPerSecondExposedReturn> = "_calculateFloatPerSecondExposed"

  type _calculateNewCumulativeIssuancePerStakedSynthExposedReturn = {
longCumulativeRates: Ethers.BigNumber.t,
shortCumulativeRates: Ethers.BigNumber.t,
    }
  @send
  external _calculateNewCumulativeIssuancePerStakedSynthExposed: (
    t,~marketIndex: int,~previousMarketUpdateIndex: Ethers.BigNumber.t,~longPrice: Ethers.BigNumber.t,~shortPrice: Ethers.BigNumber.t,~longValue: Ethers.BigNumber.t,~shortValue: Ethers.BigNumber.t,
  ) => JsPromise.t<_calculateNewCumulativeIssuancePerStakedSynthExposedReturn> = "_calculateNewCumulativeIssuancePerStakedSynthExposed"

  type _calculateTimeDeltaFromLastAccumulativeIssuancePerStakedSynthSnapshotExposedReturn = Ethers.BigNumber.t
  @send
  external _calculateTimeDeltaFromLastAccumulativeIssuancePerStakedSynthSnapshotExposed: (
    t,~marketIndex: int,~previousMarketUpdateIndex: Ethers.BigNumber.t,
  ) => JsPromise.t<_calculateTimeDeltaFromLastAccumulativeIssuancePerStakedSynthSnapshotExposedReturn> = "_calculateTimeDeltaFromLastAccumulativeIssuancePerStakedSynthSnapshotExposed"

  @send
  external _changeBalanceIncentiveParametersExposed: (
    t,~marketIndex: int,~balanceIncentiveCurve_exponent: Ethers.BigNumber.t,~balanceIncentiveCurve_equilibriumOffset: Ethers.BigNumber.t,~safeExponentBitShifting: Ethers.BigNumber.t,
  ) => JsPromise.t<transaction> = "_changeBalanceIncentiveParametersExposed"

  @send
  external _changeFloatPercentageExposed: (
    t,~newFloatPercentage: Ethers.BigNumber.t,
  ) => JsPromise.t<transaction> = "_changeFloatPercentageExposed"

  @send
  external _changeUnstakeFeeExposed: (
    t,~marketIndex: int,~newMarketUnstakeFee_e18: Ethers.BigNumber.t,
  ) => JsPromise.t<transaction> = "_changeUnstakeFeeExposed"

  type _getKValueExposedReturn = Ethers.BigNumber.t
  @send
  external _getKValueExposed: (
    t,~marketIndex: int,
  ) => JsPromise.t<_getKValueExposedReturn> = "_getKValueExposed"

  type _getMarketLaunchIncentiveParametersExposedReturn = {
period: Ethers.BigNumber.t,
multiplier: Ethers.BigNumber.t,
    }
  @send
  external _getMarketLaunchIncentiveParametersExposed: (
    t,~marketIndex: int,
  ) => JsPromise.t<_getMarketLaunchIncentiveParametersExposedReturn> = "_getMarketLaunchIncentiveParametersExposed"

  @send
  external _mintAccumulatedFloatAndExecuteOutstandingShiftsExposed: (
    t,~marketIndex: int,~user: Ethers.ethAddress,
  ) => JsPromise.t<transaction> = "_mintAccumulatedFloatAndExecuteOutstandingShiftsExposed"

  @send
  external _mintAccumulatedFloatAndExecuteOutstandingShiftsMultiExposed: (
    t,~marketIndexes: array<int>,~user: Ethers.ethAddress,
  ) => JsPromise.t<transaction> = "_mintAccumulatedFloatAndExecuteOutstandingShiftsMultiExposed"

  @send
  external _mintFloatExposed: (
    t,~user: Ethers.ethAddress,~floatToMint: Ethers.BigNumber.t,
  ) => JsPromise.t<transaction> = "_mintFloatExposed"

  @send
  external _updateUsersStakedPosition_mintAccumulatedFloatAndExecuteOutstandingShiftsExposed: (
    t,~marketIndex: int,~user: Ethers.ethAddress,
  ) => JsPromise.t<transaction> = "_updateUsersStakedPosition_mintAccumulatedFloatAndExecuteOutstandingShiftsExposed"

  @send
  external _withdrawExposed: (
    t,~marketIndex: int,~token: Ethers.ethAddress,~amount: Ethers.BigNumber.t,
  ) => JsPromise.t<transaction> = "_withdrawExposed"

  type accumulativeFloatPerSyntheticTokenSnapshotsReturn = {
timestamp: Ethers.BigNumber.t,
accumulativeFloatPerSyntheticToken_long: Ethers.BigNumber.t,
accumulativeFloatPerSyntheticToken_short: Ethers.BigNumber.t,
    }
  @send
  external accumulativeFloatPerSyntheticTokenSnapshots: (
    t, int, Ethers.BigNumber.t,
  ) => JsPromise.t<accumulativeFloatPerSyntheticTokenSnapshotsReturn> = "accumulativeFloatPerSyntheticTokenSnapshots"

  @send
  external addNewStakingFund: (
    t,~marketIndex: int,~longToken: Ethers.ethAddress,~shortToken: Ethers.ethAddress,~kInitialMultiplier: Ethers.BigNumber.t,~kPeriod: Ethers.BigNumber.t,~unstakeFee_e18: Ethers.BigNumber.t,~balanceIncentiveCurve_exponent: Ethers.BigNumber.t,~balanceIncentiveCurve_equilibriumOffset: Ethers.BigNumber.t,
  ) => JsPromise.t<transaction> = "addNewStakingFund"

  type balanceIncentiveCurve_equilibriumOffsetReturn = Ethers.BigNumber.t
  @send
  external balanceIncentiveCurve_equilibriumOffset: (
    t, int,
  ) => JsPromise.t<balanceIncentiveCurve_equilibriumOffsetReturn> = "balanceIncentiveCurve_equilibriumOffset"

  type balanceIncentiveCurve_exponentReturn = Ethers.BigNumber.t
  @send
  external balanceIncentiveCurve_exponent: (
    t, int,
  ) => JsPromise.t<balanceIncentiveCurve_exponentReturn> = "balanceIncentiveCurve_exponent"

  @send
  external changeBalanceIncentiveParameters: (
    t,~marketIndex: int,~balanceIncentiveCurve_exponent: Ethers.BigNumber.t,~balanceIncentiveCurve_equilibriumOffset: Ethers.BigNumber.t,~safeExponentBitShifting: Ethers.BigNumber.t,
  ) => JsPromise.t<transaction> = "changeBalanceIncentiveParameters"

  @send
  external changeFloatPercentage: (
    t,~newFloatPercentage: Ethers.BigNumber.t,
  ) => JsPromise.t<transaction> = "changeFloatPercentage"

  @send
  external changeUnstakeFee: (
    t,~marketIndex: int,~newMarketUnstakeFee_e18: Ethers.BigNumber.t,
  ) => JsPromise.t<transaction> = "changeUnstakeFee"

  @send
  external claimFloatCustom: (
    t,~marketIndexes: array<int>,
  ) => JsPromise.t<transaction> = "claimFloatCustom"

  @send
  external claimFloatCustomFor: (
    t,~marketIndexes: array<int>,~user: Ethers.ethAddress,
  ) => JsPromise.t<transaction> = "claimFloatCustomFor"

  type floatCapitalReturn = Ethers.ethAddress
  @send
  external floatCapital: (
    t,
  ) => JsPromise.t<floatCapitalReturn> = "floatCapital"

  type floatPercentageReturn = Ethers.BigNumber.t
  @send
  external floatPercentage: (
    t,
  ) => JsPromise.t<floatPercentageReturn> = "floatPercentage"

  type floatTokenReturn = Ethers.ethAddress
  @send
  external floatToken: (
    t,
  ) => JsPromise.t<floatTokenReturn> = "floatToken"

  type floatTreasuryReturn = Ethers.ethAddress
  @send
  external floatTreasury: (
    t,
  ) => JsPromise.t<floatTreasuryReturn> = "floatTreasury"

  type getRequiredAmountOfBitShiftForSafeExponentiationPerfectReturn = Ethers.BigNumber.t
  @send
  external getRequiredAmountOfBitShiftForSafeExponentiationPerfect: (
    t,~number: Ethers.BigNumber.t,~exponent: Ethers.BigNumber.t,
  ) => JsPromise.t<getRequiredAmountOfBitShiftForSafeExponentiationPerfectReturn> = "getRequiredAmountOfBitShiftForSafeExponentiationPerfect"

  type getRoleAdminReturn = bytes32
  @send
  external getRoleAdmin: (
    t,~role: bytes32,
  ) => JsPromise.t<getRoleAdminReturn> = "getRoleAdmin"

  @send
  external grantRole: (
    t,~role: bytes32,~account: Ethers.ethAddress,
  ) => JsPromise.t<transaction> = "grantRole"

  type hasRoleReturn = bool
  @send
  external hasRole: (
    t,~role: bytes32,~account: Ethers.ethAddress,
  ) => JsPromise.t<hasRoleReturn> = "hasRole"

  @send
  external initialize: (
    t,~admin: Ethers.ethAddress,~longShort: Ethers.ethAddress,~floatToken: Ethers.ethAddress,~floatTreasury: Ethers.ethAddress,~floatCapital: Ethers.ethAddress,~discountSigner: Ethers.ethAddress,~floatPercentage: Ethers.BigNumber.t,
  ) => JsPromise.t<transaction> = "initialize"

  type latestRewardIndexReturn = Ethers.BigNumber.t
  @send
  external latestRewardIndex: (
    t, int,
  ) => JsPromise.t<latestRewardIndexReturn> = "latestRewardIndex"

  type longShortReturn = Ethers.ethAddress
  @send
  external longShort: (
    t,
  ) => JsPromise.t<longShortReturn> = "longShort"

  type marketIndexOfTokenReturn = int
  @send
  external marketIndexOfToken: (
    t, Ethers.ethAddress,
  ) => JsPromise.t<marketIndexOfTokenReturn> = "marketIndexOfToken"

  type marketLaunchIncentive_multipliersReturn = Ethers.BigNumber.t
  @send
  external marketLaunchIncentive_multipliers: (
    t, int,
  ) => JsPromise.t<marketLaunchIncentive_multipliersReturn> = "marketLaunchIncentive_multipliers"

  type marketLaunchIncentive_periodReturn = Ethers.BigNumber.t
  @send
  external marketLaunchIncentive_period: (
    t, int,
  ) => JsPromise.t<marketLaunchIncentive_periodReturn> = "marketLaunchIncentive_period"

  type marketUnstakeFee_e18Return = Ethers.BigNumber.t
  @send
  external marketUnstakeFee_e18: (
    t, int,
  ) => JsPromise.t<marketUnstakeFee_e18Return> = "marketUnstakeFee_e18"

  @send
  external onlyAdminModifierLogicExposed: (
    t,
  ) => JsPromise.t<transaction> = "onlyAdminModifierLogicExposed"

  @send
  external onlyLongShortModifierLogicExposed: (
    t,
  ) => JsPromise.t<transaction> = "onlyLongShortModifierLogicExposed"

  @send
  external onlyValidSyntheticModifierLogicExposed: (
    t,~synth: Ethers.ethAddress,
  ) => JsPromise.t<transaction> = "onlyValidSyntheticModifierLogicExposed"

  @send
  external pushUpdatedMarketPricesToUpdateFloatIssuanceCalculations: (
    t,~marketIndex: int,~marketUpdateIndex: Ethers.BigNumber.t,~longPrice: Ethers.BigNumber.t,~shortPrice: Ethers.BigNumber.t,~longValue: Ethers.BigNumber.t,~shortValue: Ethers.BigNumber.t,
  ) => JsPromise.t<transaction> = "pushUpdatedMarketPricesToUpdateFloatIssuanceCalculations"

  @send
  external renounceRole: (
    t,~role: bytes32,~account: Ethers.ethAddress,
  ) => JsPromise.t<transaction> = "renounceRole"

  @send
  external revokeRole: (
    t,~role: bytes32,~account: Ethers.ethAddress,
  ) => JsPromise.t<transaction> = "revokeRole"

  type safeExponentBitShiftingReturn = Ethers.BigNumber.t
  @send
  external safeExponentBitShifting: (
    t, int,
  ) => JsPromise.t<safeExponentBitShiftingReturn> = "safeExponentBitShifting"

  @send
  external setCalculateAccumulatedFloatInRangeGlobals: (
    t,~marketIndex: int,~rewardIndexTo: Ethers.BigNumber.t,~rewardIndexFrom: Ethers.BigNumber.t,~syntheticRewardToLongToken: Ethers.BigNumber.t,~syntheticRewardFromLongToken: Ethers.BigNumber.t,~syntheticRewardToShortToken: Ethers.BigNumber.t,~syntheticRewardFromShortToken: Ethers.BigNumber.t,
  ) => JsPromise.t<transaction> = "setCalculateAccumulatedFloatInRangeGlobals"

  @send
  external setCalculateNewCumulativeRateParams: (
    t,~marketIndex: int,~latestRewardIndexForMarket: Ethers.BigNumber.t,~accumFloatLong: Ethers.BigNumber.t,~accumFloatShort: Ethers.BigNumber.t,
  ) => JsPromise.t<transaction> = "setCalculateNewCumulativeRateParams"

  @send
  external setCalculateTimeDeltaParams: (
    t,~marketIndex: int,~latestRewardIndexForMarket: Ethers.BigNumber.t,~timestamp: Ethers.BigNumber.t,
  ) => JsPromise.t<transaction> = "setCalculateTimeDeltaParams"

  @send
  external setEquilibriumOffset: (
    t,~marketIndex: int,~balanceIncentiveCurve_equilibriumOffset: Ethers.BigNumber.t,
  ) => JsPromise.t<transaction> = "setEquilibriumOffset"

  @send
  external setFloatRewardCalcParams: (
    t,~marketIndex: int,~longToken: Ethers.ethAddress,~shortToken: Ethers.ethAddress,~newLatestRewardIndex: Ethers.BigNumber.t,~user: Ethers.ethAddress,~usersLatestClaimedReward: Ethers.BigNumber.t,~accumulativeFloatPerTokenLatestLong: Ethers.BigNumber.t,~accumulativeFloatPerTokenLatestShort: Ethers.BigNumber.t,~accumulativeFloatPerTokenUserLong: Ethers.BigNumber.t,~accumulativeFloatPerTokenUserShort: Ethers.BigNumber.t,~newUserAmountStakedLong: Ethers.BigNumber.t,~newUserAmountStakedShort: Ethers.BigNumber.t,
  ) => JsPromise.t<transaction> = "setFloatRewardCalcParams"

  @send
  external setFunctionToNotMock: (
    t,~functionToNotMock: string,
  ) => JsPromise.t<transaction> = "setFunctionToNotMock"

  @send
  external setGetKValueParams: (
    t,~marketIndex: int,~timestamp: Ethers.BigNumber.t,
  ) => JsPromise.t<transaction> = "setGetKValueParams"

  @send
  external setGetMarketLaunchIncentiveParametersParams: (
    t,~marketIndex: int,~period: Ethers.BigNumber.t,~multiplier: Ethers.BigNumber.t,
  ) => JsPromise.t<transaction> = "setGetMarketLaunchIncentiveParametersParams"

  @send
  external setLatestRewardIndexGlobals: (
    t,~marketIndex: int,~latestRewardIndex: Ethers.BigNumber.t,
  ) => JsPromise.t<transaction> = "setLatestRewardIndexGlobals"

  @send
  external setLongShort: (
    t,~longShort: Ethers.ethAddress,
  ) => JsPromise.t<transaction> = "setLongShort"

  @send
  external setMintAccumulatedFloatAndClaimFloatParams: (
    t,~marketIndex: int,~latestRewardIndexForMarket: Ethers.BigNumber.t,
  ) => JsPromise.t<transaction> = "setMintAccumulatedFloatAndClaimFloatParams"

  @send
  external setMocker: (
    t,~mocker: Ethers.ethAddress,
  ) => JsPromise.t<transaction> = "setMocker"

  @send
  external setSetRewardObjectsParams: (
    t,~marketIndex: int,~latestRewardIndexForMarket: Ethers.BigNumber.t,
  ) => JsPromise.t<transaction> = "setSetRewardObjectsParams"

  @send
  external setShiftParams: (
    t,~marketIndex: int,~user: Ethers.ethAddress,~shiftAmountLong: Ethers.BigNumber.t,~shiftAmountShort: Ethers.BigNumber.t,~userNextPrice_stakedSyntheticTokenShiftIndex: Ethers.BigNumber.t,~latestRewardIndex: Ethers.BigNumber.t,
  ) => JsPromise.t<transaction> = "setShiftParams"

  @send
  external setShiftTokensParams: (
    t,~marketIndex: int,~isShiftFromLong: bool,~user: Ethers.ethAddress,~amountSyntheticTokensToShift: Ethers.BigNumber.t,~userAmountStaked: Ethers.BigNumber.t,~userNextPrice_stakedSyntheticTokenShiftIndex: Ethers.BigNumber.t,~latestRewardIndex: Ethers.BigNumber.t,~syntheticToken: Ethers.ethAddress,
  ) => JsPromise.t<transaction> = "setShiftTokensParams"

  @send
  external setStakeFromUserParams: (
    t,~longshort: Ethers.ethAddress,~token: Ethers.ethAddress,~marketIndexForToken: int,~user: Ethers.ethAddress,~latestRewardIndex: Ethers.BigNumber.t,~userAmountStaked: Ethers.BigNumber.t,~userLastRewardIndex: Ethers.BigNumber.t,
  ) => JsPromise.t<transaction> = "setStakeFromUserParams"

  @send
  external setWithdrawAllGlobals: (
    t,~marketIndex: int,~longShort: Ethers.ethAddress,~user: Ethers.ethAddress,~amountStaked: Ethers.BigNumber.t,~token: Ethers.ethAddress,~userNextPrice_stakedSyntheticTokenShiftIndex: Ethers.BigNumber.t,~syntheticTokens: Ethers.ethAddress,~userNextPrice_amountStakedSyntheticToken_toShiftAwayFrom_long: Ethers.BigNumber.t,~userNextPrice_amountStakedSyntheticToken_toShiftAwayFrom_short: Ethers.BigNumber.t,
  ) => JsPromise.t<transaction> = "setWithdrawAllGlobals"

  @send
  external setWithdrawGlobals: (
    t,~marketIndex: int,~longShort: Ethers.ethAddress,~token: Ethers.ethAddress,
  ) => JsPromise.t<transaction> = "setWithdrawGlobals"

  @send
  external set_mintFloatParams: (
    t,~floatToken: Ethers.ethAddress,~floatPercentage: int,
  ) => JsPromise.t<transaction> = "set_mintFloatParams"

  @send
  external set_updateStateParams: (
    t,~longShort: Ethers.ethAddress,~token: Ethers.ethAddress,~tokenMarketIndex: int,
  ) => JsPromise.t<transaction> = "set_updateStateParams"

  @send
  external set_withdrawGlobals: (
    t,~marketIndex: int,~syntheticToken: Ethers.ethAddress,~user: Ethers.ethAddress,~amountStaked: Ethers.BigNumber.t,~fees: Ethers.BigNumber.t,~treasury: Ethers.ethAddress,
  ) => JsPromise.t<transaction> = "set_withdrawGlobals"

  @send
  external shiftTokens: (
    t,~amountSyntheticTokensToShift: Ethers.BigNumber.t,~marketIndex: int,~isShiftFromLong: bool,
  ) => JsPromise.t<transaction> = "shiftTokens"

  @send
  external stakeFromUser: (
    t,~from: Ethers.ethAddress,~amount: Ethers.BigNumber.t,
  ) => JsPromise.t<transaction> = "stakeFromUser"

  type supportsInterfaceReturn = bool
  @send
  external supportsInterface: (
    t,~interfaceId: bytes4,
  ) => JsPromise.t<supportsInterfaceReturn> = "supportsInterface"

  type syntheticTokensReturn = Ethers.ethAddress
  @send
  external syntheticTokens: (
    t, int, bool,
  ) => JsPromise.t<syntheticTokensReturn> = "syntheticTokens"

  @send
  external upgradeTo: (
    t,~newImplementation: Ethers.ethAddress,
  ) => JsPromise.t<transaction> = "upgradeTo"

  @send
  external upgradeToAndCall: (
    t,~newImplementation: Ethers.ethAddress,~data: bytes32,
  ) => JsPromise.t<transaction> = "upgradeToAndCall"

  type userAmountStakedReturn = Ethers.BigNumber.t
  @send
  external userAmountStaked: (
    t, Ethers.ethAddress, Ethers.ethAddress,
  ) => JsPromise.t<userAmountStakedReturn> = "userAmountStaked"

  type userIndexOfLastClaimedRewardReturn = Ethers.BigNumber.t
  @send
  external userIndexOfLastClaimedReward: (
    t, int, Ethers.ethAddress,
  ) => JsPromise.t<userIndexOfLastClaimedRewardReturn> = "userIndexOfLastClaimedReward"

  type userNextPrice_amountStakedSyntheticToken_toShiftAwayFromReturn = Ethers.BigNumber.t
  @send
  external userNextPrice_amountStakedSyntheticToken_toShiftAwayFrom: (
    t, int, bool, Ethers.ethAddress,
  ) => JsPromise.t<userNextPrice_amountStakedSyntheticToken_toShiftAwayFromReturn> = "userNextPrice_amountStakedSyntheticToken_toShiftAwayFrom"

  type userNextPrice_stakedSyntheticTokenShiftIndexReturn = Ethers.BigNumber.t
  @send
  external userNextPrice_stakedSyntheticTokenShiftIndex: (
    t, int, Ethers.ethAddress,
  ) => JsPromise.t<userNextPrice_stakedSyntheticTokenShiftIndexReturn> = "userNextPrice_stakedSyntheticTokenShiftIndex"

  type userNonceReturn = int
  @send
  external userNonce: (
    t, Ethers.ethAddress,
  ) => JsPromise.t<userNonceReturn> = "userNonce"

  @send
  external withdraw: (
    t,~marketIndex: int,~isWithdrawFromLong: bool,~amount: Ethers.BigNumber.t,
  ) => JsPromise.t<transaction> = "withdraw"

  @send
  external withdrawAll: (
    t,~marketIndex: int,~isWithdrawFromLong: bool,
  ) => JsPromise.t<transaction> = "withdrawAll"

  @send
  external withdrawWithVoucher: (
    t,~marketIndex: int,~isWithdrawFromLong: bool,~withdrawAmount: Ethers.BigNumber.t,~expiry: Ethers.BigNumber.t,~nonce: Ethers.BigNumber.t,~discountWithdrawFee: Ethers.BigNumber.t,~v: int,~r: bytes32,~s: bytes32,
  ) => JsPromise.t<transaction> = "withdrawWithVoucher"

        }
