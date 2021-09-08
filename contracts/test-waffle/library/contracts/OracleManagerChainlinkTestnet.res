
@@ocaml.warning("-32")
open SmockGeneral
open ContractHelpers
type t = {address: Ethers.ethAddress}
let contractName = "OracleManagerChainlinkTestnet"

let at: Ethers.ethAddress => JsPromise.t<t> = contractAddress =>
  attachToContract(contractName, ~contractAddress)->Obj.magic

let make: (~admin: Ethers.ethAddress,~chainlinkOracle: Ethers.ethAddress,~maxUpdateIntervalSeconds: Ethers.BigNumber.t,) => JsPromise.t<t> = (~admin,~chainlinkOracle,~maxUpdateIntervalSeconds,) =>
    deployContract3(contractName, admin,chainlinkOracle,maxUpdateIntervalSeconds,)->Obj.magic

    let makeSmock: (~admin: Ethers.ethAddress,~chainlinkOracle: Ethers.ethAddress,~maxUpdateIntervalSeconds: Ethers.BigNumber.t,) => JsPromise.t<t> = (~admin,~chainlinkOracle,~maxUpdateIntervalSeconds,) =>
    deployMockContract3(contractName, admin,chainlinkOracle,maxUpdateIntervalSeconds,)->Obj.magic

    let setVariable: (t, ~name: string, ~value: 'a) => JsPromise.t<unit> = setVariableRaw
    
    


  type adminReturn = Ethers.ethAddress
  @send
  external admin: (
    t,
  ) => JsPromise.t<adminReturn> = "admin"

  type chainlinkOracleReturn = Ethers.ethAddress
  @send
  external chainlinkOracle: (
    t,
  ) => JsPromise.t<chainlinkOracleReturn> = "chainlinkOracle"

  @send
  external changeAdmin: (
    t,~admin: Ethers.ethAddress,
  ) => JsPromise.t<transaction> = "changeAdmin"

  type getLatestPriceReturn = Ethers.BigNumber.t
  @send
  external getLatestPrice: (
    t,
  ) => JsPromise.t<getLatestPriceReturn> = "getLatestPrice"

  type oracleDecimalsReturn = int
  @send
  external oracleDecimals: (
    t,
  ) => JsPromise.t<oracleDecimalsReturn> = "oracleDecimals"

  @send
  external setMaxUpdateInterval: (
    t,~newMaxUpdateIntervalSeconds: Ethers.BigNumber.t,
  ) => JsPromise.t<transaction> = "setMaxUpdateInterval"

  @send
  external updatePrice: (
    t,
  ) => JsPromise.t<transaction> = "updatePrice"

    type updatePriceReturn = Ethers.BigNumber.t
    @send @scope("callStatic")
    external updatePriceCall: (
      t,
    ) => JsPromise.t<updatePriceReturn> = "updatePrice"



