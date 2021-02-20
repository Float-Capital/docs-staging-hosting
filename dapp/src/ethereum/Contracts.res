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
      "function mintLong(uint256 marketIndex,uint256 amount)",
      "function mintShort(uint256 marketIndex,uint256 amount)",
      "function redeemLong(uint256 marketIndex,uint256 tokensToRedeem)",
      "function redeemShort(uint256 marketIndex,uint256 tokensToRedeem)",
      "function mintLongAndStake(uint256 marketIndex, uint256 amount) @1000000",
      "function mintShortAndStake(uint256 marketIndex, uint256 amount) @1000000",
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
  external mintShortAndStake: (
    ~contract: t,
    ~marketIndex: Ethers.BigNumber.t,
    ~amount: Ethers.BigNumber.t,
  ) => JsPromise.t<Ethers.txSubmitted> = "mintShortAndStake"
  @send
  external mintLongAndStake: (
    ~contract: t,
    ~marketIndex: Ethers.BigNumber.t,
    ~amount: Ethers.BigNumber.t,
  ) => JsPromise.t<Ethers.txSubmitted> = "mintLongAndStake"
  @send
  external _updateSystemState: (~contract: t) => JsPromise.t<Ethers.txSubmitted> =
    "_updateSystemState"
}

module Staker = {
  type t = Ethers.Contract.t

  let abi =
    [
      "function stake(address tokenAddress, uint256 amount)",
      "function stakeAndEarnImmediately(address tokenAddress, uint256 amount)",
      "function withdraw(address tokenAddress, uint256 amount)",
      "function mintFloat()",
    ]->Ethers.makeAbi

  let make = (~address, ~providerOrSigner): t =>
    Ethers.Contract.make(address, abi, providerOrSigner)

  @send
  external stake: (
    ~contract: t,
    ~tokenAddress: Ethers.ethAddress,
    ~amount: Ethers.BigNumber.t,
  ) => JsPromise.t<Ethers.txSubmitted> = "stake"
  @send
  external stakeAndEarnImmediately: (
    ~contract: t,
    ~tokenAddress: Ethers.ethAddress,
    ~amount: Ethers.BigNumber.t,
  ) => JsPromise.t<Ethers.txSubmitted> = "stakeAndEarnImmediately"
  external withdraw: (
    ~contract: t,
    ~tokenAddress: Ethers.ethAddress,
    ~amount: Ethers.BigNumber.t,
  ) => JsPromise.t<Ethers.txSubmitted> = "withdraw"
  external mintFloat: (~contract: t, unit) => JsPromise.t<Ethers.txSubmitted> = "mintFloat"
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
