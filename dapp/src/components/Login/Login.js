// Generated by ReScript, PLEASE EDIT WITH CARE

import * as Curry from "bs-platform/lib/es6/curry.js";
import * as React from "react";
import * as Config from "../../Config.js";
import * as Js_dict from "bs-platform/lib/es6/js_dict.js";
import * as Belt_Array from "bs-platform/lib/es6/belt_Array.js";
import * as Router from "next/router";
import * as RootProvider from "../../libraries/RootProvider.js";
import * as Web3Connectors from "../../bindings/web3-react/Web3Connectors.js";
import * as TorusConnector from "@web3-react/torus-connector";
import * as WalletconnectConnector from "@web3-react/walletconnect-connector";

var connectors = [
  {
    name: "MetaMask",
    connector: Web3Connectors.injected,
    img: "/img/wallet-icons/metamask.svg",
    connectionPhrase: "Connect to your MetaMask Wallet"
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
  },
  {
    name: "Torus",
    connector: new TorusConnector.TorusConnector({
          chainId: 1
        }),
    img: "/img/wallet-icons/torus.svg",
    connectionPhrase: "Connect via Torus"
  }
];

function Login(Props) {
  var match = RootProvider.useActivateConnector(undefined);
  var activateConnector = match[1];
  var router = Router.useRouter();
  var nextPath = Js_dict.get(router.query, "nextPath");
  var optCurrentUser = RootProvider.useCurrentUser(undefined);
  React.useEffect((function () {
          if (nextPath !== undefined && optCurrentUser !== undefined) {
            router.push(nextPath);
          }
          
        }), [
        nextPath,
        optCurrentUser
      ]);
  return React.createElement("div", undefined, React.createElement("p", {
                  className: "mx-2 md:mx-0"
                }, "Connect with one of the wallets below. "), React.createElement("p", {
                  className: "text-xs"
                }, "Please make sure to connect to " + Config.networkName + "."), React.createElement("div", {
                  className: "grid grid-cols-1 md:grid-cols-3 gap-4 items-center my-5"
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
}

var make = Login;

var $$default = Login;

export {
  connectors ,
  make ,
  $$default ,
  $$default as default,
  
}
/* connectors Not a pure module */
