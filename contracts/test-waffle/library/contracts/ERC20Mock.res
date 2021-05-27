open Contract

type t = {address: Ethers.ethAddress}
let contractName = "ERC20Mock"

let make: (~name: string, ~symbol: string) => JsPromise.t<t> = (~name, ~symbol) =>
  deployContract2(contractName, name, symbol)->Obj.magic

let at: Ethers.ethAddress => JsPromise.t<t> = contractAddress =>
  attachToContract(contractName, ~contractAddress)->Obj.magic

@send
external mint: (t, ~user: Ethers.ethAddress, ~amount: Ethers.BigNumber.t) => JsPromise.t<unit> =
  "mint"

@send
external transfer: (
  t,
  ~recipient: Ethers.ethAddress,
  ~amount: Ethers.BigNumber.t,
) => JsPromise.t<transaction> = "transfer"
