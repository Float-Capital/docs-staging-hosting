// Generated by ReScript, PLEASE EDIT WITH CARE
'use strict';

var ContractHelpers = require("../ContractHelpers.js");

var contractName = "TokenFactory";

function at(contractAddress) {
  return ContractHelpers.attachToContract(contractName, contractAddress);
}

function make(longShort) {
  return ContractHelpers.deployContract1(contractName, longShort);
}

function makeSmock(longShort) {
  return ContractHelpers.deployMockContract1(contractName, longShort);
}

function setVariable(prim0, prim1, prim2) {
  return prim0.setVariable(prim1, prim2);
}

exports.contractName = contractName;
exports.at = at;
exports.make = make;
exports.makeSmock = makeSmock;
exports.setVariable = setVariable;
/* ContractHelpers Not a pure module */
