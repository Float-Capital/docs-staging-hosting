// Generated by ReScript, PLEASE EDIT WITH CARE
'use strict';

var Lost = require("../components/UI/Lost.js");
var React = require("react");
var Config = require("../config/Config.js");
var ComingSoon = require("../components/ComingSoon.js");
var Navigation = require("./Navigation.js");
var RootProvider = require("../libraries/RootProvider.js");

function MainLayout(Props) {
  var children = Props.children;
  var chainId = RootProvider.useChainId(undefined);
  return React.createElement("div", {
              className: "flex lg:justify-center min-h-screen"
            }, React.createElement("div", {
                  className: "w-full text-gray-900 font-base"
                }, React.createElement("div", {
                      className: "flex flex-col h-screen"
                    }, React.createElement(ComingSoon.make, {}), React.createElement(Navigation.make, {}), React.createElement("div", {
                          className: "m-auto w-full"
                        }, chainId !== undefined && chainId !== Config.networkId ? React.createElement(React.Fragment, undefined, React.createElement("h2", undefined, "You are currently connected to the wrong network."), React.createElement("h4", {
                                    className: "text-lg"
                                  }, "Please connect to " + Config.networkName + ".")) : children))), React.createElement(Lost.make, {}));
}

var make = MainLayout;

exports.make = make;
/* Lost Not a pure module */
