open SmockGeneral

%%raw(`
const { expect, use } = require("chai");
use(require('@defi-wonderland/smock').smock.matchers);
`)

type t = {address: Ethers.ethAddress}

@module("@defi-wonderland/smock") @scope("smock")
external makeRaw: string => Js.Promise.t<t> = "fake"
let make = () => makeRaw("OracleManagerChainlink")

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

@send @scope("chainlinkOracle")
external mockChainlinkOracleToReturn: (t, Ethers.ethAddress) => unit = "returns"

type chainlinkOracleCall

let chainlinkOracleOld: t => array<chainlinkOracleCall> = _r => {
  let array = %raw("_r.chainlinkOracle.calls")
  array->Array.map(() => {
    ()->Obj.magic
  })
}

@send @scope(("to", "have", "been"))
external chainlinkOracleCalledWith: expectation => unit = "calledWith"

@get external chainlinkOracleFunction: t => string = "chainlinkOracle"

let chainlinkOracleCallCheck = contract => {
  expect(contract->chainlinkOracleFunction)->chainlinkOracleCalledWith
}

@send @scope("chainlinkOracle")
external mockChainlinkOracleToRevert: (t, ~errorString: string) => unit = "returns"

@send @scope("chainlinkOracle")
external mockChainlinkOracleToRevertNoReason: t => unit = "reverts"

type changeAdminCall = {admin: Ethers.ethAddress}

let changeAdminOld: t => array<changeAdminCall> = _r => {
  let array = %raw("_r.changeAdmin.calls")
  array->Array.map(_m => {
    let admin = _m->Array.getUnsafe(0)

    {
      admin: admin,
    }
  })
}

@send @scope(("to", "have", "been"))
external changeAdminCalledWith: (expectation, Ethers.ethAddress) => unit = "calledWith"

@get external changeAdminFunction: t => string = "changeAdmin"

let changeAdminCallCheck = (contract, {admin}: changeAdminCall) => {
  expect(contract->changeAdminFunction)->changeAdminCalledWith(admin)
}

@send @scope("changeAdmin")
external mockChangeAdminToRevert: (t, ~errorString: string) => unit = "returns"

@send @scope("changeAdmin")
external mockChangeAdminToRevertNoReason: t => unit = "reverts"

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

@send @scope("oracleDecimals")
external mockOracleDecimalsToReturn: (t, int) => unit = "returns"

type oracleDecimalsCall

let oracleDecimalsOld: t => array<oracleDecimalsCall> = _r => {
  let array = %raw("_r.oracleDecimals.calls")
  array->Array.map(() => {
    ()->Obj.magic
  })
}

@send @scope(("to", "have", "been"))
external oracleDecimalsCalledWith: expectation => unit = "calledWith"

@get external oracleDecimalsFunction: t => string = "oracleDecimals"

let oracleDecimalsCallCheck = contract => {
  expect(contract->oracleDecimalsFunction)->oracleDecimalsCalledWith
}

@send @scope("oracleDecimals")
external mockOracleDecimalsToRevert: (t, ~errorString: string) => unit = "returns"

@send @scope("oracleDecimals")
external mockOracleDecimalsToRevertNoReason: t => unit = "reverts"

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
