// Generated by ReScript, PLEASE EDIT WITH CARE

import * as Misc from "../../libraries/Misc.js";
import * as Curry from "bs-platform/lib/es6/curry.js";
import * as React from "react";
import * as Ethers from "../../ethereum/Ethers.js";
import * as Ethers$1 from "ethers";
import * as MintDai from "./MintDai.js";
import * as Queries from "../../libraries/Queries.js";
import * as MintLong from "./MintLong.js";
import * as MintShort from "./MintShort.js";
import * as ApproveDai from "./ApproveDai.js";
import * as Belt_Array from "bs-platform/lib/es6/belt_Array.js";
import * as Belt_Option from "bs-platform/lib/es6/belt_Option.js";
import * as Caml_option from "bs-platform/lib/es6/caml_option.js";
import * as RedeemSynth from "./RedeemSynth.js";
import * as RootProvider from "../../libraries/RootProvider.js";

var context = React.createContext(undefined);

var privKeyStorageId = "admin-private-key";

function AdminTestingPortal$AdminContext$Provider(Props) {
  var children = Props.children;
  var getPrivateKeyFromLocalStorage = function (__x) {
    return Caml_option.null_to_opt(__x.getItem(privKeyStorageId));
  };
  var optAuthHeader = Belt_Option.flatMap(Misc.optLocalstorage, getPrivateKeyFromLocalStorage);
  var match = React.useState(function () {
        return Belt_Option.isSome(optAuthHeader);
      });
  var setAuthSet = match[1];
  var authSet = match[0];
  var match$1 = React.useState(function () {
        return Belt_Option.getWithDefault(optAuthHeader, "");
      });
  var setAuthHeader = match$1[1];
  var authHeader = match$1[0];
  var match$2 = React.useState(function () {
        return true;
      });
  var setPrivateKeyMode = match$2[1];
  var privateKeyMode = match$2[0];
  var onChange = function (e) {
    return Curry._1(setAuthHeader, e.target.value);
  };
  var provider = context.Provider;
  var optCurrentUser = RootProvider.useCurrentUser(undefined);
  var optProvider = RootProvider.useWeb3(undefined);
  var optEthersSigner = Belt_Option.flatMap(optProvider, (function (provider) {
          if (privateKeyMode) {
            if (authSet) {
              console.log("b");
              return Belt_Option.map(optAuthHeader, (function (authHeader) {
                            return new Ethers$1.Wallet(authHeader, provider);
                          }));
            } else {
              console.log("c");
              return ;
            }
          } else {
            console.log("a");
            return Belt_Option.flatMap(optCurrentUser, (function (usersAddress) {
                          return provider.getSigner(usersAddress);
                        }));
          }
        }));
  var authDisplay = React.createElement("div", undefined, optCurrentUser !== undefined ? React.createElement(React.Fragment, undefined, React.createElement("span", {
                  className: "inline-flex"
                }, React.createElement("p", undefined, "Use injectod provider?"), React.createElement("input", {
                      checked: !privateKeyMode,
                      type: "checkbox",
                      onChange: (function (param) {
                          return Curry._1(setPrivateKeyMode, (function (param) {
                                        return !privateKeyMode;
                                      }));
                        })
                    })), React.createElement("br", undefined)) : null, authSet || !privateKeyMode ? React.createElement(React.Fragment, undefined, privateKeyMode ? React.createElement(React.Fragment, undefined, React.createElement("button", {
                        onClick: (function (param) {
                            return Curry._1(setAuthSet, (function (param) {
                                          return false;
                                        }));
                          })
                      }, "Edit your auth key"), React.createElement("br", undefined)) : null, children) : React.createElement("form", {
              onSubmit: (function ($$event) {
                  localStorage.setItem(privKeyStorageId, authHeader);
                  $$event.preventDefault();
                  return Curry._1(setAuthSet, (function (param) {
                                return true;
                              }));
                })
            }, React.createElement("label", undefined, "Auth Key: "), React.createElement("input", {
                  name: "auth_key",
                  type: "text",
                  onChange: onChange
                }), React.createElement("button", {
                  type: "submit"
                }, "submit"), React.createElement("br", undefined), React.createElement("br", undefined), React.createElement("br", undefined), React.createElement("p", undefined, "NOTE: you may need to reload the webpage after doing this to activate the key")));
  return React.createElement(provider, {
              value: optEthersSigner,
              children: authDisplay
            });
}

var Provider = {
  privKeyStorageId: privKeyStorageId,
  make: AdminTestingPortal$AdminContext$Provider
};

var AdminContext = {
  context: context,
  Provider: Provider
};

function AdminTestingPortal$AdminActions(Props) {
  var optEthersWallet = React.useContext(context);
  if (optEthersWallet === undefined) {
    return React.createElement("h1", undefined, "No provider is selected. Even if you are using your own private key you still need to login with metamask for the connection to ethereum.");
  }
  var match = Curry.app(Queries.MarketDetails.use, [
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
  var match$1 = match.data;
  return React.createElement("div", undefined, React.createElement("h1", undefined, "Test Functions"), React.createElement("div", {
                  className: "border-dashed border-4 border-light-red-500"
                }, React.createElement(ApproveDai.make, {}), React.createElement(MintDai.make, {
                      ethersWallet: optEthersWallet
                    }), React.createElement("h1", undefined, "Market specific Functions:"), match.loading ? "Loading..." : (
                    match.error !== undefined ? "Error loading data" : (
                        match$1 !== undefined ? React.createElement(React.Fragment, undefined, Belt_Array.map(match$1.syntheticMarkets, (function (param) {
                                      var marketIndex = param.marketIndex;
                                      var symbol = param.symbol;
                                      return React.createElement("div", {
                                                  key: symbol,
                                                  className: "w-full"
                                                }, React.createElement("h1", {
                                                      className: "w-full text-5xl underline text-center"
                                                    }, "Market " + param.name + " (" + symbol + ")"), React.createElement("div", {
                                                      className: "flex justify-between items-center w-full"
                                                    }, React.createElement("div", undefined, React.createElement("h1", undefined, "Long(" + Ethers.Utils.toString(param.syntheticLong.tokenAddress) + ")"), React.createElement(MintLong.make, {
                                                              marketIndex: marketIndex
                                                            }), React.createElement(RedeemSynth.make, {
                                                              isLong: true,
                                                              marketIndex: marketIndex
                                                            })), React.createElement("div", undefined, React.createElement("h1", undefined, "Short(" + Ethers.Utils.toString(param.syntheticShort.tokenAddress) + ")"), React.createElement(MintShort.make, {
                                                              marketIndex: marketIndex
                                                            }), React.createElement(RedeemSynth.make, {
                                                              isLong: false,
                                                              marketIndex: marketIndex
                                                            }))));
                                    }))) : "You might think this is impossible, but depending on the situation it might not be!"
                      )
                  )));
}

var AdminActions = {
  make: AdminTestingPortal$AdminActions
};

function $$default(param) {
  return React.createElement(AdminTestingPortal$AdminContext$Provider, {
              children: React.createElement(AdminTestingPortal$AdminActions, {})
            });
}

export {
  AdminContext ,
  AdminActions ,
  $$default ,
  $$default as default,
  
}
/* context Not a pure module */
