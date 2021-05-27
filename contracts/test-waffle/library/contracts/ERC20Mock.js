// Generated by ReScript, PLEASE EDIT WITH CARE
'use strict';

var Contract = require("../Contract.js");

var contractName = "ERC20Mock";

function make(name, symbol) {
  return Contract.deployContract2(contractName, name, symbol);
}

function at(contractAddress) {
  return Contract.attachToContract(contractName, contractAddress);
}

exports.contractName = contractName;
exports.make = make;
exports.at = at;
/* No side effect */
