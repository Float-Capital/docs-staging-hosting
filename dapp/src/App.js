// Generated by ReScript, PLEASE EDIT WITH CARE
'use strict';

var Toast = require("./components/UI/Base/Toast.js");
var React = require("react");
var Client = require("./data/Client.js");
var MainLayout = require("./layouts/MainLayout.js");
var APYProvider = require("./libraries/APYProvider.js");
var Router = require("next/router");
var RootProvider = require("./libraries/RootProvider.js");
var StartTrading = require("./components/UI/StartTrading.js");
var ToastProvider = require("./components/UI/ToastProvider.js");
var InjectedEthereum = require("./ethereum/InjectedEthereum.js");
var StateChangeMonitor = require("./libraries/StateChangeMonitor.js");

var PageComponent = {};

function $$default(props) {
  Router.useRouter();
  var content = React.createElement(props.Component, props.pageProps);
  InjectedEthereum.useReloadOnMetamaskChainChanged(undefined);
  return React.createElement(ToastProvider.make, {
              children: React.createElement(RootProvider.make, {
                    children: React.createElement(StartTrading.ClickedTradingProvider.make, {
                          children: null
                        }, React.createElement(Client.make, {
                              children: React.createElement(APYProvider.make, {
                                    children: React.createElement(StateChangeMonitor.make, {
                                          children: React.createElement(MainLayout.make, {
                                                children: content
                                              })
                                        })
                                  })
                            }), React.createElement(Toast.make, {}))
                  })
            });
}

exports.PageComponent = PageComponent;
exports.$$default = $$default;
exports.default = $$default;
exports.__esModule = true;
/* Toast Not a pure module */
