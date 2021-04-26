type contractFactory
type t

type ethAddr = string // TODO: make this better
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

module LongShort = {
  type t = {address: ethAddr}
  let contractName = "LongShort"

  let make: unit => JsPromise.t<t> = () => deployContract(contractName)->Obj.magic

  @send
  external setup: (t, ethAddr, ethAddr, ethAddr, ethAddr) => JsPromise.t<transaction> = "setup"
}

module YieldManagerMock = {
  type t = {address: ethAddr}
  let contractName = "YieldManagerMock"

  let make: unit => JsPromise.t<t> = () => deployContract(contractName)->Obj.magic
}

module OracleManagerMock = {
  type t = {address: ethAddr}
  let contractName = "OracleManagerMock"

  let make: unit => JsPromise.t<t> = () => deployContract(contractName)->Obj.magic
}

module GenericErc20 = {
  type t = {address: ethAddr}
  let contractName = "ERC20PresetMinterPauserUpgradeable"

  let make: unit => JsPromise.t<t> = () => deployContract(contractName)->Obj.magic
}

module SyntheticToken = {
  type t = {address: ethAddr}
  let contractName = "SyntheticToken"

  let make: unit => JsPromise.t<t> = () => deployContract(contractName)->Obj.magic
}

module TokenFactory = {
  type t = {address: ethAddr}
  let contractName = "TokenFactory"

  let make: unit => JsPromise.t<t> = () => deployContract(contractName)->Obj.magic

  @send external setup: (t, ethAddr, ethAddr) => JsPromise.t<transaction> = "setup"
}

module Staker = {
  type t = {address: ethAddr}
  let contractName = "Staker"

  let make: unit => JsPromise.t<t> = () => deployContract(contractName)->Obj.magic

  @send
  external setup: (t, ethAddr, ethAddr, ethAddr, ethAddr) => JsPromise.t<transaction> = "initialize"
}

module FloatToken = {
  type t = {address: ethAddr}
  let contractName = "FloatToken"

  let make: unit => JsPromise.t<t> = () => deployContract(contractName)->Obj.magic

  @send external setup: (t, string, string, ethAddr) => JsPromise.t<transaction> = "setup"
}

module FloatCapital_v0 = {
  type t = {address: ethAddr}
  let contractName = "FloatCapital_v0"

  let make: unit => JsPromise.t<t> = () => deployContract(contractName)->Obj.magic
}

module Treasury_v0 = {
  type t = {address: ethAddr}
  let contractName = "Treasury_v0"

  let make: unit => JsPromise.t<t> = () => deployContract(contractName)->Obj.magic

  @send external setup: (t, ethAddr) => JsPromise.t<transaction> = "initialize"
}
