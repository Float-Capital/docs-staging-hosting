
@@ocaml.warning("-32")
open SmockGeneral
open ContractHelpers
type t = {address: Ethers.ethAddress}
let contractName = "LendingPoolAddressesProviderMock"

let at: Ethers.ethAddress => JsPromise.t<t> = contractAddress =>
  attachToContract(contractName, ~contractAddress)->Obj.magic

let make: unit => JsPromise.t<t> = () => deployContract0(contractName)->Obj.magic
    let makeSmock: unit => JsPromise.t<t> = () => deployMockContract0(contractName)->Obj.magic

    let setVariable: (t, ~name: string, ~value: 'a) => JsPromise.t<unit> = setVariableRaw
    


  type getLendingPoolReturn = Ethers.ethAddress
  @send
  external getLendingPool: (
    t,
  ) => JsPromise.t<getLendingPoolReturn> = "getLendingPool"

  type lendingPoolReturn = Ethers.ethAddress
  @send
  external lendingPool: (
    t,
  ) => JsPromise.t<lendingPoolReturn> = "lendingPool"

  @send
  external setLendingPool: (
    t,~lendingPool: Ethers.ethAddress,
  ) => JsPromise.t<transaction> = "setLendingPool"



