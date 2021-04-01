// Generated by ReScript, PLEASE EDIT WITH CARE

import * as Curry from "bs-platform/lib/es6/curry.js";
import * as React from "react";
import * as Future from "rescript-future/src/Future.js";
import * as Js_dict from "bs-platform/lib/es6/js_dict.js";
import * as $$Request from "rescript-request/src/Request.js";
import * as Caml_option from "bs-platform/lib/es6/caml_option.js";

var context = React.createContext({
      apy: /* Loading */0,
      shouldFetchData: false,
      setShouldFetchData: (function (param) {
          
        })
    });

var provider = context.Provider;

function APYProvider$APYProviderContext$Provider(Props) {
  var value = Props.value;
  var children = Props.children;
  return React.createElement(provider, {
              value: value,
              children: children
            });
}

var Provider = {
  provider: provider,
  make: APYProvider$APYProviderContext$Provider
};

var APYProviderContext = {
  context: context,
  Provider: Provider
};

function APYProvider$GenericAPYProvider(Props) {
  var apyDeterminer = Props.apyDeterminer;
  var children = Props.children;
  var match = React.useState(function () {
        return /* Loading */0;
      });
  var setApy = match[1];
  var apy = match[0];
  var match$1 = React.useState(function () {
        return false;
      });
  React.useEffect((function () {
          Curry._1(apyDeterminer, setApy);
          
        }), [
        match$1[0],
        apy,
        apyDeterminer
      ]);
  return React.createElement(APYProvider$APYProviderContext$Provider, {
              value: {
                apy: apy,
                shouldFetchData: false,
                setShouldFetchData: match$1[1]
              },
              children: children
            });
}

var GenericAPYProvider = {
  make: APYProvider$GenericAPYProvider
};

function determineVenusApy(param) {
  Future.get($$Request.make("http://api.venus.io/api/vtoken?addresses=0x2ff3d0f6990a40261c66e1ff2017acbc282eb6d0", undefined, /* Json */4, undefined, Caml_option.some(Js_dict.fromArray([[
                      "Content-type",
                      "application/json"
                    ]])), undefined, undefined, undefined, undefined, undefined), (function (response) {
          if (response.TAG === /* Ok */0) {
            var response$1 = response._0.response;
            if (response$1 !== undefined) {
              console.log(Caml_option.valFromOption(response$1));
            } else {
              console.log("Couldn't fetch Venus APY.");
            }
            return ;
          }
          console.log("Couldn't fetch Venus APY. Reason:");
          console.log(response._0);
          
        }));
  
}

function APYProvider(Props) {
  var children = Props.children;
  return React.createElement(APYProvider$GenericAPYProvider, {
              apyDeterminer: determineVenusApy,
              children: children
            });
}

function useAPY(param) {
  var match = React.useContext(context);
  if (!match.shouldFetchData) {
    Curry._1(match.setShouldFetchData, (function (param) {
            return true;
          }));
  }
  return match.apy;
}

var vUnderlyingAssetAddress = "0x95c78222b3d6e262426483d42cfa53685a67ab9d";

var make = APYProvider;

export {
  vUnderlyingAssetAddress ,
  APYProviderContext ,
  GenericAPYProvider ,
  determineVenusApy ,
  make ,
  useAPY ,
  
}
/* context Not a pure module */
