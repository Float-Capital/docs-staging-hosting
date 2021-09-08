open SmockGeneral

%%raw(`
const { expect, use } = require("chai");
use(require('@defi-wonderland/smock').smock.matchers);
`)

type t = {address: Ethers.ethAddress}

@module("@defi-wonderland/smock") @scope("smock")
external makeRaw: string => Js.Promise.t<t> = "fake"
let make = () => makeRaw("LendingPoolAaveMock")

let uninitializedValue: t = None->Obj.magic

type depositCall = {
  asset: Ethers.ethAddress,
  amount: Ethers.BigNumber.t,
  onBehalfOf: Ethers.ethAddress,
  referralCode: int,
}

let depositOld: t => array<depositCall> = _r => {
  let array = %raw("_r.deposit.calls")
  array->Array.map(((asset, amount, onBehalfOf, referralCode)) => {
    {
      asset: asset,
      amount: amount,
      onBehalfOf: onBehalfOf,
      referralCode: referralCode,
    }
  })
}

@send @scope(("to", "have", "been"))
external depositCalledWith: (
  expectation,
  Ethers.ethAddress,
  Ethers.BigNumber.t,
  Ethers.ethAddress,
  int,
) => unit = "calledWith"

@get external depositFunction: t => string = "deposit"

let depositCallCheck = (contract, {asset, amount, onBehalfOf, referralCode}: depositCall) => {
  expect(contract->depositFunction)->depositCalledWith(asset, amount, onBehalfOf, referralCode)
}

@send @scope("deposit")
external mockDepositToRevert: (t, ~errorString: string) => unit = "returns"

@send @scope("deposit")
external mockDepositToRevertNoReason: t => unit = "reverts"

@send @scope("withdraw")
external mockWithdrawToReturn: (t, Ethers.BigNumber.t) => unit = "returns"

type withdrawCall = {
  asset: Ethers.ethAddress,
  amount: Ethers.BigNumber.t,
  _to: Ethers.ethAddress,
}

let withdrawOld: t => array<withdrawCall> = _r => {
  let array = %raw("_r.withdraw.calls")
  array->Array.map(((asset, amount, _to)) => {
    {
      asset: asset,
      amount: amount,
      _to: _to,
    }
  })
}

@send @scope(("to", "have", "been"))
external withdrawCalledWith: (
  expectation,
  Ethers.ethAddress,
  Ethers.BigNumber.t,
  Ethers.ethAddress,
) => unit = "calledWith"

@get external withdrawFunction: t => string = "withdraw"

let withdrawCallCheck = (contract, {asset, amount, _to}: withdrawCall) => {
  expect(contract->withdrawFunction)->withdrawCalledWith(asset, amount, _to)
}

@send @scope("withdraw")
external mockWithdrawToRevert: (t, ~errorString: string) => unit = "returns"

@send @scope("withdraw")
external mockWithdrawToRevertNoReason: t => unit = "reverts"
