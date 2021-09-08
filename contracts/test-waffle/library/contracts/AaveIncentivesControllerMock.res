
@@ocaml.warning("-32")
open SmockGeneral
open ContractHelpers
type t = {address: Ethers.ethAddress}
let contractName = "AaveIncentivesControllerMock"

let at: Ethers.ethAddress => JsPromise.t<t> = contractAddress =>
  attachToContract(contractName, ~contractAddress)->Obj.magic

let make: unit => JsPromise.t<t> = () => deployContract0(contractName)->Obj.magic
    let makeSmock: unit => JsPromise.t<t> = () => deployMockContract0(contractName)->Obj.magic

    let setVariable: (t, ~name: string, ~value: 'a) => JsPromise.t<unit> = setVariableRaw
    


  @send
  external claimRewards: (
    t,~assets: array<Ethers.ethAddress>,~amount: Ethers.BigNumber.t,~_to: Ethers.ethAddress,
  ) => JsPromise.t<transaction> = "claimRewards"

    type claimRewardsReturn = Ethers.BigNumber.t
    @send @scope("callStatic")
    external claimRewardsCall: (
      t,~assets: array<Ethers.ethAddress>,~amount: Ethers.BigNumber.t,~_to: Ethers.ethAddress,
    ) => JsPromise.t<claimRewardsReturn> = "claimRewards"

  type getUserUnclaimedRewardsReturn = Ethers.BigNumber.t
  @send
  external getUserUnclaimedRewards: (
    t,~user: Ethers.ethAddress,
  ) => JsPromise.t<getUserUnclaimedRewardsReturn> = "getUserUnclaimedRewards"



