// Generated by ReScript, PLEASE EDIT WITH CARE
'use strict';

var Curry = require("rescript/lib/js/curry.js");
var React = require("react");
var Tooltip = require("./Tooltip.js");
var Caml_int32 = require("rescript/lib/js/caml_int32.js");

function ProgressBar(Props) {
  var txConfirmedTimestampOpt = Props.txConfirmedTimestamp;
  var nextPriceUpdateTimestampOpt = Props.nextPriceUpdateTimestamp;
  var txConfirmedTimestamp = txConfirmedTimestampOpt !== undefined ? txConfirmedTimestampOpt : 0;
  var nextPriceUpdateTimestamp = nextPriceUpdateTimestampOpt !== undefined ? nextPriceUpdateTimestampOpt : 100;
  var secondsUntilExecution = nextPriceUpdateTimestamp - txConfirmedTimestamp | 0;
  var match = React.useState(function () {
        return 0;
      });
  var setCountupPercentage = match[1];
  React.useEffect((function () {
          var countup = {
            contents: 0
          };
          setInterval((function (param) {
                  if (Caml_int32.div(Math.imul(countup.contents, 100), secondsUntilExecution) < 100) {
                    countup.contents = countup.contents + 1 | 0;
                    return Curry._1(setCountupPercentage, (function (param) {
                                  return Caml_int32.div(Math.imul(countup.contents, 100), secondsUntilExecution);
                                }));
                  }
                  
                }), 1000);
          
        }), [nextPriceUpdateTimestamp]);
  return React.createElement("div", {
              className: "relative pt-1"
            }, React.createElement("div", {
                  className: "text-xxs text-center"
                }, "Please wait while your transaction is processed", React.createElement(Tooltip.make, {
                      tip: "The transaction will execute on the next oracle price update"
                    })), React.createElement("div", {
                  className: "relative pt-1"
                }, React.createElement("div", {
                      className: "overflow-hidden h-2 mb-4 text-xs flex rounded bg-indigo-200"
                    }, React.createElement("div", {
                          className: "w-10 shadow-none flex flex-col text-center whitespace-nowrap text-white justify-center animated-color-progress-bar",
                          style: {
                            width: String(match[0]) + "%"
                          }
                        }))));
}

var make = ProgressBar;

exports.make = make;
/* react Not a pure module */
