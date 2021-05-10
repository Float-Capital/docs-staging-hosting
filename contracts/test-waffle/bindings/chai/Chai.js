// Generated by ReScript, PLEASE EDIT WITH CARE
'use strict';


const { expect } = require("chai");
;

var bnEqual = ((number1, number2) => expect(number1).to.equal(number2));

var bnWithin = ((number1, min, max) => expect(number1).to.be.within(min, max));

var bnCloseTo = ((number1, number2, distance) => expect(number1).to.be.closeTo(number2, distance));

var callEmitEvents = ((call, contract, eventName) => expect(call).to.emit(contract, eventName));

var expectContractCall = ((functionName, contract) => expect(functionName).to.be.calledOnContract(contract));

var expectContractCallArgsRaw = ((functionName, contract, args) => expect(functionName).to.be.calledOnContractWithArgs(contract, args));

function expectContractCallArgs0(functionName, contract) {
  return expectContractCallArgsRaw(functionName, contract, []);
}

var expectContractCallArgs1 = expectContractCallArgsRaw;

var expectContractCallArgs2 = expectContractCallArgsRaw;

var expectContractCallArgs3 = expectContractCallArgsRaw;

var expectContractCallArgs4 = expectContractCallArgsRaw;

var expectContractCallArgs5 = expectContractCallArgsRaw;

var expectContractCallArgs6 = expectContractCallArgsRaw;

var expectContractCallArgs7 = expectContractCallArgsRaw;

var expectRevertNoReason = ((transaction) => expect(transaction).to.be.reverted);

var expectRevert = ((transaction, reason) => expect(transaction).to.be.revertedWith(reason));

var changeBallance = (expect(transaction).to.changeTokenBalance(token, to, amount));

exports.bnEqual = bnEqual;
exports.bnWithin = bnWithin;
exports.bnCloseTo = bnCloseTo;
exports.callEmitEvents = callEmitEvents;
exports.expectContractCall = expectContractCall;
exports.expectContractCallArgsRaw = expectContractCallArgsRaw;
exports.expectContractCallArgs0 = expectContractCallArgs0;
exports.expectContractCallArgs1 = expectContractCallArgs1;
exports.expectContractCallArgs2 = expectContractCallArgs2;
exports.expectContractCallArgs3 = expectContractCallArgs3;
exports.expectContractCallArgs4 = expectContractCallArgs4;
exports.expectContractCallArgs5 = expectContractCallArgs5;
exports.expectContractCallArgs6 = expectContractCallArgs6;
exports.expectContractCallArgs7 = expectContractCallArgs7;
exports.expectRevertNoReason = expectRevertNoReason;
exports.expectRevert = expectRevert;
exports.changeBallance = changeBallance;
/*  Not a pure module */
