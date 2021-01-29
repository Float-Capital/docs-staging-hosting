type txResult = {
  @dead("txResult.blockHash") blockHash: string,
  @dead("txResult.blockNumber") blockNumber: int,
  @dead("txResult.byzantium") byzantium: bool,
  @dead("txResult.confirmations") confirmations: int,
  // contractAddress: null,
  // cumulativeGasUsed: Object { _hex: "0x26063", … },
  // events: Array(4) [ {…}, {…}, {…}, … ],
  @dead("txResult.from") from: Web3.ethAddress,
  // gasUsed: Object { _hex: "0x26063", … },
  // logs: Array(4) [ {…}, {…}, {…}, … ],
  // logsBloom: "0x00200000000000008000000000000000000020000001000000000000400020000000000000002000000000000000000000000002800010000000008000000000000000000000000000000008000000000040000000000000000000000000000000000000020000014000000000000800024000000000000000000010000000000000000000000000000000000000000000008000000000000000000000000200000008000000000000000000000000000000000800000000000000000000000000001002000000000000000000000000000000000000000020000000040020000000000000000080000000000000000000000000000000080000000000200000"
  @dead("txResult.status") status: int,
  @dead("txResult._to") _to: Web3.ethAddress,
  transactionHash: string,
  @dead("txResult.transactionIndex") transactionIndex: int,
}
type txError = {
  @dead("txError.code") code: int, // -32000 = always failing tx ;  4001 = Rejected by signer.
  message: string,
  @dead("txError.stack") stack: option<string>,
}

type abi

let makeAbi = (abiArray: array<string>): abi => abiArray->Obj.magic

type ethAddress = string
type ethersBigNumber

module BigNumber = {
  type t = ethersBigNumber

  @send external add: (t, t) => t = "add"
  @send external sub: (t, t) => t = "sub"
  @send external mul: (t, t) => t = "mul"
  @send external div: (t, t) => t = "div"
  @send external gt: (t, t) => bool = "gt"
  @send external lt: (t, t) => bool = "lt"
  @dead("+eq") @send external eq: (t, t) => bool = "eq"
  @send external cmp: (t, t) => int = "cmp"
  @dead("+sqr") @send external sqr: t => t = "sqr"
  @send external toString: t => string = "toString"
  @send external toStringRad: (t, int) => string = "toString"

  @send external toNumber: t => int = "toNumber"
  @send external toNumberFloat: t => float = "toNumber"
}

@send
external waitForTransaction: (Web3.rawProvider, string) => JsPromise.t<txResult> =
  "waitForTransaction"

type providerType
type walletType = {address: string, provider: providerType}

module Wallet = {
  type t = walletType

  @new @module("ethers")
  external makePrivKeyWallet: (string, providerType) => t = "Wallet"
}

module Providers = {
  type t = providerType

  @new @module("ethers") @scope("providers")
  external makeProvider: string => Web3.rawProvider = "JsonRpcProvider"

  @send @scope("providers")
  external getBalance: (t, ethAddress) => JsPromise.t<option<BigNumber.t>> = "getBalance"
  @send @scope("providers")
  external getSigner: (t, ethAddress) => option<Wallet.t> = "getSigner"
}

type providerOrSigner = 
| Provider(Providers.t)
| Signer(Wallet.t)

module Contract = {
  type t

  @new @module("ethers")
  external getContractSigner: (ethAddress, abi, Wallet.t) => t = "Contract"
  @new @module("ethers")
  external getContractProvider: (ethAddress, abi, Providers.t) => t = "Contract"

  let make: (ethAddress,abi, providerOrSigner)=> t = (address, abi, providerSigner) => {switch providerSigner {
      | Provider(provider) => getContractProvider(address,abi, provider)
      | Signer(signer) => getContractSigner(address,abi, signer)
    } }
}
