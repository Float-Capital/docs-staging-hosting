// Quick and dirty bindings from here: https://ethereum-waffle.readthedocs.io/en/latest/matchers.html

// NOTE: no effort in making these binding proffessional. Mostly just raw javascript.
%%raw(`
const { expect } = require("chai");
`)

let bnEqual: (
  Ethers.BigNumber.t,
  Ethers.BigNumber.t,
) => unit = %raw(`(number1, number2) => expect(number1).to.equal(number2)`)

let bnWithin: (
  Ethers.BigNumber.t,
  ~min: Ethers.BigNumber.t,
  ~max: Ethers.BigNumber.t,
) => unit = %raw(`(number1, min, max) => expect(number1).to.be.within(min, max)`)

let bnCloseTo: (
  Ethers.BigNumber.t,
  Ethers.BigNumber.t,
  ~distance: int,
) => unit = %raw(`(number1, number2, distance) => expect(number1).to.be.closeTo(number2, distance)`)

type eventCheck
let callEmitEvents: (
  ~call: JsPromise.t<Contract.transaction>,
  ~contract: Contract.t,
  ~eventName: string,
) => eventCheck = %raw(`(call, contract, eventName) => expect(call).to.emit(contract, eventName)`)
@send external withArgs0: eventCheck => JsPromise.t<unit> = "withArgs"
@send external withArgs1: (eventCheck, 'a) => JsPromise.t<unit> = "withArgs"
@send external withArgs2: (eventCheck, 'a, 'b) => JsPromise.t<unit> = "withArgs"
@send external withArgs3: (eventCheck, 'a, 'b, 'c) => JsPromise.t<unit> = "withArgs"
@send external withArgs4: (eventCheck, 'a, 'b, 'c, 'd) => JsPromise.t<unit> = "withArgs"
@send external withArgs5: (eventCheck, 'a, 'b, 'c, 'd, 'e) => JsPromise.t<unit> = "withArgs"
@send external withArgs6: (eventCheck, 'a, 'b, 'c, 'd, 'e, 'f) => JsPromise.t<unit> = "withArgs"
@send external withArgs7: (eventCheck, 'a, 'b, 'c, 'd, 'e, 'f, 'g) => JsPromise.t<unit> = "withArgs"
@send
external withArgs8: (eventCheck, 'a, 'b, 'c, 'd, 'e, 'f, 'g, 'h) => JsPromise.t<unit> = "withArgs"

let expectContractCall: (
  ~functionName: string,
  ~contract: Contract.t,
) => unit = %raw(`(functionName, contract) => expect(functionName).to.be.calledOnContract(contract)`)

type args // TODO: make this cleaner, more typesafe, and hide implementation detail...
let expectContractCallArgsRaw: (
  ~functionName: string,
  ~contract: Contract.t,
  args,
) => unit = %raw(`(functionName, contract, args) => expect(functionName).to.be.calledOnContractWithArgs(contract, args)`)
let expectContractCallArgs0 = (~functionName: string, ~contract: Contract.t) =>
  expectContractCallArgsRaw(~functionName, ~contract, []->Obj.magic)
let expectContractCallArgs1 = (~functionName: string, ~contract: Contract.t, ~args: array<'a>) =>
  expectContractCallArgsRaw(~functionName, ~contract, args->Obj.magic)
let expectContractCallArgs2 = (~functionName: string, ~contract: Contract.t, ~args: ('a, 'b)) =>
  expectContractCallArgsRaw(~functionName, ~contract, args->Obj.magic)
let expectContractCallArgs3 = (~functionName: string, ~contract: Contract.t, ~args: ('a, 'b, 'c)) =>
  expectContractCallArgsRaw(~functionName, ~contract, args->Obj.magic)
let expectContractCallArgs4 = (
  ~functionName: string,
  ~contract: Contract.t,
  ~args: ('a, 'b, 'c, 'd),
) => expectContractCallArgsRaw(~functionName, ~contract, args->Obj.magic)
let expectContractCallArgs5 = (
  ~functionName: string,
  ~contract: Contract.t,
  ~args: ('a, 'b, 'c, 'd, 'e),
) => expectContractCallArgsRaw(~functionName, ~contract, args->Obj.magic)
let expectContractCallArgs6 = (
  ~functionName: string,
  ~contract: Contract.t,
  ~args: ('a, 'b, 'c, 'd, 'e, 'f),
) => expectContractCallArgsRaw(~functionName, ~contract, args->Obj.magic)
let expectContractCallArgs7 = (
  ~functionName: string,
  ~contract: Contract.t,
  ~args: ('a, 'b, 'c, 'd, 'e, 'f, 'g),
) => expectContractCallArgsRaw(~functionName, ~contract, args->Obj.magic)

let expectRevertNoReason: (
  ~transaction: JsPromise.t<Contract.transaction>,
) => JsPromise.t<unit> = %raw(`(transaction) => expect(transaction).to.be.reverted`)
let expectRevert: (
  ~transaction: JsPromise.t<Contract.transaction>,
  ~reason: string,
) => JsPromise.t<
  unit,
> = %raw(`(transaction, reason) => expect(transaction).to.be.revertedWith(reason)`)

let changeBallance: (
  ~transaction: unit => JsPromise.t<Contract.transaction>,
  ~token: Contract.t,
  ~to: Ethers.Wallet.t,
  ~amount: Ethers.BigNumber.t,
) => JsPromise.t<
  unit,
> = %raw(`(transaction, token, to, amount) => expect(transaction).to.changeTokenBalance(token, to, amount)`)
// TODO: implement changeBallanceMulti to test transactions that change the balance of multiple accounts
// let changeBallanceMulti = %raw(`expect(transaction).to.changeTokenBalance(token, wallets, amounts)`)

let expectToBeAddress: (
  ~address: Ethers.ethAddress,
) => JsPromise.t<unit> = %raw(`(address) => expect(address).to.be.properAddress`)
let expectToBePrivateKey: (
  ~privateKey: string,
) => JsPromise.t<unit> = %raw(`(privateKey) => expect(privateKey).to.be.properAddress`)
let expectToBeHex: (
  ~hexStr: string,
  ~length: int,
) => JsPromise.t<unit> = %raw(`(hexStr, hexLength) => expect(hexStr).to.be.properHex(hexLength)`)
let expectHexEqual: (
  ~hex1: string,
  ~hex2: string,
) => JsPromise.t<unit> = %raw(`(hex1, hex2) => expect(hex1).to.be.hexEqual(hex2)`)
