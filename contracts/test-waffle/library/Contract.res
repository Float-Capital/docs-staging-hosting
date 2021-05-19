type contractFactory
type t

type bytes32
type transaction = unit // TODO: make this better

@val @scope("ethers")
external getContractFactory: string => JsPromise.t<contractFactory> = "getContractFactory"
@send
external attachAtAddress: (contractFactory, ~contractAddress: Ethers.ethAddress) => JsPromise.t<t> =
  "attach"
@send external deploy: contractFactory => JsPromise.t<t> = "deploy"
@send external deploy1: (contractFactory, 'a) => JsPromise.t<t> = "deploy"
@send external deploy2: (contractFactory, 'a, 'b) => JsPromise.t<t> = "deploy"
@send external deploy3: (contractFactory, 'a, 'b, 'c) => JsPromise.t<t> = "deploy"
@send external deploy4: (contractFactory, 'a, 'b, 'c, 'd) => JsPromise.t<t> = "deploy"

@send external deployed: t => JsPromise.t<unit> = "deployed"

let attachToContract = (contractName, ~contractAddress) => {
  getContractFactory(contractName)->JsPromise.then(attachAtAddress(~contractAddress))
}
let deployContract = contractName => {
  getContractFactory(contractName)->JsPromise.then(deploy)->JsPromise.then(deployed)
}
let deployContract1 = (contractName, firstParam) => {
  getContractFactory(contractName)->JsPromise.then(deploy1(_, firstParam))->JsPromise.then(deployed)
}
let deployContract2 = (contractName, firstParam, secondParam) => {
  getContractFactory(contractName)
  ->JsPromise.then(deploy2(_, firstParam, secondParam))
  ->JsPromise.then(deployed)
}
let deployContract3 = (contractName, firstParam, secondParam, thirdParam) => {
  getContractFactory(contractName)
  ->JsPromise.then(deploy3(_, firstParam, secondParam, thirdParam))
  ->JsPromise.then(deployed)
}

@send external connect: ('contract, ~address: Ethers.Wallet.t) => 'contract = "connect"

module SyntheticToken = {
  type t = {address: Ethers.ethAddress}
  let contractName = "SyntheticToken"

  let at: Ethers.ethAddress => JsPromise.t<t> = contractAddress =>
    attachToContract(contractName, ~contractAddress)->Obj.magic

  @send
  external setup: (t, string, string, Ethers.ethAddress) => JsPromise.t<transaction> = "stake"
}

type staker

module PaymentToken = {
  type t = {address: Ethers.ethAddress}
  let contractName = "ERC20PresetMinterPauser"

  let make: (~name: string, ~symbol: string) => JsPromise.t<t> = (~name, ~symbol) =>
    deployContract2(contractName, name, symbol)->Obj.magic
  let at: Ethers.ethAddress => JsPromise.t<t> = contractAddress =>
    attachToContract(contractName, ~contractAddress)->Obj.magic

  @send @scope(`MINTER_ROLE`)
  external getMintRole: t => JsPromise.t<bytes32> = "call"
  @send
  external grantRole: (t, ~minterRole: bytes32, ~user: Ethers.ethAddress) => JsPromise.t<unit> =
    "grantRole"

  let grantMintRole = (t, ~user) =>
    t->getMintRole->JsPromise.then(minterRole => t->grantRole(~minterRole, ~user))

  @send
  external mint: (t, ~user: Ethers.ethAddress, ~amount: Ethers.BigNumber.t) => JsPromise.t<unit> =
    "mint"
  @send
  external approve: (
    t,
    ~spender: Ethers.ethAddress,
    ~amount: Ethers.BigNumber.t,
  ) => JsPromise.t<unit> = "approve"
  let mintAndApprove = (
    t,
    ~user: Ethers.Wallet.t,
    ~amount: Ethers.BigNumber.t,
    ~spender: Ethers.ethAddress,
  ) =>
    t
    ->mint(~amount, ~user=user.address)
    ->JsPromise.then(_ => {
      t->connect(~address=user)->approve(~amount, ~spender)
    })
}

module YieldManagerMock = {
  type t = {address: Ethers.ethAddress}
  let contractName = "YieldManagerMock"

  let make: (Ethers.ethAddress, Ethers.ethAddress, Ethers.ethAddress) => JsPromise.t<t> = (
    admin,
    longShortAddress,
    fundTokenAddress,
  ) => deployContract3(contractName, admin, longShortAddress, fundTokenAddress)->Obj.magic
  let at: Ethers.ethAddress => JsPromise.t<t> = contractAddress =>
    attachToContract(contractName, ~contractAddress)->Obj.magic
}

module OracleManagerMock = {
  type t = {address: Ethers.ethAddress}
  let contractName = "OracleManagerMock"

  let make: Ethers.ethAddress => JsPromise.t<t> = admin =>
    deployContract1(contractName, admin)->Obj.magic
  let at: Ethers.ethAddress => JsPromise.t<t> = contractAddress =>
    attachToContract(contractName, ~contractAddress)->Obj.magic
}

module LongShort = {
  type t = {address: Ethers.ethAddress}
  let contractName = "LongShort"

  let make: unit => JsPromise.t<t> = () => deployContract(contractName)->Obj.magic

  @send
  external setup: (
    t,
    Ethers.ethAddress,
    Ethers.ethAddress,
    Ethers.ethAddress,
    Ethers.ethAddress,
  ) => JsPromise.t<transaction> = "initialize"
  @send
  external newSyntheticMarket: (
    t,
    ~marketName: string,
    ~marketSymbol: string,
    ~paymentToken: Ethers.ethAddress,
    ~oracleManager: Ethers.ethAddress,
    ~yieldManager: Ethers.ethAddress,
  ) => JsPromise.t<transaction> = "newSyntheticMarket"
  @send
  external initializeMarket: (
    t,
    ~marketIndex: int,
    ~baseEntryFee: int,
    ~badLiquidityEntryFee: int,
    ~baseExitFee: int,
    ~badLiquidityExitFee: int,
    ~kInitialMultiplier: Ethers.BigNumber.t,
    ~kPeriod: Ethers.BigNumber.t,
  ) => JsPromise.t<transaction> = "initializeMarket"

  @send
  external fundTokens: (t, ~marketIndex: int) => JsPromise.t<Ethers.ethAddress> = "fundTokens"

  @send
  external longSynth: (t, ~marketIndex: int) => JsPromise.t<Ethers.ethAddress> = "longTokens"
  @send
  external shortSynth: (t, ~marketIndex: int) => JsPromise.t<Ethers.ethAddress> = "shortTokens"
  @send
  external yieldManagers: (t, ~marketIndex: int) => JsPromise.t<Ethers.ethAddress> = "yieldManagers"
  @send
  external oracleManagers: (t, ~marketIndex: int) => JsPromise.t<Ethers.ethAddress> =
    "oracleManagers"
  @send
  external staker: t => JsPromise.t<Ethers.ethAddress> = "staker"

  @send
  external latestMarket: t => JsPromise.t<int> = "latestMarket"

  @send
  external mintLongAndStake: (
    t,
    ~marketIndex: int,
    ~amount: Ethers.BigNumber.t,
  ) => JsPromise.t<transaction> = "mintLongAndStake"
  @send
  external mintShortAndStake: (
    t,
    ~marketIndex: int,
    ~amount: Ethers.BigNumber.t,
  ) => JsPromise.t<transaction> = "mintShortAndStake"
  @send
  external updateMarketOracle: (
    t,
    ~marketIndex: int,
    ~newOracleAddress: Ethers.ethAddress,
  ) => JsPromise.t<transaction> = "updateMarketOracle"
}

module GenericErc20 = {
  type t = {address: Ethers.ethAddress}
  let contractName = "ERC20PresetMinterPauserUpgradeable"

  let make: unit => JsPromise.t<t> = () => deployContract(contractName)->Obj.magic
}

module TokenFactory = {
  type t = {address: Ethers.ethAddress}
  let contractName = "TokenFactory"

  let make: (Ethers.ethAddress, Ethers.ethAddress) => JsPromise.t<t> = (admin, longShort) =>
    deployContract2(contractName, admin, longShort)->Obj.magic
}

module Staker = {
  type t = staker
  @get external address: t => Ethers.ethAddress = "address"
  let contractName = "Staker"

  let make: unit => JsPromise.t<t> = () => deployContract(contractName)->Obj.magic
  let at: Ethers.ethAddress => JsPromise.t<t> = contractAddress =>
    attachToContract(contractName, ~contractAddress)->Obj.magic

  @send
  external setup: (
    t,
    Ethers.ethAddress,
    Ethers.ethAddress,
    Ethers.ethAddress,
    Ethers.ethAddress,
  ) => JsPromise.t<transaction> = "initialize"

  @send
  external claimFloatCustom: (t, ~markets: array<int>) => JsPromise.t<transaction> =
    "claimFloatCustom"
  let claimFloatCustomUser = (staker, ~user: Ethers.Wallet.t, ~markets: array<int>) =>
    staker->connect(~address=user)->claimFloatCustom(~markets)

  @send
  external marketIndexOfToken: (t, ~syntheticToken: Ethers.ethAddress) => JsPromise.t<int> =
    "marketIndexOfToken"

  @send
  external userAmountStaked: (
    t,
    ~syntheticToken: Ethers.ethAddress,
    ~user: Ethers.ethAddress,
  ) => JsPromise.t<Ethers.BigNumber.t> = "userAmountStaked"

  @send
  external userIndexOfLastClaimedReward: (
    t,
    ~market: int,
    ~user: Ethers.ethAddress,
  ) => JsPromise.t<Ethers.BigNumber.t> = "userIndexOfLastClaimedReward"

  @send
  external latestRewardIndex: (t, ~market: int) => JsPromise.t<Ethers.BigNumber.t> =
    "latestRewardIndex"
}

module FloatToken = {
  type t = {address: Ethers.ethAddress}
  let contractName = "FloatToken"

  let make: unit => JsPromise.t<t> = () => deployContract(contractName)->Obj.magic

  @send
  external setup: (t, string, string, Ethers.ethAddress) => JsPromise.t<transaction> =
    "initialize(string,string,address)"
}

module FloatCapital_v0 = {
  type t = {address: Ethers.ethAddress}
  let contractName = "FloatCapital_v0"

  let make: unit => JsPromise.t<t> = () => deployContract(contractName)->Obj.magic
}

module Treasury_v0 = {
  type t = {address: Ethers.ethAddress}
  let contractName = "Treasury_v0"

  let make: unit => JsPromise.t<t> = () => deployContract(contractName)->Obj.magic

  @send external setup: (t, Ethers.ethAddress) => JsPromise.t<transaction> = "initialize"
}

module DataFetchers = {
  let marketIndexOfSynth = (longShort: LongShort.t, ~syntheticToken: SyntheticToken.t): JsPromise.t<
    int,
  > =>
    longShort
    ->LongShort.staker
    ->JsPromise.then(Staker.at)
    ->JsPromise.then(Staker.marketIndexOfToken(~syntheticToken=syntheticToken.address))
}
