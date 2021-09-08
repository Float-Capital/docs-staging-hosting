
@@ocaml.warning("-32")
open SmockGeneral
open ContractHelpers
type t = {address: Ethers.ethAddress}
let contractName = "OracleManagerMock"

let at: Ethers.ethAddress => JsPromise.t<t> = contractAddress =>
  attachToContract(contractName, ~contractAddress)->Obj.magic

let make: (~admin: Ethers.ethAddress,) => JsPromise.t<t> = (~admin,) =>
    deployContract1(contractName, admin,)->Obj.magic

    let makeSmock: (~admin: Ethers.ethAddress,) => JsPromise.t<t> = (~admin,) =>
    deployMockContract1(contractName, admin,)->Obj.magic

    let setVariable: (t, ~name: string, ~value: 'a) => JsPromise.t<unit> = setVariableRaw
    
    


  type adminReturn = Ethers.ethAddress
  @send
  external admin: (
    t,
  ) => JsPromise.t<adminReturn> = "admin"

  type getLatestPriceReturn = Ethers.BigNumber.t
  @send
  external getLatestPrice: (
    t,
  ) => JsPromise.t<getLatestPriceReturn> = "getLatestPrice"

  @send
  external setPrice: (
    t,~newPrice: Ethers.BigNumber.t,
  ) => JsPromise.t<transaction> = "setPrice"

  @send
  external updatePrice: (
    t,
  ) => JsPromise.t<transaction> = "updatePrice"

    type updatePriceReturn = Ethers.BigNumber.t
    @send @scope("callStatic")
    external updatePriceCall: (
      t,
    ) => JsPromise.t<updatePriceReturn> = "updatePrice"



