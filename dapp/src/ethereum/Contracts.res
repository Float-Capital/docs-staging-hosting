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
      "function mintLong(uint256 marketIndex,uint256 amount) @5000000",
      "function mintShort(uint256 marketIndex,uint256 amount)",
      "function redeemLong(uint256 marketIndex,uint256 tokensToRedeem)",
      "function redeemShort(uint256 marketIndex,uint256 tokensToRedeem)",
      "function _updateSystemState()",
    ]->Ethers.makeAbi

  let make = (~address, ~providerOrSigner): t =>
    Ethers.Contract.make(address, abi, providerOrSigner)

  @send
  external mintLong: (
    ~contract: t,
    ~marketIndex: Ethers.BigNumber.t,
    ~amount: Ethers.BigNumber.t,
  ) => JsPromise.t<Ethers.txSubmitted> = "mintLong"
  @send
  external mintShort: (
    ~contract: t,
    ~marketIndex: Ethers.BigNumber.t,
    ~amount: Ethers.BigNumber.t,
  ) => JsPromise.t<Ethers.txSubmitted> = "mintShort"
  @send
  external redeemLong: (
    ~contract: t,
    ~marketIndex: Ethers.BigNumber.t,
    ~tokensToRedeem: Ethers.BigNumber.t,
  ) => JsPromise.t<Ethers.txSubmitted> = "redeemLong"
  @send
  external redeemShort: (
    ~contract: t,
    ~marketIndex: Ethers.BigNumber.t,
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
    "function balanceOf(address owner) public view returns (uint256 balance)",
    "function allowance(address owner, address spender) public view returns (uint256 remaining)",
    // "event Transfer(address indexed _from, address indexed _to, uint256 _value)",
  ]->Ethers.makeAbi

  let make = (~address, ~providerOrSigner): t =>
    Ethers.Contract.make(address, abi, providerOrSigner)

  @send
  external approve: (
    ~contract: t,
    ~spender: Ethers.ethAddress,
    ~amount: Ethers.BigNumber.t,
  ) => JsPromise.t<Ethers.txSubmitted> = "approve"

  @send
  external balanceOf: (~contract: t, ~owner: Ethers.ethAddress) => JsPromise.t<Ethers.BigNumber.t> =
    "balanceOf"

  @send
  external allowance: (
    ~contract: t,
    ~owner: Ethers.ethAddress,
    ~spender: Ethers.ethAddress,
  ) => JsPromise.t<Ethers.BigNumber.t> = "allowance"
}

module SyntheticToken = {
  type t = Ethers.Contract.t

  let abi = ["function redeem(uint256 amount)"]->Ethers.makeAbi

  let make = (~address, ~providerOrSigner): t =>
    Ethers.Contract.make(address, abi, providerOrSigner)

  @send
  external redeem: (~contract: t, ~amount: Ethers.BigNumber.t) => JsPromise.t<Ethers.txSubmitted> =
    "redeem"
}
