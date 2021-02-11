// Generated by ReScript, PLEASE EDIT WITH CARE

import * as Curry from "bs-platform/lib/es6/curry.js";
import * as React from "react";
import * as Config from "../../Config.js";
import * as Ethers from "../../ethereum/Ethers.js";
import * as Loader from "../UI/Loader.js";
import * as Contracts from "../../ethereum/Contracts.js";
import * as RootProvider from "../../libraries/RootProvider.js";
import * as ContractActions from "../../ethereum/ContractActions.js";

function TradeForm(Props) {
  var market = Props.market;
  var match = React.useState(function () {
        return true;
      });
  var setIsMint = match[1];
  var isMint = match[0];
  var signer = ContractActions.useSignerExn(undefined);
  var match$1 = ContractActions.useContractFunction(signer);
  var txState = match$1[1];
  var contractExecutionHandler = match$1[0];
  var longShortContractAddress = Config.useLongShortAddress(undefined);
  var match$2 = React.useState(function () {
        return "";
      });
  var setAmount = match$2[1];
  var amount = match$2[0];
  var txExplererUrl = RootProvider.useEtherscanUrl(undefined);
  var tmp;
  if (typeof txState === "number") {
    switch (txState) {
      case /* UnInitialised */0 :
          tmp = null;
          break;
      case /* Created */1 :
          tmp = React.createElement(React.Fragment, undefined, React.createElement("h1", undefined, "Processing Transaction ", React.createElement(Loader.make, {})), React.createElement("p", undefined, "Tx created."), React.createElement("div", undefined, React.createElement(Loader.make, {})));
          break;
      case /* Failed */2 :
          tmp = React.createElement(React.Fragment, undefined, React.createElement("h1", undefined, "The transaction failed.", React.createElement(Loader.make, {})), React.createElement("p", undefined, "This operation isn't permitted by the smart contract."));
          break;
      
    }
  } else {
    switch (txState.TAG | 0) {
      case /* SignedAndSubmitted */0 :
          tmp = React.createElement(React.Fragment, undefined, React.createElement("h1", undefined, "Processing Transaction ", React.createElement(Loader.make, {})), React.createElement("p", undefined, React.createElement("a", {
                        href: "https://" + txExplererUrl + "/tx/" + txState._0,
                        rel: "noopener noreferrer",
                        target: "_blank"
                      }, "View the transaction on " + txExplererUrl)), React.createElement(Loader.make, {}));
          break;
      case /* Declined */1 :
          tmp = React.createElement(React.Fragment, undefined, React.createElement("h1", undefined, "The transaction was declined by your wallet, please try again."), React.createElement("p", undefined, "Failure reason: " + txState._0));
          break;
      case /* Complete */2 :
          var txHash = txState._0.transactionHash;
          tmp = React.createElement(React.Fragment, undefined, React.createElement("h1", undefined, "Transaction Complete ", React.createElement(Loader.make, {})), React.createElement("p", undefined, React.createElement("a", {
                        href: "https://" + txExplererUrl + "/tx/" + txHash,
                        rel: "noopener noreferrer",
                        target: "_blank"
                      }, "View the transaction on " + txExplererUrl)));
          break;
      
    }
  }
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
                    }, "OPEN POSITION")), tmp);
}

var make = TradeForm;

export {
  make ,
  
}
/* react Not a pure module */
