// Generated by ReScript, PLEASE EDIT WITH CARE
'use strict';

var ContractHelpers = require("../ContractHelpers.js");

var contractName = "YieldManagerAave";

function at(contractAddress) {
  return ContractHelpers.attachToContract(contractName, contractAddress);
}

function make(admin, longShort, treasury, token, aToken, lendingPool, aaveReferalCode) {
  return ContractHelpers.deployContract7(contractName, admin, longShort, treasury, token, aToken, lendingPool, aaveReferalCode);
}

exports.contractName = contractName;
exports.at = at;
exports.make = make;
/* No side effect */
