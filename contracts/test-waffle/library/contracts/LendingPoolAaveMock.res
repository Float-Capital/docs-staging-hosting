
@@ocaml.warning("-32")
open SmockGeneral
open ContractHelpers
type t = {address: Ethers.ethAddress}
let contractName = "LendingPoolAaveMock"

let at: Ethers.ethAddress => JsPromise.t<t> = contractAddress =>
  attachToContract(contractName, ~contractAddress)->Obj.magic

let make: unit => JsPromise.t<t> = () => deployContract0(contractName)->Obj.magic
    let makeSmock: unit => JsPromise.t<t> = () => deployMockContract0(contractName)->Obj.magic

    let setVariable: (t, ~name: string, ~value: 'a) => JsPromise.t<unit> = setVariableRaw
    


  type depositReturn
  @send
  external deposit: (
    t,~asset: Ethers.ethAddress,~amount: Ethers.BigNumber.t,~onBehalfOf: Ethers.ethAddress,~referralCode: int,
  ) => JsPromise.t<depositReturn> = "deposit"

  type withdrawReturn = Ethers.BigNumber.t
  @send
  external withdraw: (
    t,~asset: Ethers.ethAddress,~amount: Ethers.BigNumber.t,~_to: Ethers.ethAddress,
  ) => JsPromise.t<withdrawReturn> = "withdraw"



