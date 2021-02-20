// Generated by ReScript, PLEASE EDIT WITH CARE

import * as React from "react";
import * as Ethers from "./ethereum/Ethers.js";
import * as Globals from "./libraries/Globals.js";
import * as Belt_Array from "bs-platform/lib/es6/belt_Array.js";
import * as Belt_Float from "bs-platform/lib/es6/belt_Float.js";
import * as Belt_Option from "bs-platform/lib/es6/belt_Option.js";
import * as FormatMoney from "./components/UI/FormatMoney.js";
import * as DataFetchers from "./components/Data/DataFetchers.js";
import * as RootProvider from "./libraries/RootProvider.js";

function StakeDetails(Props) {
  var currentUser = RootProvider.useCurrentUserExn(undefined);
  var activeStakes = DataFetchers.useUsersStakes(currentUser);
  var match = activeStakes.data;
  var tmp;
  if (match !== undefined) {
    var currentStakes = match.currentStakes;
    tmp = currentStakes.length !== 0 ? React.createElement(React.Fragment, undefined, Belt_Array.map(currentStakes, (function (param) {
                  var match = param.currentStake;
                  var match$1 = match.tokenType;
                  var match$2 = match$1.syntheticMarket;
                  var amountFormatted = FormatMoney.formatMoney(Belt_Option.getWithDefault(Belt_Float.fromString(Ethers.Utils.formatEther(match.amount)), 0));
                  var timeSinceStaking = Globals.timestampToDuration(match.timestamp);
                  if (match.withdrawn) {
                    console.log("This is a bug in the graph, no withdrawn stakes should show in the `currentStakes`");
                    return null;
                  } else {
                    return React.createElement(React.Fragment, undefined, React.createElement("h3", {
                                    className: "text-xl"
                                  }, match$2.name + "(" + match$2.symbol + ")"), React.createElement("p", undefined, "Stake of " + amountFormatted + " ", React.createElement("a", {
                                        href: "https://testnet.bscscan.com/token/" + match$1.tokenAddress + "?a=" + Globals.ethAdrToStr(currentUser),
                                        target: "_"
                                      }, match$1.tokenType)), React.createElement("p", undefined, React.createElement("a", {
                                        href: "https://testnet.bscscan.com/tx/" + match.creationTxHash
                                      }, "Last updated " + timeSinceStaking + " ago")));
                  }
                }))) : React.createElement("h2", undefined, "You have no active stakes.");
  } else {
    tmp = activeStakes.error !== undefined ? "Error" : "Loading";
  }
  return React.createElement("div", {
              className: "p-5 flex flex-col items-center justify-center bg-white bg-opacity-75  rounded"
            }, React.createElement("h2", {
                  className: "text-4xl"
                }, "Stake"), tmp);
}

var make = StakeDetails;

export {
  make ,
  
}
/* react Not a pure module */
