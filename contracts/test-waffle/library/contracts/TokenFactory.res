
@@ocaml.warning("-32")
open SmockGeneral
open ContractHelpers
type t = {address: Ethers.ethAddress}
let contractName = "TokenFactory"

let at: Ethers.ethAddress => JsPromise.t<t> = contractAddress =>
  attachToContract(contractName, ~contractAddress)->Obj.magic

let make: (~longShort: Ethers.ethAddress,) => JsPromise.t<t> = (~longShort,) =>
    deployContract1(contractName, longShort,)->Obj.magic

    let makeSmock: (~longShort: Ethers.ethAddress,) => JsPromise.t<t> = (~longShort,) =>
    deployMockContract1(contractName, longShort,)->Obj.magic

    let setVariable: (t, ~name: string, ~value: 'a) => JsPromise.t<unit> = setVariableRaw
    
    


  @send
  external createSyntheticToken: (
    t,~syntheticName: string,~syntheticSymbol: string,~staker: Ethers.ethAddress,~marketIndex: int,~isLong: bool,
  ) => JsPromise.t<transaction> = "createSyntheticToken"

    type createSyntheticTokenReturn = Ethers.ethAddress
    @send @scope("callStatic")
    external createSyntheticTokenCall: (
      t,~syntheticName: string,~syntheticSymbol: string,~staker: Ethers.ethAddress,~marketIndex: int,~isLong: bool,
    ) => JsPromise.t<createSyntheticTokenReturn> = "createSyntheticToken"

  type longShortReturn = Ethers.ethAddress
  @send
  external longShort: (
    t,
  ) => JsPromise.t<longShortReturn> = "longShort"



