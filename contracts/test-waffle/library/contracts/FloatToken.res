
@@ocaml.warning("-32")
open SmockGeneral
open ContractHelpers
type t = {address: Ethers.ethAddress}
let contractName = "FloatToken"

let at: Ethers.ethAddress => JsPromise.t<t> = contractAddress =>
  attachToContract(contractName, ~contractAddress)->Obj.magic

let make: unit => JsPromise.t<t> = () => deployContract0(contractName)->Obj.magic
    let makeSmock: unit => JsPromise.t<t> = () => deployMockContract0(contractName)->Obj.magic

    let setVariable: (t, ~name: string, ~value: 'a) => JsPromise.t<unit> = setVariableRaw
    


  type dEFAULT_ADMIN_ROLEReturn = bytes32
  @send
  external dEFAULT_ADMIN_ROLE: (
    t,
  ) => JsPromise.t<dEFAULT_ADMIN_ROLEReturn> = "DEFAULT_ADMIN_ROLE"

  type dOMAIN_SEPARATORReturn = bytes32
  @send
  external dOMAIN_SEPARATOR: (
    t,
  ) => JsPromise.t<dOMAIN_SEPARATORReturn> = "DOMAIN_SEPARATOR"

  type mINTER_ROLEReturn = bytes32
  @send
  external mINTER_ROLE: (
    t,
  ) => JsPromise.t<mINTER_ROLEReturn> = "MINTER_ROLE"

  type pAUSER_ROLEReturn = bytes32
  @send
  external pAUSER_ROLE: (
    t,
  ) => JsPromise.t<pAUSER_ROLEReturn> = "PAUSER_ROLE"

  type uPGRADER_ROLEReturn = bytes32
  @send
  external uPGRADER_ROLE: (
    t,
  ) => JsPromise.t<uPGRADER_ROLEReturn> = "UPGRADER_ROLE"

  type allowanceReturn = Ethers.BigNumber.t
  @send
  external allowance: (
    t,~owner: Ethers.ethAddress,~spender: Ethers.ethAddress,
  ) => JsPromise.t<allowanceReturn> = "allowance"

  @send
  external approve: (
    t,~spender: Ethers.ethAddress,~amount: Ethers.BigNumber.t,
  ) => JsPromise.t<transaction> = "approve"

    type approveReturn = bool
    @send @scope("callStatic")
    external approveCall: (
      t,~spender: Ethers.ethAddress,~amount: Ethers.BigNumber.t,
    ) => JsPromise.t<approveReturn> = "approve"

  type balanceOfReturn = Ethers.BigNumber.t
  @send
  external balanceOf: (
    t,~account: Ethers.ethAddress,
  ) => JsPromise.t<balanceOfReturn> = "balanceOf"

  @send
  external burn: (
    t,~amount: Ethers.BigNumber.t,
  ) => JsPromise.t<transaction> = "burn"

  @send
  external burnFrom: (
    t,~account: Ethers.ethAddress,~amount: Ethers.BigNumber.t,
  ) => JsPromise.t<transaction> = "burnFrom"

  type checkpointsReturn = tuple
  @send
  external checkpoints: (
    t,~account: Ethers.ethAddress,~pos: int,
  ) => JsPromise.t<checkpointsReturn> = "checkpoints"

  type decimalsReturn = int
  @send
  external decimals: (
    t,
  ) => JsPromise.t<decimalsReturn> = "decimals"

  @send
  external decreaseAllowance: (
    t,~spender: Ethers.ethAddress,~subtractedValue: Ethers.BigNumber.t,
  ) => JsPromise.t<transaction> = "decreaseAllowance"

    type decreaseAllowanceReturn = bool
    @send @scope("callStatic")
    external decreaseAllowanceCall: (
      t,~spender: Ethers.ethAddress,~subtractedValue: Ethers.BigNumber.t,
    ) => JsPromise.t<decreaseAllowanceReturn> = "decreaseAllowance"

  @send
  external delegate: (
    t,~delegatee: Ethers.ethAddress,
  ) => JsPromise.t<transaction> = "delegate"

  @send
  external delegateBySig: (
    t,~delegatee: Ethers.ethAddress,~nonce: Ethers.BigNumber.t,~expiry: Ethers.BigNumber.t,~v: int,~r: bytes32,~s: bytes32,
  ) => JsPromise.t<transaction> = "delegateBySig"

  type delegatesReturn = Ethers.ethAddress
  @send
  external delegates: (
    t,~account: Ethers.ethAddress,
  ) => JsPromise.t<delegatesReturn> = "delegates"

  type getPastTotalSupplyReturn = Ethers.BigNumber.t
  @send
  external getPastTotalSupply: (
    t,~blockNumber: Ethers.BigNumber.t,
  ) => JsPromise.t<getPastTotalSupplyReturn> = "getPastTotalSupply"

  type getPastVotesReturn = Ethers.BigNumber.t
  @send
  external getPastVotes: (
    t,~account: Ethers.ethAddress,~blockNumber: Ethers.BigNumber.t,
  ) => JsPromise.t<getPastVotesReturn> = "getPastVotes"

  type getRoleAdminReturn = bytes32
  @send
  external getRoleAdmin: (
    t,~role: bytes32,
  ) => JsPromise.t<getRoleAdminReturn> = "getRoleAdmin"

  type getVotesReturn = Ethers.BigNumber.t
  @send
  external getVotes: (
    t,~account: Ethers.ethAddress,
  ) => JsPromise.t<getVotesReturn> = "getVotes"

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
  external increaseAllowance: (
    t,~spender: Ethers.ethAddress,~addedValue: Ethers.BigNumber.t,
  ) => JsPromise.t<transaction> = "increaseAllowance"

    type increaseAllowanceReturn = bool
    @send @scope("callStatic")
    external increaseAllowanceCall: (
      t,~spender: Ethers.ethAddress,~addedValue: Ethers.BigNumber.t,
    ) => JsPromise.t<increaseAllowanceReturn> = "increaseAllowance"

  @send
  external initialize: (
    t,~name: string,~symbol: string,~stakerAddress: Ethers.ethAddress,
  ) => JsPromise.t<transaction> = "initialize"

  @send
  external mint: (
    t,~_to: Ethers.ethAddress,~amount: Ethers.BigNumber.t,
  ) => JsPromise.t<transaction> = "mint"

  type nameReturn = string
  @send
  external name: (
    t,
  ) => JsPromise.t<nameReturn> = "name"

  type noncesReturn = Ethers.BigNumber.t
  @send
  external nonces: (
    t,~owner: Ethers.ethAddress,
  ) => JsPromise.t<noncesReturn> = "nonces"

  type numCheckpointsReturn = int
  @send
  external numCheckpoints: (
    t,~account: Ethers.ethAddress,
  ) => JsPromise.t<numCheckpointsReturn> = "numCheckpoints"

  @send
  external pause: (
    t,
  ) => JsPromise.t<transaction> = "pause"

  type pausedReturn = bool
  @send
  external paused: (
    t,
  ) => JsPromise.t<pausedReturn> = "paused"

  @send
  external permit: (
    t,~owner: Ethers.ethAddress,~spender: Ethers.ethAddress,~value: Ethers.BigNumber.t,~deadline: Ethers.BigNumber.t,~v: int,~r: bytes32,~s: bytes32,
  ) => JsPromise.t<transaction> = "permit"

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

  type symbolReturn = string
  @send
  external symbol: (
    t,
  ) => JsPromise.t<symbolReturn> = "symbol"

  type totalSupplyReturn = Ethers.BigNumber.t
  @send
  external totalSupply: (
    t,
  ) => JsPromise.t<totalSupplyReturn> = "totalSupply"

  @send
  external transfer: (
    t,~recipient: Ethers.ethAddress,~amount: Ethers.BigNumber.t,
  ) => JsPromise.t<transaction> = "transfer"

    type transferReturn = bool
    @send @scope("callStatic")
    external transferCall: (
      t,~recipient: Ethers.ethAddress,~amount: Ethers.BigNumber.t,
    ) => JsPromise.t<transferReturn> = "transfer"

  @send
  external transferFrom: (
    t,~sender: Ethers.ethAddress,~recipient: Ethers.ethAddress,~amount: Ethers.BigNumber.t,
  ) => JsPromise.t<transaction> = "transferFrom"

    type transferFromReturn = bool
    @send @scope("callStatic")
    external transferFromCall: (
      t,~sender: Ethers.ethAddress,~recipient: Ethers.ethAddress,~amount: Ethers.BigNumber.t,
    ) => JsPromise.t<transferFromReturn> = "transferFrom"

  @send
  external unpause: (
    t,
  ) => JsPromise.t<transaction> = "unpause"

  @send
  external upgradeTo: (
    t,~newImplementation: Ethers.ethAddress,
  ) => JsPromise.t<transaction> = "upgradeTo"

  @send
  external upgradeToAndCall: (
    t,~newImplementation: Ethers.ethAddress,~data: bytes32,
  ) => JsPromise.t<transaction> = "upgradeToAndCall"



