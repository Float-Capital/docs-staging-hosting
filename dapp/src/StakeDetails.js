// Generated by ReScript, PLEASE EDIT WITH CARE

import * as Card from "./components/UI/Card.js";
import * as React from "react";
import * as Globals from "./libraries/Globals.js";
import * as Belt_Array from "bs-platform/lib/es6/belt_Array.js";
import * as MiniLoader from "./components/UI/MiniLoader.js";
import * as Caml_option from "bs-platform/lib/es6/caml_option.js";
import * as FormatMoney from "./components/UI/FormatMoney.js";
import * as DataFetchers from "./components/Data/DataFetchers.js";
import * as RootProvider from "./libraries/RootProvider.js";
import * as ClaimFloatImmediatlyPerToken from "./components/Claim/ClaimFloatImmediatlyPerToken.js";

function StakeDetails$UsersActiveStakes(Props) {
  var currentUser = Props.currentUser;
  var activeStakes = DataFetchers.useUsersStakes(currentUser);
  var match = activeStakes.data;
  var tmp;
  if (match !== undefined) {
    var currentStakes = match.currentStakes;
    tmp = currentStakes.length !== 0 ? React.createElement(React.Fragment, undefined, Belt_Array.map(currentStakes, (function (param) {
                  var match = param.currentStake;
                  var match$1 = match.syntheticToken;
                  var tokenAddress = match$1.tokenAddress;
                  var amountFormatted = FormatMoney.formatEther(undefined, match.amount);
                  var timeSinceStaking = Globals.timestampToDuration(match.timestamp);
                  if (match.withdrawn) {
                    console.log("This is a bug in the graph, no withdrawn stakes should show in the `currentStakes`");
                    return null;
                  } else {
                    return React.createElement(Card.make, {
                                children: null
                              }, React.createElement("div", {
                                    className: "flex justify-between items-start w-full "
                                  }, React.createElement("div", {
                                        className: "flex justify-start items-center "
                                      }, React.createElement("h3", {
                                            className: "text-xl"
                                          }, match$1.syntheticMarket.symbol)), React.createElement("a", {
                                        className: "text-xs hover:text-gray-500 hover:underline  ml-5",
                                        href: "https://testnet.bscscan.com/tx/" + match.creationTxHash
                                      }, "Last updated " + timeSinceStaking + " ago")), React.createElement("div", {
                                    className: "flex justify-between items-end w-full"
                                  }, React.createElement("h4", {
                                        className: "text-lg"
                                      }, match$1.tokenType), React.createElement("p", {
                                        className: "text-primary "
                                      }, React.createElement("a", {
                                            href: "https://testnet.bscscan.com/token/" + Globals.ethAdrToStr(tokenAddress) + "?a=" + Globals.ethAdrToStr(currentUser),
                                            target: "_"
                                          }, React.createElement("span", {
                                                className: "text-bold text-4xl"
                                              }, amountFormatted), " Tokens")), React.createElement("div", {
                                        className: "flex items-center"
                                      }, React.createElement(ClaimFloatImmediatlyPerToken.make, {
                                            tokenAddress: tokenAddress
                                          }))));
                  }
                }))) : React.createElement("h2", undefined, "You have no active stakes.");
  } else {
    tmp = activeStakes.error !== undefined ? "Error" : React.createElement(MiniLoader.make, {});
  }
  return React.createElement("div", {
              className: "flex flex-col"
            }, React.createElement("h2", {
                  className: "text-xl"
                }, "Your stakes"), tmp);
}

var UsersActiveStakes = {
  make: StakeDetails$UsersActiveStakes
};

function StakeDetails(Props) {
  var optCurrentUser = RootProvider.useCurrentUser(undefined);
  if (optCurrentUser !== undefined) {
    return React.createElement(StakeDetails$UsersActiveStakes, {
                currentUser: Caml_option.valFromOption(optCurrentUser)
              });
  } else {
    return "Login to view your stakes";
  }
}

var make = StakeDetails;

export {
  UsersActiveStakes ,
  make ,
  
}
/* Card Not a pure module */
