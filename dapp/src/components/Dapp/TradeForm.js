// Generated by ReScript, PLEASE EDIT WITH CARE

import * as Curry from "bs-platform/lib/es6/curry.js";
import * as React from "react";
import * as Config from "../../Config.js";
import * as Ethers from "../../ethereum/Ethers.js";
import * as Contracts from "../../ethereum/Contracts.js";
import * as ContractActions from "../../ethereum/ContractActions.js";

function TradeForm(Props) {
  var market = Props.market;
  console.log(market);
  var match = React.useState(function () {
        return true;
      });
  var setIsMint = match[1];
  var isMint = match[0];
  var signer = ContractActions.useSignerExn(undefined);
  var match$1 = ContractActions.useContractFunction(signer);
  var contractExecutionHandler = match$1[0];
  var longShortContractAddress = Config.useLongShortAddress(undefined);
  Config.useDaiAddress(undefined);
  var match$2 = React.useState(function () {
        return "";
      });
  var setAmount = match$2[1];
  var amount = match$2[0];
  return React.createElement("div", {
              className: "screen-centered-container"
            }, React.createElement("div", {
                  className: "trade-form"
                }, React.createElement("h2", undefined, market.name + " (" + market.symbol + ")"), React.createElement("select", {
                      className: "trade-select",
                      name: "longshort"
                    }, React.createElement("option", {
                          value: "long"
                        }, "Long 🐮"), React.createElement("option", {
                          value: "short"
                        }, "Short 🐻")), isMint ? React.createElement("input", {
                        className: "trade-input",
                        placeholder: "mint",
                        value: amount,
                        onChange: (function (e) {
                            var mintAmount = e.target.value;
                            return Curry._1(setAmount, (function (param) {
                                          return mintAmount;
                                        }));
                          })
                      }) : React.createElement("input", {
                        className: "trade-input",
                        placeholder: "redeem"
                      }), React.createElement("div", {
                      className: "trade-switch",
                      onClick: (function (param) {
                          return Curry._1(setIsMint, (function (param) {
                                        return !isMint;
                                      }));
                        })
                    }, "↑↓"), isMint ? React.createElement("input", {
                        className: "trade-input",
                        placeholder: "redeem"
                      }) : React.createElement("input", {
                        className: "trade-input",
                        placeholder: "mint"
                      }), React.createElement("button", {
                      className: "trade-action",
                      onClick: (function (param) {
                          var arg = market.marketIndex;
                          var arg$1 = Ethers.Utils.parseEtherUnsafe(amount);
                          return Curry._2(contractExecutionHandler, (function (param) {
                                        return Contracts.LongShort.make(longShortContractAddress, param);
                                      }), (function (param) {
                                        return param.mintLong(arg, arg$1);
                                      }));
                        })
                    }, "OPEN POSITION")));
}

var make = TradeForm;

export {
  make ,
  
}
/* react Not a pure module */
