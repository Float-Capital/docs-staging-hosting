open SmockGeneral

%%raw(`
const { expect, use } = require("chai");
use(require('@defi-wonderland/smock').smock.matchers);
`)

type t = {address: Ethers.ethAddress}

@module("@defi-wonderland/smock") @scope("smock")
external makeRaw: string => Js.Promise.t<t> = "fake"
let make = () => makeRaw("LendingPoolAddressesProviderMock")

let uninitializedValue: t = None->Obj.magic

@send @scope("getLendingPool")
external mockGetLendingPoolToReturn: (t, Ethers.ethAddress) => unit = "returns"

type getLendingPoolCall

let getLendingPoolOld: t => array<getLendingPoolCall> = _r => {
  let array = %raw("_r.getLendingPool.calls")
  array->Array.map(() => {
    ()->Obj.magic
  })
}

@send @scope(("to", "have", "been"))
external getLendingPoolCalledWith: expectation => unit = "calledWith"

@get external getLendingPoolFunction: t => string = "getLendingPool"

let getLendingPoolCallCheck = contract => {
  expect(contract->getLendingPoolFunction)->getLendingPoolCalledWith
}

@send @scope("getLendingPool")
external mockGetLendingPoolToRevert: (t, ~errorString: string) => unit = "returns"

@send @scope("getLendingPool")
external mockGetLendingPoolToRevertNoReason: t => unit = "reverts"

@send @scope("lendingPool")
external mockLendingPoolToReturn: (t, Ethers.ethAddress) => unit = "returns"

type lendingPoolCall

let lendingPoolOld: t => array<lendingPoolCall> = _r => {
  let array = %raw("_r.lendingPool.calls")
  array->Array.map(() => {
    ()->Obj.magic
  })
}

@send @scope(("to", "have", "been"))
external lendingPoolCalledWith: expectation => unit = "calledWith"

@get external lendingPoolFunction: t => string = "lendingPool"

let lendingPoolCallCheck = contract => {
  expect(contract->lendingPoolFunction)->lendingPoolCalledWith
}

@send @scope("lendingPool")
external mockLendingPoolToRevert: (t, ~errorString: string) => unit = "returns"

@send @scope("lendingPool")
external mockLendingPoolToRevertNoReason: t => unit = "reverts"

type setLendingPoolCall = {lendingPool: Ethers.ethAddress}

let setLendingPoolOld: t => array<setLendingPoolCall> = _r => {
  let array = %raw("_r.setLendingPool.calls")
  array->Array.map(_m => {
    let lendingPool = _m->Array.getUnsafe(0)

    {
      lendingPool: lendingPool,
    }
  })
}

@send @scope(("to", "have", "been"))
external setLendingPoolCalledWith: (expectation, Ethers.ethAddress) => unit = "calledWith"

@get external setLendingPoolFunction: t => string = "setLendingPool"

let setLendingPoolCallCheck = (contract, {lendingPool}: setLendingPoolCall) => {
  expect(contract->setLendingPoolFunction)->setLendingPoolCalledWith(lendingPool)
}

@send @scope("setLendingPool")
external mockSetLendingPoolToRevert: (t, ~errorString: string) => unit = "returns"

@send @scope("setLendingPool")
external mockSetLendingPoolToRevertNoReason: t => unit = "reverts"
