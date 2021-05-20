// Generated by ReScript, PLEASE EDIT WITH CARE
'use strict';

var Tick = require("../components/UI/Base/Tick.js");
var Curry = require("rescript/lib/js/curry.js");
var Login = require("./Login.js");
var Modal = require("../components/UI/Base/Modal.js");
var React = require("react");
var Button = require("../components/UI/Base/Button.js");
var Config = require("../config/Config.js");
var Loader = require("../components/UI/Base/Loader.js");
var Metamask = require("../components/UI/Base/Metamask.js");
var CONSTANTS = require("../CONSTANTS.js");
var Contracts = require("../ethereum/Contracts.js");
var ToastProvider = require("../components/UI/ToastProvider.js");
var ContractActions = require("../ethereum/ContractActions.js");
var MessageUsOnDiscord = require("../components/Ethereum/MessageUsOnDiscord.js");
var ViewOnBlockExplorer = require("../components/Ethereum/ViewOnBlockExplorer.js");

function AaveDaiFaucet$FaucetTxStatusModal(Props) {
  var txState = Props.txState;
  if (typeof txState === "number") {
    if (txState === /* UnInitialised */0) {
      return null;
    } else {
      return React.createElement(Modal.make, {
                  id: 1,
                  children: React.createElement("div", {
                        className: "text-center m-3"
                      }, React.createElement(Loader.Ellipses.make, {}), React.createElement("h1", undefined, "Confirm the transaction to mint testnet DAI"))
                });
    }
  }
  switch (txState.TAG | 0) {
    case /* SignedAndSubmitted */0 :
        return React.createElement(Modal.make, {
                    id: 2,
                    children: React.createElement("div", {
                          className: "text-center m-3"
                        }, React.createElement("div", {
                              className: "m-2"
                            }, React.createElement(Loader.Mini.make, {})), React.createElement("p", undefined, "Minting testnet DAI transaction pending... "), React.createElement(ViewOnBlockExplorer.make, {
                              txHash: txState._0
                            }))
                  });
    case /* Declined */1 :
        return React.createElement(Modal.make, {
                    id: 4,
                    children: React.createElement("div", {
                          className: "text-center m-3"
                        }, React.createElement("p", undefined, "The transaction was rejected by your wallet"), React.createElement(MessageUsOnDiscord.make, {}))
                  });
    case /* Complete */2 :
        return React.createElement(Modal.make, {
                    id: 3,
                    children: null
                  }, React.createElement("div", {
                        className: "text-center m-3"
                      }, React.createElement(Tick.make, {}), React.createElement("p", undefined, "Transaction complete 🎉")), React.createElement(Metamask.AddTokenButton.make, {
                        token: Config.config.contracts.Dai,
                        tokenSymbol: "DAI"
                      }));
    case /* Failed */3 :
        return React.createElement(Modal.make, {
                    id: 5,
                    children: React.createElement("div", {
                          className: "text-center m-3"
                        }, React.createElement("h1", undefined, "The transaction failed."), React.createElement(ViewOnBlockExplorer.make, {
                              txHash: txState._0
                            }), React.createElement(MessageUsOnDiscord.make, {}))
                  });
    
  }
}

var FaucetTxStatusModal = {
  make: AaveDaiFaucet$FaucetTxStatusModal
};

function AaveDaiFaucet$FaucetCard(Props) {
  var signer = Props.signer;
  var match = ContractActions.useContractFunction(signer);
  var txState = match[1];
  var contractExecutionHandler = match[0];
  var toastDispatch = React.useContext(ToastProvider.DispatchToastContext.context);
  React.useEffect((function () {
          if (typeof txState === "number") {
            if (txState !== /* UnInitialised */0) {
              Curry._1(toastDispatch, {
                    _0: "Confirm mint testnet DAI transaction in your wallet",
                    _1: "",
                    _2: /* Info */2,
                    [Symbol.for("name")]: "Show"
                  });
            }
            
          } else {
            switch (txState.TAG | 0) {
              case /* SignedAndSubmitted */0 :
                  Curry._1(toastDispatch, {
                        _0: "Minting testnet DAI transaction pending",
                        _1: "",
                        _2: /* Info */2,
                        [Symbol.for("name")]: "Show"
                      });
                  break;
              case /* Declined */1 :
                  Curry._1(toastDispatch, {
                        _0: "The transaction was rejected by your wallet",
                        _1: txState._0,
                        _2: /* Error */0,
                        [Symbol.for("name")]: "Show"
                      });
                  break;
              case /* Complete */2 :
                  Curry._1(toastDispatch, {
                        _0: "Mint testnet DAI transaction confirmed 🎉",
                        _1: "",
                        _2: /* Success */3,
                        [Symbol.for("name")]: "Show"
                      });
                  break;
              case /* Failed */3 :
                  Curry._1(toastDispatch, {
                        _0: "The transaction failed",
                        _1: "",
                        _2: /* Error */0,
                        [Symbol.for("name")]: "Show"
                      });
                  break;
              
            }
          }
          
        }), [txState]);
  return React.createElement("section", {
              className: "max-w-2xl mx-auto p-5  flex-col items-center justify-between bg-white bg-opacity-75 rounded-lg shadow-lg"
            }, React.createElement("div", {
                  className: "text-center p-6 pt-0"
                }, React.createElement("h1", {
                      className: "text-lg p-2"
                    }, "Mumbai testnet DAI faucet"), React.createElement("p", {
                      className: "text-xxs"
                    }, "In order to mint testnet DAI you will need testnet ", React.createElement("a", {
                          className: "hover:bg-white underline",
                          href: "https://faucet.matic.network/",
                          rel: "noopener noreferrer",
                          target: "_blank"
                        }, "Matic token, get some from their faucet"))), React.createElement("div", {
                  className: "mx-auto max-w-sm"
                }, React.createElement(Button.make, {
                      onClick: (function (param) {
                          return Curry._2(contractExecutionHandler, (function (param) {
                                        return Contracts.Erc20.make(Config.dai, param);
                                      }), (function (param) {
                                        return param.mint(CONSTANTS.oneThousandInWei);
                                      }));
                        }),
                      children: "Mint testnet dai"
                    })), React.createElement(AaveDaiFaucet$FaucetTxStatusModal, {
                  txState: txState
                }));
}

var FaucetCard = {
  make: AaveDaiFaucet$FaucetCard
};

function AaveDaiFaucet(Props) {
  var optSigner = ContractActions.useSigner(undefined);
  if (optSigner !== undefined) {
    return React.createElement(AaveDaiFaucet$FaucetCard, {
                signer: optSigner
              });
  } else {
    return React.createElement(Login.make, {});
  }
}

var make = AaveDaiFaucet;

var $$default = AaveDaiFaucet;

exports.FaucetTxStatusModal = FaucetTxStatusModal;
exports.FaucetCard = FaucetCard;
exports.make = make;
exports.$$default = $$default;
exports.default = $$default;
exports.__esModule = true;
/* Tick Not a pure module */
