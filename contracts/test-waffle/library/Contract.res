type contractFactory
type t

type bytes32
type transaction = unit // TODO: make this better

@val @scope("ethers")
external getContractFactory: string => JsPromise.t<contractFactory> = "getContractFactory"
@send external deploy: contractFactory => JsPromise.t<t> = "deploy"
@send external deploy1: (contractFactory, 'a) => JsPromise.t<t> = "deploy"
@send external deploy2: (contractFactory, 'a, 'b) => JsPromise.t<t> = "deploy"
@send external deploy3: (contractFactory, 'a, 'b, 'c) => JsPromise.t<t> = "deploy"
@send external deploy4: (contractFactory, 'a, 'b, 'c, 'd) => JsPromise.t<t> = "deploy"

@send external deployed: t => JsPromise.t<unit> = "deployed"

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

@send external attach: ('contract, ~address: Ethers.ethAddress) => 'contract = "attach"

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

  @send @scope("fundTokens")
  external fundTokenAddress: (t, ~marketName: string) => JsPromise.t<Ethers.ethAddress> = "call"

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
}

module YieldManagerMock = {
  type t = {address: Ethers.ethAddress}
  let contractName = "YieldManagerMock"

  let make: (Ethers.ethAddress, Ethers.ethAddress, Ethers.ethAddress) => JsPromise.t<t> = (
    admin,
    longShortAddress,
    fundTokenAddress,
  ) => deployContract3(contractName, admin, longShortAddress, fundTokenAddress)->Obj.magic
}

module OracleManagerMock = {
  type t = {address: Ethers.ethAddress}
  let contractName = "OracleManagerMock"

  let make: Ethers.ethAddress => JsPromise.t<t> = admin =>
    deployContract1(contractName, admin)->Obj.magic
}

module GenericErc20 = {
  type t = {address: Ethers.ethAddress}
  let contractName = "ERC20PresetMinterPauserUpgradeable"

  let make: unit => JsPromise.t<t> = () => deployContract(contractName)->Obj.magic
}

module SyntheticToken = {
  type t = {address: Ethers.ethAddress}
  let contractName = "SyntheticToken"

  let make: unit => JsPromise.t<t> = () => deployContract(contractName)->Obj.magic
}

module TokenFactory = {
  type t = {address: Ethers.ethAddress}
  let contractName = "TokenFactory"

  let make: (Ethers.ethAddress, Ethers.ethAddress) => JsPromise.t<t> = (admin, longShort) =>
    deployContract2(contractName, admin, longShort)->Obj.magic
}

module Staker = {
  type t = {address: Ethers.ethAddress}
  let contractName = "Staker"

  let make: unit => JsPromise.t<t> = () => deployContract(contractName)->Obj.magic

  @send
  external setup: (
    t,
    Ethers.ethAddress,
    Ethers.ethAddress,
    Ethers.ethAddress,
    Ethers.ethAddress,
  ) => JsPromise.t<transaction> = "initialize"
}

module FloatToken = {
  type t = {address: Ethers.ethAddress}
  let contractName = "FloatToken"

  let make: unit => JsPromise.t<t> = () => deployContract(contractName)->Obj.magic

  @send
  external setup: (t, string, string, Ethers.ethAddress) => JsPromise.t<transaction> =
    "initialize(string,string,address)"
}

module PaymentToken = {
  type t = {address: Ethers.ethAddress}
  let contractName = "ERC20PresetMinterPauser"

  let make: (~name: string, ~symbol: string) => JsPromise.t<t> = (~name, ~symbol) =>
    deployContract2(contractName, name, symbol)->Obj.magic

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
    ~user: Ethers.ethAddress,
    ~amount: Ethers.BigNumber.t,
    ~spender: Ethers.ethAddress,
  ) =>
    t
    ->mint(~amount, ~user)
    ->JsPromise.then(_ => {
      t->attach(~address=user)->approve(~amount, ~spender)
    })
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
