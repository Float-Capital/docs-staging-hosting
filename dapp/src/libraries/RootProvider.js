// Generated by ReScript, PLEASE EDIT WITH CARE

import * as Curry from "bs-platform/lib/es6/curry.js";
import * as React from "react";
import * as Config from "../Config.js";
import * as Ethers from "ethers";
import * as Globals from "./Globals.js";
import * as JsPromise from "./Js.Promise/JsPromise.js";
import * as Belt_Option from "bs-platform/lib/es6/belt_Option.js";
import * as Caml_option from "bs-platform/lib/es6/caml_option.js";
import * as ToastProvider from "../components/UI/ToastProvider.js";
import * as Web3Connectors from "../bindings/web3-react/Web3Connectors.js";
import * as Core from "@web3-react/core";
import * as Caml_js_exceptions from "bs-platform/lib/es6/caml_js_exceptions.js";

var Web3ReactProvider = {};

function getLibrary(provider) {
  var library = new (Ethers.providers.Web3Provider)(provider);
  var setPollingInterval = ((lib, pollingInterval) => {lib.pollingInterval = pollingInterval; return lib; });
  return setPollingInterval(library, Config.web3PollingInterval);
}

var initialState = {
  ethState: /* Disconnected */0
};

function reducer(_prevState, action) {
  if (action) {
    return {
            ethState: {
              _0: action._0,
              _1: action._1,
              [Symbol.for("name")]: "Connected"
            }
          };
  } else {
    return {
            ethState: /* Disconnected */0
          };
  }
}

var context = React.createContext([
      initialState,
      (function (param) {
          
        })
    ]);

var make = context.Provider;

function makeProps(value, children, param) {
  return {
          value: value,
          children: children
        };
}

var RootContext = {
  context: context,
  make: make,
  makeProps: makeProps
};

function RootProvider$RootWithWeb3(Props) {
  var children = Props.children;
  var match = React.useReducer(reducer, initialState);
  var dispatch = match[1];
  var rootState = match[0];
  var context = Core.useWeb3React();
  var match$1 = React.useState(function () {
        return false;
      });
  var setTriedLoginAlready = match$1[1];
  var triedLoginAlready = match$1[0];
  React.useEffect((function () {
          Curry._1(Web3Connectors.injected.isAuthorized, undefined).then(function (authorised) {
                if (authorised && !triedLoginAlready) {
                  JsPromise.$$catch(context.activate(Web3Connectors.injected, (function (param) {
                              
                            }), true), (function (param) {
                          return Promise.resolve(Curry._1(setTriedLoginAlready, (function (param) {
                                            return true;
                                          })));
                        }));
                  return ;
                } else {
                  return Curry._1(setTriedLoginAlready, (function (param) {
                                return true;
                              }));
                }
              });
          var match = context.chainId;
          if (match !== undefined) {
            
          } else {
            Curry._1(dispatch, /* Logout */0);
          }
          
        }), [
        context.activate,
        context.chainId,
        dispatch,
        setTriedLoginAlready,
        triedLoginAlready
      ]);
  React.useEffect((function () {
          if (context.active) {
            
          } else {
            Curry._1(dispatch, /* Logout */0);
          }
          
        }), [rootState.ethState]);
  React.useEffect((function () {
          if (!triedLoginAlready && context.active) {
            Curry._1(setTriedLoginAlready, (function (param) {
                    return true;
                  }));
          }
          
        }), [
        triedLoginAlready,
        context.active,
        setTriedLoginAlready
      ]);
  React.useEffect((function () {
          var match = context.library;
          var match$1 = context.account;
          if (match === undefined) {
            return ;
          }
          if (match$1 === undefined) {
            return ;
          }
          var account = Caml_option.valFromOption(match$1);
          JsPromise.$$catch(Caml_option.valFromOption(match).getBalance(account).then(function (newBalance) {
                    return Curry._1(dispatch, {
                                _0: account,
                                _1: newBalance,
                                [Symbol.for("name")]: "LoadAddress"
                              });
                  }), (function (param) {
                  return Promise.resolve(undefined);
                }));
          
        }), [
        context.library,
        context.account,
        context.chainId,
        dispatch
      ]);
  return React.createElement(make, makeProps([
                  rootState,
                  dispatch
                ], children, undefined));
}

var RootWithWeb3 = {
  make: RootProvider$RootWithWeb3
};

function useCurrentUser(param) {
  return Core.useWeb3React().account;
}

function useIsLoggedIn(param) {
  var context = Core.useWeb3React();
  return Belt_Option.isSome(context.account);
}

function useCurrentUserExn(param) {
  return Belt_Option.getExn(Core.useWeb3React().account);
}

function useIsAddressCurrentUser(address) {
  var currentUser = Core.useWeb3React().account;
  if (currentUser !== undefined) {
    return Globals.ethAdrToLowerStr(address) === Globals.ethAdrToLowerStr(Caml_option.valFromOption(currentUser));
  } else {
    return false;
  }
}

function useEthBalance(param) {
  var match = React.useContext(context);
  var match$1 = match[0].ethState;
  if (match$1) {
    return match$1._1;
  }
  
}

function useChainId(param) {
  return Core.useWeb3React().chainId;
}

function useChainIdExn(param) {
  return Belt_Option.getExn(Core.useWeb3React().chainId);
}

function useDeactivateWeb3(param) {
  return Core.useWeb3React().deactivate;
}

function useWeb3(param) {
  return Core.useWeb3React().library;
}

function useActivateConnector(param) {
  var context = Core.useWeb3React();
  var match = React.useState(function () {
        return /* Standby */0;
      });
  var setConnectionStatus = match[1];
  var toastDispatch = React.useContext(ToastProvider.DispatchToastContext.context);
  return [
          match[0],
          (function (provider) {
              JsPromise.$$catch(context.activate(provider, (function (param) {
                            
                          }), true).then(function (param) {
                        return Curry._1(setConnectionStatus, (function (param) {
                                      return /* Connected */1;
                                    }));
                      }), (function (error) {
                      var err = Caml_js_exceptions.caml_as_js_exn(error);
                      var errorMessage = err !== undefined ? Belt_Option.mapWithDefault(Caml_option.valFromOption(err).message, "", (function (x) {
                                return x;
                              })) : "";
                      Curry._1(toastDispatch, {
                            _0: "Error connecting to the network",
                            _1: errorMessage,
                            _2: /* Error */0,
                            [Symbol.for("name")]: "Show"
                          });
                      return Promise.resolve(Curry._1(setConnectionStatus, (function (param) {
                                        return /* ErrorConnecting */3;
                                      })));
                    }));
              return Curry._1(setConnectionStatus, (function (param) {
                            return /* Connecting */2;
                          }));
            })
        ];
}

function RootProvider(Props) {
  var children = Props.children;
  return React.createElement(Core.Web3ReactProvider, {
              getLibrary: getLibrary,
              children: React.createElement(RootProvider$RootWithWeb3, {
                    children: children
                  })
            });
}

var make$1 = RootProvider;

export {
  Web3ReactProvider ,
  getLibrary ,
  initialState ,
  reducer ,
  RootContext ,
  RootWithWeb3 ,
  useCurrentUser ,
  useIsLoggedIn ,
  useCurrentUserExn ,
  useIsAddressCurrentUser ,
  useEthBalance ,
  useChainId ,
  useChainIdExn ,
  useDeactivateWeb3 ,
  useWeb3 ,
  useActivateConnector ,
  make$1 as make,
  
}
/* context Not a pure module */
