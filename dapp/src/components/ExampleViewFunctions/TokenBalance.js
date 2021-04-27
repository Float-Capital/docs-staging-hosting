// Generated by ReScript, PLEASE EDIT WITH CARE
'use strict';

var React = require("react");
var MiniLoader = require("../UI/MiniLoader.js");
var Caml_option = require("rescript/lib/js/caml_option.js");
var FormatMoney = require("../UI/FormatMoney.js");
var ContractHooks = require("../Testing/Admin/ContractHooks.js");

function TokenBalance(Props) {
  var erc20Address = Props.erc20Address;
  var match = ContractHooks.useErc20BalanceRefresh(erc20Address);
  var optBalance = match.data;
  return React.createElement(React.Fragment, undefined, optBalance !== undefined ? React.createElement("p", undefined, FormatMoney.formatEther(undefined, Caml_option.valFromOption(optBalance))) : React.createElement(MiniLoader.make, {}));
}

var make = TokenBalance;

exports.make = make;
/* react Not a pure module */
