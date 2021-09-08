open SmockGeneral

%%raw(`
const { expect, use } = require("chai");
use(require('@defi-wonderland/smock').smock.matchers);
`)

type t = {address: Ethers.ethAddress}

@module("@defi-wonderland/smock") @scope("smock")
external makeRaw: string => Js.Promise.t<t> = "fake"
let make = () => makeRaw("AaveIncentivesControllerMock")

let uninitializedValue: t = None->Obj.magic

@send @scope("claimRewards")
external mockClaimRewardsToReturn: (t, Ethers.BigNumber.t) => unit = "returns"

type claimRewardsCall = {
  assets: array<Ethers.ethAddress>,
  amount: Ethers.BigNumber.t,
  _to: Ethers.ethAddress,
}

let claimRewardsOld: t => array<claimRewardsCall> = _r => {
  let array = %raw("_r.claimRewards.calls")
  array->Array.map(((assets, amount, _to)) => {
    {
      assets: assets,
      amount: amount,
      _to: _to,
    }
  })
}

@send @scope(("to", "have", "been"))
external claimRewardsCalledWith: (
  expectation,
  array<Ethers.ethAddress>,
  Ethers.BigNumber.t,
  Ethers.ethAddress,
) => unit = "calledWith"

@get external claimRewardsFunction: t => string = "claimRewards"

let claimRewardsCallCheck = (contract, {assets, amount, _to}: claimRewardsCall) => {
  expect(contract->claimRewardsFunction)->claimRewardsCalledWith(assets, amount, _to)
}

@send @scope("claimRewards")
external mockClaimRewardsToRevert: (t, ~errorString: string) => unit = "returns"

@send @scope("claimRewards")
external mockClaimRewardsToRevertNoReason: t => unit = "reverts"

@send @scope("getUserUnclaimedRewards")
external mockGetUserUnclaimedRewardsToReturn: (t, Ethers.BigNumber.t) => unit = "returns"

type getUserUnclaimedRewardsCall = {user: Ethers.ethAddress}

let getUserUnclaimedRewardsOld: t => array<getUserUnclaimedRewardsCall> = _r => {
  let array = %raw("_r.getUserUnclaimedRewards.calls")
  array->Array.map(_m => {
    let user = _m->Array.getUnsafe(0)

    {
      user: user,
    }
  })
}

@send @scope(("to", "have", "been"))
external getUserUnclaimedRewardsCalledWith: (expectation, Ethers.ethAddress) => unit = "calledWith"

@get external getUserUnclaimedRewardsFunction: t => string = "getUserUnclaimedRewards"

let getUserUnclaimedRewardsCallCheck = (contract, {user}: getUserUnclaimedRewardsCall) => {
  expect(contract->getUserUnclaimedRewardsFunction)->getUserUnclaimedRewardsCalledWith(user)
}

@send @scope("getUserUnclaimedRewards")
external mockGetUserUnclaimedRewardsToRevert: (t, ~errorString: string) => unit = "returns"

@send @scope("getUserUnclaimedRewards")
external mockGetUserUnclaimedRewardsToRevertNoReason: t => unit = "reverts"
