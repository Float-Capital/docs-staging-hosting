// Generated by ReScript, PLEASE EDIT WITH CARE
'use strict';

var Misc = require("../../../libraries/Misc.js");
var Curry = require("rescript/lib/js/curry.js");
var React = require("react");
var Button = require("./Button.js");
var Config = require("../../../config/Config.js");
var Loader = require("./Loader.js");
var Backend = require("../../../mockBackend/Backend.js");
var Tooltip = require("./Tooltip.js");
var Contracts = require("../../../ethereum/Contracts.js");
var CountDown = require("./CountDown.js");
var DataHooks = require("../../../data/DataHooks.js");
var Refetchers = require("../../../libraries/Refetchers.js");
var ContractActions = require("../../../ethereum/ContractActions.js");
var Format = require("date-fns/format").default;

function PendingBar$SystemUpdateTxState(Props) {
  var txState = Props.txState;
  var updateSystemStateCall = Props.updateSystemStateCall;
  var refetchCallback = Props.refetchCallback;
  var tmp;
  var exit = 0;
  if (typeof txState === "number") {
    if (txState === /* UnInitialised */0) {
      exit = 1;
    } else {
      tmp = React.createElement(Loader.Ellipses.make, {});
    }
  } else {
    switch (txState.TAG | 0) {
      case /* SignedAndSubmitted */0 :
          tmp = React.createElement(Loader.Mini.make, {});
          break;
      case /* Declined */1 :
          exit = 1;
          break;
      case /* Complete */2 :
          Curry._1(refetchCallback, (function (param) {
                  return 1;
                }));
          tmp = React.createElement("p", {
                className: "text-xxxxs text-right text-green-500 "
              }, "✅ Success");
          break;
      case /* Failed */3 :
          tmp = React.createElement("p", {
                className: "text-xxxxs text-right text-red-500 "
              }, "Update tx failed");
          break;
      
    }
  }
  if (exit === 1) {
    tmp = React.createElement("div", undefined, React.createElement(Button.Tiny.make, {
              onClick: (function (param) {
                  return Curry._1(updateSystemStateCall, undefined);
                }),
              children: "Update Price"
            }));
  }
  return React.createElement("div", {
              className: "flex flex-row items-center"
            }, tmp);
}

var SystemUpdateTxState = {
  make: PendingBar$SystemUpdateTxState
};

function PendingBar$PendingBarInner(Props) {
  var lastOracleUpdateTimestamp = Props.lastOracleUpdateTimestamp;
  var oracleHeartbeat = Props.oracleHeartbeat;
  var now = Props.now;
  var txState = Props.txState;
  var updateSystemStateCall = Props.updateSystemStateCall;
  var refetchCallback = Props.refetchCallback;
  React.useEffect((function () {
          if (((lastOracleUpdateTimestamp.toNumber() + oracleHeartbeat | 0) - 30 | 0) > (now | 0)) {
            Curry._1(refetchCallback, (function (param) {
                    return now;
                  }));
          }
          
        }), [now]);
  var estimatedNextUpdateTimestamp = lastOracleUpdateTimestamp.toNumber() + oracleHeartbeat | 0;
  var tmp;
  if (estimatedNextUpdateTimestamp >= (now | 0)) {
    tmp = React.createElement("div", {
          className: "flex flex-row justify-end items-center"
        }, React.createElement("p", {
              className: "text-xs mr-2"
            }, React.createElement(CountDown.make, {
                  endDateTimestamp: estimatedNextUpdateTimestamp,
                  displayUnits: true
                })), React.createElement("p", {
              className: "text-gray text-right"
            }, "Est next", React.createElement("br", undefined), "update"));
  } else {
    var anUnreasonablyLongWait = (estimatedNextUpdateTimestamp + 10 | 0) > (now | 0);
    tmp = anUnreasonablyLongWait ? React.createElement("div", {
            className: "flex flex-col justify-center"
          }, React.createElement("div", {
                className: "mx-auto text-xs"
              }, React.createElement(Loader.Tiny.make, {})), React.createElement("p", {
                className: "text-xxxxs"
              }, "checking for", React.createElement("br", undefined), "price update")) : React.createElement(PendingBar$SystemUpdateTxState, {
            txState: txState,
            updateSystemStateCall: updateSystemStateCall,
            refetchCallback: refetchCallback
          });
  }
  return React.createElement("div", {
              className: "flex flex-row justify-between text-xxxs"
            }, React.createElement("div", {
                  className: "flex flex-row justify-start items-center"
                }, React.createElement("p", {
                      className: "text-gray"
                    }, "Previous", React.createElement("br", undefined), "update"), React.createElement("p", {
                      className: "text-xs ml-2"
                    }, Format(new Date(lastOracleUpdateTimestamp.toNumber() * 1000), "HH:mm:ss"))), tmp);
}

var PendingBarInner = {
  make: PendingBar$PendingBarInner
};

function PendingBar$PendingBarWrapper(Props) {
  var marketIndex = Props.marketIndex;
  var signer = Props.signer;
  var refetchCallback = Props.refetchCallback;
  var showBlurb = Props.showBlurb;
  var lastOracleTimestamp = DataHooks.useOracleLastUpdate(marketIndex.toString());
  var oracleHeartbeat = Backend.getMarketInfoUnsafe(marketIndex.toNumber()).oracleHeartbeat;
  var match = ContractActions.useContractFunction(signer);
  var contractExecutionHandler = match[0];
  var updateSystemStateCall = function (param) {
    var longShortContract = function (param) {
      return Contracts.LongShort.make(Config.longShort, param);
    };
    var arg = [marketIndex];
    return Curry._2(contractExecutionHandler, longShortContract, (function (param) {
                  return param.updateSystemStateMulti(arg);
                }));
  };
  var match$1 = React.useState(function () {
        return Date.now() / 1000;
      });
  var setNow = match$1[1];
  var now = match$1[0];
  Refetchers.useRefetchLastOracleTimestamp(marketIndex, now);
  Misc.Time.useInterval((function (param) {
          return Curry._1(setNow, (function (param) {
                        return Date.now() / 1000;
                      }));
        }), 1000);
  var tmp;
  tmp = typeof lastOracleTimestamp === "number" ? React.createElement(Loader.Tiny.make, {}) : (
      lastOracleTimestamp.TAG === /* GraphError */0 ? React.createElement("p", {
              className: "text-xxxxs"
            }, lastOracleTimestamp._0) : React.createElement(PendingBar$PendingBarInner, {
              lastOracleUpdateTimestamp: lastOracleTimestamp._0,
              oracleHeartbeat: oracleHeartbeat,
              now: now,
              txState: match[1],
              updateSystemStateCall: updateSystemStateCall,
              refetchCallback: refetchCallback
            })
    );
  return React.createElement("div", {
              className: "relative pt-1"
            }, showBlurb ? React.createElement("div", {
                    className: "text-xxs text-center mx-4 text-gray-600"
                  }, "Your transaction will be processed with the next price update ", React.createElement(Tooltip.make, {
                        tip: "To ensure fairness and security your position will be opened on the next oracle price update"
                      })) : null, tmp, React.createElement("div", {
                  className: "w-full mx-auto my-1"
                }, React.createElement("div", {
                      className: "pending-bar-container"
                    }, React.createElement("span", {
                          className: "pending-bar"
                        }))));
}

var PendingBarWrapper = {
  make: PendingBar$PendingBarWrapper
};

function PendingBar(Props) {
  var marketIndex = Props.marketIndex;
  var refetchCallback = Props.refetchCallback;
  var showBlurbOpt = Props.showBlurb;
  var showBlurb = showBlurbOpt !== undefined ? showBlurbOpt : true;
  var signer = ContractActions.useSignerExn(undefined);
  return React.createElement(PendingBar$PendingBarWrapper, {
              marketIndex: marketIndex,
              signer: signer,
              refetchCallback: refetchCallback,
              showBlurb: showBlurb
            });
}

var make = PendingBar;

exports.SystemUpdateTxState = SystemUpdateTxState;
exports.PendingBarInner = PendingBarInner;
exports.PendingBarWrapper = PendingBarWrapper;
exports.make = make;
/* Misc Not a pure module */
