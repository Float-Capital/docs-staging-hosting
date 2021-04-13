// Generated by ReScript, PLEASE EDIT WITH CARE

import * as Curry from "bs-platform/lib/es6/curry.js";
import * as React from "react";
import * as Button from "../UI/Button.js";
import * as Config from "../../Config.js";
import * as Ethers from "ethers";
import * as Contracts from "../../ethereum/Contracts.js";
import * as Belt_Array from "bs-platform/lib/es6/belt_Array.js";
import * as ToastProvider from "../UI/ToastProvider.js";
import * as ContractActions from "../../ethereum/ContractActions.js";
import * as ClaimTxStatusModal from "./ClaimTxStatusModal.js";

function ClaimFloat(Props) {
  var tokenAddresses = Props.tokenAddresses;
  var signer = ContractActions.useSignerExn(undefined);
  var match = ContractActions.useContractFunction(signer);
  var txState = match[1];
  var contractExecutionHandler = match[0];
  var toastDispatch = React.useContext(ToastProvider.DispatchToastContext.context);
  React.useEffect((function () {
          if (typeof txState === "number") {
            switch (txState) {
              case /* UnInitialised */0 :
                  break;
              case /* Created */1 :
                  Curry._1(toastDispatch, {
                        _0: "Confirm claim transaction in your wallet",
                        _1: "",
                        _2: /* Info */2,
                        [Symbol.for("name")]: "Show"
                      });
                  break;
              case /* Failed */2 :
                  Curry._1(toastDispatch, {
                        _0: "The transaction failed",
                        _1: "",
                        _2: /* Error */0,
                        [Symbol.for("name")]: "Show"
                      });
                  break;
              
            }
          } else {
            switch (txState.TAG | 0) {
              case /* SignedAndSubmitted */0 :
                  Curry._1(toastDispatch, {
                        _0: "claim transaction pending",
                        _1: "",
                        _2: /* Info */2,
                        [Symbol.for("name")]: "Show"
                      });
                  break;
              case /* Declined */1 :
                  Curry._1(toastDispatch, {
                        _0: "The transaction was rejected by your wallet",
                        _1: txState._0,
                        _2: /* Error */0,
                        [Symbol.for("name")]: "Show"
                      });
                  break;
              case /* Complete */2 :
                  Curry._1(toastDispatch, {
                        _0: "Claim transaction confirmed 🎉",
                        _1: "",
                        _2: /* Success */3,
                        [Symbol.for("name")]: "Show"
                      });
                  break;
              
            }
          }
          
        }), [txState]);
  return React.createElement(React.Fragment, undefined, React.createElement(Button.Tiny.make, {
                  onClick: (function (param) {
                      var arg = Belt_Array.map(tokenAddresses, (function (prim) {
                              return Ethers.utils.getAddress(prim);
                            }));
                      return Curry._2(contractExecutionHandler, (function (param) {
                                    return Contracts.Staker.make(Config.staker, param);
                                  }), (function (param) {
                                    return param.claimFloat(arg);
                                  }));
                    }),
                  children: "Claim Float"
                }), React.createElement(ClaimTxStatusModal.make, {
                  txState: txState
                }));
}

var make = ClaimFloat;

export {
  make ,
  
}
/* react Not a pure module */
