// Generated by ReScript, PLEASE EDIT WITH CARE
'use strict';

var Curry = require("rescript/lib/js/curry.js");
var React = require("react");
var Button = require("../UI/Base/Button.js");
var Config = require("../../config/Config.js");
var Contracts = require("../../ethereum/Contracts.js");
var ToastProvider = require("../UI/ToastProvider.js");
var ContractActions = require("../../ethereum/ContractActions.js");
var ClaimTxStatusModal = require("./ClaimTxStatusModal.js");

function ClaimFloat(Props) {
  var marketIndexes = Props.marketIndexes;
  var signer = ContractActions.useSignerExn(undefined);
  var match = ContractActions.useContractFunction(signer);
  var txState = match[1];
  var contractExecutionHandler = match[0];
  var toastDispatch = React.useContext(ToastProvider.DispatchToastContext.context);
  React.useEffect((function () {
          if (typeof txState === "number") {
            if (txState !== /* UnInitialised */0) {
              Curry._1(toastDispatch, {
                    _0: "Confirm claim transaction in your wallet",
                    _1: "",
                    _2: /* Info */2,
                    [Symbol.for("name")]: "Show"
                  });
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
              case /* Failed */3 :
                  Curry._1(toastDispatch, {
                        _0: "The transaction failed",
                        _1: "",
                        _2: /* Error */0,
                        [Symbol.for("name")]: "Show"
                      });
                  break;
              
            }
          }
          
        }), [txState]);
  return React.createElement(React.Fragment, undefined, React.createElement(Button.Tiny.make, {
                  onClick: (function (param) {
                      return Curry._2(contractExecutionHandler, (function (param) {
                                    return Contracts.Staker.make(Config.staker, param);
                                  }), (function (param) {
                                    return param.claimFloatCustom(marketIndexes);
                                  }));
                    }),
                  children: "Claim Float"
                }), React.createElement(ClaimTxStatusModal.make, {
                  txState: txState
                }));
}

var make = ClaimFloat;

exports.make = make;
/* react Not a pure module */
