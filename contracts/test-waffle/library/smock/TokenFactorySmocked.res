open SmockGeneral

%%raw(`
const { expect, use } = require("chai");
use(require('@defi-wonderland/smock').smock.matchers);
`)

type t = {address: Ethers.ethAddress}

@module("@defi-wonderland/smock") @scope("smock")
external makeRaw: string => Js.Promise.t<t> = "fake"
let make = () => makeRaw("TokenFactory")

let uninitializedValue: t = None->Obj.magic

@send @scope("createSyntheticToken")
external mockCreateSyntheticTokenToReturn: (t, Ethers.ethAddress) => unit = "returns"

type createSyntheticTokenCall = {
  syntheticName: string,
  syntheticSymbol: string,
  staker: Ethers.ethAddress,
  marketIndex: int,
  isLong: bool,
}

let createSyntheticTokenOld: t => array<createSyntheticTokenCall> = _r => {
  let array = %raw("_r.createSyntheticToken.calls")
  array->Array.map(((syntheticName, syntheticSymbol, staker, marketIndex, isLong)) => {
    {
      syntheticName: syntheticName,
      syntheticSymbol: syntheticSymbol,
      staker: staker,
      marketIndex: marketIndex,
      isLong: isLong,
    }
  })
}

@send @scope(("to", "have", "been"))
external createSyntheticTokenCalledWith: (
  expectation,
  string,
  string,
  Ethers.ethAddress,
  int,
  bool,
) => unit = "calledWith"

@get external createSyntheticTokenFunction: t => string = "createSyntheticToken"

let createSyntheticTokenCallCheck = (
  contract,
  {syntheticName, syntheticSymbol, staker, marketIndex, isLong}: createSyntheticTokenCall,
) => {
  expect(contract->createSyntheticTokenFunction)->createSyntheticTokenCalledWith(
    syntheticName,
    syntheticSymbol,
    staker,
    marketIndex,
    isLong,
  )
}

@send @scope("createSyntheticToken")
external mockCreateSyntheticTokenToRevert: (t, ~errorString: string) => unit = "returns"

@send @scope("createSyntheticToken")
external mockCreateSyntheticTokenToRevertNoReason: t => unit = "reverts"

@send @scope("longShort")
external mockLongShortToReturn: (t, Ethers.ethAddress) => unit = "returns"

type longShortCall

let longShortOld: t => array<longShortCall> = _r => {
  let array = %raw("_r.longShort.calls")
  array->Array.map(() => {
    ()->Obj.magic
  })
}

@send @scope(("to", "have", "been"))
external longShortCalledWith: expectation => unit = "calledWith"

@get external longShortFunction: t => string = "longShort"

let longShortCallCheck = contract => {
  expect(contract->longShortFunction)->longShortCalledWith
}

@send @scope("longShort")
external mockLongShortToRevert: (t, ~errorString: string) => unit = "returns"

@send @scope("longShort")
external mockLongShortToRevertNoReason: t => unit = "reverts"
