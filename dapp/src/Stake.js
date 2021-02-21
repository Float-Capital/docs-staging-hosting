// Generated by ReScript, PLEASE EDIT WITH CARE

import * as Card from "./components/UI/Card.js";
import * as Curry from "bs-platform/lib/es6/curry.js";
import * as Login from "./components/Login/Login.js";
import * as React from "react";
import * as Button from "./components/UI/Button.js";
import * as Ethers from "ethers";
import * as Js_dict from "bs-platform/lib/es6/js_dict.js";
import * as Queries from "./libraries/Queries.js";
import * as ViewBox from "./components/UI/ViewBox.js";
import * as StakeForm from "./components/Stake/StakeForm.js";
import * as Belt_Array from "bs-platform/lib/es6/belt_Array.js";
import * as Router from "next/router";
import * as TokenBalance from "./components/ExampleViewFunctions/TokenBalance.js";
import * as AccessControl from "./components/AccessControl.js";
import * as AddToMetamask from "./components/UI/AddToMetamask.js";
import * as Belt_SortArray from "bs-platform/lib/es6/belt_SortArray.js";

function Stake$Stake(Props) {
  var router = Router.useRouter();
  React.useState(function () {
        return true;
      });
  var match = React.useState(function () {
        return [];
      });
  var setSyntheticTokens = match[1];
  var tokens = Curry.app(Queries.SyntheticTokens.use, [
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
  var tokenId = Js_dict.get(router.query, "tokenId");
  React.useEffect((function () {
          var match = tokens.data;
          if (tokens.loading) {
            return ;
          }
          if (tokens.error !== undefined) {
            console.log("error");
            Curry._1(setSyntheticTokens, (function (param) {
                    return [];
                  }));
            return ;
          }
          if (match !== undefined) {
            var syntheticTokens = match.syntheticTokens;
            Curry._1(setSyntheticTokens, (function (param) {
                    return Belt_SortArray.stableSortBy(Belt_Array.map(syntheticTokens, (function (param) {
                                      return {
                                              id: param.id,
                                              symbol: param.syntheticMarket.name,
                                              apy: 0.2,
                                              tokenType: String(param.tokenType).toLowerCase()
                                            };
                                    })), (function (a, b) {
                                  var greater = b.symbol.localeCompare(a.symbol);
                                  if (greater > 0.0) {
                                    return -1;
                                  }
                                  if (greater < 0.0) {
                                    return 1;
                                  }
                                  var match = a.tokenType;
                                  var match$1 = b.tokenType;
                                  switch (match) {
                                    case "long" :
                                        if (match$1 === "short") {
                                          return -1;
                                        } else {
                                          return 0;
                                        }
                                    case "short" :
                                        if (match$1 === "long") {
                                          return 1;
                                        } else {
                                          return 0;
                                        }
                                    default:
                                      return 0;
                                  }
                                }));
                  }));
            return ;
          }
          Curry._1(setSyntheticTokens, (function (param) {
                  return [];
                }));
          console.log("You might think this is impossible, but depending on the situation it might not be!");
          
        }), [tokens]);
  return React.createElement(AccessControl.make, {
              children: React.createElement(ViewBox.make, {
                    children: tokenId !== undefined ? React.createElement("div", undefined, React.createElement(StakeForm.make, {
                                tokenId: tokenId
                              })) : React.createElement(React.Fragment, undefined, React.createElement("h1", undefined, "Stake"), Belt_Array.map(match[0], (function (token) {
                                  return React.createElement(Card.make, {
                                              children: React.createElement("div", {
                                                    className: "flex justify-between items-center w-full"
                                                  }, React.createElement("div", {
                                                        className: "flex flex-col"
                                                      }, React.createElement("div", {
                                                            className: "flex"
                                                          }, React.createElement("h3", {
                                                                className: "font-bold"
                                                              }, "Token"), React.createElement(AddToMetamask.make, {
                                                                tokenAddress: token.id,
                                                                tokenSymbol: (
                                                                  token.tokenType === "short" ? "↘️" : "↗️"
                                                                ) + token.symbol.replace(/[aeiou]/ig, "")
                                                              })), React.createElement("p", undefined, token.symbol, token.tokenType === "short" ? "↘️" : "↗️")), React.createElement("div", {
                                                        className: "flex flex-col"
                                                      }, React.createElement("h3", {
                                                            className: "font-bold"
                                                          }, "Balance"), React.createElement(TokenBalance.make, {
                                                            erc20Address: Ethers.utils.getAddress(token.id)
                                                          })), React.createElement("div", {
                                                        className: "flex flex-col"
                                                      }, React.createElement("h3", {
                                                            className: "font-bold"
                                                          }, "R ", React.createElement("span", {
                                                                className: "text-xs"
                                                              }, "ℹ️")), React.createElement("p", undefined, String(token.apy * 100) + "%" + (
                                                            token.apy > 0.15 ? "🔥" : ""
                                                          ))), React.createElement(Button.make, {
                                                        onClick: (function (param) {
                                                            router.push("/stake?tokenId=" + token.id);
                                                            
                                                          }),
                                                        children: "STAKE",
                                                        variant: "small"
                                                      })),
                                              key: token.symbol + token.tokenType
                                            });
                                })))
                  }),
              alternateComponent: React.createElement("h1", {
                    onClick: (function (param) {
                        router.push("/login?nextPath=/stake");
                        
                      })
                  }, React.createElement(Login.make, {}))
            });
}

var Stake = {
  make: Stake$Stake
};

function $$default(param) {
  return React.createElement(Stake$Stake, {});
}

export {
  Stake ,
  $$default ,
  $$default as default,
  
}
/* Card Not a pure module */
