// Generated by ReScript, PLEASE EDIT WITH CARE

import * as Card from "./components/UI/Card.js";
import * as Curry from "bs-platform/lib/es6/curry.js";
import * as Login from "./components/Login/Login.js";
import * as React from "react";
import * as Ethers from "ethers";
import * as Js_dict from "bs-platform/lib/es6/js_dict.js";
import * as Queries from "./libraries/Queries.js";
import * as Belt_Array from "bs-platform/lib/es6/belt_Array.js";
import * as DaiBalance from "./components/ExampleViewFunctions/DaiBalance.js";
import * as MiniLoader from "./components/UI/MiniLoader.js";
import * as Router from "next/router";
import * as StakeDetails from "./StakeDetails.js";
import * as TokenBalance from "./components/ExampleViewFunctions/TokenBalance.js";
import * as AccessControl from "./components/AccessControl.js";
import * as AddToMetamask from "./components/UI/AddToMetamask.js";

function Profile$Profile(Props) {
  var router = Router.useRouter();
  var userAddress = Js_dict.get(router.query, "address");
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
  var tmp;
  if (userAddress !== undefined) {
    var match = tokens.data;
    tmp = React.createElement("div", undefined, React.createElement("p", {
              className: "text-xs"
            }, "User: ", userAddress), React.createElement("div", {
              className: "flex w-full justify-between"
            }, React.createElement("div", {
                  className: "w-full mr-3"
                }, React.createElement(Card.make, {
                      children: React.createElement(DaiBalance.make, {})
                    }), tokens.loading ? React.createElement(MiniLoader.make, {}) : (
                    tokens.error !== undefined ? "There was an error loading the tokens" : (
                        match !== undefined ? Belt_Array.map(match.syntheticTokens, (function (param) {
                                  var tokenType = param.tokenType;
                                  var symbol = param.syntheticMarket.name;
                                  var id = param.id;
                                  return React.createElement(Card.make, {
                                              children: React.createElement("div", {
                                                    className: "flex justify-between w-full"
                                                  }, React.createElement("div", {
                                                        className: "flex items-center "
                                                      }, React.createElement("div", {
                                                            className: "mr-2"
                                                          }, React.createElement(AddToMetamask.make, {
                                                                tokenAddress: id,
                                                                tokenSymbol: (
                                                                  String(tokenType).toLowerCase() === "short" ? "↘️" : "↗️"
                                                                ) + symbol.replace(/[aeiou]/ig, "")
                                                              })), symbol + " ", String(tokenType).toLowerCase() + " balance: "), React.createElement("div", {
                                                        className: "ml-2"
                                                      }, React.createElement(TokenBalance.make, {
                                                            erc20Address: Ethers.utils.getAddress(id)
                                                          })))
                                            });
                                })) : "You might think this is impossible, but depending on the situation it might not be!"
                      )
                  )), React.createElement("div", {
                  className: "w-full ml-3"
                }, React.createElement(StakeDetails.make, {}))));
  } else {
    tmp = null;
  }
  return React.createElement(AccessControl.make, {
              children: React.createElement("section", undefined, tmp),
              alternateComponent: React.createElement("h1", {
                    onClick: (function (param) {
                        router.push("/login?nextPath=/");
                        
                      })
                  }, React.createElement(Login.make, {}))
            });
}

var Profile = {
  make: Profile$Profile
};

function $$default(param) {
  return React.createElement(Profile$Profile, {});
}

export {
  Profile ,
  $$default ,
  $$default as default,
  
}
/* Card Not a pure module */
