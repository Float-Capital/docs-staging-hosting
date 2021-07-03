// Quick and dirty bindings from here: https://ethereum-waffle.readthedocs.io/en/latest/matchers.html

// NOTE: no effort in making these binding proffessional. Mostly just raw javascript.
%%raw(`
const { expect } = require("chai");
`)

let bnEqual: (
  ~message: string=?,
  Ethers.BigNumber.t,
  Ethers.BigNumber.t,
) => unit = %raw(`(message, number1, number2) => expect(number1, message).to.equal(number2)`)

let recordEqualFlatLabeled: (~expected: 'a, ~actual: 'a) => unit = (~expected, ~actual) => {
  let a = %raw("(expected, actual) => {
    for(const key of Object.keys(actual)){
      expect(actual[key]).to.equal(expected[key])
    }
  }")
  a(expected, actual)
}

let recordEqualFlat: ('a, 'a) => unit = (expected, actual) => {
  let a = %raw("(expected, actual) => {
    for(const key of Object.keys(actual)){
      expect(actual[key]).to.equal(expected[key])
    }
  }")
  a(expected, actual)
}

let recordEqualDeep: ('a, 'a) => unit = (expected, actual) => {
  let a = %raw("(expected, actual) => {
    for(const key of Object.keys(actual)){
      expect(actual[key]).to.deep.equal(expected[key])
    }
  }")
  a(expected, actual)
}
let intEqual: (
  ~message: string=?,
  int,
  int,
) => unit = %raw(`(message, number1, number2) => expect(number1, message).to.equal(number2)`)

let addressEqual: (
  ~message: string=?,
  ~otherAddress: Ethers.ethAddress,
  Ethers.ethAddress,
) => unit = %raw(`(message, number1, number2) => expect(number1, message).to.equal(number2)`)

let boolEqual: (
  ~message: string=?,
  bool,
  bool,
) => unit = %raw(`(message, number1, number2) => expect(number1, message).to.equal(number2)`)

let bnWithin: (
  Ethers.BigNumber.t,
  ~min: Ethers.BigNumber.t,
  ~max: Ethers.BigNumber.t,
) => unit = %raw(`(number1, min, max) => expect(number1).to.be.within(min, max)`)

let bnCloseTo: (
  ~message: string=?,
  ~distance: int,
  Ethers.BigNumber.t,
  Ethers.BigNumber.t,
) => unit = %raw(`(message, distance, number1, number2) => expect(number1, message).to.be.closeTo(number2, distance)`)

type eventCheck
let callEmitEvents: (
  ~call: JsPromise.t<ContractHelpers.transaction>,
  ~contract: ContractHelpers.t,
  ~eventName: string,
) => eventCheck = %raw(`(call, contract, eventName) => expect(call).to.emit(contract, eventName)`)
@send external withArgs0: eventCheck => JsPromise.t<unit> = "withArgs"
@send external withArgs1: (eventCheck, 'a) => JsPromise.t<unit> = "withArgs"
@send external withArgs2: (eventCheck, 'a, 'b) => JsPromise.t<unit> = "withArgs"
@send external withArgs3: (eventCheck, 'a, 'b, 'c) => JsPromise.t<unit> = "withArgs"
@send external withArgs4: (eventCheck, 'a, 'b, 'c, 'd) => JsPromise.t<unit> = "withArgs"
@send external withArgs5: (eventCheck, 'a, 'b, 'c, 'd, 'e) => JsPromise.t<unit> = "withArgs"

@send external withArgs5Return: (eventCheck, 'a, 'b, 'c, 'd, 'e) => eventCheck = "withArgs"

@send external withArgs6: (eventCheck, 'a, 'b, 'c, 'd, 'e, 'f) => JsPromise.t<unit> = "withArgs"
@send external withArgs7: (eventCheck, 'a, 'b, 'c, 'd, 'e, 'f, 'g) => JsPromise.t<unit> = "withArgs"
@send
external withArgs8: (eventCheck, 'a, 'b, 'c, 'd, 'e, 'f, 'g, 'h) => JsPromise.t<unit> = "withArgs"

let expectToNotEmit: eventCheck => JsPromise.t<unit> = _eventCheck =>
  %raw(`_eventCheck.then(() => assert.fail('An event was emitted when it should not have been')).catch(() => {})`)

let expectRevertNoReason: (
  ~transaction: JsPromise.t<ContractHelpers.transaction>,
) => JsPromise.t<unit> = %raw(`(transaction) => expect(transaction).to.be.reverted`)
let expectRevert: (
  ~transaction: JsPromise.t<ContractHelpers.transaction>,
  ~reason: string,
) => JsPromise.t<
  unit,
> = %raw(`(transaction, reason) => expect(transaction).to.be.revertedWith(reason)`)

let changeBallance: (
  ~transaction: unit => JsPromise.t<ContractHelpers.transaction>,
  ~token: ContractHelpers.t,
  ~to_: Ethers.ethAddress,
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
