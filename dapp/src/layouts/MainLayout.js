// Generated by ReScript, PLEASE EDIT WITH CARE

import * as Lost from "../components/UI/Lost.js";
import * as React from "react";
import * as Config from "../Config.js";
import * as Navigation from "./Navigation.js";
import * as RootProvider from "../libraries/RootProvider.js";
import * as AddBinanceToMetamask from "../components/UI/AddBinanceToMetamask.js";

function MainLayout(Props) {
  var children = Props.children;
  var chainId = RootProvider.useChainId(undefined);
  return React.createElement("div", {
              className: "flex lg:justify-center min-h-screen"
            }, React.createElement("div", {
                  className: "max-w-5xl w-full text-gray-900 font-base"
                }, React.createElement("div", {
                      className: "flex flex-col h-screen"
                    }, React.createElement(Navigation.make, {}), React.createElement("div", {
                          className: "m-auto w-full"
                        }, chainId !== undefined && chainId !== Config.defaultNetworkId ? React.createElement(React.Fragment, undefined, React.createElement("h2", undefined, "You are currently connected to the wrong network."), React.createElement("h4", {
                                    className: "text-lg"
                                  }, "Please connect to " + Config.defaultNetworkName + "."), React.createElement(AddBinanceToMetamask.make, {})) : children))), React.createElement(Lost.make, {}));
}

var make = MainLayout;

export {
  make ,
  
}
/* Lost Not a pure module */
