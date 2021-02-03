module TestErc20 = {
  type t

  let abi = [
    "function mint(address,uint256)",
    // "event Transfer(address indexed from, address indexed to, uint amount)",
  ]->Ethers.makeAbi

  let make = (~address, ~providerOrSigner): t =>
    Ethers.Contract.make(address, abi, providerOrSigner)->Obj.magic

  @send
  external mint: (
    ~contract: t,
    ~recipient: Ethers.ethAddress,
    ~amount: Ethers.BigNumber.t,
  ) => JsPromise.t<Ethers.txSubmitted> = "mint"
}

module LongShort = {
  type t

  let abi =
    [
      "function mintLong(uint256 amount)",
      "function mintShort(uint256 amount)",
      "function redeemLong(uint256 tokensToRedeem)",
      "function redeemShort(uint256 tokensToRedeem)",
      "function _updateSystemState()",
    ]->Ethers.makeAbi

  let make = (~address, ~providerOrSigner): t =>
    Ethers.Contract.make(address, abi, providerOrSigner)->Obj.magic

  @send
  external mintLong: (
    ~contract: t,
    Ethers.ethAddress,
    Ethers.BigNumber.t,
  ) => JsPromise.t<Ethers.txSubmitted> = "mintLong"
  @send
  external mintShort: (
    t,
    Ethers.ethAddress,
    Ethers.BigNumber.t,
  ) => JsPromise.t<Ethers.txSubmitted> = "mintShort"
  @send
  external redeemLong: (
    t,
    Ethers.ethAddress,
    Ethers.BigNumber.t,
  ) => JsPromise.t<Ethers.txSubmitted> = "redeemLong"
  @send
  external redeemShort: (
    t,
    Ethers.ethAddress,
    Ethers.BigNumber.t,
  ) => JsPromise.t<Ethers.txSubmitted> = "redeemShort"
  @send
  external _updateSystemState: (t, Ethers.ethAddress) => JsPromise.t<Ethers.txSubmitted> =
    "_updateSystemState"
}
