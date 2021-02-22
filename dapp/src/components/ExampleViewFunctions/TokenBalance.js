// Generated by ReScript, PLEASE EDIT WITH CARE

import * as React from "react";
import * as MiniLoader from "../UI/MiniLoader.js";
import * as Caml_option from "bs-platform/lib/es6/caml_option.js";
import * as FormatMoney from "../UI/FormatMoney.js";
import * as ContractHooks from "../Admin/ContractHooks.js";

function TokenBalance(Props) {
  var erc20Address = Props.erc20Address;
  var match = ContractHooks.useErc20Balance(erc20Address);
  var optBalance = match.data;
  return React.createElement(React.Fragment, undefined, optBalance !== undefined ? React.createElement("p", undefined, FormatMoney.formatEther(Caml_option.valFromOption(optBalance))) : React.createElement(MiniLoader.make, {}));
}

var make = TokenBalance;

export {
  make ,
  
}
/* react Not a pure module */
