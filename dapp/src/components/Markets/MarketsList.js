// Generated by ReScript, PLEASE EDIT WITH CARE

import * as Curry from "bs-platform/lib/es6/curry.js";
import * as Login from "../Login/Login.js";
import * as React from "react";
import * as Button from "../UI/Button.js";
import * as Queries from "../../data/Queries.js";
import * as Belt_Array from "bs-platform/lib/es6/belt_Array.js";
import * as MiniLoader from "../UI/MiniLoader.js";
import * as FormatMoney from "../UI/FormatMoney.js";
import * as Router from "next/router";
import * as AccessControl from "../AccessControl.js";

function MarketsList(Props) {
  var router = Router.useRouter();
  var marketDetailsQuery = Curry.app(Queries.MarketDetails.use, [
        undefined,
        undefined,
        undefined,
        undefined,
        undefined,
        undefined,
        undefined,
        undefined,
        undefined,
        undefined,
        undefined,
        undefined,
        undefined,
        undefined
      ]);
  var match = marketDetailsQuery.data;
  return React.createElement(AccessControl.make, {
              children: React.createElement("div", {
                    className: "p-5 flex flex-col bg-white bg-opacity-75  rounded"
                  }, React.createElement("h2", {
                        className: "text-xl font-medium"
                      }, "Markets"), React.createElement("div", {
                        className: "grid grid-cols-4 gap-1 items-center"
                      }, React.createElement("p", {
                            className: "font-bold underline text-xs"
                          }, "Market"), React.createElement("p", {
                            className: "font-bold underline  text-xs"
                          }, "Long Liquidity"), React.createElement("p", {
                            className: "font-bold underline text-xs"
                          }, "Short Liquidity"), React.createElement("p", {
                            className: "font-bold underline text-xs"
                          }, "")), marketDetailsQuery.loading ? React.createElement("div", {
                          className: "m-auto"
                        }, React.createElement(MiniLoader.make, {})) : (
                      marketDetailsQuery.error !== undefined ? "Error loading data" : (
                          match !== undefined ? React.createElement(React.Fragment, undefined, Belt_Array.map(match.syntheticMarkets, (function (param) {
                                        var match = param.latestSystemState;
                                        var marketIndex = param.marketIndex;
                                        return React.createElement("div", {
                                                    className: "grid grid-cols-4 gap-1 items-center"
                                                  }, React.createElement("p", undefined, param.name), React.createElement("p", undefined, "$" + FormatMoney.formatEther(match.totalLockedLong)), React.createElement("p", undefined, "$" + FormatMoney.formatEther(match.totalLockedShort)), React.createElement(Button.make, {
                                                        onClick: (function (param) {
                                                            router.push("/mint?marketIndex=" + marketIndex.toString());
                                                            
                                                          }),
                                                        children: "Mint",
                                                        variant: "small"
                                                      }));
                                      }))) : "You might think this is impossible, but depending on the situation it might not be!"
                        )
                    )),
              alternateComponent: React.createElement("h1", {
                    onClick: (function (param) {
                        router.push("/login?nextPath=/dashboard");
                        
                      })
                  }, React.createElement(Login.make, {}))
            });
}

var make = MarketsList;

export {
  make ,
  
}
/* Login Not a pure module */
