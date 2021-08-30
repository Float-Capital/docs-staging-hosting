// Generated by ReScript, PLEASE EDIT WITH CARE
'use strict';

var Curry = require("rescript/lib/js/curry.js");
var React = require("react");
var Config = require("../config/Config.js");
var Js_dict = require("rescript/lib/js/js_dict.js");
var Metamask = require("../components/UI/Base/Metamask.js");
var Belt_Array = require("rescript/lib/js/belt_Array.js");
var Belt_Option = require("rescript/lib/js/belt_Option.js");
var Belt_SetInt = require("rescript/lib/js/belt_SetInt.js");
var Caml_option = require("rescript/lib/js/caml_option.js");
var Router = require("next/router");
var RootProvider = require("../libraries/RootProvider.js");
var Web3Connectors = require("../bindings/web3-react/Web3Connectors.js");
var InjectedEthereum = require("../ethereum/InjectedEthereum.js");
var Caml_js_exceptions = require("rescript/lib/js/caml_js_exceptions.js");
var WalletconnectConnector = require("@web3-react/walletconnect-connector");

var connectors = [
  {
    name: "MetaMask",
    connector: Web3Connectors.injected,
    img: "/img/wallet-icons/metamask.svg",
    connectionPhrase: "Connect via MetaMask"
  },
  {
    name: "WalletConnect",
    connector: new WalletconnectConnector.WalletConnectConnector({
          rpc: Js_dict.fromArray([[
                  String(Config.networkId),
                  Config.rpcEndopint
                ]]),
          bridge: "https://bridge.walletconnect.org",
          qrcode: true,
          pollingInterval: Config.web3PollingInterval
        }),
    img: "/img/wallet-icons/walletConnect.svg",
    connectionPhrase: "Connect via WalletConnect"
  }
];

var metamaskDefaultChainIds = Belt_SetInt.fromArray([
      1,
      3,
      4,
      5,
      42,
      1337
    ]);

function metamaskDefaultChainIdsToMetamaskName(chainId) {
  if (chainId === 42) {
    return "Kovan Test Network";
  }
  if (chainId >= 6) {
    if (chainId !== 1337) {
      return "Ethereum Mainnet";
    } else {
      return "Local Network";
    }
  }
  if (chainId < 3) {
    return "Ethereum Mainnet";
  }
  switch (chainId) {
    case 3 :
        return "Ropsten Test Network";
    case 4 :
        return "Rinkeby Test Network";
    case 5 :
        return "Goerli Test Network";
    
  }
}

function instructionForDropdown(metamaskChainId) {
  if (metamaskChainId !== undefined) {
    if (Belt_SetInt.has(metamaskDefaultChainIds, metamaskChainId)) {
      return "Click on the " + metamaskDefaultChainIdsToMetamaskName(metamaskChainId) + " dropdown";
    } else {
      return "Click on the dropdown for the network you're connected to.";
    }
  } else {
    return "Click on the dropdown for the network you're connected to.";
  }
}

function addNetworkInstructions(param) {
  return React.createElement(React.Fragment, undefined, "Enter the following information:", React.createElement("br", undefined), React.createElement("div", {
                  className: "pl-8"
                }, "Network name - " + Config.networkName, React.createElement("br", undefined), "New RPC Url - " + Config.rpcEndopint, React.createElement("br", undefined), "Chain Id - " + String(Config.networkId), React.createElement("br", undefined), "Currency Symbol - " + Config.networkCurrencySymbol, React.createElement("br", undefined), "Block Explorer URL - " + Config.blockExplorer));
}

function Login(Props) {
  var match = RootProvider.useActivateConnector(undefined);
  var activateConnector = match[1];
  var router = Router.useRouter();
  var nextPath = Js_dict.get(router.query, "nextPath");
  var optCurrentUser = RootProvider.useCurrentUser(undefined);
  var isMetamask = InjectedEthereum.useIsMetamask(undefined);
  var metamaskChainId = InjectedEthereum.useMetamaskChainId(undefined);
  var match$1 = React.useState(function () {
        return false;
      });
  var setMetamaskDoesntSupportSwitchNetworks = match$1[1];
  var onFailureToSwitchNetworksCallback = function (error) {
    var err = Caml_js_exceptions.caml_as_js_exn(error);
    var errorMessage = err !== undefined ? Belt_Option.mapWithDefault(Caml_option.valFromOption(err).message, "", (function (x) {
              return x;
            })) : "";
    if (errorMessage.includes("The method 'wallet_addEthereumChain' does not exist")) {
      return Curry._1(setMetamaskDoesntSupportSwitchNetworks, (function (param) {
                    return true;
                  }));
    }
    
  };
  React.useEffect((function () {
          if (nextPath !== undefined && optCurrentUser !== undefined) {
            router.push(nextPath);
          }
          
        }), [
        nextPath,
        optCurrentUser
      ]);
  if (!isMetamask || Belt_Option.getWithDefault(metamaskChainId, -1) === Config.networkId) {
    return React.createElement("div", {
                className: "max-w-5xl w-full mx-auto"
              }, React.createElement("p", {
                    className: "mx-2 md:mx-0"
                  }, "Connect with one of the wallets below. "), isMetamask ? null : React.createElement("p", {
                      className: "text-xs"
                    }, "Please make sure to connect to " + Config.networkName + "."), React.createElement("div", {
                    className: "grid grid-cols-1 md:grid-cols-2 gap-4 items-center my-5"
                  }, Belt_Array.mapWithIndex(connectors, (function (index, connector) {
                          return React.createElement("div", {
                                      key: String(index),
                                      className: "mx-2 md:mx-0 p-5 flex flex-col items-center justify-center bg-white bg-opacity-75 hover:bg-gray-200 active:bg-gray-300 rounded ",
                                      onClick: (function (e) {
                                          e.stopPropagation();
                                          return Curry._1(activateConnector, connector.connector);
                                        })
                                    }, React.createElement("div", {
                                          className: "w-10 h-10"
                                        }, React.createElement("img", {
                                              className: "w-full h-full",
                                              alt: connector.name,
                                              src: connector.img
                                            })), React.createElement("div", {
                                          className: "text-xl font-bold my-1"
                                        }, connector.name), React.createElement("div", {
                                          className: "text-base my-1 text-gray-400\t"
                                        }, connector.connectionPhrase));
                        }))));
  } else {
    return React.createElement("div", {
                className: "mx-auto flex justify-center"
              }, React.createElement("div", {
                    className: "flex flex-col max-w-3xl bg-opacity-75 bg-white rounded-lg p-10"
                  }, React.createElement("div", undefined, React.createElement("p", {
                            className: "text-lg text-bf mb-8"
                          }, "To use ", React.createElement("span", {
                                className: "font-alphbeta text-xl pr-1"
                              }, "FLOAT"), ", please connect to the " + Config.networkName), Belt_SetInt.has(metamaskDefaultChainIds, Config.networkId) ? React.createElement("div", undefined, React.createElement("ul", {
                                  className: "list-decimal pl-10"
                                }, React.createElement("li", {
                                      key: "instructions-1"
                                    }, "Open MetaMask"), React.createElement("li", {
                                      key: "instructions-2"
                                    }, instructionForDropdown(metamaskChainId)), React.createElement("li", {
                                      key: "instructions-3"
                                    }, "Select " + Config.networkName))) : (
                          match$1[0] ? React.createElement("div", {
                                  className: "flex flex-col justify-center"
                                }, React.createElement("p", {
                                      className: "mb-2 -mt-5"
                                    }, [
                                      "Unfortunately your version of",
                                      React.createElement("img", {
                                            className: "h-5 mx-1 inline",
                                            src: "/icons/metamask.svg"
                                          }),
                                      "doesn't support automatic switching of networks."
                                    ]), React.createElement("p", {
                                      className: "mb-2"
                                    }, "To connect you'll have to switch to " + Config.networkName + " manually."), "To add " + Config.networkName + " to metamask:", React.createElement("ul", {
                                      className: "list-disc pl-10"
                                    }, React.createElement("li", {
                                          key: "instructions-1"
                                        }, "Open Metamask."), React.createElement("li", {
                                          key: "instructions-2"
                                        }, instructionForDropdown(metamaskChainId)), React.createElement("li", {
                                          key: "instructions-3"
                                        }, "Select Custom RPC"), React.createElement("li", {
                                          key: "instructions-4"
                                        }, addNetworkInstructions(undefined)), React.createElement("li", {
                                          key: "instructions-5"
                                        }, "Save the new network"))) : React.createElement("div", {
                                  className: "flex justify-center"
                                }, React.createElement(Metamask.AddOrSwitchNetwork.make, {
                                      onFailureCallback: onFailureToSwitchNetworksCallback
                                    }))
                        ))));
  }
}

var make = Login;

var $$default = Login;

exports.connectors = connectors;
exports.metamaskDefaultChainIds = metamaskDefaultChainIds;
exports.metamaskDefaultChainIdsToMetamaskName = metamaskDefaultChainIdsToMetamaskName;
exports.instructionForDropdown = instructionForDropdown;
exports.addNetworkInstructions = addNetworkInstructions;
exports.make = make;
exports.$$default = $$default;
exports.default = $$default;
exports.__esModule = true;
/* connectors Not a pure module */
