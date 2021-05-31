@@ocaml.warning("-32")
open ContractHelpers
type t = {address: Ethers.ethAddress}
let contractName = "ERC20"

let at: Ethers.ethAddress => JsPromise.t<t> = contractAddress =>
  attachToContract(contractName, ~contractAddress)->Obj.magic

let make: (~name_: string, ~symbol_: string) => JsPromise.t<t> = (~name_, ~symbol_) =>
  deployContract2(contractName, name_, symbol_)->Obj.magic

type allowanceReturn = Ethers.BigNumber.t
@send
external allowance: (
  t,
  ~owner: Ethers.ethAddress,
  ~spender: Ethers.ethAddress,
) => JsPromise.t<allowanceReturn> = "allowance"

@send
external approve: (
  t,
  ~spender: Ethers.ethAddress,
  ~amount: Ethers.BigNumber.t,
) => JsPromise.t<transaction> = "approve"

type approveReturn = bool
@send @scope("callStatic")
external approveCall: (
  t,
  ~spender: Ethers.ethAddress,
  ~amount: Ethers.BigNumber.t,
) => JsPromise.t<approveReturn> = "approve"

type balanceOfReturn = Ethers.BigNumber.t
@send
external balanceOf: (t, ~account: Ethers.ethAddress) => JsPromise.t<balanceOfReturn> = "balanceOf"

type decimalsReturn = int
@send
external decimals: t => JsPromise.t<decimalsReturn> = "decimals"

@send
external decreaseAllowance: (
  t,
  ~spender: Ethers.ethAddress,
  ~subtractedValue: Ethers.BigNumber.t,
) => JsPromise.t<transaction> = "decreaseAllowance"

type decreaseAllowanceReturn = bool
@send @scope("callStatic")
external decreaseAllowanceCall: (
  t,
  ~spender: Ethers.ethAddress,
  ~subtractedValue: Ethers.BigNumber.t,
) => JsPromise.t<decreaseAllowanceReturn> = "decreaseAllowance"

@send
external increaseAllowance: (
  t,
  ~spender: Ethers.ethAddress,
  ~addedValue: Ethers.BigNumber.t,
) => JsPromise.t<transaction> = "increaseAllowance"

type increaseAllowanceReturn = bool
@send @scope("callStatic")
external increaseAllowanceCall: (
  t,
  ~spender: Ethers.ethAddress,
  ~addedValue: Ethers.BigNumber.t,
) => JsPromise.t<increaseAllowanceReturn> = "increaseAllowance"

type nameReturn = string
@send
external name: t => JsPromise.t<nameReturn> = "name"

type symbolReturn = string
@send
external symbol: t => JsPromise.t<symbolReturn> = "symbol"

type totalSupplyReturn = Ethers.BigNumber.t
@send
external totalSupply: t => JsPromise.t<totalSupplyReturn> = "totalSupply"

@send
external transfer: (
  t,
  ~recipient: Ethers.ethAddress,
  ~amount: Ethers.BigNumber.t,
) => JsPromise.t<transaction> = "transfer"

type transferReturn = bool
@send @scope("callStatic")
external transferCall: (
  t,
  ~recipient: Ethers.ethAddress,
  ~amount: Ethers.BigNumber.t,
) => JsPromise.t<transferReturn> = "transfer"

@send
external transferFrom: (
  t,
  ~sender: Ethers.ethAddress,
  ~recipient: Ethers.ethAddress,
  ~amount: Ethers.BigNumber.t,
) => JsPromise.t<transaction> = "transferFrom"

type transferFromReturn = bool
@send @scope("callStatic")
external transferFromCall: (
  t,
  ~sender: Ethers.ethAddress,
  ~recipient: Ethers.ethAddress,
  ~amount: Ethers.BigNumber.t,
) => JsPromise.t<transferFromReturn> = "transferFrom"
