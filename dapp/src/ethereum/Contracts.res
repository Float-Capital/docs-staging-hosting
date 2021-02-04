// NOTE: since the type of all of these contracts is a generic `Ethers.Contract.t`, this code can runtime error if the wrong functions are called on the wrong contracts.

module TestErc20 = {
  type t = Ethers.Contract.t

  let abi = [
    "function mint(address,uint256)",
    // "event Transfer(address indexed from, address indexed to, uint amount)",
  ]->Ethers.makeAbi

  let make = (~address, ~providerOrSigner): t =>
    Ethers.Contract.make(address, abi, providerOrSigner)

  @send
  external mint: (
    ~contract: t,
    ~recipient: Ethers.ethAddress,
    ~amount: Ethers.BigNumber.t,
  ) => JsPromise.t<Ethers.txSubmitted> = "mint"
}

module LongShort = {
  type t = Ethers.Contract.t

  let abi =
    [
      "function mintLong(uint256 amount)",
      "function mintShort(uint256 amount)",
      "function redeemLong(uint256 tokensToRedeem)",
      "function redeemShort(uint256 tokensToRedeem)",
      "function _updateSystemState()",
    ]->Ethers.makeAbi

  let make = (~address, ~providerOrSigner): t =>
    Ethers.Contract.make(address, abi, providerOrSigner)

  @send
  external mintLong: (
    ~contract: t,
    ~amount: Ethers.BigNumber.t,
  ) => JsPromise.t<Ethers.txSubmitted> = "mintLong"
  @send
  external mintShort: (t, ~amount: Ethers.BigNumber.t) => JsPromise.t<Ethers.txSubmitted> =
    "mintShort"
  @send
  external redeemLong: (
    ~contract: t,
    ~tokensToRedeem: Ethers.BigNumber.t,
  ) => JsPromise.t<Ethers.txSubmitted> = "redeemLong"
  @send
  external redeemShort: (
    ~contract: t,
    ~tokensToRedeem: Ethers.BigNumber.t,
  ) => JsPromise.t<Ethers.txSubmitted> = "redeemShort"
  @send
  external _updateSystemState: (~contract: t) => JsPromise.t<Ethers.txSubmitted> =
    "_updateSystemState"
}

module Erc20 = {
  type t = Ethers.Contract.t

  let abi = [
    "function approve(address spender, uint256 amount)",
    // "event Transfer(address indexed from, address indexed to, uint amount)",
  ]->Ethers.makeAbi

  let make = (~address, ~providerOrSigner): t =>
    Ethers.Contract.make(address, abi, providerOrSigner)

  @send
  external approve: (
    ~contract: t,
    ~spender: Ethers.ethAddress,
    ~amount: Ethers.BigNumber.t,
  ) => JsPromise.t<Ethers.txSubmitted> = "approve"
}
