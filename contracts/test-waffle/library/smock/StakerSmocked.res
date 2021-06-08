type t = {address: Ethers.ethAddress}

@module("@eth-optimism/smock") external make: Staker.t => Js.Promise.t<t> = "smockit"

let uninitializedValue: t = None->Obj.magic

@get @scope(("smocked", "addNewStakingFund"))
external addNewStakingFundCallsExternal: t => array<(
  int,
  Ethers.ethAddress,
  Ethers.ethAddress,
  Ethers.BigNumber.t,
  Ethers.BigNumber.t,
)> = "calls"

type addNewStakingFundCall = {
  marketIndex: int,
  longToken: Ethers.ethAddress,
  shortToken: Ethers.ethAddress,
  kInitialMultiplier: Ethers.BigNumber.t,
  kPeriod: Ethers.BigNumber.t,
}

let mockaddNewStakingFundToReturn: t => unit = %raw(
  "t => t.smocked.addNewStakingFund.will.return()"
)

let addNewStakingFundCalls = smocked => {
  smocked
  ->addNewStakingFundCallsExternal
  ->Array.map(((m, l, s, kI, kP)) => {
    marketIndex: m,
    longToken: l,
    shortToken: s,
    kInitialMultiplier: kI,
    kPeriod: kP,
  })
}
let getTest = tas => tas->addNewStakingFundCallsExternal
