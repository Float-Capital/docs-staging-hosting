// Generated by ReScript, PLEASE EDIT WITH CARE

import * as Curry from "rescript/lib/es6/curry.js";
import * as React from "react";
import * as JsPromise from "../libraries/Js.Promise/JsPromise.js";
import * as Belt_Array from "rescript/lib/es6/belt_Array.js";
import * as Belt_Option from "rescript/lib/es6/belt_Option.js";
import * as Caml_option from "rescript/lib/es6/caml_option.js";
import * as Core from "@web3-react/core";
import * as Caml_js_exceptions from "rescript/lib/es6/caml_js_exceptions.js";

function getProviderOrSigner(library, account) {
  if (account !== undefined) {
    return Belt_Option.mapWithDefault(library.getSigner(Caml_option.valFromOption(account)), {
                TAG: 0,
                _0: library,
                [Symbol.for("name")]: "Provider"
              }, (function (signer) {
                  return {
                          TAG: 1,
                          _0: signer,
                          [Symbol.for("name")]: "Signer"
                        };
                }));
  } else {
    return {
            TAG: 0,
            _0: library,
            [Symbol.for("name")]: "Provider"
          };
  }
}

function getSigner(library, account) {
  if (account !== undefined) {
    return Belt_Option.mapWithDefault(library.getSigner(Caml_option.valFromOption(account)), undefined, (function (signer) {
                  return signer;
                }));
  }
  
}

function useProviderOrSigner(param) {
  var context = Core.useWeb3React();
  return React.useMemo((function () {
                var library = context.library;
                if (library !== undefined) {
                  return getProviderOrSigner(Caml_option.valFromOption(library), context.account);
                }
                
              }), [
              context.library,
              context.account
            ]);
}

function useProviderOrSignerExn(param) {
  return Belt_Option.getExn(useProviderOrSigner(undefined));
}

function useSigner(param) {
  var match = useProviderOrSigner(undefined);
  if (match !== undefined && match.TAG !== /* Provider */0) {
    return match._0;
  }
  
}

function useSignerExn(param) {
  return Belt_Option.getExn(useSigner(undefined));
}

function useContractFunction(signer) {
  var match = React.useState(function () {
        return /* UnInitialised */0;
      });
  var setTxState = match[1];
  return [
          (function (makeContractInstance, contractFunction) {
              Curry._1(setTxState, (function (param) {
                      return /* Created */1;
                    }));
              var contractInstance = Curry._1(makeContractInstance, {
                    TAG: 1,
                    _0: signer,
                    [Symbol.for("name")]: "Signer"
                  });
              var mintPromise = Curry._1(contractFunction, contractInstance);
              JsPromise.$$catch(mintPromise, (function (error) {
                      return Curry._1(setTxState, (function (param) {
                                    var msg = error.message;
                                    return {
                                            TAG: 1,
                                            _0: msg !== undefined ? ": " + msg : "unknown error",
                                            [Symbol.for("name")]: "Declined"
                                          };
                                  }));
                    }));
              JsPromise.$$catch(mintPromise.then(function (tx) {
                          Curry._1(setTxState, (function (param) {
                                  return {
                                          TAG: 0,
                                          _0: tx.hash,
                                          [Symbol.for("name")]: "SignedAndSubmitted"
                                        };
                                }));
                          return tx.wait();
                        }).then(function (txOutcome) {
                        return Curry._1(setTxState, (function (param) {
                                      return {
                                              TAG: 2,
                                              _0: txOutcome,
                                              [Symbol.for("name")]: "Complete"
                                            };
                                    }));
                      }), (function (error) {
                      var err = Caml_js_exceptions.caml_as_js_exn(error);
                      var txHash;
                      if (err !== undefined) {
                        var exceptionMessage = Belt_Option.getWithDefault(Caml_option.valFromOption(err).message, "");
                        var txHashRegex = /transactionHash="(.{66})/;
                        var txHashOpt = txHashRegex.exec(exceptionMessage);
                        var txHashNullable = txHashOpt !== null ? Belt_Option.getWithDefault(Belt_Array.get(txHashOpt, 1), "") : "";
                        txHash = (txHashNullable == null) ? "" : txHashNullable;
                      } else {
                        txHash = "";
                      }
                      Curry._1(setTxState, (function (param) {
                              return {
                                      TAG: 3,
                                      _0: txHash,
                                      [Symbol.for("name")]: "Failed"
                                    };
                            }));
                      return Promise.resolve((console.log(error), undefined));
                    }));
              
            }),
          match[0],
          setTxState
        ];
}

export {
  getProviderOrSigner ,
  getSigner ,
  useProviderOrSigner ,
  useProviderOrSignerExn ,
  useSigner ,
  useSignerExn ,
  useContractFunction ,
  
}
/* react Not a pure module */
