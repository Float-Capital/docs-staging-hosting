// Generated by ReScript, PLEASE EDIT WITH CARE
'use strict';

var Misc = require("../../../libraries/Misc.js");
var Curry = require("rescript/lib/js/curry.js");
var React = require("react");
var Button = require("./Button.js");
var Config = require("../../../Config.js");
var Ethers = require("../../../ethereum/Ethers.js");
var Caml_option = require("rescript/lib/js/caml_option.js");
var InjectedEthereum = require("../../../ethereum/InjectedEthereum.js");

function Metamask$AddOrSwitchNetwork(Props) {
  var ethObj = window.ethereum;
  if (ethObj === undefined) {
    return null;
  }
  var ethObj$1 = Caml_option.valFromOption(ethObj);
  return React.createElement(Button.$$Element.make, {
              onClick: (function (_event) {
                  return Misc.onlyExecuteClientSide(function (param) {
                              ethObj$1.request({
                                    method: "wallet_addEthereumChain",
                                    params: [{
                                        chainId: InjectedEthereum.chainIdIntToHex(Config.networkId),
                                        chainName: Config.networkName,
                                        nativeCurrency: {
                                          name: Config.networkCurrencyName,
                                          symbol: Config.networkCurrencySymbol,
                                          decimals: 18
                                        },
                                        rpcUrls: [Config.rpcEndopint],
                                        blockExplorerUrls: [Config.blockExplorer]
                                      }]
                                  });
                              
                            });
                }),
              children: React.createElement("div", {
                    className: "mx-auto"
                  }, React.createElement("div", {
                        className: "flex flex-row items-center"
                      }, React.createElement("div", {
                            className: "text-sm"
                          }, "Switch metamask to " + Config.networkName), React.createElement("img", {
                            className: "h-6 ml-1",
                            src: "/icons/metamask.svg"
                          })))
            });
}

var AddOrSwitchNetwork = {
  make: Metamask$AddOrSwitchNetwork
};

function requestStructure(tokenAddress, tokenSymbol) {
  return {
          method: "wallet_watchAsset",
          params: {
            type: "ERC20",
            options: {
              address: tokenAddress,
              symbol: tokenSymbol.slice(0, 5),
              decimals: "18",
              image: undefined
            }
          }
        };
}

function Metamask$AddToken(Props) {
  var tokenAddress = Props.tokenAddress;
  var tokenSymbol = Props.tokenSymbol;
  var callbackOpt = Props.callback;
  var childrenOpt = Props.children;
  var callback = callbackOpt !== undefined ? callbackOpt : (function (param) {
        
      });
  var children = childrenOpt !== undefined ? Caml_option.valFromOption(childrenOpt) : React.createElement("img", {
          className: "h-5 ml-1",
          src: "/icons/metamask.svg"
        });
  var ethObj = window.ethereum;
  if (ethObj === undefined) {
    return null;
  }
  var ethObj$1 = Caml_option.valFromOption(ethObj);
  return React.createElement("div", {
              className: "flex justify-start align-center",
              onClick: (function (_event) {
                  return Misc.onlyExecuteClientSide(function (param) {
                              ethObj$1.request(requestStructure(tokenAddress, tokenSymbol));
                              return Curry._1(callback, undefined);
                            });
                })
            }, children);
}

var AddToken = {
  requestStructure: requestStructure,
  make: Metamask$AddToken
};

function Metamask$AddTokenButton(Props) {
  var token = Props.token;
  var tokenSymbol = Props.tokenSymbol;
  if (InjectedEthereum.isMetamask(undefined)) {
    return React.createElement(Metamask$AddToken, {
                tokenAddress: Ethers.Utils.ethAdrToStr(token),
                tokenSymbol: tokenSymbol,
                children: React.createElement("button", {
                      className: "w-44 h-12 text-sm shadow-md rounded-lg border-2 focus:outline-none border-gray-200 hover:bg-gray-200 flex justify-center items-center mx-auto"
                    }, React.createElement("div", {
                          className: "mx-2 flex flex-row"
                        }, React.createElement("div", undefined, "Add token to"), React.createElement("img", {
                              className: "h-5 ml-1",
                              src: "/icons/metamask.svg"
                            })))
              });
  } else {
    return null;
  }
}

var AddTokenButton = {
  make: Metamask$AddTokenButton
};

exports.AddOrSwitchNetwork = AddOrSwitchNetwork;
exports.AddToken = AddToken;
exports.AddTokenButton = AddTokenButton;
/* Misc Not a pure module */
