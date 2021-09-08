open SmockGeneral

%%raw(`
const { expect, use } = require("chai");
use(require('@defi-wonderland/smock').smock.matchers);
`)

type t = {address: Ethers.ethAddress}

@module("@defi-wonderland/smock") @scope("smock")
external makeRaw: string => Js.Promise.t<t> = "fake"
let make = () => makeRaw("Staker")

let uninitializedValue: t = None->Obj.magic

@send @scope("ADMIN_ROLE")
external mockADMIN_ROLEToReturn: (t, string) => unit = "returns"

type aDMIN_ROLECall

let aDMIN_ROLEOld: t => array<aDMIN_ROLECall> = _r => {
  let array = %raw("_r.ADMIN_ROLE.calls")
  array->Array.map(() => {
    ()->Obj.magic
  })
}

@send @scope(("to", "have", "been"))
external aDMIN_ROLECalledWith: expectation => unit = "calledWith"

@get external aDMIN_ROLEFunction: t => string = "aDMIN_ROLE"

let aDMIN_ROLECallCheck = contract => {
  expect(contract->aDMIN_ROLEFunction)->aDMIN_ROLECalledWith
}

@send @scope("ADMIN_ROLE")
external mockADMIN_ROLEToRevert: (t, ~errorString: string) => unit = "returns"

@send @scope("ADMIN_ROLE")
external mockADMIN_ROLEToRevertNoReason: t => unit = "reverts"

@send @scope("DEFAULT_ADMIN_ROLE")
external mockDEFAULT_ADMIN_ROLEToReturn: (t, string) => unit = "returns"

type dEFAULT_ADMIN_ROLECall

let dEFAULT_ADMIN_ROLEOld: t => array<dEFAULT_ADMIN_ROLECall> = _r => {
  let array = %raw("_r.DEFAULT_ADMIN_ROLE.calls")
  array->Array.map(() => {
    ()->Obj.magic
  })
}

@send @scope(("to", "have", "been"))
external dEFAULT_ADMIN_ROLECalledWith: expectation => unit = "calledWith"

@get external dEFAULT_ADMIN_ROLEFunction: t => string = "dEFAULT_ADMIN_ROLE"

let dEFAULT_ADMIN_ROLECallCheck = contract => {
  expect(contract->dEFAULT_ADMIN_ROLEFunction)->dEFAULT_ADMIN_ROLECalledWith
}

@send @scope("DEFAULT_ADMIN_ROLE")
external mockDEFAULT_ADMIN_ROLEToRevert: (t, ~errorString: string) => unit = "returns"

@send @scope("DEFAULT_ADMIN_ROLE")
external mockDEFAULT_ADMIN_ROLEToRevertNoReason: t => unit = "reverts"

@send @scope("DISCOUNT_ROLE")
external mockDISCOUNT_ROLEToReturn: (t, string) => unit = "returns"

type dISCOUNT_ROLECall

let dISCOUNT_ROLEOld: t => array<dISCOUNT_ROLECall> = _r => {
  let array = %raw("_r.DISCOUNT_ROLE.calls")
  array->Array.map(() => {
    ()->Obj.magic
  })
}

@send @scope(("to", "have", "been"))
external dISCOUNT_ROLECalledWith: expectation => unit = "calledWith"

@get external dISCOUNT_ROLEFunction: t => string = "dISCOUNT_ROLE"

let dISCOUNT_ROLECallCheck = contract => {
  expect(contract->dISCOUNT_ROLEFunction)->dISCOUNT_ROLECalledWith
}

@send @scope("DISCOUNT_ROLE")
external mockDISCOUNT_ROLEToRevert: (t, ~errorString: string) => unit = "returns"

@send @scope("DISCOUNT_ROLE")
external mockDISCOUNT_ROLEToRevertNoReason: t => unit = "reverts"

@send @scope("FLOAT_ISSUANCE_FIXED_DECIMAL")
external mockFLOAT_ISSUANCE_FIXED_DECIMALToReturn: (t, Ethers.BigNumber.t) => unit = "returns"

type fLOAT_ISSUANCE_FIXED_DECIMALCall

let fLOAT_ISSUANCE_FIXED_DECIMALOld: t => array<fLOAT_ISSUANCE_FIXED_DECIMALCall> = _r => {
  let array = %raw("_r.FLOAT_ISSUANCE_FIXED_DECIMAL.calls")
  array->Array.map(() => {
    ()->Obj.magic
  })
}

@send @scope(("to", "have", "been"))
external fLOAT_ISSUANCE_FIXED_DECIMALCalledWith: expectation => unit = "calledWith"

@get external fLOAT_ISSUANCE_FIXED_DECIMALFunction: t => string = "fLOAT_ISSUANCE_FIXED_DECIMAL"

let fLOAT_ISSUANCE_FIXED_DECIMALCallCheck = contract => {
  expect(contract->fLOAT_ISSUANCE_FIXED_DECIMALFunction)->fLOAT_ISSUANCE_FIXED_DECIMALCalledWith
}

@send @scope("FLOAT_ISSUANCE_FIXED_DECIMAL")
external mockFLOAT_ISSUANCE_FIXED_DECIMALToRevert: (t, ~errorString: string) => unit = "returns"

@send @scope("FLOAT_ISSUANCE_FIXED_DECIMAL")
external mockFLOAT_ISSUANCE_FIXED_DECIMALToRevertNoReason: t => unit = "reverts"

@send @scope("UPGRADER_ROLE")
external mockUPGRADER_ROLEToReturn: (t, string) => unit = "returns"

type uPGRADER_ROLECall

let uPGRADER_ROLEOld: t => array<uPGRADER_ROLECall> = _r => {
  let array = %raw("_r.UPGRADER_ROLE.calls")
  array->Array.map(() => {
    ()->Obj.magic
  })
}

@send @scope(("to", "have", "been"))
external uPGRADER_ROLECalledWith: expectation => unit = "calledWith"

@get external uPGRADER_ROLEFunction: t => string = "uPGRADER_ROLE"

let uPGRADER_ROLECallCheck = contract => {
  expect(contract->uPGRADER_ROLEFunction)->uPGRADER_ROLECalledWith
}

@send @scope("UPGRADER_ROLE")
external mockUPGRADER_ROLEToRevert: (t, ~errorString: string) => unit = "returns"

@send @scope("UPGRADER_ROLE")
external mockUPGRADER_ROLEToRevertNoReason: t => unit = "reverts"

@send @scope("accumulativeFloatPerSyntheticTokenSnapshots")
external mockAccumulativeFloatPerSyntheticTokenSnapshotsToReturn: (
  t,
  (Ethers.BigNumber.t, Ethers.BigNumber.t, Ethers.BigNumber.t),
) => unit = "returns"

type accumulativeFloatPerSyntheticTokenSnapshotsCall = {
  param0: int,
  param1: Ethers.BigNumber.t,
}

let accumulativeFloatPerSyntheticTokenSnapshotsOld: t => array<
  accumulativeFloatPerSyntheticTokenSnapshotsCall,
> = _r => {
  let array = %raw("_r.accumulativeFloatPerSyntheticTokenSnapshots.calls")
  array->Array.map(((param0, param1)) => {
    {
      param0: param0,
      param1: param1,
    }
  })
}

@send @scope(("to", "have", "been"))
external accumulativeFloatPerSyntheticTokenSnapshotsCalledWith: (
  expectation,
  int,
  Ethers.BigNumber.t,
) => unit = "calledWith"

@get
external accumulativeFloatPerSyntheticTokenSnapshotsFunction: t => string =
  "accumulativeFloatPerSyntheticTokenSnapshots"

let accumulativeFloatPerSyntheticTokenSnapshotsCallCheck = (
  contract,
  {param0, param1}: accumulativeFloatPerSyntheticTokenSnapshotsCall,
) => {
  expect(
    contract->accumulativeFloatPerSyntheticTokenSnapshotsFunction,
  )->accumulativeFloatPerSyntheticTokenSnapshotsCalledWith(param0, param1)
}

@send @scope("accumulativeFloatPerSyntheticTokenSnapshots")
external mockAccumulativeFloatPerSyntheticTokenSnapshotsToRevert: (
  t,
  ~errorString: string,
) => unit = "returns"

@send @scope("accumulativeFloatPerSyntheticTokenSnapshots")
external mockAccumulativeFloatPerSyntheticTokenSnapshotsToRevertNoReason: t => unit = "reverts"

type addNewStakingFundCall = {
  marketIndex: int,
  longToken: Ethers.ethAddress,
  shortToken: Ethers.ethAddress,
  kInitialMultiplier: Ethers.BigNumber.t,
  kPeriod: Ethers.BigNumber.t,
  unstakeFee_e18: Ethers.BigNumber.t,
  balanceIncentiveCurve_exponent: Ethers.BigNumber.t,
  balanceIncentiveCurve_equilibriumOffset: Ethers.BigNumber.t,
}

let addNewStakingFundOld: t => array<addNewStakingFundCall> = _r => {
  let array = %raw("_r.addNewStakingFund.calls")
  array->Array.map(((
    marketIndex,
    longToken,
    shortToken,
    kInitialMultiplier,
    kPeriod,
    unstakeFee_e18,
    balanceIncentiveCurve_exponent,
    balanceIncentiveCurve_equilibriumOffset,
  )) => {
    {
      marketIndex: marketIndex,
      longToken: longToken,
      shortToken: shortToken,
      kInitialMultiplier: kInitialMultiplier,
      kPeriod: kPeriod,
      unstakeFee_e18: unstakeFee_e18,
      balanceIncentiveCurve_exponent: balanceIncentiveCurve_exponent,
      balanceIncentiveCurve_equilibriumOffset: balanceIncentiveCurve_equilibriumOffset,
    }
  })
}

@send @scope(("to", "have", "been"))
external addNewStakingFundCalledWith: (
  expectation,
  int,
  Ethers.ethAddress,
  Ethers.ethAddress,
  Ethers.BigNumber.t,
  Ethers.BigNumber.t,
  Ethers.BigNumber.t,
  Ethers.BigNumber.t,
  Ethers.BigNumber.t,
) => unit = "calledWith"

@get external addNewStakingFundFunction: t => string = "addNewStakingFund"

let addNewStakingFundCallCheck = (
  contract,
  {
    marketIndex,
    longToken,
    shortToken,
    kInitialMultiplier,
    kPeriod,
    unstakeFee_e18,
    balanceIncentiveCurve_exponent,
    balanceIncentiveCurve_equilibriumOffset,
  }: addNewStakingFundCall,
) => {
  expect(contract->addNewStakingFundFunction)->addNewStakingFundCalledWith(
    marketIndex,
    longToken,
    shortToken,
    kInitialMultiplier,
    kPeriod,
    unstakeFee_e18,
    balanceIncentiveCurve_exponent,
    balanceIncentiveCurve_equilibriumOffset,
  )
}

@send @scope("addNewStakingFund")
external mockAddNewStakingFundToRevert: (t, ~errorString: string) => unit = "returns"

@send @scope("addNewStakingFund")
external mockAddNewStakingFundToRevertNoReason: t => unit = "reverts"

@send @scope("balanceIncentiveCurve_equilibriumOffset")
external mockBalanceIncentiveCurve_equilibriumOffsetToReturn: (t, Ethers.BigNumber.t) => unit =
  "returns"

type balanceIncentiveCurve_equilibriumOffsetCall = {param0: int}

let balanceIncentiveCurve_equilibriumOffsetOld: t => array<
  balanceIncentiveCurve_equilibriumOffsetCall,
> = _r => {
  let array = %raw("_r.balanceIncentiveCurve_equilibriumOffset.calls")
  array->Array.map(_m => {
    let param0 = _m->Array.getUnsafe(0)

    {
      param0: param0,
    }
  })
}

@send @scope(("to", "have", "been"))
external balanceIncentiveCurve_equilibriumOffsetCalledWith: (expectation, int) => unit =
  "calledWith"

@get
external balanceIncentiveCurve_equilibriumOffsetFunction: t => string =
  "balanceIncentiveCurve_equilibriumOffset"

let balanceIncentiveCurve_equilibriumOffsetCallCheck = (
  contract,
  {param0}: balanceIncentiveCurve_equilibriumOffsetCall,
) => {
  expect(
    contract->balanceIncentiveCurve_equilibriumOffsetFunction,
  )->balanceIncentiveCurve_equilibriumOffsetCalledWith(param0)
}

@send @scope("balanceIncentiveCurve_equilibriumOffset")
external mockBalanceIncentiveCurve_equilibriumOffsetToRevert: (t, ~errorString: string) => unit =
  "returns"

@send @scope("balanceIncentiveCurve_equilibriumOffset")
external mockBalanceIncentiveCurve_equilibriumOffsetToRevertNoReason: t => unit = "reverts"

@send @scope("balanceIncentiveCurve_exponent")
external mockBalanceIncentiveCurve_exponentToReturn: (t, Ethers.BigNumber.t) => unit = "returns"

type balanceIncentiveCurve_exponentCall = {param0: int}

let balanceIncentiveCurve_exponentOld: t => array<balanceIncentiveCurve_exponentCall> = _r => {
  let array = %raw("_r.balanceIncentiveCurve_exponent.calls")
  array->Array.map(_m => {
    let param0 = _m->Array.getUnsafe(0)

    {
      param0: param0,
    }
  })
}

@send @scope(("to", "have", "been"))
external balanceIncentiveCurve_exponentCalledWith: (expectation, int) => unit = "calledWith"

@get external balanceIncentiveCurve_exponentFunction: t => string = "balanceIncentiveCurve_exponent"

let balanceIncentiveCurve_exponentCallCheck = (
  contract,
  {param0}: balanceIncentiveCurve_exponentCall,
) => {
  expect(
    contract->balanceIncentiveCurve_exponentFunction,
  )->balanceIncentiveCurve_exponentCalledWith(param0)
}

@send @scope("balanceIncentiveCurve_exponent")
external mockBalanceIncentiveCurve_exponentToRevert: (t, ~errorString: string) => unit = "returns"

@send @scope("balanceIncentiveCurve_exponent")
external mockBalanceIncentiveCurve_exponentToRevertNoReason: t => unit = "reverts"

type changeBalanceIncentiveParametersCall = {
  marketIndex: int,
  balanceIncentiveCurve_exponent: Ethers.BigNumber.t,
  balanceIncentiveCurve_equilibriumOffset: Ethers.BigNumber.t,
  safeExponentBitShifting: Ethers.BigNumber.t,
}

let changeBalanceIncentiveParametersOld: t => array<changeBalanceIncentiveParametersCall> = _r => {
  let array = %raw("_r.changeBalanceIncentiveParameters.calls")
  array->Array.map(((
    marketIndex,
    balanceIncentiveCurve_exponent,
    balanceIncentiveCurve_equilibriumOffset,
    safeExponentBitShifting,
  )) => {
    {
      marketIndex: marketIndex,
      balanceIncentiveCurve_exponent: balanceIncentiveCurve_exponent,
      balanceIncentiveCurve_equilibriumOffset: balanceIncentiveCurve_equilibriumOffset,
      safeExponentBitShifting: safeExponentBitShifting,
    }
  })
}

@send @scope(("to", "have", "been"))
external changeBalanceIncentiveParametersCalledWith: (
  expectation,
  int,
  Ethers.BigNumber.t,
  Ethers.BigNumber.t,
  Ethers.BigNumber.t,
) => unit = "calledWith"

@get
external changeBalanceIncentiveParametersFunction: t => string = "changeBalanceIncentiveParameters"

let changeBalanceIncentiveParametersCallCheck = (
  contract,
  {
    marketIndex,
    balanceIncentiveCurve_exponent,
    balanceIncentiveCurve_equilibriumOffset,
    safeExponentBitShifting,
  }: changeBalanceIncentiveParametersCall,
) => {
  expect(
    contract->changeBalanceIncentiveParametersFunction,
  )->changeBalanceIncentiveParametersCalledWith(
    marketIndex,
    balanceIncentiveCurve_exponent,
    balanceIncentiveCurve_equilibriumOffset,
    safeExponentBitShifting,
  )
}

@send @scope("changeBalanceIncentiveParameters")
external mockChangeBalanceIncentiveParametersToRevert: (t, ~errorString: string) => unit = "returns"

@send @scope("changeBalanceIncentiveParameters")
external mockChangeBalanceIncentiveParametersToRevertNoReason: t => unit = "reverts"

type changeFloatPercentageCall = {newFloatPercentage: Ethers.BigNumber.t}

let changeFloatPercentageOld: t => array<changeFloatPercentageCall> = _r => {
  let array = %raw("_r.changeFloatPercentage.calls")
  array->Array.map(_m => {
    let newFloatPercentage = _m->Array.getUnsafe(0)

    {
      newFloatPercentage: newFloatPercentage,
    }
  })
}

@send @scope(("to", "have", "been"))
external changeFloatPercentageCalledWith: (expectation, Ethers.BigNumber.t) => unit = "calledWith"

@get external changeFloatPercentageFunction: t => string = "changeFloatPercentage"

let changeFloatPercentageCallCheck = (
  contract,
  {newFloatPercentage}: changeFloatPercentageCall,
) => {
  expect(contract->changeFloatPercentageFunction)->changeFloatPercentageCalledWith(
    newFloatPercentage,
  )
}

@send @scope("changeFloatPercentage")
external mockChangeFloatPercentageToRevert: (t, ~errorString: string) => unit = "returns"

@send @scope("changeFloatPercentage")
external mockChangeFloatPercentageToRevertNoReason: t => unit = "reverts"

type changeUnstakeFeeCall = {
  marketIndex: int,
  newMarketUnstakeFee_e18: Ethers.BigNumber.t,
}

let changeUnstakeFeeOld: t => array<changeUnstakeFeeCall> = _r => {
  let array = %raw("_r.changeUnstakeFee.calls")
  array->Array.map(((marketIndex, newMarketUnstakeFee_e18)) => {
    {
      marketIndex: marketIndex,
      newMarketUnstakeFee_e18: newMarketUnstakeFee_e18,
    }
  })
}

@send @scope(("to", "have", "been"))
external changeUnstakeFeeCalledWith: (expectation, int, Ethers.BigNumber.t) => unit = "calledWith"

@get external changeUnstakeFeeFunction: t => string = "changeUnstakeFee"

let changeUnstakeFeeCallCheck = (
  contract,
  {marketIndex, newMarketUnstakeFee_e18}: changeUnstakeFeeCall,
) => {
  expect(contract->changeUnstakeFeeFunction)->changeUnstakeFeeCalledWith(
    marketIndex,
    newMarketUnstakeFee_e18,
  )
}

@send @scope("changeUnstakeFee")
external mockChangeUnstakeFeeToRevert: (t, ~errorString: string) => unit = "returns"

@send @scope("changeUnstakeFee")
external mockChangeUnstakeFeeToRevertNoReason: t => unit = "reverts"

type claimFloatCustomCall = {marketIndexes: array<int>}

let claimFloatCustomOld: t => array<claimFloatCustomCall> = _r => {
  let array = %raw("_r.claimFloatCustom.calls")
  array->Array.map(_m => {
    let marketIndexes = _m->Array.getUnsafe(0)

    {
      marketIndexes: marketIndexes,
    }
  })
}

@send @scope(("to", "have", "been"))
external claimFloatCustomCalledWith: (expectation, array<int>) => unit = "calledWith"

@get external claimFloatCustomFunction: t => string = "claimFloatCustom"

let claimFloatCustomCallCheck = (contract, {marketIndexes}: claimFloatCustomCall) => {
  expect(contract->claimFloatCustomFunction)->claimFloatCustomCalledWith(marketIndexes)
}

@send @scope("claimFloatCustom")
external mockClaimFloatCustomToRevert: (t, ~errorString: string) => unit = "returns"

@send @scope("claimFloatCustom")
external mockClaimFloatCustomToRevertNoReason: t => unit = "reverts"

type claimFloatCustomForCall = {
  marketIndexes: array<int>,
  user: Ethers.ethAddress,
}

let claimFloatCustomForOld: t => array<claimFloatCustomForCall> = _r => {
  let array = %raw("_r.claimFloatCustomFor.calls")
  array->Array.map(((marketIndexes, user)) => {
    {
      marketIndexes: marketIndexes,
      user: user,
    }
  })
}

@send @scope(("to", "have", "been"))
external claimFloatCustomForCalledWith: (expectation, array<int>, Ethers.ethAddress) => unit =
  "calledWith"

@get external claimFloatCustomForFunction: t => string = "claimFloatCustomFor"

let claimFloatCustomForCallCheck = (contract, {marketIndexes, user}: claimFloatCustomForCall) => {
  expect(contract->claimFloatCustomForFunction)->claimFloatCustomForCalledWith(marketIndexes, user)
}

@send @scope("claimFloatCustomFor")
external mockClaimFloatCustomForToRevert: (t, ~errorString: string) => unit = "returns"

@send @scope("claimFloatCustomFor")
external mockClaimFloatCustomForToRevertNoReason: t => unit = "reverts"

@send @scope("floatCapital")
external mockFloatCapitalToReturn: (t, Ethers.ethAddress) => unit = "returns"

type floatCapitalCall

let floatCapitalOld: t => array<floatCapitalCall> = _r => {
  let array = %raw("_r.floatCapital.calls")
  array->Array.map(() => {
    ()->Obj.magic
  })
}

@send @scope(("to", "have", "been"))
external floatCapitalCalledWith: expectation => unit = "calledWith"

@get external floatCapitalFunction: t => string = "floatCapital"

let floatCapitalCallCheck = contract => {
  expect(contract->floatCapitalFunction)->floatCapitalCalledWith
}

@send @scope("floatCapital")
external mockFloatCapitalToRevert: (t, ~errorString: string) => unit = "returns"

@send @scope("floatCapital")
external mockFloatCapitalToRevertNoReason: t => unit = "reverts"

@send @scope("floatPercentage")
external mockFloatPercentageToReturn: (t, Ethers.BigNumber.t) => unit = "returns"

type floatPercentageCall

let floatPercentageOld: t => array<floatPercentageCall> = _r => {
  let array = %raw("_r.floatPercentage.calls")
  array->Array.map(() => {
    ()->Obj.magic
  })
}

@send @scope(("to", "have", "been"))
external floatPercentageCalledWith: expectation => unit = "calledWith"

@get external floatPercentageFunction: t => string = "floatPercentage"

let floatPercentageCallCheck = contract => {
  expect(contract->floatPercentageFunction)->floatPercentageCalledWith
}

@send @scope("floatPercentage")
external mockFloatPercentageToRevert: (t, ~errorString: string) => unit = "returns"

@send @scope("floatPercentage")
external mockFloatPercentageToRevertNoReason: t => unit = "reverts"

@send @scope("floatToken")
external mockFloatTokenToReturn: (t, Ethers.ethAddress) => unit = "returns"

type floatTokenCall

let floatTokenOld: t => array<floatTokenCall> = _r => {
  let array = %raw("_r.floatToken.calls")
  array->Array.map(() => {
    ()->Obj.magic
  })
}

@send @scope(("to", "have", "been"))
external floatTokenCalledWith: expectation => unit = "calledWith"

@get external floatTokenFunction: t => string = "floatToken"

let floatTokenCallCheck = contract => {
  expect(contract->floatTokenFunction)->floatTokenCalledWith
}

@send @scope("floatToken")
external mockFloatTokenToRevert: (t, ~errorString: string) => unit = "returns"

@send @scope("floatToken")
external mockFloatTokenToRevertNoReason: t => unit = "reverts"

@send @scope("floatTreasury")
external mockFloatTreasuryToReturn: (t, Ethers.ethAddress) => unit = "returns"

type floatTreasuryCall

let floatTreasuryOld: t => array<floatTreasuryCall> = _r => {
  let array = %raw("_r.floatTreasury.calls")
  array->Array.map(() => {
    ()->Obj.magic
  })
}

@send @scope(("to", "have", "been"))
external floatTreasuryCalledWith: expectation => unit = "calledWith"

@get external floatTreasuryFunction: t => string = "floatTreasury"

let floatTreasuryCallCheck = contract => {
  expect(contract->floatTreasuryFunction)->floatTreasuryCalledWith
}

@send @scope("floatTreasury")
external mockFloatTreasuryToRevert: (t, ~errorString: string) => unit = "returns"

@send @scope("floatTreasury")
external mockFloatTreasuryToRevertNoReason: t => unit = "reverts"

@send @scope("getRoleAdmin")
external mockGetRoleAdminToReturn: (t, string) => unit = "returns"

type getRoleAdminCall = {role: string}

let getRoleAdminOld: t => array<getRoleAdminCall> = _r => {
  let array = %raw("_r.getRoleAdmin.calls")
  array->Array.map(_m => {
    let role = _m->Array.getUnsafe(0)

    {
      role: role,
    }
  })
}

@send @scope(("to", "have", "been"))
external getRoleAdminCalledWith: (expectation, string) => unit = "calledWith"

@get external getRoleAdminFunction: t => string = "getRoleAdmin"

let getRoleAdminCallCheck = (contract, {role}: getRoleAdminCall) => {
  expect(contract->getRoleAdminFunction)->getRoleAdminCalledWith(role)
}

@send @scope("getRoleAdmin")
external mockGetRoleAdminToRevert: (t, ~errorString: string) => unit = "returns"

@send @scope("getRoleAdmin")
external mockGetRoleAdminToRevertNoReason: t => unit = "reverts"

type grantRoleCall = {
  role: string,
  account: Ethers.ethAddress,
}

let grantRoleOld: t => array<grantRoleCall> = _r => {
  let array = %raw("_r.grantRole.calls")
  array->Array.map(((role, account)) => {
    {
      role: role,
      account: account,
    }
  })
}

@send @scope(("to", "have", "been"))
external grantRoleCalledWith: (expectation, string, Ethers.ethAddress) => unit = "calledWith"

@get external grantRoleFunction: t => string = "grantRole"

let grantRoleCallCheck = (contract, {role, account}: grantRoleCall) => {
  expect(contract->grantRoleFunction)->grantRoleCalledWith(role, account)
}

@send @scope("grantRole")
external mockGrantRoleToRevert: (t, ~errorString: string) => unit = "returns"

@send @scope("grantRole")
external mockGrantRoleToRevertNoReason: t => unit = "reverts"

@send @scope("hasRole")
external mockHasRoleToReturn: (t, bool) => unit = "returns"

type hasRoleCall = {
  role: string,
  account: Ethers.ethAddress,
}

let hasRoleOld: t => array<hasRoleCall> = _r => {
  let array = %raw("_r.hasRole.calls")
  array->Array.map(((role, account)) => {
    {
      role: role,
      account: account,
    }
  })
}

@send @scope(("to", "have", "been"))
external hasRoleCalledWith: (expectation, string, Ethers.ethAddress) => unit = "calledWith"

@get external hasRoleFunction: t => string = "hasRole"

let hasRoleCallCheck = (contract, {role, account}: hasRoleCall) => {
  expect(contract->hasRoleFunction)->hasRoleCalledWith(role, account)
}

@send @scope("hasRole")
external mockHasRoleToRevert: (t, ~errorString: string) => unit = "returns"

@send @scope("hasRole")
external mockHasRoleToRevertNoReason: t => unit = "reverts"

type initializeCall = {
  admin: Ethers.ethAddress,
  longShort: Ethers.ethAddress,
  floatToken: Ethers.ethAddress,
  floatTreasury: Ethers.ethAddress,
  floatCapital: Ethers.ethAddress,
  discountSigner: Ethers.ethAddress,
  floatPercentage: Ethers.BigNumber.t,
}

let initializeOld: t => array<initializeCall> = _r => {
  let array = %raw("_r.initialize.calls")
  array->Array.map(((
    admin,
    longShort,
    floatToken,
    floatTreasury,
    floatCapital,
    discountSigner,
    floatPercentage,
  )) => {
    {
      admin: admin,
      longShort: longShort,
      floatToken: floatToken,
      floatTreasury: floatTreasury,
      floatCapital: floatCapital,
      discountSigner: discountSigner,
      floatPercentage: floatPercentage,
    }
  })
}

@send @scope(("to", "have", "been"))
external initializeCalledWith: (
  expectation,
  Ethers.ethAddress,
  Ethers.ethAddress,
  Ethers.ethAddress,
  Ethers.ethAddress,
  Ethers.ethAddress,
  Ethers.ethAddress,
  Ethers.BigNumber.t,
) => unit = "calledWith"

@get external initializeFunction: t => string = "initialize"

let initializeCallCheck = (
  contract,
  {
    admin,
    longShort,
    floatToken,
    floatTreasury,
    floatCapital,
    discountSigner,
    floatPercentage,
  }: initializeCall,
) => {
  expect(contract->initializeFunction)->initializeCalledWith(
    admin,
    longShort,
    floatToken,
    floatTreasury,
    floatCapital,
    discountSigner,
    floatPercentage,
  )
}

@send @scope("initialize")
external mockInitializeToRevert: (t, ~errorString: string) => unit = "returns"

@send @scope("initialize")
external mockInitializeToRevertNoReason: t => unit = "reverts"

@send @scope("latestRewardIndex")
external mockLatestRewardIndexToReturn: (t, Ethers.BigNumber.t) => unit = "returns"

type latestRewardIndexCall = {param0: int}

let latestRewardIndexOld: t => array<latestRewardIndexCall> = _r => {
  let array = %raw("_r.latestRewardIndex.calls")
  array->Array.map(_m => {
    let param0 = _m->Array.getUnsafe(0)

    {
      param0: param0,
    }
  })
}

@send @scope(("to", "have", "been"))
external latestRewardIndexCalledWith: (expectation, int) => unit = "calledWith"

@get external latestRewardIndexFunction: t => string = "latestRewardIndex"

let latestRewardIndexCallCheck = (contract, {param0}: latestRewardIndexCall) => {
  expect(contract->latestRewardIndexFunction)->latestRewardIndexCalledWith(param0)
}

@send @scope("latestRewardIndex")
external mockLatestRewardIndexToRevert: (t, ~errorString: string) => unit = "returns"

@send @scope("latestRewardIndex")
external mockLatestRewardIndexToRevertNoReason: t => unit = "reverts"

@send @scope("longShort")
external mockLongShortToReturn: (t, Ethers.ethAddress) => unit = "returns"

type longShortCall

let longShortOld: t => array<longShortCall> = _r => {
  let array = %raw("_r.longShort.calls")
  array->Array.map(() => {
    ()->Obj.magic
  })
}

@send @scope(("to", "have", "been"))
external longShortCalledWith: expectation => unit = "calledWith"

@get external longShortFunction: t => string = "longShort"

let longShortCallCheck = contract => {
  expect(contract->longShortFunction)->longShortCalledWith
}

@send @scope("longShort")
external mockLongShortToRevert: (t, ~errorString: string) => unit = "returns"

@send @scope("longShort")
external mockLongShortToRevertNoReason: t => unit = "reverts"

@send @scope("marketIndexOfToken")
external mockMarketIndexOfTokenToReturn: (t, int) => unit = "returns"

type marketIndexOfTokenCall = {param0: Ethers.ethAddress}

let marketIndexOfTokenOld: t => array<marketIndexOfTokenCall> = _r => {
  let array = %raw("_r.marketIndexOfToken.calls")
  array->Array.map(_m => {
    let param0 = _m->Array.getUnsafe(0)

    {
      param0: param0,
    }
  })
}

@send @scope(("to", "have", "been"))
external marketIndexOfTokenCalledWith: (expectation, Ethers.ethAddress) => unit = "calledWith"

@get external marketIndexOfTokenFunction: t => string = "marketIndexOfToken"

let marketIndexOfTokenCallCheck = (contract, {param0}: marketIndexOfTokenCall) => {
  expect(contract->marketIndexOfTokenFunction)->marketIndexOfTokenCalledWith(param0)
}

@send @scope("marketIndexOfToken")
external mockMarketIndexOfTokenToRevert: (t, ~errorString: string) => unit = "returns"

@send @scope("marketIndexOfToken")
external mockMarketIndexOfTokenToRevertNoReason: t => unit = "reverts"

@send @scope("marketLaunchIncentive_multipliers")
external mockMarketLaunchIncentive_multipliersToReturn: (t, Ethers.BigNumber.t) => unit = "returns"

type marketLaunchIncentive_multipliersCall = {param0: int}

let marketLaunchIncentive_multipliersOld: t => array<
  marketLaunchIncentive_multipliersCall,
> = _r => {
  let array = %raw("_r.marketLaunchIncentive_multipliers.calls")
  array->Array.map(_m => {
    let param0 = _m->Array.getUnsafe(0)

    {
      param0: param0,
    }
  })
}

@send @scope(("to", "have", "been"))
external marketLaunchIncentive_multipliersCalledWith: (expectation, int) => unit = "calledWith"

@get
external marketLaunchIncentive_multipliersFunction: t => string =
  "marketLaunchIncentive_multipliers"

let marketLaunchIncentive_multipliersCallCheck = (
  contract,
  {param0}: marketLaunchIncentive_multipliersCall,
) => {
  expect(
    contract->marketLaunchIncentive_multipliersFunction,
  )->marketLaunchIncentive_multipliersCalledWith(param0)
}

@send @scope("marketLaunchIncentive_multipliers")
external mockMarketLaunchIncentive_multipliersToRevert: (t, ~errorString: string) => unit =
  "returns"

@send @scope("marketLaunchIncentive_multipliers")
external mockMarketLaunchIncentive_multipliersToRevertNoReason: t => unit = "reverts"

@send @scope("marketLaunchIncentive_period")
external mockMarketLaunchIncentive_periodToReturn: (t, Ethers.BigNumber.t) => unit = "returns"

type marketLaunchIncentive_periodCall = {param0: int}

let marketLaunchIncentive_periodOld: t => array<marketLaunchIncentive_periodCall> = _r => {
  let array = %raw("_r.marketLaunchIncentive_period.calls")
  array->Array.map(_m => {
    let param0 = _m->Array.getUnsafe(0)

    {
      param0: param0,
    }
  })
}

@send @scope(("to", "have", "been"))
external marketLaunchIncentive_periodCalledWith: (expectation, int) => unit = "calledWith"

@get external marketLaunchIncentive_periodFunction: t => string = "marketLaunchIncentive_period"

let marketLaunchIncentive_periodCallCheck = (
  contract,
  {param0}: marketLaunchIncentive_periodCall,
) => {
  expect(contract->marketLaunchIncentive_periodFunction)->marketLaunchIncentive_periodCalledWith(
    param0,
  )
}

@send @scope("marketLaunchIncentive_period")
external mockMarketLaunchIncentive_periodToRevert: (t, ~errorString: string) => unit = "returns"

@send @scope("marketLaunchIncentive_period")
external mockMarketLaunchIncentive_periodToRevertNoReason: t => unit = "reverts"

@send @scope("marketUnstakeFee_e18")
external mockMarketUnstakeFee_e18ToReturn: (t, Ethers.BigNumber.t) => unit = "returns"

type marketUnstakeFee_e18Call = {param0: int}

let marketUnstakeFee_e18Old: t => array<marketUnstakeFee_e18Call> = _r => {
  let array = %raw("_r.marketUnstakeFee_e18.calls")
  array->Array.map(_m => {
    let param0 = _m->Array.getUnsafe(0)

    {
      param0: param0,
    }
  })
}

@send @scope(("to", "have", "been"))
external marketUnstakeFee_e18CalledWith: (expectation, int) => unit = "calledWith"

@get external marketUnstakeFee_e18Function: t => string = "marketUnstakeFee_e18"

let marketUnstakeFee_e18CallCheck = (contract, {param0}: marketUnstakeFee_e18Call) => {
  expect(contract->marketUnstakeFee_e18Function)->marketUnstakeFee_e18CalledWith(param0)
}

@send @scope("marketUnstakeFee_e18")
external mockMarketUnstakeFee_e18ToRevert: (t, ~errorString: string) => unit = "returns"

@send @scope("marketUnstakeFee_e18")
external mockMarketUnstakeFee_e18ToRevertNoReason: t => unit = "reverts"

type pushUpdatedMarketPricesToUpdateFloatIssuanceCalculationsCall = {
  marketIndex: int,
  marketUpdateIndex: Ethers.BigNumber.t,
  longPrice: Ethers.BigNumber.t,
  shortPrice: Ethers.BigNumber.t,
  longValue: Ethers.BigNumber.t,
  shortValue: Ethers.BigNumber.t,
}

let pushUpdatedMarketPricesToUpdateFloatIssuanceCalculationsOld: t => array<
  pushUpdatedMarketPricesToUpdateFloatIssuanceCalculationsCall,
> = _r => {
  let array = %raw("_r.pushUpdatedMarketPricesToUpdateFloatIssuanceCalculations.calls")
  array->Array.map(((
    marketIndex,
    marketUpdateIndex,
    longPrice,
    shortPrice,
    longValue,
    shortValue,
  )) => {
    {
      marketIndex: marketIndex,
      marketUpdateIndex: marketUpdateIndex,
      longPrice: longPrice,
      shortPrice: shortPrice,
      longValue: longValue,
      shortValue: shortValue,
    }
  })
}

@send @scope(("to", "have", "been"))
external pushUpdatedMarketPricesToUpdateFloatIssuanceCalculationsCalledWith: (
  expectation,
  int,
  Ethers.BigNumber.t,
  Ethers.BigNumber.t,
  Ethers.BigNumber.t,
  Ethers.BigNumber.t,
  Ethers.BigNumber.t,
) => unit = "calledWith"

@get
external pushUpdatedMarketPricesToUpdateFloatIssuanceCalculationsFunction: t => string =
  "pushUpdatedMarketPricesToUpdateFloatIssuanceCalculations"

let pushUpdatedMarketPricesToUpdateFloatIssuanceCalculationsCallCheck = (
  contract,
  {
    marketIndex,
    marketUpdateIndex,
    longPrice,
    shortPrice,
    longValue,
    shortValue,
  }: pushUpdatedMarketPricesToUpdateFloatIssuanceCalculationsCall,
) => {
  expect(
    contract->pushUpdatedMarketPricesToUpdateFloatIssuanceCalculationsFunction,
  )->pushUpdatedMarketPricesToUpdateFloatIssuanceCalculationsCalledWith(
    marketIndex,
    marketUpdateIndex,
    longPrice,
    shortPrice,
    longValue,
    shortValue,
  )
}

@send @scope("pushUpdatedMarketPricesToUpdateFloatIssuanceCalculations")
external mockPushUpdatedMarketPricesToUpdateFloatIssuanceCalculationsToRevert: (
  t,
  ~errorString: string,
) => unit = "returns"

@send @scope("pushUpdatedMarketPricesToUpdateFloatIssuanceCalculations")
external mockPushUpdatedMarketPricesToUpdateFloatIssuanceCalculationsToRevertNoReason: t => unit =
  "reverts"

type renounceRoleCall = {
  role: string,
  account: Ethers.ethAddress,
}

let renounceRoleOld: t => array<renounceRoleCall> = _r => {
  let array = %raw("_r.renounceRole.calls")
  array->Array.map(((role, account)) => {
    {
      role: role,
      account: account,
    }
  })
}

@send @scope(("to", "have", "been"))
external renounceRoleCalledWith: (expectation, string, Ethers.ethAddress) => unit = "calledWith"

@get external renounceRoleFunction: t => string = "renounceRole"

let renounceRoleCallCheck = (contract, {role, account}: renounceRoleCall) => {
  expect(contract->renounceRoleFunction)->renounceRoleCalledWith(role, account)
}

@send @scope("renounceRole")
external mockRenounceRoleToRevert: (t, ~errorString: string) => unit = "returns"

@send @scope("renounceRole")
external mockRenounceRoleToRevertNoReason: t => unit = "reverts"

type revokeRoleCall = {
  role: string,
  account: Ethers.ethAddress,
}

let revokeRoleOld: t => array<revokeRoleCall> = _r => {
  let array = %raw("_r.revokeRole.calls")
  array->Array.map(((role, account)) => {
    {
      role: role,
      account: account,
    }
  })
}

@send @scope(("to", "have", "been"))
external revokeRoleCalledWith: (expectation, string, Ethers.ethAddress) => unit = "calledWith"

@get external revokeRoleFunction: t => string = "revokeRole"

let revokeRoleCallCheck = (contract, {role, account}: revokeRoleCall) => {
  expect(contract->revokeRoleFunction)->revokeRoleCalledWith(role, account)
}

@send @scope("revokeRole")
external mockRevokeRoleToRevert: (t, ~errorString: string) => unit = "returns"

@send @scope("revokeRole")
external mockRevokeRoleToRevertNoReason: t => unit = "reverts"

@send @scope("safeExponentBitShifting")
external mockSafeExponentBitShiftingToReturn: (t, Ethers.BigNumber.t) => unit = "returns"

type safeExponentBitShiftingCall = {param0: int}

let safeExponentBitShiftingOld: t => array<safeExponentBitShiftingCall> = _r => {
  let array = %raw("_r.safeExponentBitShifting.calls")
  array->Array.map(_m => {
    let param0 = _m->Array.getUnsafe(0)

    {
      param0: param0,
    }
  })
}

@send @scope(("to", "have", "been"))
external safeExponentBitShiftingCalledWith: (expectation, int) => unit = "calledWith"

@get external safeExponentBitShiftingFunction: t => string = "safeExponentBitShifting"

let safeExponentBitShiftingCallCheck = (contract, {param0}: safeExponentBitShiftingCall) => {
  expect(contract->safeExponentBitShiftingFunction)->safeExponentBitShiftingCalledWith(param0)
}

@send @scope("safeExponentBitShifting")
external mockSafeExponentBitShiftingToRevert: (t, ~errorString: string) => unit = "returns"

@send @scope("safeExponentBitShifting")
external mockSafeExponentBitShiftingToRevertNoReason: t => unit = "reverts"

type shiftTokensCall = {
  amountSyntheticTokensToShift: Ethers.BigNumber.t,
  marketIndex: int,
  isShiftFromLong: bool,
}

let shiftTokensOld: t => array<shiftTokensCall> = _r => {
  let array = %raw("_r.shiftTokens.calls")
  array->Array.map(((amountSyntheticTokensToShift, marketIndex, isShiftFromLong)) => {
    {
      amountSyntheticTokensToShift: amountSyntheticTokensToShift,
      marketIndex: marketIndex,
      isShiftFromLong: isShiftFromLong,
    }
  })
}

@send @scope(("to", "have", "been"))
external shiftTokensCalledWith: (expectation, Ethers.BigNumber.t, int, bool) => unit = "calledWith"

@get external shiftTokensFunction: t => string = "shiftTokens"

let shiftTokensCallCheck = (
  contract,
  {amountSyntheticTokensToShift, marketIndex, isShiftFromLong}: shiftTokensCall,
) => {
  expect(contract->shiftTokensFunction)->shiftTokensCalledWith(
    amountSyntheticTokensToShift,
    marketIndex,
    isShiftFromLong,
  )
}

@send @scope("shiftTokens")
external mockShiftTokensToRevert: (t, ~errorString: string) => unit = "returns"

@send @scope("shiftTokens")
external mockShiftTokensToRevertNoReason: t => unit = "reverts"

type stakeFromUserCall = {
  from: Ethers.ethAddress,
  amount: Ethers.BigNumber.t,
}

let stakeFromUserOld: t => array<stakeFromUserCall> = _r => {
  let array = %raw("_r.stakeFromUser.calls")
  array->Array.map(((from, amount)) => {
    {
      from: from,
      amount: amount,
    }
  })
}

@send @scope(("to", "have", "been"))
external stakeFromUserCalledWith: (expectation, Ethers.ethAddress, Ethers.BigNumber.t) => unit =
  "calledWith"

@get external stakeFromUserFunction: t => string = "stakeFromUser"

let stakeFromUserCallCheck = (contract, {from, amount}: stakeFromUserCall) => {
  expect(contract->stakeFromUserFunction)->stakeFromUserCalledWith(from, amount)
}

@send @scope("stakeFromUser")
external mockStakeFromUserToRevert: (t, ~errorString: string) => unit = "returns"

@send @scope("stakeFromUser")
external mockStakeFromUserToRevertNoReason: t => unit = "reverts"

@send @scope("supportsInterface")
external mockSupportsInterfaceToReturn: (t, bool) => unit = "returns"

type supportsInterfaceCall = {interfaceId: string}

let supportsInterfaceOld: t => array<supportsInterfaceCall> = _r => {
  let array = %raw("_r.supportsInterface.calls")
  array->Array.map(_m => {
    let interfaceId = _m->Array.getUnsafe(0)

    {
      interfaceId: interfaceId,
    }
  })
}

@send @scope(("to", "have", "been"))
external supportsInterfaceCalledWith: (expectation, string) => unit = "calledWith"

@get external supportsInterfaceFunction: t => string = "supportsInterface"

let supportsInterfaceCallCheck = (contract, {interfaceId}: supportsInterfaceCall) => {
  expect(contract->supportsInterfaceFunction)->supportsInterfaceCalledWith(interfaceId)
}

@send @scope("supportsInterface")
external mockSupportsInterfaceToRevert: (t, ~errorString: string) => unit = "returns"

@send @scope("supportsInterface")
external mockSupportsInterfaceToRevertNoReason: t => unit = "reverts"

@send @scope("syntheticTokens")
external mockSyntheticTokensToReturn: (t, Ethers.ethAddress) => unit = "returns"

type syntheticTokensCall = {
  param0: int,
  param1: bool,
}

let syntheticTokensOld: t => array<syntheticTokensCall> = _r => {
  let array = %raw("_r.syntheticTokens.calls")
  array->Array.map(((param0, param1)) => {
    {
      param0: param0,
      param1: param1,
    }
  })
}

@send @scope(("to", "have", "been"))
external syntheticTokensCalledWith: (expectation, int, bool) => unit = "calledWith"

@get external syntheticTokensFunction: t => string = "syntheticTokens"

let syntheticTokensCallCheck = (contract, {param0, param1}: syntheticTokensCall) => {
  expect(contract->syntheticTokensFunction)->syntheticTokensCalledWith(param0, param1)
}

@send @scope("syntheticTokens")
external mockSyntheticTokensToRevert: (t, ~errorString: string) => unit = "returns"

@send @scope("syntheticTokens")
external mockSyntheticTokensToRevertNoReason: t => unit = "reverts"

type upgradeToCall = {newImplementation: Ethers.ethAddress}

let upgradeToOld: t => array<upgradeToCall> = _r => {
  let array = %raw("_r.upgradeTo.calls")
  array->Array.map(_m => {
    let newImplementation = _m->Array.getUnsafe(0)

    {
      newImplementation: newImplementation,
    }
  })
}

@send @scope(("to", "have", "been"))
external upgradeToCalledWith: (expectation, Ethers.ethAddress) => unit = "calledWith"

@get external upgradeToFunction: t => string = "upgradeTo"

let upgradeToCallCheck = (contract, {newImplementation}: upgradeToCall) => {
  expect(contract->upgradeToFunction)->upgradeToCalledWith(newImplementation)
}

@send @scope("upgradeTo")
external mockUpgradeToToRevert: (t, ~errorString: string) => unit = "returns"

@send @scope("upgradeTo")
external mockUpgradeToToRevertNoReason: t => unit = "reverts"

type upgradeToAndCallCall = {
  newImplementation: Ethers.ethAddress,
  data: string,
}

let upgradeToAndCallOld: t => array<upgradeToAndCallCall> = _r => {
  let array = %raw("_r.upgradeToAndCall.calls")
  array->Array.map(((newImplementation, data)) => {
    {
      newImplementation: newImplementation,
      data: data,
    }
  })
}

@send @scope(("to", "have", "been"))
external upgradeToAndCallCalledWith: (expectation, Ethers.ethAddress, string) => unit = "calledWith"

@get external upgradeToAndCallFunction: t => string = "upgradeToAndCall"

let upgradeToAndCallCallCheck = (contract, {newImplementation, data}: upgradeToAndCallCall) => {
  expect(contract->upgradeToAndCallFunction)->upgradeToAndCallCalledWith(newImplementation, data)
}

@send @scope("upgradeToAndCall")
external mockUpgradeToAndCallToRevert: (t, ~errorString: string) => unit = "returns"

@send @scope("upgradeToAndCall")
external mockUpgradeToAndCallToRevertNoReason: t => unit = "reverts"

@send @scope("userAmountStaked")
external mockUserAmountStakedToReturn: (t, Ethers.BigNumber.t) => unit = "returns"

type userAmountStakedCall = {
  param0: Ethers.ethAddress,
  param1: Ethers.ethAddress,
}

let userAmountStakedOld: t => array<userAmountStakedCall> = _r => {
  let array = %raw("_r.userAmountStaked.calls")
  array->Array.map(((param0, param1)) => {
    {
      param0: param0,
      param1: param1,
    }
  })
}

@send @scope(("to", "have", "been"))
external userAmountStakedCalledWith: (expectation, Ethers.ethAddress, Ethers.ethAddress) => unit =
  "calledWith"

@get external userAmountStakedFunction: t => string = "userAmountStaked"

let userAmountStakedCallCheck = (contract, {param0, param1}: userAmountStakedCall) => {
  expect(contract->userAmountStakedFunction)->userAmountStakedCalledWith(param0, param1)
}

@send @scope("userAmountStaked")
external mockUserAmountStakedToRevert: (t, ~errorString: string) => unit = "returns"

@send @scope("userAmountStaked")
external mockUserAmountStakedToRevertNoReason: t => unit = "reverts"

@send @scope("userIndexOfLastClaimedReward")
external mockUserIndexOfLastClaimedRewardToReturn: (t, Ethers.BigNumber.t) => unit = "returns"

type userIndexOfLastClaimedRewardCall = {
  param0: int,
  param1: Ethers.ethAddress,
}

let userIndexOfLastClaimedRewardOld: t => array<userIndexOfLastClaimedRewardCall> = _r => {
  let array = %raw("_r.userIndexOfLastClaimedReward.calls")
  array->Array.map(((param0, param1)) => {
    {
      param0: param0,
      param1: param1,
    }
  })
}

@send @scope(("to", "have", "been"))
external userIndexOfLastClaimedRewardCalledWith: (expectation, int, Ethers.ethAddress) => unit =
  "calledWith"

@get external userIndexOfLastClaimedRewardFunction: t => string = "userIndexOfLastClaimedReward"

let userIndexOfLastClaimedRewardCallCheck = (
  contract,
  {param0, param1}: userIndexOfLastClaimedRewardCall,
) => {
  expect(contract->userIndexOfLastClaimedRewardFunction)->userIndexOfLastClaimedRewardCalledWith(
    param0,
    param1,
  )
}

@send @scope("userIndexOfLastClaimedReward")
external mockUserIndexOfLastClaimedRewardToRevert: (t, ~errorString: string) => unit = "returns"

@send @scope("userIndexOfLastClaimedReward")
external mockUserIndexOfLastClaimedRewardToRevertNoReason: t => unit = "reverts"

@send @scope("userNextPrice_amountStakedSyntheticToken_toShiftAwayFrom")
external mockUserNextPrice_amountStakedSyntheticToken_toShiftAwayFromToReturn: (
  t,
  Ethers.BigNumber.t,
) => unit = "returns"

type userNextPrice_amountStakedSyntheticToken_toShiftAwayFromCall = {
  param0: int,
  param1: bool,
  param2: Ethers.ethAddress,
}

let userNextPrice_amountStakedSyntheticToken_toShiftAwayFromOld: t => array<
  userNextPrice_amountStakedSyntheticToken_toShiftAwayFromCall,
> = _r => {
  let array = %raw("_r.userNextPrice_amountStakedSyntheticToken_toShiftAwayFrom.calls")
  array->Array.map(((param0, param1, param2)) => {
    {
      param0: param0,
      param1: param1,
      param2: param2,
    }
  })
}

@send @scope(("to", "have", "been"))
external userNextPrice_amountStakedSyntheticToken_toShiftAwayFromCalledWith: (
  expectation,
  int,
  bool,
  Ethers.ethAddress,
) => unit = "calledWith"

@get
external userNextPrice_amountStakedSyntheticToken_toShiftAwayFromFunction: t => string =
  "userNextPrice_amountStakedSyntheticToken_toShiftAwayFrom"

let userNextPrice_amountStakedSyntheticToken_toShiftAwayFromCallCheck = (
  contract,
  {param0, param1, param2}: userNextPrice_amountStakedSyntheticToken_toShiftAwayFromCall,
) => {
  expect(
    contract->userNextPrice_amountStakedSyntheticToken_toShiftAwayFromFunction,
  )->userNextPrice_amountStakedSyntheticToken_toShiftAwayFromCalledWith(param0, param1, param2)
}

@send @scope("userNextPrice_amountStakedSyntheticToken_toShiftAwayFrom")
external mockUserNextPrice_amountStakedSyntheticToken_toShiftAwayFromToRevert: (
  t,
  ~errorString: string,
) => unit = "returns"

@send @scope("userNextPrice_amountStakedSyntheticToken_toShiftAwayFrom")
external mockUserNextPrice_amountStakedSyntheticToken_toShiftAwayFromToRevertNoReason: t => unit =
  "reverts"

@send @scope("userNextPrice_stakedSyntheticTokenShiftIndex")
external mockUserNextPrice_stakedSyntheticTokenShiftIndexToReturn: (t, Ethers.BigNumber.t) => unit =
  "returns"

type userNextPrice_stakedSyntheticTokenShiftIndexCall = {
  param0: int,
  param1: Ethers.ethAddress,
}

let userNextPrice_stakedSyntheticTokenShiftIndexOld: t => array<
  userNextPrice_stakedSyntheticTokenShiftIndexCall,
> = _r => {
  let array = %raw("_r.userNextPrice_stakedSyntheticTokenShiftIndex.calls")
  array->Array.map(((param0, param1)) => {
    {
      param0: param0,
      param1: param1,
    }
  })
}

@send @scope(("to", "have", "been"))
external userNextPrice_stakedSyntheticTokenShiftIndexCalledWith: (
  expectation,
  int,
  Ethers.ethAddress,
) => unit = "calledWith"

@get
external userNextPrice_stakedSyntheticTokenShiftIndexFunction: t => string =
  "userNextPrice_stakedSyntheticTokenShiftIndex"

let userNextPrice_stakedSyntheticTokenShiftIndexCallCheck = (
  contract,
  {param0, param1}: userNextPrice_stakedSyntheticTokenShiftIndexCall,
) => {
  expect(
    contract->userNextPrice_stakedSyntheticTokenShiftIndexFunction,
  )->userNextPrice_stakedSyntheticTokenShiftIndexCalledWith(param0, param1)
}

@send @scope("userNextPrice_stakedSyntheticTokenShiftIndex")
external mockUserNextPrice_stakedSyntheticTokenShiftIndexToRevert: (
  t,
  ~errorString: string,
) => unit = "returns"

@send @scope("userNextPrice_stakedSyntheticTokenShiftIndex")
external mockUserNextPrice_stakedSyntheticTokenShiftIndexToRevertNoReason: t => unit = "reverts"

@send @scope("userNonce")
external mockUserNonceToReturn: (t, int) => unit = "returns"

type userNonceCall = {param0: Ethers.ethAddress}

let userNonceOld: t => array<userNonceCall> = _r => {
  let array = %raw("_r.userNonce.calls")
  array->Array.map(_m => {
    let param0 = _m->Array.getUnsafe(0)

    {
      param0: param0,
    }
  })
}

@send @scope(("to", "have", "been"))
external userNonceCalledWith: (expectation, Ethers.ethAddress) => unit = "calledWith"

@get external userNonceFunction: t => string = "userNonce"

let userNonceCallCheck = (contract, {param0}: userNonceCall) => {
  expect(contract->userNonceFunction)->userNonceCalledWith(param0)
}

@send @scope("userNonce")
external mockUserNonceToRevert: (t, ~errorString: string) => unit = "returns"

@send @scope("userNonce")
external mockUserNonceToRevertNoReason: t => unit = "reverts"

type withdrawCall = {
  marketIndex: int,
  isWithdrawFromLong: bool,
  amount: Ethers.BigNumber.t,
}

let withdrawOld: t => array<withdrawCall> = _r => {
  let array = %raw("_r.withdraw.calls")
  array->Array.map(((marketIndex, isWithdrawFromLong, amount)) => {
    {
      marketIndex: marketIndex,
      isWithdrawFromLong: isWithdrawFromLong,
      amount: amount,
    }
  })
}

@send @scope(("to", "have", "been"))
external withdrawCalledWith: (expectation, int, bool, Ethers.BigNumber.t) => unit = "calledWith"

@get external withdrawFunction: t => string = "withdraw"

let withdrawCallCheck = (contract, {marketIndex, isWithdrawFromLong, amount}: withdrawCall) => {
  expect(contract->withdrawFunction)->withdrawCalledWith(marketIndex, isWithdrawFromLong, amount)
}

@send @scope("withdraw")
external mockWithdrawToRevert: (t, ~errorString: string) => unit = "returns"

@send @scope("withdraw")
external mockWithdrawToRevertNoReason: t => unit = "reverts"

type withdrawAllCall = {
  marketIndex: int,
  isWithdrawFromLong: bool,
}

let withdrawAllOld: t => array<withdrawAllCall> = _r => {
  let array = %raw("_r.withdrawAll.calls")
  array->Array.map(((marketIndex, isWithdrawFromLong)) => {
    {
      marketIndex: marketIndex,
      isWithdrawFromLong: isWithdrawFromLong,
    }
  })
}

@send @scope(("to", "have", "been"))
external withdrawAllCalledWith: (expectation, int, bool) => unit = "calledWith"

@get external withdrawAllFunction: t => string = "withdrawAll"

let withdrawAllCallCheck = (contract, {marketIndex, isWithdrawFromLong}: withdrawAllCall) => {
  expect(contract->withdrawAllFunction)->withdrawAllCalledWith(marketIndex, isWithdrawFromLong)
}

@send @scope("withdrawAll")
external mockWithdrawAllToRevert: (t, ~errorString: string) => unit = "returns"

@send @scope("withdrawAll")
external mockWithdrawAllToRevertNoReason: t => unit = "reverts"

type withdrawWithVoucherCall = {
  marketIndex: int,
  isWithdrawFromLong: bool,
  withdrawAmount: Ethers.BigNumber.t,
  expiry: Ethers.BigNumber.t,
  nonce: Ethers.BigNumber.t,
  discountWithdrawFee: Ethers.BigNumber.t,
  v: int,
  r: string,
  s: string,
}

let withdrawWithVoucherOld: t => array<withdrawWithVoucherCall> = _r => {
  let array = %raw("_r.withdrawWithVoucher.calls")
  array->Array.map(((
    marketIndex,
    isWithdrawFromLong,
    withdrawAmount,
    expiry,
    nonce,
    discountWithdrawFee,
    v,
    r,
    s,
  )) => {
    {
      marketIndex: marketIndex,
      isWithdrawFromLong: isWithdrawFromLong,
      withdrawAmount: withdrawAmount,
      expiry: expiry,
      nonce: nonce,
      discountWithdrawFee: discountWithdrawFee,
      v: v,
      r: r,
      s: s,
    }
  })
}

@send @scope(("to", "have", "been"))
external withdrawWithVoucherCalledWith: (
  expectation,
  int,
  bool,
  Ethers.BigNumber.t,
  Ethers.BigNumber.t,
  Ethers.BigNumber.t,
  Ethers.BigNumber.t,
  int,
  string,
  string,
) => unit = "calledWith"

@get external withdrawWithVoucherFunction: t => string = "withdrawWithVoucher"

let withdrawWithVoucherCallCheck = (
  contract,
  {
    marketIndex,
    isWithdrawFromLong,
    withdrawAmount,
    expiry,
    nonce,
    discountWithdrawFee,
    v,
    r,
    s,
  }: withdrawWithVoucherCall,
) => {
  expect(contract->withdrawWithVoucherFunction)->withdrawWithVoucherCalledWith(
    marketIndex,
    isWithdrawFromLong,
    withdrawAmount,
    expiry,
    nonce,
    discountWithdrawFee,
    v,
    r,
    s,
  )
}

@send @scope("withdrawWithVoucher")
external mockWithdrawWithVoucherToRevert: (t, ~errorString: string) => unit = "returns"

@send @scope("withdrawWithVoucher")
external mockWithdrawWithVoucherToRevertNoReason: t => unit = "reverts"

module InternalMock = {
  let mockContractName = "StakerForInternalMocking"
  type t = {address: Ethers.ethAddress}

  let internalRef: ref<option<t>> = ref(None)

  let functionToNotMock: ref<string> = ref("")

  @module("@defi-wonderland/smock") @scope("smock")
  external smock: string => Js.Promise.t<t> = "fake"

  let setup: Staker.t => JsPromise.t<ContractHelpers.transaction> = contract => {
    smock(mockContractName)->JsPromise.then(b => {
      internalRef := Some(b)
      contract->Staker.Exposed.setMocker(~mocker=(b->Obj.magic).address)
    })
  }

  let setFunctionForUnitTesting = (contract, ~functionName) => {
    functionToNotMock := functionName
    contract->Staker.Exposed.setFunctionToNotMock(~functionToNotMock=functionName)
  }

  let setupFunctionForUnitTesting = (contract, ~functionName) => {
    smock(mockContractName)->JsPromise.then(b => {
      internalRef := Some(b)
      [
        contract->Staker.Exposed.setMocker(~mocker=(b->Obj.magic).address),
        contract->Staker.Exposed.setFunctionToNotMock(~functionToNotMock=functionName),
      ]->JsPromise.all
    })
  }

  exception MockingAFunctionThatYouShouldntBe

  exception HaventSetupInternalMockingForStaker

  let checkForExceptions = (~functionName) => {
    if functionToNotMock.contents == functionName {
      raise(MockingAFunctionThatYouShouldntBe)
    }
    if internalRef.contents == None {
      raise(HaventSetupInternalMockingForStaker)
    }
  }

  type onlyAdminModifierLogicCall

  @send @scope(("to", "have", "been"))
  external onlyAdminModifierLogicCalledWith: expectation => unit = "calledWith"

  @get
  external onlyAdminModifierLogicFunctionFromInstance: t => string = "onlyAdminModifierLogicMock"

  let onlyAdminModifierLogicFunction = () => {
    checkForExceptions(~functionName="onlyAdminModifierLogic")
    internalRef.contents->Option.map(contract => {
      contract->onlyAdminModifierLogicFunctionFromInstance
    })
  }

  let onlyAdminModifierLogicCallCheck = () =>
    expect(onlyAdminModifierLogicFunction())->onlyAdminModifierLogicCalledWith

  @send @scope("onlyAdminModifierLogicMock")
  external onlyAdminModifierLogicMockRevertRaw: (t, ~errorString: string) => unit = "reverts"

  @send @scope("onlyAdminModifierLogicMock")
  external onlyAdminModifierLogicMockRevertNoReasonRaw: t => unit = "reverts"

  let mockOnlyAdminModifierLogicToRevert = (~errorString) => {
    checkForExceptions(~functionName="onlyAdminModifierLogic")
    let _ = internalRef.contents->Option.map(onlyAdminModifierLogicMockRevertRaw(~errorString))
  }
  let mockOnlyAdminModifierLogicToRevertNoReason = () => {
    checkForExceptions(~functionName="onlyAdminModifierLogic")
    let _ = internalRef.contents->Option.map(onlyAdminModifierLogicMockRevertNoReasonRaw)
  }

  type onlyValidSyntheticModifierLogicCall = {synth: Ethers.ethAddress}

  @send @scope(("to", "have", "been"))
  external onlyValidSyntheticModifierLogicCalledWith: (expectation, Ethers.ethAddress) => unit =
    "calledWith"

  @get
  external onlyValidSyntheticModifierLogicFunctionFromInstance: t => string =
    "onlyValidSyntheticModifierLogicMock"

  let onlyValidSyntheticModifierLogicFunction = () => {
    checkForExceptions(~functionName="onlyValidSyntheticModifierLogic")
    internalRef.contents->Option.map(contract => {
      contract->onlyValidSyntheticModifierLogicFunctionFromInstance
    })
  }

  let onlyValidSyntheticModifierLogicCallCheck = ({synth}: onlyValidSyntheticModifierLogicCall) =>
    expect(onlyValidSyntheticModifierLogicFunction())->onlyValidSyntheticModifierLogicCalledWith(
      synth,
    )

  @send @scope("onlyValidSyntheticModifierLogicMock")
  external onlyValidSyntheticModifierLogicMockRevertRaw: (t, ~errorString: string) => unit =
    "reverts"

  @send @scope("onlyValidSyntheticModifierLogicMock")
  external onlyValidSyntheticModifierLogicMockRevertNoReasonRaw: t => unit = "reverts"

  let mockOnlyValidSyntheticModifierLogicToRevert = (~errorString) => {
    checkForExceptions(~functionName="onlyValidSyntheticModifierLogic")
    let _ =
      internalRef.contents->Option.map(onlyValidSyntheticModifierLogicMockRevertRaw(~errorString))
  }
  let mockOnlyValidSyntheticModifierLogicToRevertNoReason = () => {
    checkForExceptions(~functionName="onlyValidSyntheticModifierLogic")
    let _ = internalRef.contents->Option.map(onlyValidSyntheticModifierLogicMockRevertNoReasonRaw)
  }

  type onlyLongShortModifierLogicCall

  @send @scope(("to", "have", "been"))
  external onlyLongShortModifierLogicCalledWith: expectation => unit = "calledWith"

  @get
  external onlyLongShortModifierLogicFunctionFromInstance: t => string =
    "onlyLongShortModifierLogicMock"

  let onlyLongShortModifierLogicFunction = () => {
    checkForExceptions(~functionName="onlyLongShortModifierLogic")
    internalRef.contents->Option.map(contract => {
      contract->onlyLongShortModifierLogicFunctionFromInstance
    })
  }

  let onlyLongShortModifierLogicCallCheck = () =>
    expect(onlyLongShortModifierLogicFunction())->onlyLongShortModifierLogicCalledWith

  @send @scope("onlyLongShortModifierLogicMock")
  external onlyLongShortModifierLogicMockRevertRaw: (t, ~errorString: string) => unit = "reverts"

  @send @scope("onlyLongShortModifierLogicMock")
  external onlyLongShortModifierLogicMockRevertNoReasonRaw: t => unit = "reverts"

  let mockOnlyLongShortModifierLogicToRevert = (~errorString) => {
    checkForExceptions(~functionName="onlyLongShortModifierLogic")
    let _ = internalRef.contents->Option.map(onlyLongShortModifierLogicMockRevertRaw(~errorString))
  }
  let mockOnlyLongShortModifierLogicToRevertNoReason = () => {
    checkForExceptions(~functionName="onlyLongShortModifierLogic")
    let _ = internalRef.contents->Option.map(onlyLongShortModifierLogicMockRevertNoReasonRaw)
  }

  type _updateUsersStakedPosition_mintAccumulatedFloatAndExecuteOutstandingShiftsCall = {
    marketIndex: int,
    user: Ethers.ethAddress,
  }

  @send @scope(("to", "have", "been"))
  external _updateUsersStakedPosition_mintAccumulatedFloatAndExecuteOutstandingShiftsCalledWith: (
    expectation,
    int,
    Ethers.ethAddress,
  ) => unit = "calledWith"

  @get
  external _updateUsersStakedPosition_mintAccumulatedFloatAndExecuteOutstandingShiftsFunctionFromInstance: t => string =
    "_updateUsersStakedPosition_mintAccumulatedFloatAndExecuteOutstandingShiftsMock"

  let _updateUsersStakedPosition_mintAccumulatedFloatAndExecuteOutstandingShiftsFunction = () => {
    checkForExceptions(
      ~functionName="_updateUsersStakedPosition_mintAccumulatedFloatAndExecuteOutstandingShifts",
    )
    internalRef.contents->Option.map(contract => {
      contract->_updateUsersStakedPosition_mintAccumulatedFloatAndExecuteOutstandingShiftsFunctionFromInstance
    })
  }

  let _updateUsersStakedPosition_mintAccumulatedFloatAndExecuteOutstandingShiftsCallCheck = (
    {
      marketIndex,
      user,
    }: _updateUsersStakedPosition_mintAccumulatedFloatAndExecuteOutstandingShiftsCall,
  ) =>
    expect(
      _updateUsersStakedPosition_mintAccumulatedFloatAndExecuteOutstandingShiftsFunction(),
    )->_updateUsersStakedPosition_mintAccumulatedFloatAndExecuteOutstandingShiftsCalledWith(
      marketIndex,
      user,
    )

  @send @scope("_updateUsersStakedPosition_mintAccumulatedFloatAndExecuteOutstandingShiftsMock")
  external _updateUsersStakedPosition_mintAccumulatedFloatAndExecuteOutstandingShiftsMockRevertRaw: (
    t,
    ~errorString: string,
  ) => unit = "reverts"

  @send @scope("_updateUsersStakedPosition_mintAccumulatedFloatAndExecuteOutstandingShiftsMock")
  external _updateUsersStakedPosition_mintAccumulatedFloatAndExecuteOutstandingShiftsMockRevertNoReasonRaw: t => unit =
    "reverts"

  let mock_updateUsersStakedPosition_mintAccumulatedFloatAndExecuteOutstandingShiftsToRevert = (
    ~errorString,
  ) => {
    checkForExceptions(
      ~functionName="_updateUsersStakedPosition_mintAccumulatedFloatAndExecuteOutstandingShifts",
    )
    let _ =
      internalRef.contents->Option.map(
        _updateUsersStakedPosition_mintAccumulatedFloatAndExecuteOutstandingShiftsMockRevertRaw(
          ~errorString,
        ),
      )
  }
  let mock_updateUsersStakedPosition_mintAccumulatedFloatAndExecuteOutstandingShiftsToRevertNoReason = () => {
    checkForExceptions(
      ~functionName="_updateUsersStakedPosition_mintAccumulatedFloatAndExecuteOutstandingShifts",
    )
    let _ =
      internalRef.contents->Option.map(
        _updateUsersStakedPosition_mintAccumulatedFloatAndExecuteOutstandingShiftsMockRevertNoReasonRaw,
      )
  }

  type initializeCall = {
    admin: Ethers.ethAddress,
    longShort: Ethers.ethAddress,
    floatToken: Ethers.ethAddress,
    floatTreasury: Ethers.ethAddress,
    floatCapital: Ethers.ethAddress,
    discountSigner: Ethers.ethAddress,
    floatPercentage: Ethers.BigNumber.t,
  }

  @send @scope(("to", "have", "been"))
  external initializeCalledWith: (
    expectation,
    Ethers.ethAddress,
    Ethers.ethAddress,
    Ethers.ethAddress,
    Ethers.ethAddress,
    Ethers.ethAddress,
    Ethers.ethAddress,
    Ethers.BigNumber.t,
  ) => unit = "calledWith"

  @get external initializeFunctionFromInstance: t => string = "initializeMock"

  let initializeFunction = () => {
    checkForExceptions(~functionName="initialize")
    internalRef.contents->Option.map(contract => {
      contract->initializeFunctionFromInstance
    })
  }

  let initializeCallCheck = (
    {
      admin,
      longShort,
      floatToken,
      floatTreasury,
      floatCapital,
      discountSigner,
      floatPercentage,
    }: initializeCall,
  ) =>
    expect(initializeFunction())->initializeCalledWith(
      admin,
      longShort,
      floatToken,
      floatTreasury,
      floatCapital,
      discountSigner,
      floatPercentage,
    )

  @send @scope("initializeMock")
  external initializeMockRevertRaw: (t, ~errorString: string) => unit = "reverts"

  @send @scope("initializeMock")
  external initializeMockRevertNoReasonRaw: t => unit = "reverts"

  let mockInitializeToRevert = (~errorString) => {
    checkForExceptions(~functionName="initialize")
    let _ = internalRef.contents->Option.map(initializeMockRevertRaw(~errorString))
  }
  let mockInitializeToRevertNoReason = () => {
    checkForExceptions(~functionName="initialize")
    let _ = internalRef.contents->Option.map(initializeMockRevertNoReasonRaw)
  }

  type _changeFloatPercentageCall = {newFloatPercentage: Ethers.BigNumber.t}

  @send @scope(("to", "have", "been"))
  external _changeFloatPercentageCalledWith: (expectation, Ethers.BigNumber.t) => unit =
    "calledWith"

  @get
  external _changeFloatPercentageFunctionFromInstance: t => string = "_changeFloatPercentageMock"

  let _changeFloatPercentageFunction = () => {
    checkForExceptions(~functionName="_changeFloatPercentage")
    internalRef.contents->Option.map(contract => {
      contract->_changeFloatPercentageFunctionFromInstance
    })
  }

  let _changeFloatPercentageCallCheck = ({newFloatPercentage}: _changeFloatPercentageCall) =>
    expect(_changeFloatPercentageFunction())->_changeFloatPercentageCalledWith(newFloatPercentage)

  @send @scope("_changeFloatPercentageMock")
  external _changeFloatPercentageMockRevertRaw: (t, ~errorString: string) => unit = "reverts"

  @send @scope("_changeFloatPercentageMock")
  external _changeFloatPercentageMockRevertNoReasonRaw: t => unit = "reverts"

  let mock_changeFloatPercentageToRevert = (~errorString) => {
    checkForExceptions(~functionName="_changeFloatPercentage")
    let _ = internalRef.contents->Option.map(_changeFloatPercentageMockRevertRaw(~errorString))
  }
  let mock_changeFloatPercentageToRevertNoReason = () => {
    checkForExceptions(~functionName="_changeFloatPercentage")
    let _ = internalRef.contents->Option.map(_changeFloatPercentageMockRevertNoReasonRaw)
  }

  type _changeUnstakeFeeCall = {
    marketIndex: int,
    newMarketUnstakeFee_e18: Ethers.BigNumber.t,
  }

  @send @scope(("to", "have", "been"))
  external _changeUnstakeFeeCalledWith: (expectation, int, Ethers.BigNumber.t) => unit =
    "calledWith"

  @get external _changeUnstakeFeeFunctionFromInstance: t => string = "_changeUnstakeFeeMock"

  let _changeUnstakeFeeFunction = () => {
    checkForExceptions(~functionName="_changeUnstakeFee")
    internalRef.contents->Option.map(contract => {
      contract->_changeUnstakeFeeFunctionFromInstance
    })
  }

  let _changeUnstakeFeeCallCheck = (
    {marketIndex, newMarketUnstakeFee_e18}: _changeUnstakeFeeCall,
  ) =>
    expect(_changeUnstakeFeeFunction())->_changeUnstakeFeeCalledWith(
      marketIndex,
      newMarketUnstakeFee_e18,
    )

  @send @scope("_changeUnstakeFeeMock")
  external _changeUnstakeFeeMockRevertRaw: (t, ~errorString: string) => unit = "reverts"

  @send @scope("_changeUnstakeFeeMock")
  external _changeUnstakeFeeMockRevertNoReasonRaw: t => unit = "reverts"

  let mock_changeUnstakeFeeToRevert = (~errorString) => {
    checkForExceptions(~functionName="_changeUnstakeFee")
    let _ = internalRef.contents->Option.map(_changeUnstakeFeeMockRevertRaw(~errorString))
  }
  let mock_changeUnstakeFeeToRevertNoReason = () => {
    checkForExceptions(~functionName="_changeUnstakeFee")
    let _ = internalRef.contents->Option.map(_changeUnstakeFeeMockRevertNoReasonRaw)
  }

  type _changeBalanceIncentiveParametersCall = {
    marketIndex: int,
    balanceIncentiveCurve_exponent: Ethers.BigNumber.t,
    balanceIncentiveCurve_equilibriumOffset: Ethers.BigNumber.t,
    safeExponentBitShifting: Ethers.BigNumber.t,
  }

  @send @scope(("to", "have", "been"))
  external _changeBalanceIncentiveParametersCalledWith: (
    expectation,
    int,
    Ethers.BigNumber.t,
    Ethers.BigNumber.t,
    Ethers.BigNumber.t,
  ) => unit = "calledWith"

  @get
  external _changeBalanceIncentiveParametersFunctionFromInstance: t => string =
    "_changeBalanceIncentiveParametersMock"

  let _changeBalanceIncentiveParametersFunction = () => {
    checkForExceptions(~functionName="_changeBalanceIncentiveParameters")
    internalRef.contents->Option.map(contract => {
      contract->_changeBalanceIncentiveParametersFunctionFromInstance
    })
  }

  let _changeBalanceIncentiveParametersCallCheck = (
    {
      marketIndex,
      balanceIncentiveCurve_exponent,
      balanceIncentiveCurve_equilibriumOffset,
      safeExponentBitShifting,
    }: _changeBalanceIncentiveParametersCall,
  ) =>
    expect(
      _changeBalanceIncentiveParametersFunction(),
    )->_changeBalanceIncentiveParametersCalledWith(
      marketIndex,
      balanceIncentiveCurve_exponent,
      balanceIncentiveCurve_equilibriumOffset,
      safeExponentBitShifting,
    )

  @send @scope("_changeBalanceIncentiveParametersMock")
  external _changeBalanceIncentiveParametersMockRevertRaw: (t, ~errorString: string) => unit =
    "reverts"

  @send @scope("_changeBalanceIncentiveParametersMock")
  external _changeBalanceIncentiveParametersMockRevertNoReasonRaw: t => unit = "reverts"

  let mock_changeBalanceIncentiveParametersToRevert = (~errorString) => {
    checkForExceptions(~functionName="_changeBalanceIncentiveParameters")
    let _ =
      internalRef.contents->Option.map(_changeBalanceIncentiveParametersMockRevertRaw(~errorString))
  }
  let mock_changeBalanceIncentiveParametersToRevertNoReason = () => {
    checkForExceptions(~functionName="_changeBalanceIncentiveParameters")
    let _ = internalRef.contents->Option.map(_changeBalanceIncentiveParametersMockRevertNoReasonRaw)
  }

  @send @scope("_getMarketLaunchIncentiveParametersMock")
  external _getMarketLaunchIncentiveParametersMockReturnRaw: (
    t,
    (Ethers.BigNumber.t, Ethers.BigNumber.t),
  ) => unit = "returns"

  let mock_getMarketLaunchIncentiveParametersToReturn: (
    Ethers.BigNumber.t,
    Ethers.BigNumber.t,
  ) => unit = (_param0, _param1) => {
    checkForExceptions(~functionName="_getMarketLaunchIncentiveParameters")
    let _ =
      internalRef.contents->Option.map(smockedContract =>
        smockedContract->_getMarketLaunchIncentiveParametersMockReturnRaw((_param0, _param1))
      )
  }

  type _getMarketLaunchIncentiveParametersCall = {marketIndex: int}

  @send @scope(("to", "have", "been"))
  external _getMarketLaunchIncentiveParametersCalledWith: (expectation, int) => unit = "calledWith"

  @get
  external _getMarketLaunchIncentiveParametersFunctionFromInstance: t => string =
    "_getMarketLaunchIncentiveParametersMock"

  let _getMarketLaunchIncentiveParametersFunction = () => {
    checkForExceptions(~functionName="_getMarketLaunchIncentiveParameters")
    internalRef.contents->Option.map(contract => {
      contract->_getMarketLaunchIncentiveParametersFunctionFromInstance
    })
  }

  let _getMarketLaunchIncentiveParametersCallCheck = (
    {marketIndex}: _getMarketLaunchIncentiveParametersCall,
  ) =>
    expect(
      _getMarketLaunchIncentiveParametersFunction(),
    )->_getMarketLaunchIncentiveParametersCalledWith(marketIndex)

  @send @scope("_getMarketLaunchIncentiveParametersMock")
  external _getMarketLaunchIncentiveParametersMockRevertRaw: (t, ~errorString: string) => unit =
    "reverts"

  @send @scope("_getMarketLaunchIncentiveParametersMock")
  external _getMarketLaunchIncentiveParametersMockRevertNoReasonRaw: t => unit = "reverts"

  let mock_getMarketLaunchIncentiveParametersToRevert = (~errorString) => {
    checkForExceptions(~functionName="_getMarketLaunchIncentiveParameters")
    let _ =
      internalRef.contents->Option.map(
        _getMarketLaunchIncentiveParametersMockRevertRaw(~errorString),
      )
  }
  let mock_getMarketLaunchIncentiveParametersToRevertNoReason = () => {
    checkForExceptions(~functionName="_getMarketLaunchIncentiveParameters")
    let _ =
      internalRef.contents->Option.map(_getMarketLaunchIncentiveParametersMockRevertNoReasonRaw)
  }

  @send @scope("_getKValueMock")
  external _getKValueMockReturnRaw: (t, Ethers.BigNumber.t) => unit = "returns"

  let mock_getKValueToReturn: Ethers.BigNumber.t => unit = _param0 => {
    checkForExceptions(~functionName="_getKValue")
    let _ =
      internalRef.contents->Option.map(smockedContract =>
        smockedContract->_getKValueMockReturnRaw(_param0)
      )
  }

  type _getKValueCall = {marketIndex: int}

  @send @scope(("to", "have", "been"))
  external _getKValueCalledWith: (expectation, int) => unit = "calledWith"

  @get external _getKValueFunctionFromInstance: t => string = "_getKValueMock"

  let _getKValueFunction = () => {
    checkForExceptions(~functionName="_getKValue")
    internalRef.contents->Option.map(contract => {
      contract->_getKValueFunctionFromInstance
    })
  }

  let _getKValueCallCheck = ({marketIndex}: _getKValueCall) =>
    expect(_getKValueFunction())->_getKValueCalledWith(marketIndex)

  @send @scope("_getKValueMock")
  external _getKValueMockRevertRaw: (t, ~errorString: string) => unit = "reverts"

  @send @scope("_getKValueMock")
  external _getKValueMockRevertNoReasonRaw: t => unit = "reverts"

  let mock_getKValueToRevert = (~errorString) => {
    checkForExceptions(~functionName="_getKValue")
    let _ = internalRef.contents->Option.map(_getKValueMockRevertRaw(~errorString))
  }
  let mock_getKValueToRevertNoReason = () => {
    checkForExceptions(~functionName="_getKValue")
    let _ = internalRef.contents->Option.map(_getKValueMockRevertNoReasonRaw)
  }

  @send @scope("_calculateFloatPerSecondMock")
  external _calculateFloatPerSecondMockReturnRaw: (
    t,
    (Ethers.BigNumber.t, Ethers.BigNumber.t),
  ) => unit = "returns"

  let mock_calculateFloatPerSecondToReturn: (Ethers.BigNumber.t, Ethers.BigNumber.t) => unit = (
    _param0,
    _param1,
  ) => {
    checkForExceptions(~functionName="_calculateFloatPerSecond")
    let _ =
      internalRef.contents->Option.map(smockedContract =>
        smockedContract->_calculateFloatPerSecondMockReturnRaw((_param0, _param1))
      )
  }

  type _calculateFloatPerSecondCall = {
    marketIndex: int,
    longPrice: Ethers.BigNumber.t,
    shortPrice: Ethers.BigNumber.t,
    longValue: Ethers.BigNumber.t,
    shortValue: Ethers.BigNumber.t,
  }

  @send @scope(("to", "have", "been"))
  external _calculateFloatPerSecondCalledWith: (
    expectation,
    int,
    Ethers.BigNumber.t,
    Ethers.BigNumber.t,
    Ethers.BigNumber.t,
    Ethers.BigNumber.t,
  ) => unit = "calledWith"

  @get
  external _calculateFloatPerSecondFunctionFromInstance: t => string =
    "_calculateFloatPerSecondMock"

  let _calculateFloatPerSecondFunction = () => {
    checkForExceptions(~functionName="_calculateFloatPerSecond")
    internalRef.contents->Option.map(contract => {
      contract->_calculateFloatPerSecondFunctionFromInstance
    })
  }

  let _calculateFloatPerSecondCallCheck = (
    {marketIndex, longPrice, shortPrice, longValue, shortValue}: _calculateFloatPerSecondCall,
  ) =>
    expect(_calculateFloatPerSecondFunction())->_calculateFloatPerSecondCalledWith(
      marketIndex,
      longPrice,
      shortPrice,
      longValue,
      shortValue,
    )

  @send @scope("_calculateFloatPerSecondMock")
  external _calculateFloatPerSecondMockRevertRaw: (t, ~errorString: string) => unit = "reverts"

  @send @scope("_calculateFloatPerSecondMock")
  external _calculateFloatPerSecondMockRevertNoReasonRaw: t => unit = "reverts"

  let mock_calculateFloatPerSecondToRevert = (~errorString) => {
    checkForExceptions(~functionName="_calculateFloatPerSecond")
    let _ = internalRef.contents->Option.map(_calculateFloatPerSecondMockRevertRaw(~errorString))
  }
  let mock_calculateFloatPerSecondToRevertNoReason = () => {
    checkForExceptions(~functionName="_calculateFloatPerSecond")
    let _ = internalRef.contents->Option.map(_calculateFloatPerSecondMockRevertNoReasonRaw)
  }

  @send @scope("_calculateTimeDeltaFromLastAccumulativeIssuancePerStakedSynthSnapshotMock")
  external _calculateTimeDeltaFromLastAccumulativeIssuancePerStakedSynthSnapshotMockReturnRaw: (
    t,
    Ethers.BigNumber.t,
  ) => unit = "returns"

  let mock_calculateTimeDeltaFromLastAccumulativeIssuancePerStakedSynthSnapshotToReturn: Ethers.BigNumber.t => unit = _param0 => {
    checkForExceptions(
      ~functionName="_calculateTimeDeltaFromLastAccumulativeIssuancePerStakedSynthSnapshot",
    )
    let _ =
      internalRef.contents->Option.map(smockedContract =>
        smockedContract->_calculateTimeDeltaFromLastAccumulativeIssuancePerStakedSynthSnapshotMockReturnRaw(
          _param0,
        )
      )
  }

  type _calculateTimeDeltaFromLastAccumulativeIssuancePerStakedSynthSnapshotCall = {
    marketIndex: int,
    previousMarketUpdateIndex: Ethers.BigNumber.t,
  }

  @send @scope(("to", "have", "been"))
  external _calculateTimeDeltaFromLastAccumulativeIssuancePerStakedSynthSnapshotCalledWith: (
    expectation,
    int,
    Ethers.BigNumber.t,
  ) => unit = "calledWith"

  @get
  external _calculateTimeDeltaFromLastAccumulativeIssuancePerStakedSynthSnapshotFunctionFromInstance: t => string =
    "_calculateTimeDeltaFromLastAccumulativeIssuancePerStakedSynthSnapshotMock"

  let _calculateTimeDeltaFromLastAccumulativeIssuancePerStakedSynthSnapshotFunction = () => {
    checkForExceptions(
      ~functionName="_calculateTimeDeltaFromLastAccumulativeIssuancePerStakedSynthSnapshot",
    )
    internalRef.contents->Option.map(contract => {
      contract->_calculateTimeDeltaFromLastAccumulativeIssuancePerStakedSynthSnapshotFunctionFromInstance
    })
  }

  let _calculateTimeDeltaFromLastAccumulativeIssuancePerStakedSynthSnapshotCallCheck = (
    {
      marketIndex,
      previousMarketUpdateIndex,
    }: _calculateTimeDeltaFromLastAccumulativeIssuancePerStakedSynthSnapshotCall,
  ) =>
    expect(
      _calculateTimeDeltaFromLastAccumulativeIssuancePerStakedSynthSnapshotFunction(),
    )->_calculateTimeDeltaFromLastAccumulativeIssuancePerStakedSynthSnapshotCalledWith(
      marketIndex,
      previousMarketUpdateIndex,
    )

  @send @scope("_calculateTimeDeltaFromLastAccumulativeIssuancePerStakedSynthSnapshotMock")
  external _calculateTimeDeltaFromLastAccumulativeIssuancePerStakedSynthSnapshotMockRevertRaw: (
    t,
    ~errorString: string,
  ) => unit = "reverts"

  @send @scope("_calculateTimeDeltaFromLastAccumulativeIssuancePerStakedSynthSnapshotMock")
  external _calculateTimeDeltaFromLastAccumulativeIssuancePerStakedSynthSnapshotMockRevertNoReasonRaw: t => unit =
    "reverts"

  let mock_calculateTimeDeltaFromLastAccumulativeIssuancePerStakedSynthSnapshotToRevert = (
    ~errorString,
  ) => {
    checkForExceptions(
      ~functionName="_calculateTimeDeltaFromLastAccumulativeIssuancePerStakedSynthSnapshot",
    )
    let _ =
      internalRef.contents->Option.map(
        _calculateTimeDeltaFromLastAccumulativeIssuancePerStakedSynthSnapshotMockRevertRaw(
          ~errorString,
        ),
      )
  }
  let mock_calculateTimeDeltaFromLastAccumulativeIssuancePerStakedSynthSnapshotToRevertNoReason = () => {
    checkForExceptions(
      ~functionName="_calculateTimeDeltaFromLastAccumulativeIssuancePerStakedSynthSnapshot",
    )
    let _ =
      internalRef.contents->Option.map(
        _calculateTimeDeltaFromLastAccumulativeIssuancePerStakedSynthSnapshotMockRevertNoReasonRaw,
      )
  }

  @send @scope("_calculateNewCumulativeIssuancePerStakedSynthMock")
  external _calculateNewCumulativeIssuancePerStakedSynthMockReturnRaw: (
    t,
    (Ethers.BigNumber.t, Ethers.BigNumber.t),
  ) => unit = "returns"

  let mock_calculateNewCumulativeIssuancePerStakedSynthToReturn: (
    Ethers.BigNumber.t,
    Ethers.BigNumber.t,
  ) => unit = (_param0, _param1) => {
    checkForExceptions(~functionName="_calculateNewCumulativeIssuancePerStakedSynth")
    let _ =
      internalRef.contents->Option.map(smockedContract =>
        smockedContract->_calculateNewCumulativeIssuancePerStakedSynthMockReturnRaw((
          _param0,
          _param1,
        ))
      )
  }

  type _calculateNewCumulativeIssuancePerStakedSynthCall = {
    marketIndex: int,
    previousMarketUpdateIndex: Ethers.BigNumber.t,
    longPrice: Ethers.BigNumber.t,
    shortPrice: Ethers.BigNumber.t,
    longValue: Ethers.BigNumber.t,
    shortValue: Ethers.BigNumber.t,
  }

  @send @scope(("to", "have", "been"))
  external _calculateNewCumulativeIssuancePerStakedSynthCalledWith: (
    expectation,
    int,
    Ethers.BigNumber.t,
    Ethers.BigNumber.t,
    Ethers.BigNumber.t,
    Ethers.BigNumber.t,
    Ethers.BigNumber.t,
  ) => unit = "calledWith"

  @get
  external _calculateNewCumulativeIssuancePerStakedSynthFunctionFromInstance: t => string =
    "_calculateNewCumulativeIssuancePerStakedSynthMock"

  let _calculateNewCumulativeIssuancePerStakedSynthFunction = () => {
    checkForExceptions(~functionName="_calculateNewCumulativeIssuancePerStakedSynth")
    internalRef.contents->Option.map(contract => {
      contract->_calculateNewCumulativeIssuancePerStakedSynthFunctionFromInstance
    })
  }

  let _calculateNewCumulativeIssuancePerStakedSynthCallCheck = (
    {
      marketIndex,
      previousMarketUpdateIndex,
      longPrice,
      shortPrice,
      longValue,
      shortValue,
    }: _calculateNewCumulativeIssuancePerStakedSynthCall,
  ) =>
    expect(
      _calculateNewCumulativeIssuancePerStakedSynthFunction(),
    )->_calculateNewCumulativeIssuancePerStakedSynthCalledWith(
      marketIndex,
      previousMarketUpdateIndex,
      longPrice,
      shortPrice,
      longValue,
      shortValue,
    )

  @send @scope("_calculateNewCumulativeIssuancePerStakedSynthMock")
  external _calculateNewCumulativeIssuancePerStakedSynthMockRevertRaw: (
    t,
    ~errorString: string,
  ) => unit = "reverts"

  @send @scope("_calculateNewCumulativeIssuancePerStakedSynthMock")
  external _calculateNewCumulativeIssuancePerStakedSynthMockRevertNoReasonRaw: t => unit = "reverts"

  let mock_calculateNewCumulativeIssuancePerStakedSynthToRevert = (~errorString) => {
    checkForExceptions(~functionName="_calculateNewCumulativeIssuancePerStakedSynth")
    let _ =
      internalRef.contents->Option.map(
        _calculateNewCumulativeIssuancePerStakedSynthMockRevertRaw(~errorString),
      )
  }
  let mock_calculateNewCumulativeIssuancePerStakedSynthToRevertNoReason = () => {
    checkForExceptions(~functionName="_calculateNewCumulativeIssuancePerStakedSynth")
    let _ =
      internalRef.contents->Option.map(
        _calculateNewCumulativeIssuancePerStakedSynthMockRevertNoReasonRaw,
      )
  }

  @send @scope("_calculateAccumulatedFloatInRangeMock")
  external _calculateAccumulatedFloatInRangeMockReturnRaw: (t, Ethers.BigNumber.t) => unit =
    "returns"

  let mock_calculateAccumulatedFloatInRangeToReturn: Ethers.BigNumber.t => unit = _param0 => {
    checkForExceptions(~functionName="_calculateAccumulatedFloatInRange")
    let _ =
      internalRef.contents->Option.map(smockedContract =>
        smockedContract->_calculateAccumulatedFloatInRangeMockReturnRaw(_param0)
      )
  }

  type _calculateAccumulatedFloatInRangeCall = {
    marketIndex: int,
    amountStakedLong: Ethers.BigNumber.t,
    amountStakedShort: Ethers.BigNumber.t,
    rewardIndexFrom: Ethers.BigNumber.t,
    rewardIndexTo: Ethers.BigNumber.t,
  }

  @send @scope(("to", "have", "been"))
  external _calculateAccumulatedFloatInRangeCalledWith: (
    expectation,
    int,
    Ethers.BigNumber.t,
    Ethers.BigNumber.t,
    Ethers.BigNumber.t,
    Ethers.BigNumber.t,
  ) => unit = "calledWith"

  @get
  external _calculateAccumulatedFloatInRangeFunctionFromInstance: t => string =
    "_calculateAccumulatedFloatInRangeMock"

  let _calculateAccumulatedFloatInRangeFunction = () => {
    checkForExceptions(~functionName="_calculateAccumulatedFloatInRange")
    internalRef.contents->Option.map(contract => {
      contract->_calculateAccumulatedFloatInRangeFunctionFromInstance
    })
  }

  let _calculateAccumulatedFloatInRangeCallCheck = (
    {
      marketIndex,
      amountStakedLong,
      amountStakedShort,
      rewardIndexFrom,
      rewardIndexTo,
    }: _calculateAccumulatedFloatInRangeCall,
  ) =>
    expect(
      _calculateAccumulatedFloatInRangeFunction(),
    )->_calculateAccumulatedFloatInRangeCalledWith(
      marketIndex,
      amountStakedLong,
      amountStakedShort,
      rewardIndexFrom,
      rewardIndexTo,
    )

  @send @scope("_calculateAccumulatedFloatInRangeMock")
  external _calculateAccumulatedFloatInRangeMockRevertRaw: (t, ~errorString: string) => unit =
    "reverts"

  @send @scope("_calculateAccumulatedFloatInRangeMock")
  external _calculateAccumulatedFloatInRangeMockRevertNoReasonRaw: t => unit = "reverts"

  let mock_calculateAccumulatedFloatInRangeToRevert = (~errorString) => {
    checkForExceptions(~functionName="_calculateAccumulatedFloatInRange")
    let _ =
      internalRef.contents->Option.map(_calculateAccumulatedFloatInRangeMockRevertRaw(~errorString))
  }
  let mock_calculateAccumulatedFloatInRangeToRevertNoReason = () => {
    checkForExceptions(~functionName="_calculateAccumulatedFloatInRange")
    let _ = internalRef.contents->Option.map(_calculateAccumulatedFloatInRangeMockRevertNoReasonRaw)
  }

  @send @scope("_calculateAccumulatedFloatAndExecuteOutstandingShiftsMock")
  external _calculateAccumulatedFloatAndExecuteOutstandingShiftsMockReturnRaw: (
    t,
    Ethers.BigNumber.t,
  ) => unit = "returns"

  let mock_calculateAccumulatedFloatAndExecuteOutstandingShiftsToReturn: Ethers.BigNumber.t => unit = _param0 => {
    checkForExceptions(~functionName="_calculateAccumulatedFloatAndExecuteOutstandingShifts")
    let _ =
      internalRef.contents->Option.map(smockedContract =>
        smockedContract->_calculateAccumulatedFloatAndExecuteOutstandingShiftsMockReturnRaw(_param0)
      )
  }

  type _calculateAccumulatedFloatAndExecuteOutstandingShiftsCall = {
    marketIndex: int,
    user: Ethers.ethAddress,
  }

  @send @scope(("to", "have", "been"))
  external _calculateAccumulatedFloatAndExecuteOutstandingShiftsCalledWith: (
    expectation,
    int,
    Ethers.ethAddress,
  ) => unit = "calledWith"

  @get
  external _calculateAccumulatedFloatAndExecuteOutstandingShiftsFunctionFromInstance: t => string =
    "_calculateAccumulatedFloatAndExecuteOutstandingShiftsMock"

  let _calculateAccumulatedFloatAndExecuteOutstandingShiftsFunction = () => {
    checkForExceptions(~functionName="_calculateAccumulatedFloatAndExecuteOutstandingShifts")
    internalRef.contents->Option.map(contract => {
      contract->_calculateAccumulatedFloatAndExecuteOutstandingShiftsFunctionFromInstance
    })
  }

  let _calculateAccumulatedFloatAndExecuteOutstandingShiftsCallCheck = (
    {marketIndex, user}: _calculateAccumulatedFloatAndExecuteOutstandingShiftsCall,
  ) =>
    expect(
      _calculateAccumulatedFloatAndExecuteOutstandingShiftsFunction(),
    )->_calculateAccumulatedFloatAndExecuteOutstandingShiftsCalledWith(marketIndex, user)

  @send @scope("_calculateAccumulatedFloatAndExecuteOutstandingShiftsMock")
  external _calculateAccumulatedFloatAndExecuteOutstandingShiftsMockRevertRaw: (
    t,
    ~errorString: string,
  ) => unit = "reverts"

  @send @scope("_calculateAccumulatedFloatAndExecuteOutstandingShiftsMock")
  external _calculateAccumulatedFloatAndExecuteOutstandingShiftsMockRevertNoReasonRaw: t => unit =
    "reverts"

  let mock_calculateAccumulatedFloatAndExecuteOutstandingShiftsToRevert = (~errorString) => {
    checkForExceptions(~functionName="_calculateAccumulatedFloatAndExecuteOutstandingShifts")
    let _ =
      internalRef.contents->Option.map(
        _calculateAccumulatedFloatAndExecuteOutstandingShiftsMockRevertRaw(~errorString),
      )
  }
  let mock_calculateAccumulatedFloatAndExecuteOutstandingShiftsToRevertNoReason = () => {
    checkForExceptions(~functionName="_calculateAccumulatedFloatAndExecuteOutstandingShifts")
    let _ =
      internalRef.contents->Option.map(
        _calculateAccumulatedFloatAndExecuteOutstandingShiftsMockRevertNoReasonRaw,
      )
  }

  type _mintFloatCall = {
    user: Ethers.ethAddress,
    floatToMint: Ethers.BigNumber.t,
  }

  @send @scope(("to", "have", "been"))
  external _mintFloatCalledWith: (expectation, Ethers.ethAddress, Ethers.BigNumber.t) => unit =
    "calledWith"

  @get external _mintFloatFunctionFromInstance: t => string = "_mintFloatMock"

  let _mintFloatFunction = () => {
    checkForExceptions(~functionName="_mintFloat")
    internalRef.contents->Option.map(contract => {
      contract->_mintFloatFunctionFromInstance
    })
  }

  let _mintFloatCallCheck = ({user, floatToMint}: _mintFloatCall) =>
    expect(_mintFloatFunction())->_mintFloatCalledWith(user, floatToMint)

  @send @scope("_mintFloatMock")
  external _mintFloatMockRevertRaw: (t, ~errorString: string) => unit = "reverts"

  @send @scope("_mintFloatMock")
  external _mintFloatMockRevertNoReasonRaw: t => unit = "reverts"

  let mock_mintFloatToRevert = (~errorString) => {
    checkForExceptions(~functionName="_mintFloat")
    let _ = internalRef.contents->Option.map(_mintFloatMockRevertRaw(~errorString))
  }
  let mock_mintFloatToRevertNoReason = () => {
    checkForExceptions(~functionName="_mintFloat")
    let _ = internalRef.contents->Option.map(_mintFloatMockRevertNoReasonRaw)
  }

  type _mintAccumulatedFloatAndExecuteOutstandingShiftsCall = {
    marketIndex: int,
    user: Ethers.ethAddress,
  }

  @send @scope(("to", "have", "been"))
  external _mintAccumulatedFloatAndExecuteOutstandingShiftsCalledWith: (
    expectation,
    int,
    Ethers.ethAddress,
  ) => unit = "calledWith"

  @get
  external _mintAccumulatedFloatAndExecuteOutstandingShiftsFunctionFromInstance: t => string =
    "_mintAccumulatedFloatAndExecuteOutstandingShiftsMock"

  let _mintAccumulatedFloatAndExecuteOutstandingShiftsFunction = () => {
    checkForExceptions(~functionName="_mintAccumulatedFloatAndExecuteOutstandingShifts")
    internalRef.contents->Option.map(contract => {
      contract->_mintAccumulatedFloatAndExecuteOutstandingShiftsFunctionFromInstance
    })
  }

  let _mintAccumulatedFloatAndExecuteOutstandingShiftsCallCheck = (
    {marketIndex, user}: _mintAccumulatedFloatAndExecuteOutstandingShiftsCall,
  ) =>
    expect(
      _mintAccumulatedFloatAndExecuteOutstandingShiftsFunction(),
    )->_mintAccumulatedFloatAndExecuteOutstandingShiftsCalledWith(marketIndex, user)

  @send @scope("_mintAccumulatedFloatAndExecuteOutstandingShiftsMock")
  external _mintAccumulatedFloatAndExecuteOutstandingShiftsMockRevertRaw: (
    t,
    ~errorString: string,
  ) => unit = "reverts"

  @send @scope("_mintAccumulatedFloatAndExecuteOutstandingShiftsMock")
  external _mintAccumulatedFloatAndExecuteOutstandingShiftsMockRevertNoReasonRaw: t => unit =
    "reverts"

  let mock_mintAccumulatedFloatAndExecuteOutstandingShiftsToRevert = (~errorString) => {
    checkForExceptions(~functionName="_mintAccumulatedFloatAndExecuteOutstandingShifts")
    let _ =
      internalRef.contents->Option.map(
        _mintAccumulatedFloatAndExecuteOutstandingShiftsMockRevertRaw(~errorString),
      )
  }
  let mock_mintAccumulatedFloatAndExecuteOutstandingShiftsToRevertNoReason = () => {
    checkForExceptions(~functionName="_mintAccumulatedFloatAndExecuteOutstandingShifts")
    let _ =
      internalRef.contents->Option.map(
        _mintAccumulatedFloatAndExecuteOutstandingShiftsMockRevertNoReasonRaw,
      )
  }

  type _mintAccumulatedFloatAndExecuteOutstandingShiftsMultiCall = {
    marketIndexes: array<int>,
    user: Ethers.ethAddress,
  }

  @send @scope(("to", "have", "been"))
  external _mintAccumulatedFloatAndExecuteOutstandingShiftsMultiCalledWith: (
    expectation,
    array<int>,
    Ethers.ethAddress,
  ) => unit = "calledWith"

  @get
  external _mintAccumulatedFloatAndExecuteOutstandingShiftsMultiFunctionFromInstance: t => string =
    "_mintAccumulatedFloatAndExecuteOutstandingShiftsMultiMock"

  let _mintAccumulatedFloatAndExecuteOutstandingShiftsMultiFunction = () => {
    checkForExceptions(~functionName="_mintAccumulatedFloatAndExecuteOutstandingShiftsMulti")
    internalRef.contents->Option.map(contract => {
      contract->_mintAccumulatedFloatAndExecuteOutstandingShiftsMultiFunctionFromInstance
    })
  }

  let _mintAccumulatedFloatAndExecuteOutstandingShiftsMultiCallCheck = (
    {marketIndexes, user}: _mintAccumulatedFloatAndExecuteOutstandingShiftsMultiCall,
  ) =>
    expect(
      _mintAccumulatedFloatAndExecuteOutstandingShiftsMultiFunction(),
    )->_mintAccumulatedFloatAndExecuteOutstandingShiftsMultiCalledWith(marketIndexes, user)

  @send @scope("_mintAccumulatedFloatAndExecuteOutstandingShiftsMultiMock")
  external _mintAccumulatedFloatAndExecuteOutstandingShiftsMultiMockRevertRaw: (
    t,
    ~errorString: string,
  ) => unit = "reverts"

  @send @scope("_mintAccumulatedFloatAndExecuteOutstandingShiftsMultiMock")
  external _mintAccumulatedFloatAndExecuteOutstandingShiftsMultiMockRevertNoReasonRaw: t => unit =
    "reverts"

  let mock_mintAccumulatedFloatAndExecuteOutstandingShiftsMultiToRevert = (~errorString) => {
    checkForExceptions(~functionName="_mintAccumulatedFloatAndExecuteOutstandingShiftsMulti")
    let _ =
      internalRef.contents->Option.map(
        _mintAccumulatedFloatAndExecuteOutstandingShiftsMultiMockRevertRaw(~errorString),
      )
  }
  let mock_mintAccumulatedFloatAndExecuteOutstandingShiftsMultiToRevertNoReason = () => {
    checkForExceptions(~functionName="_mintAccumulatedFloatAndExecuteOutstandingShiftsMulti")
    let _ =
      internalRef.contents->Option.map(
        _mintAccumulatedFloatAndExecuteOutstandingShiftsMultiMockRevertNoReasonRaw,
      )
  }

  type stakeFromUserCall = {
    from: Ethers.ethAddress,
    amount: Ethers.BigNumber.t,
  }

  @send @scope(("to", "have", "been"))
  external stakeFromUserCalledWith: (expectation, Ethers.ethAddress, Ethers.BigNumber.t) => unit =
    "calledWith"

  @get external stakeFromUserFunctionFromInstance: t => string = "stakeFromUserMock"

  let stakeFromUserFunction = () => {
    checkForExceptions(~functionName="stakeFromUser")
    internalRef.contents->Option.map(contract => {
      contract->stakeFromUserFunctionFromInstance
    })
  }

  let stakeFromUserCallCheck = ({from, amount}: stakeFromUserCall) =>
    expect(stakeFromUserFunction())->stakeFromUserCalledWith(from, amount)

  @send @scope("stakeFromUserMock")
  external stakeFromUserMockRevertRaw: (t, ~errorString: string) => unit = "reverts"

  @send @scope("stakeFromUserMock")
  external stakeFromUserMockRevertNoReasonRaw: t => unit = "reverts"

  let mockStakeFromUserToRevert = (~errorString) => {
    checkForExceptions(~functionName="stakeFromUser")
    let _ = internalRef.contents->Option.map(stakeFromUserMockRevertRaw(~errorString))
  }
  let mockStakeFromUserToRevertNoReason = () => {
    checkForExceptions(~functionName="stakeFromUser")
    let _ = internalRef.contents->Option.map(stakeFromUserMockRevertNoReasonRaw)
  }

  type shiftTokensCall = {
    amountSyntheticTokensToShift: Ethers.BigNumber.t,
    marketIndex: int,
    isShiftFromLong: bool,
  }

  @send @scope(("to", "have", "been"))
  external shiftTokensCalledWith: (expectation, Ethers.BigNumber.t, int, bool) => unit =
    "calledWith"

  @get external shiftTokensFunctionFromInstance: t => string = "shiftTokensMock"

  let shiftTokensFunction = () => {
    checkForExceptions(~functionName="shiftTokens")
    internalRef.contents->Option.map(contract => {
      contract->shiftTokensFunctionFromInstance
    })
  }

  let shiftTokensCallCheck = (
    {amountSyntheticTokensToShift, marketIndex, isShiftFromLong}: shiftTokensCall,
  ) =>
    expect(shiftTokensFunction())->shiftTokensCalledWith(
      amountSyntheticTokensToShift,
      marketIndex,
      isShiftFromLong,
    )

  @send @scope("shiftTokensMock")
  external shiftTokensMockRevertRaw: (t, ~errorString: string) => unit = "reverts"

  @send @scope("shiftTokensMock")
  external shiftTokensMockRevertNoReasonRaw: t => unit = "reverts"

  let mockShiftTokensToRevert = (~errorString) => {
    checkForExceptions(~functionName="shiftTokens")
    let _ = internalRef.contents->Option.map(shiftTokensMockRevertRaw(~errorString))
  }
  let mockShiftTokensToRevertNoReason = () => {
    checkForExceptions(~functionName="shiftTokens")
    let _ = internalRef.contents->Option.map(shiftTokensMockRevertNoReasonRaw)
  }

  type _withdrawCall = {
    marketIndex: int,
    token: Ethers.ethAddress,
    amount: Ethers.BigNumber.t,
  }

  @send @scope(("to", "have", "been"))
  external _withdrawCalledWith: (expectation, int, Ethers.ethAddress, Ethers.BigNumber.t) => unit =
    "calledWith"

  @get external _withdrawFunctionFromInstance: t => string = "_withdrawMock"

  let _withdrawFunction = () => {
    checkForExceptions(~functionName="_withdraw")
    internalRef.contents->Option.map(contract => {
      contract->_withdrawFunctionFromInstance
    })
  }

  let _withdrawCallCheck = ({marketIndex, token, amount}: _withdrawCall) =>
    expect(_withdrawFunction())->_withdrawCalledWith(marketIndex, token, amount)

  @send @scope("_withdrawMock")
  external _withdrawMockRevertRaw: (t, ~errorString: string) => unit = "reverts"

  @send @scope("_withdrawMock")
  external _withdrawMockRevertNoReasonRaw: t => unit = "reverts"

  let mock_withdrawToRevert = (~errorString) => {
    checkForExceptions(~functionName="_withdraw")
    let _ = internalRef.contents->Option.map(_withdrawMockRevertRaw(~errorString))
  }
  let mock_withdrawToRevertNoReason = () => {
    checkForExceptions(~functionName="_withdraw")
    let _ = internalRef.contents->Option.map(_withdrawMockRevertNoReasonRaw)
  }
}
