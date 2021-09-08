
@@ocaml.warning("-32")
open SmockGeneral
open ContractHelpers
type t = {address: Ethers.ethAddress}
let contractName = "Treasury_v0"

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

  type uPGRADER_ROLEReturn = bytes32
  @send
  external uPGRADER_ROLE: (
    t,
  ) => JsPromise.t<uPGRADER_ROLEReturn> = "UPGRADER_ROLE"

  type floatTokenReturn = Ethers.ethAddress
  @send
  external floatToken: (
    t,
  ) => JsPromise.t<floatTokenReturn> = "floatToken"

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
    t,~admin: Ethers.ethAddress,~paymentToken: Ethers.ethAddress,~floatToken: Ethers.ethAddress,
  ) => JsPromise.t<transaction> = "initialize"

  type paymentTokenReturn = Ethers.ethAddress
  @send
  external paymentToken: (
    t,
  ) => JsPromise.t<paymentTokenReturn> = "paymentToken"

  @send
  external renounceRole: (
    t,~role: bytes32,~account: Ethers.ethAddress,
  ) => JsPromise.t<transaction> = "renounceRole"

  @send
  external revokeRole: (
    t,~role: bytes32,~account: Ethers.ethAddress,
  ) => JsPromise.t<transaction> = "revokeRole"

  type supportsInterfaceReturn = bool
  @send
  external supportsInterface: (
    t,~interfaceId: bytes4,
  ) => JsPromise.t<supportsInterfaceReturn> = "supportsInterface"

  @send
  external upgradeTo: (
    t,~newImplementation: Ethers.ethAddress,
  ) => JsPromise.t<transaction> = "upgradeTo"

  @send
  external upgradeToAndCall: (
    t,~newImplementation: Ethers.ethAddress,~data: bytes32,
  ) => JsPromise.t<transaction> = "upgradeToAndCall"



