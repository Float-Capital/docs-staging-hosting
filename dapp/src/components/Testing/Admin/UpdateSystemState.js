// Generated by ReScript, PLEASE EDIT WITH CARE

import * as Curry from "bs-platform/lib/es6/curry.js";
import * as React from "react";
import * as Config from "../../../Config.js";
import * as Contracts from "../../../ethereum/Contracts.js";
import * as TxTemplate from "../../Ethereum/TxTemplate.js";
import * as ContractActions from "../../../ethereum/ContractActions.js";

function UpdateSystemState(Props) {
  var signer = ContractActions.useSignerExn(undefined);
  var match = ContractActions.useContractFunction(signer);
  var setTxState = match[2];
  var contractExecutionHandler = match[0];
  var onClick = function (param) {
    return Curry._2(contractExecutionHandler, (function (param) {
                  return Contracts.LongShort.make(Config.longShort, param);
                }), (function (prim) {
                  return prim._updateSystemState();
                }));
  };
  return React.createElement(TxTemplate.make, {
              children: React.createElement("div", undefined, React.createElement("div", {
                        className: ""
                      }, React.createElement("h2", {
                            className: "text-xl"
                          }, "Update System State"), React.createElement("div", undefined, React.createElement("button", {
                                className: "text-lg disabled:opacity-50 bg-green-500 rounded-lg",
                                onClick: onClick
                              }, "Submit")))),
              txState: match[1],
              resetTxState: (function (param) {
                  return Curry._1(setTxState, (function (param) {
                                return /* UnInitialised */0;
                              }));
                })
            });
}

var make = UpdateSystemState;

export {
  make ,
  
}
/* react Not a pure module */
