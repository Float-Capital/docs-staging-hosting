// NOTE: since the type of all of these contracts is a generic `Ethers.Contract.t`, this code can runtime error if the wrong functions are called on the wrong contracts.

module LongShort = {
  type t = Ethers.Contract.t

  let abi =
    [
      "function mintLongNextPrice(uint32 marketIndex,uint256 amount) @1200000",
      "function mintShortNextPrice(uint32 marketIndex,uint256 amount) @1200000",
      "function redeemLongNextPrice(uint32 marketIndex,uint256 tokensToRedeem) @1200000",
      "function redeemShortNextPrice(uint32 marketIndex,uint256 tokensToRedeem) @1200000",
      "function executeOutstandingNextPriceSettlementsUser(address user,uint32 marketIndex) @1200000",
      "function updateSystemState()",
      "function updateSystemStateMulti(uint32[] marketIndexes)",
    ]->Ethers.makeAbi

  let make = (~address, ~providerOrSigner): t =>
    Ethers.Contract.make(address, abi, providerOrSigner)

  @send
  external mintLongNextPrice: (
    ~contract: t,
    ~marketIndex: Ethers.BigNumber.t,
    ~amount: Ethers.BigNumber.t,
    'txOptions,
  ) => JsPromise.t<Ethers.txSubmitted> = "mintLongNextPrice"
  @send
  external mintShortNextPrice: (
    ~contract: t,
    ~marketIndex: Ethers.BigNumber.t,
    ~amount: Ethers.BigNumber.t,
    'txOptions,
  ) => JsPromise.t<Ethers.txSubmitted> = "mintShortNextPrice"
  @send
  external redeemLongNextPrice: (
    ~contract: t,
    ~marketIndex: Ethers.BigNumber.t,
    ~tokensToRedeem: Ethers.BigNumber.t,
    'txOptions,
  ) => JsPromise.t<Ethers.txSubmitted> = "redeemLongNextPrice"
  @send
  external redeemShortNextPrice: (
    ~contract: t,
    ~marketIndex: Ethers.BigNumber.t,
    ~tokensToRedeem: Ethers.BigNumber.t,
    'txOptions,
  ) => JsPromise.t<Ethers.txSubmitted> = "redeemShortNextPrice"
  @send
  external executeOutstandingNextPriceSettlementsUser: (
    ~contract: t,
    ~user: Ethers.ethAddress,
    ~marketIndex: Ethers.BigNumber.t,
    'txOptions,
  ) => JsPromise.t<Ethers.txSubmitted> = "executeOutstandingNextPriceSettlementsUser"
  @send
  external updateSystemState: (~contract: t, 'txOptions) => JsPromise.t<Ethers.txSubmitted> =
    "updateSystemState"
  @send
  external updateSystemStateMulti: (
    ~contract: t,
    ~marketIndexes: array<Ethers.BigNumber.t>,
    'txOptions,
  ) => JsPromise.t<Ethers.txSubmitted> = "updateSystemStateMulti"
}

module Staker = {
  type t = Ethers.Contract.t

  let abi =
    [
      "function stake(address tokenAddress, uint256 amount) @6000000",
      "function withdraw(uint32, bool, uint256 amount) @6000000",
      "function claimFloatCustom(uint32[] calldata marketIndexes) @6000000",
    ]->Ethers.makeAbi

  let make = (~address, ~providerOrSigner): t =>
    Ethers.Contract.make(address, abi, providerOrSigner)

  @send
  external stake: (
    ~contract: t,
    ~tokenAddress: Ethers.ethAddress,
    ~amount: Ethers.BigNumber.t,
    'txOptions,
  ) => JsPromise.t<Ethers.txSubmitted> = "stake"
  @send
  external withdraw: (
    ~contract: t,
    ~marketIndex: int,
    ~isWithdrawFromLong: bool,
    ~amount: Ethers.BigNumber.t,
    'txOptions,
  ) => JsPromise.t<Ethers.txSubmitted> = "withdraw"
  @send
  external claimFloatCustom: (
    ~contract: t,
    ~marketIndexes: array<Ethers.BigNumber.t>,
    'txOptions,
  ) => JsPromise.t<Ethers.txSubmitted> = "claimFloatCustom"
}

module Erc20 = {
  type t = Ethers.Contract.t

  let abi =
    [
      "function approve(address spender, uint256 amount) @52000",
      "function balanceOf(address owner) public view returns (uint256 balance)",
      "function allowance(address owner, address spender) public view returns (uint256 remaining)",
      "function mint(uint256 value) public virtual returns (bool)",
    ]->Ethers.makeAbi

  let make = (~address, ~providerOrSigner): t =>
    Ethers.Contract.make(address, abi, providerOrSigner)

  @send
  external approve: (
    ~contract: t,
    ~spender: Ethers.ethAddress,
    ~amount: Ethers.BigNumber.t,
    'txOptions,
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

  @send
  external mint: (
    ~contract: t,
    ~amount: Ethers.BigNumber.t,
    'txOptions,
  ) => JsPromise.t<Ethers.txSubmitted> = "mint"
}

module Synth = {
  type t = Ethers.Contract.t

  let abi =
    [
      "function approve(address spender, uint256 amount) @52000",
      "function balanceOf(address owner) public view returns (uint256 balance)",
      "function allowance(address owner, address spender) public view returns (uint256 remaining)",
      "function stake(uint256 amount) external @500000",
    ]->Ethers.makeAbi

  let make = (~address, ~providerOrSigner): t =>
    Ethers.Contract.make(address, abi, providerOrSigner)

  @send
  external approve: (
    ~contract: t,
    ~spender: Ethers.ethAddress,
    ~amount: Ethers.BigNumber.t,
    'txOptions,
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

  @send
  external stake: (
    ~contract: t,
    ~amount: Ethers.BigNumber.t,
    'txOptions,
  ) => JsPromise.t<Ethers.txSubmitted> = "stake"
}
