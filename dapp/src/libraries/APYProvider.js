// Generated by ReScript, PLEASE EDIT WITH CARE
'use strict';

var Curry = require("rescript/lib/js/curry.js");
var Decco = require("decco/src/Decco.js");
var React = require("react");
var Ethers = require("../ethereum/Ethers.js");
var Future = require("rescript-future/src/Future.js");
var Ethers$1 = require("ethers");
var Js_dict = require("rescript/lib/js/js_dict.js");
var Js_json = require("rescript/lib/js/js_json.js");
var $$Request = require("rescript-request/src/Request.js");
var CONSTANTS = require("../CONSTANTS.js");
var Belt_Array = require("rescript/lib/js/belt_Array.js");
var Belt_Float = require("rescript/lib/js/belt_Float.js");
var Belt_Option = require("rescript/lib/js/belt_Option.js");
var Caml_option = require("rescript/lib/js/caml_option.js");

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
  var shouldFetchData = match$1[0];
  React.useEffect((function () {
          if (apy === /* Loading */0 && shouldFetchData) {
            Curry._1(apyDeterminer, setApy);
          }
          
        }), [
        shouldFetchData,
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

function i_list_decode(v) {
  var dict = Js_json.classify(v);
  if (typeof dict === "number") {
    return Decco.error(undefined, "Not an object", v);
  }
  if (dict.TAG !== /* JSONObject */2) {
    return Decco.error(undefined, "Not an object", v);
  }
  var liquidityRate = Decco.stringFromJson(Belt_Option.getWithDefault(Js_dict.get(dict._0, "liquidityRate"), null));
  if (liquidityRate.TAG === /* Ok */0) {
    return {
            TAG: 0,
            _0: {
              liquidityRate: liquidityRate._0
            },
            [Symbol.for("name")]: "Ok"
          };
  }
  var e = liquidityRate._0;
  return {
          TAG: 1,
          _0: {
            path: ".liquidityRate" + e.path,
            message: e.message,
            value: e.value
          },
          [Symbol.for("name")]: "Error"
        };
}

function inner_decode(v) {
  var dict = Js_json.classify(v);
  if (typeof dict === "number") {
    return Decco.error(undefined, "Not an object", v);
  }
  if (dict.TAG !== /* JSONObject */2) {
    return Decco.error(undefined, "Not an object", v);
  }
  var reserves = Decco.arrayFromJson(i_list_decode, Belt_Option.getWithDefault(Js_dict.get(dict._0, "reserves"), null));
  if (reserves.TAG === /* Ok */0) {
    return {
            TAG: 0,
            _0: {
              reserves: reserves._0
            },
            [Symbol.for("name")]: "Ok"
          };
  }
  var e = reserves._0;
  return {
          TAG: 1,
          _0: {
            path: ".reserves" + e.path,
            message: e.message,
            value: e.value
          },
          [Symbol.for("name")]: "Error"
        };
}

function t_decode(v) {
  var dict = Js_json.classify(v);
  if (typeof dict === "number") {
    return Decco.error(undefined, "Not an object", v);
  }
  if (dict.TAG !== /* JSONObject */2) {
    return Decco.error(undefined, "Not an object", v);
  }
  var data = inner_decode(Belt_Option.getWithDefault(Js_dict.get(dict._0, "data"), null));
  if (data.TAG === /* Ok */0) {
    return {
            TAG: 0,
            _0: {
              data: data._0
            },
            [Symbol.for("name")]: "Ok"
          };
  }
  var e = data._0;
  return {
          TAG: 1,
          _0: {
            path: ".data" + e.path,
            message: e.message,
            value: e.value
          },
          [Symbol.for("name")]: "Error"
        };
}

var AaveAPYResponse = {
  i_list_decode: i_list_decode,
  inner_decode: inner_decode,
  t_decode: t_decode
};

function determineAaveApy(setApy) {
  var logError = function (reasonOpt, param) {
    var reason = reasonOpt !== undefined ? Caml_option.valFromOption(reasonOpt) : undefined;
    if (reason !== undefined) {
      console.log("Couldn't fetch AAVE Dai APY. Reason:");
      console.log(Caml_option.valFromOption(reason));
    } else {
      console.log("Couldn't fetch AAVE Dai APY for unknown reason.");
    }
    
  };
  Future.get($$Request.make("https://api.thegraph.com/subgraphs/name/aave/aave-v2-matic", "POST", /* Json */4, "{\"query\":\"{\\n  reserves(where:{symbol: \\\"DAI\\\"}){\\n    liquidityRate\\n  }\\n}\\n\",\"variables\":null}", Caml_option.some(Js_dict.fromArray([[
                      "Content-type",
                      "application/json"
                    ]])), undefined, undefined, undefined, undefined, undefined), (function (response) {
          if (response.TAG !== /* Ok */0) {
            return logError(Caml_option.some(response._0), undefined);
          }
          var response$1 = response._0.response;
          if (response$1 === undefined) {
            return logError(undefined, undefined);
          }
          var decoded = t_decode(Caml_option.valFromOption(response$1));
          if (decoded.TAG !== /* Ok */0) {
            return logError(Caml_option.some(decoded._0), undefined);
          }
          var inner = Belt_Array.get(decoded._0.data.reserves, 0);
          if (inner === undefined) {
            return logError(undefined, undefined);
          }
          var apy = Belt_Float.fromString(Ethers.Utils.formatEther(Ethers$1.BigNumber.from(inner.liquidityRate).div(CONSTANTS.tenToThe9)));
          return Curry._1(setApy, (function (param) {
                        return {
                                TAG: 0,
                                _0: apy,
                                [Symbol.for("name")]: "Loaded"
                              };
                      }));
        }));
  
}

function APYProvider(Props) {
  var children = Props.children;
  return React.createElement(APYProvider$GenericAPYProvider, {
              apyDeterminer: determineAaveApy,
              children: children
            });
}

function useAPY(param) {
  var match = React.useContext(context);
  var setShouldFetchData = match.setShouldFetchData;
  var shouldFetchData = match.shouldFetchData;
  React.useEffect((function () {
          if (!shouldFetchData) {
            Curry._1(setShouldFetchData, (function (param) {
                    return true;
                  }));
          }
          
        }), [
        shouldFetchData,
        setShouldFetchData
      ]);
  return match.apy;
}

var make = APYProvider;

exports.APYProviderContext = APYProviderContext;
exports.GenericAPYProvider = GenericAPYProvider;
exports.AaveAPYResponse = AaveAPYResponse;
exports.determineAaveApy = determineAaveApy;
exports.make = make;
exports.useAPY = useAPY;
/* context Not a pure module */
