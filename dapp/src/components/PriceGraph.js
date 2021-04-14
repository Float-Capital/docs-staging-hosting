// Generated by ReScript, PLEASE EDIT WITH CARE

import * as View from "../libraries/View.js";
import * as Curry from "bs-platform/lib/es6/curry.js";
import * as React from "react";
import * as Button from "./UI/Button.js";
import * as Client from "../data/Client.js";
import * as Ethers from "../ethereum/Ethers.js";
import * as Js_math from "bs-platform/lib/es6/js_math.js";
import * as Recharts from "recharts";
import * as Belt_Array from "bs-platform/lib/es6/belt_Array.js";
import * as Belt_Float from "bs-platform/lib/es6/belt_Float.js";
import * as MiniLoader from "./UI/MiniLoader.js";
import * as Belt_Option from "bs-platform/lib/es6/belt_Option.js";
import * as Caml_option from "bs-platform/lib/es6/caml_option.js";
import * as GqlConverters from "../libraries/GqlConverters.js";
import Format from "date-fns/format";
import * as BsRecharts__XAxis from "@ahrefs/bs-recharts/src/BsRecharts__XAxis.js";
import * as BsRecharts__YAxis from "@ahrefs/bs-recharts/src/BsRecharts__YAxis.js";
import * as BsRecharts__Tooltip from "@ahrefs/bs-recharts/src/BsRecharts__Tooltip.js";
import * as BsRecharts__ResponsiveContainer from "@ahrefs/bs-recharts/src/BsRecharts__ResponsiveContainer.js";
import * as ApolloClient__React_Hooks_UseQuery from "rescript-apollo-client/src/@apollo/client/react/hooks/ApolloClient__React_Hooks_UseQuery.js";

var Raw = {};

var query = (require("@apollo/client").gql`
  query   {
    fiveMinPrices(first: 25, orderBy: intervalIndex, orderDirection: desc, where: {oracle: "0x49b6eb4bb38178790b51a5630f08923580e10e8d"})  {
      __typename
      startTimestamp
      endPrice
    }
  }
`);

function parse(value) {
  var value$1 = value.fiveMinPrices;
  return {
          fiveMinPrices: value$1.map(function (value) {
                return {
                        __typename: value.__typename,
                        startTimestamp: GqlConverters.$$Date.parse(value.startTimestamp),
                        endPrice: GqlConverters.$$BigInt.parse(value.endPrice)
                      };
              })
        };
}

function serialize(value) {
  var value$1 = value.fiveMinPrices;
  var fiveMinPrices = value$1.map(function (value) {
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
  return {
          fiveMinPrices: fiveMinPrices
        };
}

function serializeVariables(param) {
  
}

function makeVariables(param) {
  
}

function makeDefaultVariables(param) {
  
}

var PriceHistory_inner = {
  Raw: Raw,
  query: query,
  parse: parse,
  serialize: serialize,
  serializeVariables: serializeVariables,
  makeVariables: makeVariables,
  makeDefaultVariables: makeDefaultVariables
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
  makeDefaultVariables: makeDefaultVariables,
  refetchQueryDescription: PriceHistory_refetchQueryDescription,
  use: use,
  useLazy: PriceHistory_useLazy,
  useLazyWithVariables: PriceHistory_useLazyWithVariables
};

function PriceGraph$LoadedGraph(Props) {
  var marketName = Props.marketName;
  var data = Props.data;
  var dummyData = [
    {
      date: "1 Feb",
      price: Js_math.random_int(100, 200)
    },
    {
      date: "2 Feb",
      price: Js_math.random_int(100, 200)
    },
    {
      date: "3 Feb",
      price: Js_math.random_int(100, 200)
    },
    {
      date: "4 Feb",
      price: Js_math.random_int(100, 200)
    },
    {
      date: "5 Feb",
      price: Js_math.random_int(100, 200)
    },
    {
      date: "6 Feb",
      price: Js_math.random_int(100, 200)
    },
    {
      date: "7 Feb",
      price: Js_math.random_int(100, 200)
    },
    {
      date: "8 Feb",
      price: Js_math.random_int(100, 200)
    },
    {
      date: "9 Feb",
      price: Js_math.random_int(100, 200)
    },
    {
      date: "10 Feb",
      price: Js_math.random_int(100, 200)
    },
    {
      date: "11 Feb",
      price: Js_math.random_int(100, 200)
    },
    {
      date: "12 Feb",
      price: Js_math.random_int(100, 200)
    },
    {
      date: "13 Feb",
      price: Js_math.random_int(100, 200)
    },
    {
      date: "14 Feb",
      price: Js_math.random_int(100, 200)
    }
  ];
  var noDataAvailable = data.length === 0;
  var displayData = noDataAvailable ? dummyData : data;
  var d = Belt_Array.get(displayData, 0);
  var minYRange = displayData.reduce((function (min, dataPoint) {
          if (dataPoint.price < min) {
            return dataPoint.price;
          } else {
            return min;
          }
        }), d !== undefined ? d.price : 0);
  var d$1 = Belt_Array.get(displayData, 0);
  var maxYRange = displayData.reduce((function (max, dataPoint) {
          if (dataPoint.price > max) {
            return dataPoint.price;
          } else {
            return max;
          }
        }), d$1 !== undefined ? d$1.price : 0);
  var totalRange = maxYRange - minYRange;
  var yAxisRange = [
<<<<<<< HEAD
    minYRange - totalRange * 0.05,
    maxYRange + totalRange * 0.05
=======
    minYRange - minYRange * 0.05,
    maxYRange + maxYRange * 0.05
>>>>>>> Update the UI to have a demo implementation of the price data graph (everything hard-coded)
  ];
  var isMobile = View.useIsTailwindMobile(undefined);
  return React.createElement(React.Fragment, undefined, React.createElement("div", {
                  className: "flex-1 p-1 my-4 mr-6 flex flex-col relative"
                }, noDataAvailable ? React.createElement("div", {
                        className: "v-align-in-responsive-height text-center text-gray-500 bg-white bg-opacity-90 p-2 z-10 rounded-lg"
                      }, "No price data available for this market yet") : null, React.createElement(React.Fragment, undefined, React.createElement("h3", {
                          className: "ml-5"
                        }, marketName + " Price"), React.createElement(Recharts.ResponsiveContainer, Curry._3(BsRecharts__ResponsiveContainer.makeProps(isMobile ? ({
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
                                  data: displayData,
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
                                        ]))), undefined, undefined)), React.createElement("div", {
                          className: "flex flex-row justify-between ml-5"
                        }, React.createElement(Button.Tiny.make, {
                              onClick: (function (param) {
                                  console.log("1D");
                                  
                                }),
                              children: "1D"
                            }), React.createElement(Button.Tiny.make, {
                              onClick: (function (param) {
                                  console.log("1W");
                                  
                                }),
                              children: "1W"
                            }), React.createElement(Button.Tiny.make, {
                              onClick: (function (param) {
                                  console.log("1M");
                                  
                                }),
                              children: "1M"
                            }), React.createElement(Button.Tiny.make, {
                              onClick: (function (param) {
                                  console.log("3M");
                                  
                                }),
                              children: "3M",
                              disabled: true
                            }), React.createElement(Button.Tiny.make, {
                              onClick: (function (param) {
                                  console.log("1Y");
                                  
                                }),
                              children: "1Y",
                              disabled: true
                            }), React.createElement(Button.Tiny.make, {
                              onClick: (function (param) {
                                  console.log("MAX");
                                  
                                }),
                              children: "MAX",
                              disabled: true
                            })))));
}

var LoadedGraph = {
  make: PriceGraph$LoadedGraph
};

function PriceGraph(Props) {
  var marketName = Props.marketName;
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
        undefined
      ]);
  var loading = React.createElement("div", undefined, React.createElement("p", undefined, "Loading data for " + marketName), React.createElement(MiniLoader.make, {}));
  var match = priceHistory.data;
  if (priceHistory.error !== undefined) {
    return "Error loading data";
  }
  if (match === undefined) {
    return loading;
  }
  var priceData = Belt_Array.map(match.fiveMinPrices, (function (param) {
          return {
                  date: Format(param.startTimestamp, "do MMM yyyy"),
                  price: Belt_Option.getExn(Belt_Float.fromString(Ethers.Utils.formatEther(param.endPrice)))
                };
        }));
  console.log(priceData);
  return React.createElement(PriceGraph$LoadedGraph, {
              marketName: marketName,
              data: priceData
            });
}

var make = PriceGraph;

export {
  PriceHistory ,
  LoadedGraph ,
  make ,
  
}
/* query Not a pure module */
