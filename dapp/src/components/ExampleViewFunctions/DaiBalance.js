// Generated by ReScript, PLEASE EDIT WITH CARE

import * as React from "react";
import * as MiniLoader from "../UI/MiniLoader.js";
import * as Caml_option from "bs-platform/lib/es6/caml_option.js";
import * as FormatMoney from "../UI/FormatMoney.js";
import * as ContractHooks from "../Testing/Admin/ContractHooks.js";

function DaiBalance(Props) {
  var match = ContractHooks.useDaiBalanceRefresh(undefined);
  var optBalance = match.data;
  return React.createElement(React.Fragment, undefined, optBalance !== undefined ? React.createElement("div", {
                    className: "flex justify-between w-full"
                  }, React.createElement("p", undefined, "BUSD balance: "), React.createElement("p", undefined, "$" + FormatMoney.formatEther(undefined, Caml_option.valFromOption(optBalance)))) : React.createElement(MiniLoader.make, {}));
}

var make = DaiBalance;

export {
  make ,
  
}
/* react Not a pure module */
