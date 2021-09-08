open SmockGeneral

%%raw(`
const { expect, use } = require("chai");
use(require('@defi-wonderland/smock').smock.matchers);
`)

type t = {address: Ethers.ethAddress}

@module("@defi-wonderland/smock") @scope("smock")
external makeRaw: string => Js.Promise.t<t> = "fake"
let make = () => makeRaw("OracleManagerMock")

let uninitializedValue: t = None->Obj.magic

@send @scope("admin")
external mockAdminToReturn: (t, Ethers.ethAddress) => unit = "returns"

type adminCall

let adminOld: t => array<adminCall> = _r => {
  let array = %raw("_r.admin.calls")
  array->Array.map(() => {
    ()->Obj.magic
  })
}

@send @scope(("to", "have", "been"))
external adminCalledWith: expectation => unit = "calledWith"

@get external adminFunction: t => string = "admin"

let adminCallCheck = contract => {
  expect(contract->adminFunction)->adminCalledWith
}

@send @scope("admin")
external mockAdminToRevert: (t, ~errorString: string) => unit = "returns"

@send @scope("admin")
external mockAdminToRevertNoReason: t => unit = "reverts"

@send @scope("getLatestPrice")
external mockGetLatestPriceToReturn: (t, Ethers.BigNumber.t) => unit = "returns"

type getLatestPriceCall

let getLatestPriceOld: t => array<getLatestPriceCall> = _r => {
  let array = %raw("_r.getLatestPrice.calls")
  array->Array.map(() => {
    ()->Obj.magic
  })
}

@send @scope(("to", "have", "been"))
external getLatestPriceCalledWith: expectation => unit = "calledWith"

@get external getLatestPriceFunction: t => string = "getLatestPrice"

let getLatestPriceCallCheck = contract => {
  expect(contract->getLatestPriceFunction)->getLatestPriceCalledWith
}

@send @scope("getLatestPrice")
external mockGetLatestPriceToRevert: (t, ~errorString: string) => unit = "returns"

@send @scope("getLatestPrice")
external mockGetLatestPriceToRevertNoReason: t => unit = "reverts"

type setPriceCall = {newPrice: Ethers.BigNumber.t}

let setPriceOld: t => array<setPriceCall> = _r => {
  let array = %raw("_r.setPrice.calls")
  array->Array.map(_m => {
    let newPrice = _m->Array.getUnsafe(0)

    {
      newPrice: newPrice,
    }
  })
}

@send @scope(("to", "have", "been"))
external setPriceCalledWith: (expectation, Ethers.BigNumber.t) => unit = "calledWith"

@get external setPriceFunction: t => string = "setPrice"

let setPriceCallCheck = (contract, {newPrice}: setPriceCall) => {
  expect(contract->setPriceFunction)->setPriceCalledWith(newPrice)
}

@send @scope("setPrice")
external mockSetPriceToRevert: (t, ~errorString: string) => unit = "returns"

@send @scope("setPrice")
external mockSetPriceToRevertNoReason: t => unit = "reverts"

@send @scope("updatePrice")
external mockUpdatePriceToReturn: (t, Ethers.BigNumber.t) => unit = "returns"

type updatePriceCall

let updatePriceOld: t => array<updatePriceCall> = _r => {
  let array = %raw("_r.updatePrice.calls")
  array->Array.map(() => {
    ()->Obj.magic
  })
}

@send @scope(("to", "have", "been"))
external updatePriceCalledWith: expectation => unit = "calledWith"

@get external updatePriceFunction: t => string = "updatePrice"

let updatePriceCallCheck = contract => {
  expect(contract->updatePriceFunction)->updatePriceCalledWith
}

@send @scope("updatePrice")
external mockUpdatePriceToRevert: (t, ~errorString: string) => unit = "returns"

@send @scope("updatePrice")
external mockUpdatePriceToRevertNoReason: t => unit = "reverts"
