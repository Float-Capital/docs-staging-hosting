// Generated by ReScript, PLEASE EDIT WITH CARE

import * as Misc from "../libraries/Misc.js";
import * as View from "../libraries/View.js";
import * as Curry from "bs-platform/lib/es6/curry.js";
import * as React from "react";
import * as Button from "./UI/Button.js";
import * as Client from "../data/Client.js";
import * as Ethers from "../ethereum/Ethers.js";
import * as Recharts from "recharts";
import * as Belt_Array from "bs-platform/lib/es6/belt_Array.js";
import * as Belt_Float from "bs-platform/lib/es6/belt_Float.js";
import * as Belt_Option from "bs-platform/lib/es6/belt_Option.js";
import * as Caml_option from "bs-platform/lib/es6/caml_option.js";
import * as GqlConverters from "../libraries/GqlConverters.js";
import Format from "date-fns/format";
import * as BsRecharts__XAxis from "@ahrefs/bs-recharts/src/BsRecharts__XAxis.js";
import * as BsRecharts__YAxis from "@ahrefs/bs-recharts/src/BsRecharts__YAxis.js";
import * as BsRecharts__Tooltip from "@ahrefs/bs-recharts/src/BsRecharts__Tooltip.js";
import * as BsRecharts__ResponsiveContainer from "@ahrefs/bs-recharts/src/BsRecharts__ResponsiveContainer.js";
import * as ApolloClient__React_Hooks_UseQuery from "rescript-apollo-client/src/@apollo/client/react/hooks/ApolloClient__React_Hooks_UseQuery.js";

var ethAdrToLowerStr = Ethers.Utils.ethAdrToLowerStr;

var Raw = {};

var query = (require("@apollo/client").gql`
  query ($intervalId: String!, $numDataPoints: Int!)  {
    priceIntervalManager(id: $intervalId)  {
      __typename
      prices(first: $numDataPoints, orderBy: intervalIndex, orderDirection: desc)  {
        __typename
        startTimestamp
        endPrice
      }
    }
  }
`);

function parse(value) {
  var value$1 = value.priceIntervalManager;
  var tmp;
  if (value$1 == null) {
    tmp = undefined;
  } else {
    var value$2 = value$1.prices;
    tmp = {
      __typename: value$1.__typename,
      prices: value$2.map(function (value) {
            return {
                    __typename: value.__typename,
                    startTimestamp: GqlConverters.$$Date.parse(value.startTimestamp),
                    endPrice: GqlConverters.$$BigInt.parse(value.endPrice)
                  };
          })
    };
  }
  return {
          priceIntervalManager: tmp
        };
}

function serialize(value) {
  var value$1 = value.priceIntervalManager;
  var priceIntervalManager;
  if (value$1 !== undefined) {
    var value$2 = value$1.prices;
    var prices = value$2.map(function (value) {
          var value$1 = value.endPrice;
          var value$2 = GqlConverters.$$BigInt.serialize(value$1);
          var value$3 = value.startTimestamp;
          var value$4 = GqlConverters.$$Date.serialize(value$3);
          var value$5 = value.__typename;
          return {
                  __typename: value$5,
                  startTimestamp: value$4,
                  endPrice: value$2
                };
        });
    var value$3 = value$1.__typename;
    priceIntervalManager = {
      __typename: value$3,
      prices: prices
    };
  } else {
    priceIntervalManager = null;
  }
  return {
          priceIntervalManager: priceIntervalManager
        };
}

function serializeVariables(inp) {
  return {
          intervalId: inp.intervalId,
          numDataPoints: inp.numDataPoints
        };
}

function makeVariables(intervalId, numDataPoints, param) {
  return {
          intervalId: intervalId,
          numDataPoints: numDataPoints
        };
}

var PriceHistory_inner = {
  Raw: Raw,
  query: query,
  parse: parse,
  serialize: serialize,
  serializeVariables: serializeVariables,
  makeVariables: makeVariables
};

var include = ApolloClient__React_Hooks_UseQuery.Extend({
      query: query,
      Raw: Raw,
      parse: parse,
      serialize: serialize,
      serializeVariables: serializeVariables
    });

var use = include.use;

var PriceHistory_refetchQueryDescription = include.refetchQueryDescription;

var PriceHistory_useLazy = include.useLazy;

var PriceHistory_useLazyWithVariables = include.useLazyWithVariables;

var PriceHistory = {
  PriceHistory_inner: PriceHistory_inner,
  Raw: Raw,
  query: query,
  parse: parse,
  serialize: serialize,
  serializeVariables: serializeVariables,
  makeVariables: makeVariables,
  refetchQueryDescription: PriceHistory_refetchQueryDescription,
  use: use,
  useLazy: PriceHistory_useLazy,
  useLazyWithVariables: PriceHistory_useLazyWithVariables
};

function PriceGraph$LoadedGraph(Props) {
  var data = Props.data;
  var d = Belt_Array.get(data, 0);
  var minYRange = data.reduce((function (min, dataPoint) {
          if (dataPoint.price < min) {
            return dataPoint.price;
          } else {
            return min;
          }
        }), d !== undefined ? d.price : 0);
  var d$1 = Belt_Array.get(data, 0);
  var maxYRange = data.reduce((function (max, dataPoint) {
          if (dataPoint.price > max) {
            return dataPoint.price;
          } else {
            return max;
          }
        }), d$1 !== undefined ? d$1.price : 0);
  var totalRange = maxYRange - minYRange;
  var yAxisRange = [
    minYRange - totalRange * 0.05,
    maxYRange + totalRange * 0.05
  ];
  var isMobile = View.useIsTailwindMobile(undefined);
  return React.createElement(Recharts.ResponsiveContainer, Curry._3(BsRecharts__ResponsiveContainer.makeProps(isMobile ? ({
                            TAG: 0,
                            _0: 200,
                            [Symbol.for("name")]: "Px"
                          }) : ({
                            TAG: 1,
                            _0: 100,
                            [Symbol.for("name")]: "Prc"
                          }), {
                        TAG: 1,
                        _0: 100,
                        [Symbol.for("name")]: "Prc"
                      })(undefined, "w-full text-xs m-0 p-0", undefined, undefined, undefined), React.createElement(Recharts.LineChart, {
                      data: data,
                      margin: {
                        top: 0,
                        right: 0,
                        bottom: 0,
                        left: 0
                      },
                      children: null
                    }, React.createElement(Recharts.Line, {
                          type: "natural",
                          dataKey: "price",
                          dot: false,
                          stroke: "#0d4184",
                          strokeWidth: 2
                        }), React.createElement(Recharts.Tooltip, Curry.app(BsRecharts__Tooltip.makeProps(undefined)(undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined), [
                              undefined,
                              undefined,
                              undefined,
                              undefined,
                              undefined,
                              undefined,
                              undefined,
                              undefined,
                              undefined,
                              undefined,
                              undefined,
                              undefined,
                              undefined,
                              undefined
                            ])), React.createElement(Recharts.XAxis, Curry.app(BsRecharts__XAxis.makeProps(undefined)(undefined, undefined, undefined, undefined, undefined, undefined, "date", undefined, undefined, undefined), [
                              undefined,
                              undefined,
                              undefined,
                              undefined,
                              undefined,
                              undefined,
                              undefined,
                              undefined,
                              undefined,
                              undefined,
                              undefined,
                              undefined,
                              undefined,
                              undefined,
                              undefined,
                              undefined,
                              undefined,
                              undefined,
                              undefined,
                              undefined,
                              undefined,
                              undefined,
                              undefined,
                              undefined,
                              undefined,
                              undefined,
                              undefined,
                              undefined
                            ])), React.createElement(Recharts.YAxis, Curry.app(BsRecharts__YAxis.makeProps(undefined)("number", undefined, undefined, undefined, false, undefined, undefined, yAxisRange, undefined, undefined), [
                              undefined,
                              undefined,
                              undefined,
                              undefined,
                              undefined,
                              undefined,
                              undefined,
                              undefined,
                              undefined,
                              undefined,
                              undefined,
                              undefined,
                              undefined,
                              undefined,
                              undefined,
                              undefined,
                              undefined,
                              undefined,
                              undefined,
                              undefined,
                              undefined,
                              undefined,
                              undefined,
                              undefined,
                              undefined,
                              undefined,
                              undefined
                            ]))), undefined, undefined));
}

var LoadedGraph = {
  make: PriceGraph$LoadedGraph
};

function minThreshodFromGraphSetting(graphSetting) {
  switch (graphSetting) {
    case /* Day */0 :
        return 86400;
    case /* Week */1 :
        return 604800;
    case /* Month */2 :
        return 2628029;
    case /* ThreeMonth */3 :
        return 7884087;
    case /* Year */4 :
        return 31536000;
    case /* Max */5 :
        return 0;
    
  }
}

function btnTextFromGraphSetting(graphSetting) {
  switch (graphSetting) {
    case /* Day */0 :
        return "1D";
    case /* Week */1 :
        return "1W";
    case /* Month */2 :
        return "1M";
    case /* ThreeMonth */3 :
        return "3M";
    case /* Year */4 :
        return "1Y";
    case /* Max */5 :
        return "MAX";
    
  }
}

function zoomAndNumDataPointsFromGraphSetting(graphSetting) {
  switch (graphSetting) {
    case /* Day */0 :
        return [
                3600,
                24
              ];
    case /* Week */1 :
        return [
                43200,
                14
              ];
    case /* Month */2 :
        return [
                86400,
                30
              ];
    case /* ThreeMonth */3 :
        return [
                259200,
                30
              ];
    case /* Year */4 :
        return [
                1209600,
                26
              ];
    case /* Max */5 :
        return [
                3600,
                10000
              ];
    
  }
}

function PriceGraph(Props) {
  var marketName = Props.marketName;
  var oracleAddress = Props.oracleAddress;
  var timestampCreated = Props.timestampCreated;
  var currentTimestamp = Misc.Time.getCurrentTimestamp(undefined);
  var timestampCreatedInt = timestampCreated.toNumber();
  var timeMaketHasExisted = currentTimestamp - timestampCreatedInt | 0;
  var match = React.useState(function () {
        return /* Max */5;
      });
  var setGraphSetting = match[1];
  var graphSetting = match[0];
  var match$1 = zoomAndNumDataPointsFromGraphSetting(graphSetting);
  var priceHistory = Curry.app(use, [
        undefined,
        Caml_option.some(Client.createContext(/* PriceHistory */1)),
        undefined,
        undefined,
        undefined,
        undefined,
        undefined,
        undefined,
        undefined,
        undefined,
        undefined,
        undefined,
        undefined,
        {
          intervalId: ethAdrToLowerStr(oracleAddress) + "-" + String(match$1[0]),
          numDataPoints: match$1[1]
        }
      ]);
  var overlayMessage = function (message) {
    return React.createElement("div", {
                className: "v-align-in-responsive-height text-center text-gray-500 bg-white bg-opacity-90 p-2 z-10 rounded-lg"
              }, message);
  };
  var match$2 = priceHistory.data;
  var tmp;
  if (priceHistory.error !== undefined) {
    tmp = "Error loading data";
  } else if (match$2 !== undefined) {
    var match$3 = match$2.priceIntervalManager;
    if (match$3 !== undefined) {
      var priceData = Belt_Array.map(match$3.prices, (function (param) {
              return {
                      date: Format(param.startTimestamp, "do MMM yyyy"),
                      price: Belt_Option.getExn(Belt_Float.fromString(Ethers.Utils.formatEther(param.endPrice)))
                    };
            }));
      console.log(priceData);
      tmp = React.createElement(PriceGraph$LoadedGraph, {
            data: priceData
          });
    } else {
      tmp = overlayMessage("Unable to find prices for this market");
    }
  } else {
    tmp = priceHistory.loading ? overlayMessage("Loading data for " + marketName) : overlayMessage("Loading data for " + marketName);
  }
  return React.createElement(React.Fragment, undefined, React.createElement("div", {
                  className: "flex-1 p-1 my-4 mr-6 flex flex-col relative"
                }, React.createElement(React.Fragment, undefined, React.createElement("h3", {
                          className: "ml-5"
                        }, marketName + " Price"), tmp, React.createElement("div", {
                          className: "flex flex-row justify-between ml-5"
                        }, Belt_Array.map([
                              /* Day */0,
                              /* Week */1,
                              /* Month */2,
                              /* ThreeMonth */3,
                              /* Year */4,
                              /* Max */5
                            ], (function (buttonSetting) {
                                return React.createElement(Button.Tiny.make, {
                                            onClick: (function (param) {
                                                return Curry._1(setGraphSetting, (function (param) {
                                                              return buttonSetting;
                                                            }));
                                              }),
                                            children: btnTextFromGraphSetting(buttonSetting),
                                            disabled: minThreshodFromGraphSetting(buttonSetting) > timeMaketHasExisted,
                                            active: graphSetting === buttonSetting
                                          });
                              }))))));
}

var make = PriceGraph;

export {
  ethAdrToLowerStr ,
  PriceHistory ,
  LoadedGraph ,
  minThreshodFromGraphSetting ,
  btnTextFromGraphSetting ,
  zoomAndNumDataPointsFromGraphSetting ,
  make ,
  
}
/* query Not a pure module */
