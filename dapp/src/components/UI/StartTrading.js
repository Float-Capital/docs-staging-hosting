// Generated by ReScript, PLEASE EDIT WITH CARE
'use strict';

var Curry = require("rescript/lib/js/curry.js");
var React = require("react");
var Belt_Int = require("rescript/lib/js/belt_Int.js");
var Belt_Option = require("rescript/lib/js/belt_Option.js");

function useStartTradingStorage(param) {
  var match = React.useState(function () {
        return false;
      });
  var setHasVisitedEnoughTimes = match[1];
  var match$1 = React.useState(function () {
        return false;
      });
  var setIsPartOfActiveSession = match$1[1];
  var match$2 = React.useState(function () {
        return /* Rendering */0;
      });
  var setState = match$2[1];
  React.useEffect((function () {
          var key = "numberOfVisits";
          var localStorage$1 = localStorage;
          var optNumberOfVisits = localStorage$1.getItem(key);
          var numberOfVisits = optNumberOfVisits !== null ? Belt_Option.getWithDefault(Belt_Int.fromString(optNumberOfVisits), 0) + 1 | 0 : 0;
          Curry._1(setHasVisitedEnoughTimes, (function (param) {
                  return numberOfVisits >= 6;
                }));
          localStorage$1.setItem(key, String(numberOfVisits));
          var key$1 = "isActiveSession";
          var sessionStorage$1 = sessionStorage;
          var optIsActiveSession = sessionStorage$1.getItem(key$1);
          if (optIsActiveSession !== null) {
            Curry._1(setIsPartOfActiveSession, (function (param) {
                    return optIsActiveSession === "true";
                  }));
          } else {
            sessionStorage$1.setItem(key$1, "true");
          }
          Curry._1(setState, (function (param) {
                  return /* Rendered */1;
                }));
          
        }), []);
  return [
          match[0],
          match$1[0],
          match$2[0]
        ];
}

var StartTradingStorage = {
  useStartTradingStorage: useStartTradingStorage
};

var context = React.createContext(false);

var provider = context.Provider;

function StartTrading$ClickedTradingProvider$ClickedTradingContext$Provider(Props) {
  var value = Props.value;
  var children = Props.children;
  return React.createElement(provider, {
              value: value,
              children: children
            });
}

var Provider = {
  provider: provider,
  make: StartTrading$ClickedTradingProvider$ClickedTradingContext$Provider
};

var ClickedTradingContext = {
  context: context,
  Provider: Provider
};

var context$1 = React.createContext(function (_action) {
      
    });

var provider$1 = context$1.Provider;

function StartTrading$ClickedTradingProvider$DispatchClickedTradingContext$Provider(Props) {
  var value = Props.value;
  var children = Props.children;
  return React.createElement(provider$1, {
              value: value,
              children: children
            });
}

var Provider$1 = {
  provider: provider$1,
  make: StartTrading$ClickedTradingProvider$DispatchClickedTradingContext$Provider
};

var DispatchClickedTradingContext = {
  context: context$1,
  Provider: Provider$1
};

function StartTrading$ClickedTradingProvider(Props) {
  var children = Props.children;
  var match = React.useReducer((function (_state, action) {
          if (action) {
            return false;
          } else {
            return true;
          }
        }), false);
  return React.createElement(StartTrading$ClickedTradingProvider$ClickedTradingContext$Provider, {
              value: match[0],
              children: React.createElement(StartTrading$ClickedTradingProvider$DispatchClickedTradingContext$Provider, {
                    value: match[1],
                    children: children
                  })
            });
}

var ClickedTradingProvider = {
  ClickedTradingContext: ClickedTradingContext,
  DispatchClickedTradingContext: DispatchClickedTradingContext,
  make: StartTrading$ClickedTradingProvider
};

function StartTrading(Props) {
  var clickedTradingDispatch = React.useContext(context$1);
  return React.createElement("div", {
              className: "floating w-full"
            }, React.createElement("div", {
                  onClick: (function (param) {
                      return Curry._1(clickedTradingDispatch, /* Clicked */0);
                    })
                }, React.createElement("span", {
                      className: "cursor-pointer hover:opacity-70 w-full flex justify-center"
                    }, React.createElement("img", {
                          className: "p-4",
                          alt: "start-trading",
                          src: "/img/start-trading.png"
                        }))));
}

var make = StartTrading;

exports.StartTradingStorage = StartTradingStorage;
exports.ClickedTradingProvider = ClickedTradingProvider;
exports.make = make;
/* context Not a pure module */
