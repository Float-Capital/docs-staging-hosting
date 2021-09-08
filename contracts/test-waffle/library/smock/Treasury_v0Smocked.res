open SmockGeneral

%%raw(`
const { expect, use } = require("chai");
use(require('@defi-wonderland/smock').smock.matchers);
`)

type t = {address: Ethers.ethAddress}

@module("@defi-wonderland/smock") @scope("smock")
external makeRaw: string => Js.Promise.t<t> = "fake"
let make = () => makeRaw("Treasury_v0")

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
  paymentToken: Ethers.ethAddress,
  floatToken: Ethers.ethAddress,
}

let initializeOld: t => array<initializeCall> = _r => {
  let array = %raw("_r.initialize.calls")
  array->Array.map(((admin, paymentToken, floatToken)) => {
    {
      admin: admin,
      paymentToken: paymentToken,
      floatToken: floatToken,
    }
  })
}

@send @scope(("to", "have", "been"))
external initializeCalledWith: (
  expectation,
  Ethers.ethAddress,
  Ethers.ethAddress,
  Ethers.ethAddress,
) => unit = "calledWith"

@get external initializeFunction: t => string = "initialize"

let initializeCallCheck = (contract, {admin, paymentToken, floatToken}: initializeCall) => {
  expect(contract->initializeFunction)->initializeCalledWith(admin, paymentToken, floatToken)
}

@send @scope("initialize")
external mockInitializeToRevert: (t, ~errorString: string) => unit = "returns"

@send @scope("initialize")
external mockInitializeToRevertNoReason: t => unit = "reverts"

@send @scope("paymentToken")
external mockPaymentTokenToReturn: (t, Ethers.ethAddress) => unit = "returns"

type paymentTokenCall

let paymentTokenOld: t => array<paymentTokenCall> = _r => {
  let array = %raw("_r.paymentToken.calls")
  array->Array.map(() => {
    ()->Obj.magic
  })
}

@send @scope(("to", "have", "been"))
external paymentTokenCalledWith: expectation => unit = "calledWith"

@get external paymentTokenFunction: t => string = "paymentToken"

let paymentTokenCallCheck = contract => {
  expect(contract->paymentTokenFunction)->paymentTokenCalledWith
}

@send @scope("paymentToken")
external mockPaymentTokenToRevert: (t, ~errorString: string) => unit = "returns"

@send @scope("paymentToken")
external mockPaymentTokenToRevertNoReason: t => unit = "reverts"

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
