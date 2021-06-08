// Generated by ReScript, PLEASE EDIT WITH CARE
'use strict';

var React = require("react");
var Loader = require("../components/UI/Base/Loader.js");
var Markets = require("./Markets.js");
var StartTrading = require("../components/UI/StartTrading.js");

function Home$Home(Props) {
  var match = StartTrading.StartTradingStorage.useStartTradingStorage(undefined);
  var clickedTrading = React.useContext(StartTrading.ClickedTradingProvider.ClickedTradingContext.context);
  if (match[2]) {
    if (match[0] || match[1] || clickedTrading) {
      return React.createElement(Markets.make, {});
    } else {
      return React.createElement(StartTrading.make, {});
    }
  } else {
    return React.createElement(Loader.make, {});
  }
}

var Home = {
  make: Home$Home
};

function $$default(param) {
  return React.createElement(Home$Home, {});
}

exports.Home = Home;
exports.$$default = $$default;
exports.default = $$default;
exports.__esModule = true;
/* react Not a pure module */
