type ethAddress

type txHash = string

type txResult

type txSubmitted = {
  hash: txHash,
  wait: (. unit) => JsPromise.t<txResult>,
}

type abi

let makeAbi = (abiArray: array<string>): abi => abiArray->Obj.magic

module BigNumber = {
  type t

  @module("ethers") @scope("BigNumber")
  external fromUnsafe: string => t = "from"
  @module("ethers") @scope("BigNumber")
  external fromInt: int => t = "from"

  @send external add: (t, t) => t = "add"
  @send external sub: (t, t) => t = "sub"
  @send external mul: (t, t) => t = "mul"
  @send external div: (t, t) => t = "div"
  @send external mod: (t, t) => t = "mod"
  @send external pow: (t, t) => t = "pow"
  @send external abs: t => t = "abs"

  @send external gt: (t, t) => bool = "gt"
  @send external gte: (t, t) => bool = "gte"
  @send external lt: (t, t) => bool = "lt"
  @send external lte: (t, t) => bool = "lte"
  @send external eq: (t, t) => bool = "eq"

  @send external toString: t => string = "toString"

  @send external toNumber: t => int = "toNumber"
  @send external toNumberFloat: t => float = "toNumber"
}

module Providers = {
  type t
  module JsonRpcProvider = {
    @new @module("ethers") @scope("providers")
    external make: (string, ~chainId: int) => JsPromise.t<t> = "JsonRpcProvider"
  }

  module FallbackProvider = {
    @new @module("ethers") @scope("providers")
    external make: (array<t>, ~quorum: int) => JsPromise.t<t> = "FallbackProvider"
  }

  type filter = {
    address: ethAddress,
    topics: array<string>,
  }

  @send external on: (t, filter, unit => unit) => unit = "on"
}

module Wallet = {
  type t

  @new @module("ethers") @scope("Wallet")
  external fromMnemonic: string => JsPromise.t<t> = "fromMnemonic"

  @send external connect: (t, Providers.t) => t = "connect"

  @send external getBalance: t => JsPromise.t<BigNumber.t> = "getBalance"
}

type providerOrSigner =
  | Provider(Providers.t)
  | Signer(Wallet.t)

let getSigner: Wallet.t => providerOrSigner = w => Signer(w)

module Utils = {
  type ethUnit = [
    | #wei
    | #kwei
    | #mwei
    | #gwei
    | #microether
    | #milliether
    | #ether
    | #kether
    | #mether
    | #geher
    | #tether
  ]

  @module("ethers") @scope("utils")
  external formatUnits: (. BigNumber.t, ethUnit) => string = "formatUnits"

  let formatEther = formatUnits(. _, #ether)

  @module("ethers") @scope("utils")
  external id: string => string = "id"

  @module("ethers") @scope("utils")
  external getAddressUnsafe: string => ethAddress = "getAddress"
}

module Contract = {
  type t

  @new @module("ethers")
  external getContractSigner: (ethAddress, abi, Wallet.t) => t = "Contract"
  @new @module("ethers")
  external getContractProvider: (ethAddress, abi, Providers.t) => t = "Contract"

  let make: (ethAddress, abi, providerOrSigner) => t = (address, abi, providerSigner) => {
    switch providerSigner {
    | Provider(provider) => getContractProvider(address, abi, provider)
    | Signer(signer) => getContractSigner(address, abi, signer)
    }
  }
}

let ethAdrToStr: ethAddress => string = Obj.magic
