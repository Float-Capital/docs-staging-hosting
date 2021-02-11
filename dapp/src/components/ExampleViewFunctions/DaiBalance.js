// Generated by ReScript, PLEASE EDIT WITH CARE

import * as React from "react";
import * as Ethers from "../../ethereum/Ethers.js";
import * as Caml_option from "bs-platform/lib/es6/caml_option.js";
import * as ContractHooks from "../Admin/ContractHooks.js";

function DaiBalance(Props) {
  var match = ContractHooks.useDaiBalance(undefined);
  var optBalance = match.data;
  return React.createElement(React.Fragment, undefined, optBalance !== undefined ? React.createElement("h1", undefined, "dai balance: " + Ethers.Utils.formatEther(Caml_option.valFromOption(optBalance)) + " DAI") : React.createElement("h1", undefined, "Loading dai balance"));
}

var make = DaiBalance;

export {
  make ,
  
}
/* react Not a pure module */
