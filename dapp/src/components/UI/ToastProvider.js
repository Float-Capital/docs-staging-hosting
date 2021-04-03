// Generated by ReScript, PLEASE EDIT WITH CARE

import * as React from "react";

var context = React.createContext("");

var provider = context.Provider;

function ToastProvider$ToastContext$Provider(Props) {
  var value = Props.value;
  var children = Props.children;
  return React.createElement(provider, {
              value: value,
              children: children
            });
}

var Provider = {
  provider: provider,
  make: ToastProvider$ToastContext$Provider
};

var ToastContext = {
  context: context,
  Provider: Provider
};

var context$1 = React.createContext(function (_action) {
      
    });

var provider$1 = context$1.Provider;

function ToastProvider$DispatchToastContext$Provider(Props) {
  var value = Props.value;
  var children = Props.children;
  return React.createElement(provider$1, {
              value: value,
              children: children
            });
}

var Provider$1 = {
  provider: provider$1,
  make: ToastProvider$DispatchToastContext$Provider
};

var DispatchToastContext = {
  context: context$1,
  Provider: Provider$1
};

function ToastProvider(Props) {
  var children = Props.children;
  var match = React.useReducer((function (_state, action) {
          if (action) {
            return action._0;
          } else {
            return "";
          }
        }), "");
  return React.createElement(ToastProvider$ToastContext$Provider, {
              value: match[0],
              children: React.createElement(ToastProvider$DispatchToastContext$Provider, {
                    value: match[1],
                    children: React.createElement("div", undefined, children)
                  })
            });
}

var make = ToastProvider;

export {
  ToastContext ,
  DispatchToastContext ,
  make ,
  
}
/* context Not a pure module */
