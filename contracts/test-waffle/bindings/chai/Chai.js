// Generated by ReScript, PLEASE EDIT WITH CARE
'use strict';


const { expect } = require("chai");
;

var bnEqual = ((message, number1, number2) => expect(number1, message).to.equal(number2));

function recordEqualFlatLabeled(expected, actual) {
  var a = ((expected, actual) => {
    for(const key of Object.keys(actual)){
      expect(actual[key]).to.equal(expected[key])
    }
  });
  return a(expected, actual);
}

function recordEqualFlat(expected, actual) {
  var a = ((expected, actual) => {
    for(const key of Object.keys(actual)){
      expect(actual[key]).to.equal(expected[key])
    }
  });
  return a(expected, actual);
}

function recordEqualDeep(expected, actual) {
  var a = ((expected, actual) => {
    for(const key of Object.keys(actual)){
      expect(actual[key]).to.deep.equal(expected[key])
    }
  });
  return a(expected, actual);
}

var intEqual = ((message, number1, number2) => expect(number1, message).to.equal(number2));

var boolEqual = ((message, number1, number2) => expect(number1, message).to.equal(number2));

var bnWithin = ((number1, min, max) => expect(number1).to.be.within(min, max));

var bnCloseTo = ((message, distance, number1, number2) => expect(number1, message).to.be.closeTo(number2, distance));

var callEmitEvents = ((call, contract, eventName) => expect(call).to.emit(contract, eventName));

function expectToNotEmit(_eventCheck) {
  return (_eventCheck.then(() => assert.fail('An event was emitted when it should not have been')).catch(() => {}));
}

var expectRevertNoReason = ((transaction) => expect(transaction).to.be.reverted);

var expectRevert = ((transaction, reason) => expect(transaction).to.be.revertedWith(reason));

var changeBallance = ((transaction, token, to, amount) => expect(transaction).to.changeTokenBalance(token, to, amount));

var expectToBeAddress = ((address) => expect(address).to.be.properAddress);

var expectToBePrivateKey = ((privateKey) => expect(privateKey).to.be.properAddress);

var expectToBeHex = ((hexStr, hexLength) => expect(hexStr).to.be.properHex(hexLength));

var expectHexEqual = ((hex1, hex2) => expect(hex1).to.be.hexEqual(hex2));

exports.bnEqual = bnEqual;
exports.recordEqualFlatLabeled = recordEqualFlatLabeled;
exports.recordEqualFlat = recordEqualFlat;
exports.recordEqualDeep = recordEqualDeep;
exports.intEqual = intEqual;
exports.boolEqual = boolEqual;
exports.bnWithin = bnWithin;
exports.bnCloseTo = bnCloseTo;
exports.callEmitEvents = callEmitEvents;
exports.expectToNotEmit = expectToNotEmit;
exports.expectRevertNoReason = expectRevertNoReason;
exports.expectRevert = expectRevert;
exports.changeBallance = changeBallance;
exports.expectToBeAddress = expectToBeAddress;
exports.expectToBePrivateKey = expectToBePrivateKey;
exports.expectToBeHex = expectToBeHex;
exports.expectHexEqual = expectHexEqual;
/*  Not a pure module */
