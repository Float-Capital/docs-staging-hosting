// Generated by ReScript, PLEASE EDIT WITH CARE

import * as Misc from "../libraries/Misc.js";
import * as View from "../libraries/View.js";
import * as Curry from "rescript/lib/es6/curry.js";
import * as React from "react";
import * as Button from "./UI/Button.js";
import * as Client from "../data/Client.js";
import * as Ethers from "../ethereum/Ethers.js";
import * as Js_int from "rescript/lib/es6/js_int.js";
import * as Js_math from "rescript/lib/es6/js_math.js";
import * as Caml_obj from "rescript/lib/es6/caml_obj.js";
import * as Recharts from "recharts";
import * as CONSTANTS from "../CONSTANTS.js";
import * as Belt_Array from "rescript/lib/es6/belt_Array.js";
import * as Belt_Float from "rescript/lib/es6/belt_Float.js";
import * as Belt_Option from "rescript/lib/es6/belt_Option.js";
import * as Caml_option from "rescript/lib/es6/caml_option.js";
import * as GqlConverters from "../libraries/GqlConverters.js";
import Format from "date-fns/format";
import * as BsRecharts__XAxis from "@ahrefs/bs-recharts/src/BsRecharts__XAxis.js";
import * as BsRecharts__YAxis from "@ahrefs/bs-recharts/src/BsRecharts__YAxis.js";
import * as BsRecharts__Tooltip from "@ahrefs/bs-recharts/src/BsRecharts__Tooltip.js";
import FromUnixTime from "date-fns/fromUnixTime";
import * as BsRecharts__ResponsiveContainer from "@ahrefs/bs-recharts/src/BsRecharts__ResponsiveContainer.js";
import * as ApolloClient__React_Hooks_UseQuery from "rescript-apollo-client/src/@apollo/client/react/hooks/ApolloClient__React_Hooks_UseQuery.js";

var ethAdrToLowerStr = Ethers.Utils.ethAdrToLowerStr;

var Raw = {};

var query = (require("@apollo/client").gql`
  query ($intervalId: String!, $numDataPoints: Int!)  {
    priceIntervalManager(id: $intervalId)  {
      __typename
      id
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
      id: value$1.id,
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
    var value$3 = value$1.id;
    var value$4 = value$1.__typename;
    priceIntervalManager = {
      __typename: value$4,
      id: value$3,
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
  var xAxisFormat = Props.xAxisFormat;
  var minYValue = Props.minYValue;
  var maxYValue = Props.maxYValue;
  var totalRange = maxYValue - minYValue;
  var yAxisRange = [
    minYValue - totalRange * 0.05,
    maxYValue + totalRange * 0.05
  ];
  var isMobile = View.useIsTailwindMobile(undefined);
  return React.createElement(Recharts.ResponsiveContainer, Curry._3(BsRecharts__ResponsiveContainer.makeProps(isMobile ? ({
                            TAG: /* Px */0,
                            _0: 200
                          }) : ({
                            TAG: /* Prc */1,
                            _0: 100
                          }), {
                        TAG: /* Prc */1,
                        _0: 100
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
                              (function (value) {
                                  return Format(value, "ha do MMM ''yy");
                                }),
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
                              (function (value) {
                                  return Format(value, xAxisFormat);
                                }),
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
                              (function (value) {
                                  return value.toFixed(3);
                                }),
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
  if (typeof graphSetting !== "number") {
    return 0;
  }
  switch (graphSetting) {
    case /* Day */0 :
        return CONSTANTS.oneDayInSeconds;
    case /* Week */1 :
        return CONSTANTS.oneWeekInSeconds;
    case /* Month */2 :
        return CONSTANTS.oneMonthInSeconds;
    case /* ThreeMonth */3 :
        return CONSTANTS.threeMonthsInSeconds;
    case /* Year */4 :
        return CONSTANTS.oneYearInSeconds;
    
  }
}

function btnTextFromGraphSetting(graphSetting) {
  if (typeof graphSetting !== "number") {
    return "MAX";
  }
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
    
  }
}

function getMaxTimeDateFormatter(timeMarketExists) {
  if (timeMarketExists < CONSTANTS.halfDayInSeconds) {
    return "ha";
  } else if (timeMarketExists < CONSTANTS.oneWeekInSeconds) {
    return "iii";
  } else if (timeMarketExists < CONSTANTS.twoWeeksInSeconds || timeMarketExists < CONSTANTS.threeMonthsInSeconds) {
    return "iii MMM";
  } else {
    return "MMM";
  }
}

function dateFormattersFromGraphSetting(graphSetting) {
  if (typeof graphSetting !== "number") {
    return getMaxTimeDateFormatter(graphSetting._0);
  }
  switch (graphSetting) {
    case /* Day */0 :
        return "ha";
    case /* Week */1 :
    case /* Month */2 :
        return "iii";
    case /* ThreeMonth */3 :
        return "iii MMM";
    case /* Year */4 :
        return "MMM";
    
  }
}

function getMaxTimeIntervalAndAmount(timeMarketExists) {
  if (timeMarketExists < CONSTANTS.halfDayInSeconds) {
    return [
            CONSTANTS.fiveMinutesInSeconds,
            1000
          ];
  } else if (timeMarketExists < CONSTANTS.oneWeekInSeconds) {
    return [
            CONSTANTS.oneHourInSeconds,
            1000
          ];
  } else if (timeMarketExists < CONSTANTS.twoWeeksInSeconds) {
    return [
            CONSTANTS.halfDayInSeconds,
            1000
          ];
  } else if (timeMarketExists < CONSTANTS.threeMonthsInSeconds) {
    return [
            CONSTANTS.oneDayInSeconds,
            1000
          ];
  } else if (timeMarketExists < CONSTANTS.oneYearInSeconds) {
    return [
            CONSTANTS.oneWeekInSeconds,
            1000
          ];
  } else {
    return [
            CONSTANTS.twoWeeksInSeconds,
            1000
          ];
  }
}

function zoomAndNumDataPointsFromGraphSetting(graphSetting) {
  if (typeof graphSetting !== "number") {
    return getMaxTimeIntervalAndAmount(graphSetting._0);
  }
  switch (graphSetting) {
    case /* Day */0 :
        return [
                CONSTANTS.oneHourInSeconds,
                24
              ];
    case /* Week */1 :
        return [
                CONSTANTS.halfDayInSeconds,
                14
              ];
    case /* Month */2 :
        return [
                CONSTANTS.oneDayInSeconds,
                30
              ];
    case /* ThreeMonth */3 :
        return [
                CONSTANTS.threeMonthsInSeconds,
                30
              ];
    case /* Year */4 :
        return [
                CONSTANTS.twoWeeksInSeconds,
                26
              ];
    
  }
}

function extractGraphPriceInfo(rawPriceData, graphZoomSetting) {
  return Belt_Array.reduceReverse(rawPriceData, {
              dataArray: [],
              minYValue: Js_int.max,
              maxYValue: 0,
              dateFormat: dateFormattersFromGraphSetting(graphZoomSetting)
            }, (function (data, param) {
                var price = Belt_Option.getExn(Belt_Float.fromString(Ethers.Utils.formatEther(param.endPrice)));
                return {
                        dataArray: Belt_Array.concat(data.dataArray, [{
                                date: param.startTimestamp,
                                price: price
                              }]),
                        minYValue: price < data.minYValue ? price : data.minYValue,
                        maxYValue: price > data.maxYValue ? price : data.maxYValue,
                        dateFormat: data.dateFormat
                      };
              }));
}

function generateDummyData(endTimestamp) {
  return Belt_Array.reduce(new Array(60), [
                {
                  dataArray: [],
                  minYValue: 200,
                  maxYValue: 100,
                  dateFormat: "iii"
                },
                endTimestamp,
                500
              ], (function (param, _i) {
                  var timestamp = param[1];
                  var data = param[0];
                  var newTimestamp = timestamp - CONSTANTS.oneDayInSeconds;
                  var randomDelta = Js_math.random_int(-30, 25);
                  var randomPrice = param[2] + randomDelta;
                  return [
                          {
                            dataArray: Belt_Array.concat([{
                                    date: FromUnixTime(timestamp),
                                    price: randomPrice
                                  }], data.dataArray),
                            minYValue: randomPrice < data.minYValue ? randomPrice : data.minYValue,
                            maxYValue: randomPrice > data.maxYValue ? randomPrice : data.maxYValue,
                            dateFormat: data.dateFormat
                          },
                          newTimestamp,
                          randomPrice
                        ];
                }))[0];
}

function PriceGraph(Props) {
  var marketName = Props.marketName;
  var oracleAddress = Props.oracleAddress;
  var timestampCreated = Props.timestampCreated;
  var currentTimestamp = Misc.Time.getCurrentTimestamp(undefined);
  var timestampCreatedInt = timestampCreated.toNumber();
  var timeMaketHasExisted = currentTimestamp - timestampCreatedInt | 0;
  var match = React.useState(function () {
        return generateDummyData(currentTimestamp);
      });
  var setDisplayData = match[1];
  var match$1 = match[0];
  var match$2 = React.useState(function () {
        
      });
  var setOverlayMessageText = match$2[1];
  var match$3 = React.useState(function () {
        return /* Max */{
                _0: timeMaketHasExisted
              };
      });
  var setGraphSetting = match$3[1];
  var graphSetting = match$3[0];
  var match$4 = zoomAndNumDataPointsFromGraphSetting(graphSetting);
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
          intervalId: ethAdrToLowerStr(oracleAddress) + "-" + String(match$4[0]),
          numDataPoints: match$4[1]
        }
      ]);
  React.useEffect((function () {
          var exit = 0;
          var match = priceHistory.data;
          if (priceHistory.error !== undefined) {
            Curry._1(setOverlayMessageText, (function (param) {
                    return "Error loading data";
                  }));
          } else if (match !== undefined) {
            var match$1 = match.priceIntervalManager;
            if (match$1 !== undefined) {
              var prices = match$1.prices;
              Curry._1(setOverlayMessageText, (function (param) {
                      
                    }));
              Curry._1(setDisplayData, (function (param) {
                      return extractGraphPriceInfo(prices, graphSetting);
                    }));
            } else {
              Curry._1(setOverlayMessageText, (function (param) {
                      return "Unable to find prices for this market";
                    }));
            }
          } else {
            exit = 1;
          }
          if (exit === 1) {
            Curry._1(setOverlayMessageText, (function (param) {
                    return "Loading data for " + marketName;
                  }));
          }
          
        }), [
        graphSetting,
        priceHistory.loading
      ]);
  var overlayMessage = function (message) {
    return React.createElement("div", {
                className: "v-align-in-responsive-height text-center text-gray-500 bg-white bg-opacity-90 p-2 z-10 rounded-lg"
              }, message);
  };
  return React.createElement(React.Fragment, undefined, React.createElement("div", {
                  className: "flex-1 p-1 my-4 mr-6 flex flex-col relative"
                }, React.createElement("h3", {
                      className: "ml-5"
                    }, marketName + " Price"), React.createElement(PriceGraph$LoadedGraph, {
                      data: match$1.dataArray,
                      xAxisFormat: dateFormattersFromGraphSetting(graphSetting),
                      minYValue: match$1.minYValue,
                      maxYValue: match$1.maxYValue
                    }), Belt_Option.mapWithDefault(match$2[0], null, overlayMessage), React.createElement("div", {
                      className: "flex flex-row justify-between ml-5"
                    }, Belt_Array.map([
                          /* Day */0,
                          /* Week */1,
                          /* Month */2,
                          /* ThreeMonth */3,
                          /* Year */4,
                          /* Max */{
                            _0: timeMaketHasExisted
                          }
                        ], (function (buttonSetting) {
                            var text = btnTextFromGraphSetting(buttonSetting);
                            return React.createElement(Button.Tiny.make, {
                                        onClick: (function (param) {
                                            return Curry._1(setGraphSetting, (function (param) {
                                                          return buttonSetting;
                                                        }));
                                          }),
                                        children: text,
                                        disabled: minThreshodFromGraphSetting(buttonSetting) > timeMaketHasExisted,
                                        active: Caml_obj.caml_equal(graphSetting, buttonSetting),
                                        key: text
                                      });
                          })))));
}

var make = PriceGraph;

export {
  ethAdrToLowerStr ,
  PriceHistory ,
  LoadedGraph ,
  minThreshodFromGraphSetting ,
  btnTextFromGraphSetting ,
  getMaxTimeDateFormatter ,
  dateFormattersFromGraphSetting ,
  getMaxTimeIntervalAndAmount ,
  zoomAndNumDataPointsFromGraphSetting ,
  extractGraphPriceInfo ,
  generateDummyData ,
  make ,
  
}
/* query Not a pure module */
