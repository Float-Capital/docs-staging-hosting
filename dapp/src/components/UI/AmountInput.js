// Generated by ReScript, PLEASE EDIT WITH CARE

import * as React from "react";
import * as Ethers from "../../ethereum/Ethers.js";
import * as Caml_option from "rescript/lib/es6/caml_option.js";

function AmountInput(Props) {
  var placeholder = Props.placeholder;
  var value = Props.value;
  var optBalanceOpt = Props.optBalance;
  var disabled = Props.disabled;
  var onBlur = Props.onBlur;
  var onChange = Props.onChange;
  var onMaxClick = Props.onMaxClick;
  var optCurrencyOpt = Props.optCurrency;
  var optBalance = optBalanceOpt !== undefined ? Caml_option.valFromOption(optBalanceOpt) : undefined;
  var optCurrency = optCurrencyOpt !== undefined ? Caml_option.valFromOption(optCurrencyOpt) : undefined;
  return React.createElement("div", {
              className: "flex flex-row my-3"
            }, React.createElement("input", {
                  className: "py-2 font-normal text-grey-darkest w-full py-1 px-2 outline-none text-md text-gray-600",
                  id: "amount",
                  disabled: disabled,
                  placeholder: placeholder,
                  type: "text",
                  value: value,
                  onBlur: onBlur,
                  onChange: onChange
                }), optCurrency !== undefined ? React.createElement("span", {
                    className: "flex items-center bg-white pr-3 text-md text-gray-300"
                  }, optCurrency) : null, optBalance !== undefined ? React.createElement("span", {
                    className: "flex items-center bg-white px-1 text-xxs text-gray-400"
                  }, "balance " + Ethers.Utils.formatEtherToPrecision(Caml_option.valFromOption(optBalance), 2)) : null, React.createElement("span", {
                  className: "flex items-center bg-gray-200 hover:bg-white hover:text-gray-700 px-5 font-bold"
                }, React.createElement("span", {
                      onClick: onMaxClick
                    }, "MAX")));
}

var make = AmountInput;

export {
  make ,
  
}
/* react Not a pure module */
