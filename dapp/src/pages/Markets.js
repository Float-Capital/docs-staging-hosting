// Generated by ReScript, PLEASE EDIT WITH CARE
'use strict';

var Misc = require("../libraries/Misc.js");
var Next = require("../bindings/Next.js");
var View = require("../libraries/View.js");
var Curry = require("rescript/lib/js/curry.js");
var React = require("react");
var Client = require("../data/Client.js");
var Ethers = require("../ethereum/Ethers.js");
var Loader = require("../components/UI/Base/Loader.js");
var Market = require("../components/Markets/Market.js");
var $$String = require("rescript/lib/js/string.js");
var Backend = require("../mockBackend/Backend.js");
var Js_dict = require("rescript/lib/js/js_dict.js");
var Queries = require("../data/Queries.js");
var Belt_Int = require("rescript/lib/js/belt_Int.js");
var MintForm = require("../components/Trade/MintForm.js");
var Recharts = require("recharts");
var CONSTANTS = require("../CONSTANTS.js");
var CountDown = require("../components/UI/Base/CountDown.js");
var DataHooks = require("../data/DataHooks.js");
var Link = require("next/link").default;
var Belt_Array = require("rescript/lib/js/belt_Array.js");
var Belt_Float = require("rescript/lib/js/belt_Float.js");
var Belt_Option = require("rescript/lib/js/belt_Option.js");
var Caml_option = require("rescript/lib/js/caml_option.js");
var Router = require("next/router");
var YAxis$Recharts = require("@float-capital/rescript-recharts/src/YAxis.js");
var ResponsiveContainer$Recharts = require("@float-capital/rescript-recharts/src/ResponsiveContainer.js");

function Markets$PriceCard$Card(Props) {
  var selectedOpt = Props.selected;
  var childrenOpt = Props.children;
  var selected = selectedOpt !== undefined ? selectedOpt : false;
  var children = childrenOpt !== undefined ? Caml_option.valFromOption(childrenOpt) : null;
  return React.createElement("div", {
              className: "        \n        " + (
                selected ? "shadow-inner-card" : "shadow-outer-card opacity-60 transform hover:scale-102"
              ) + "\n    my-2\n    md:my-3\n    h-md\n    md:w-price-width\n    md:mr-4\n    md:h-price-height\n    custom-cursor\n    bg-white\n    flex md:flex-col\n    relative\n    rounded-lg"
            }, children);
}

var Card = {
  make: Markets$PriceCard$Card
};

function Markets$PriceCard$ComingSoon(Props) {
  var releaseDateOpt = Props.releaseDate;
  var releaseDate = releaseDateOpt !== undefined ? releaseDateOpt : Date.now() / 1000 | 0;
  return React.createElement("div", {
              className: "shadow-inner-card px-8 py-2 opacity-60 my-2 md:my-3 h-md md:w-price-width md:mr-4 md:h-price-height bg-white flex md:flex-col relative rounded-lg items-center justify-center"
            }, React.createElement("p", {
                  className: "text-xs text-gray"
                }, "New market"), React.createElement("p", {
                  className: "text-xs text-gray"
                }, "coming soon"), React.createElement("div", {
                  className: "text-xxxs text-center text-gray-600"
                }, React.createElement(CountDown.make, {
                      endDateTimestamp: releaseDate,
                      displayUnits: true
                    })));
}

var ComingSoon = {
  make: Markets$PriceCard$ComingSoon
};

function Markets$PriceCard$LoadedGraph(Props) {
  var data = Props.data;
  var isMobile = View.useIsTailwindMobile(undefined);
  return React.createElement(Recharts.ResponsiveContainer, Curry._3(ResponsiveContainer$Recharts.makeProps(isMobile ? ({
                            TAG: 0,
                            _0: 40,
                            [Symbol.for("name")]: "Px"
                          }) : ({
                            TAG: 1,
                            _0: 100,
                            [Symbol.for("name")]: "Prc"
                          }), {
                        TAG: 1,
                        _0: 99,
                        [Symbol.for("name")]: "Prc"
                      })(undefined, "m-0 p-0", undefined, undefined, undefined), React.createElement(Recharts.LineChart, {
                      data: data,
                      margin: {
                        top: 5,
                        right: 0,
                        bottom: 5,
                        left: 0
                      },
                      children: null
                    }, React.createElement(Recharts.Line, {
                          type: "natural",
                          dataKey: "price",
                          dot: false,
                          stroke: "#0d4184",
                          strokeWidth: 2
                        }), React.createElement(Recharts.YAxis, Curry.app(YAxis$Recharts.makeProps(undefined)("number", undefined, undefined, undefined, false, undefined, undefined, [
                                  "dataMin",
                                  "dataMax"
                                ], undefined, true), [
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
  make: Markets$PriceCard$LoadedGraph
};

function Markets$PriceCard(Props) {
  var selected = Props.selected;
  var market = Props.market;
  var onClick = Props.onClick;
  var priceHistory = Curry.app(Queries.PriceHistory.use, [
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
          intervalId: Ethers.Utils.ethAdrToLowerStr(market.oracleAddress) + "-" + String(CONSTANTS.oneHourInSeconds),
          numDataPoints: 168
        }
      ]);
  var marketIndex = market.marketIndex.toNumber();
  var assetDecimals = Backend.getMarketInfoUnsafe(marketIndex - 1 | 0).oracleDecimals;
  var match = priceHistory.data;
  var state;
  var exit = 0;
  if (match !== undefined) {
    var match$1 = match.priceIntervalManager;
    if (match$1 !== undefined) {
      var normalizeDecimals = Ethers.Utils.make18DecimalsNormalizer(assetDecimals);
      state = {
        TAG: 1,
        _0: {
          data: Belt_Array.reduceReverse(match$1.prices, [], (function (prev, param) {
                  var info_date = param.startTimestamp;
                  var info_price = Belt_Option.getExn(Belt_Float.fromString(Ethers.Utils.formatEther(Curry._1(normalizeDecimals, param.endPrice))));
                  var info = {
                    date: info_date,
                    price: info_price
                  };
                  return Belt_Array.concat(prev, [info]);
                })),
          latestPrice: Ethers.Utils.formatEtherToPrecision(Curry._1(normalizeDecimals, match$1.latestPriceInterval.endPrice), 2)
        },
        [Symbol.for("name")]: "Response"
      };
    } else {
      state = {
        TAG: 0,
        _0: "Couldn't fetch prices for this market.",
        [Symbol.for("name")]: "GraphError"
      };
    }
  } else if (priceHistory.error !== undefined || priceHistory.loading) {
    exit = 1;
  } else {
    state = {
      TAG: 0,
      _0: "Couldn't fetch prices for this market.",
      [Symbol.for("name")]: "GraphError"
    };
  }
  if (exit === 1) {
    state = priceHistory.loading ? /* Loading */0 : ({
          TAG: 0,
          _0: priceHistory.error.message,
          [Symbol.for("name")]: "GraphError"
        });
  }
  var tmp;
  tmp = typeof state === "number" || state.TAG === /* GraphError */0 ? null : "$" + state._0.latestPrice;
  var tmp$1;
  if (typeof state === "number") {
    tmp$1 = React.createElement(Loader.Ellipses.make, {});
  } else if (state.TAG === /* GraphError */0) {
    console.log(state._0);
    tmp$1 = React.createElement("p", {
          className: "text-xxs text-gray-500"
        }, "unable to fetch price data");
  } else {
    tmp$1 = React.createElement(Markets$PriceCard$LoadedGraph, {
          data: state._0.data
        });
  }
  return React.createElement(Markets$PriceCard$Card, {
              selected: selected,
              children: null
            }, React.createElement("div", {
                  className: "z-10 absolute w-full h-full flex items-center justify-center",
                  onClick: onClick
                }), React.createElement("div", {
                  className: "pt-2 text-xs font-medium flex-1 md:flex-initial md:w-full flex justify-between"
                }, React.createElement("div", {
                      className: "mx-3 flex flex-row items-center"
                    }, React.createElement("img", {
                          className: "h-3 mr-1",
                          src: Backend.getMarketInfoUnsafe(market.marketIndex.toNumber()).icon
                        }), market.name), React.createElement("div", {
                      className: "mr-3 flex flex-row items-center"
                    }, tmp)), React.createElement("div", {
                  className: "flex items-center justify-center px-4 py-2 md:px-4 md:py-4 flex-1"
                }, tmp$1));
}

var PriceCard = {
  Card: Card,
  ComingSoon: ComingSoon,
  LoadedGraph: LoadedGraph,
  make: Markets$PriceCard
};

function Markets$Mint$Header$TypedCharacters(Props) {
  var str = Props.str;
  var match = React.useState(function () {
        return 1;
      });
  var setCount = match[1];
  Misc.Time.useIntervalFixed((function (param) {
          return Curry._1(setCount, (function (c) {
                        return c + 1 | 0;
                      }));
        }), 25, str.length - 1 | 0);
  return $$String.sub(str, 0, match[0]);
}

var TypedCharacters = {
  make: Markets$Mint$Header$TypedCharacters
};

function Markets$Mint$Header(Props) {
  var market = Props.market;
  var actionOption = Props.actionOption;
  var marketIndex = Props.marketIndex;
  return React.createElement("div", {
              className: "flex justify-between items-center mb-2"
            }, React.createElement("div", {
                  className: "text-xl flex flex-row items-center"
                }, React.createElement("img", {
                      className: "h-6 mr-2",
                      src: Backend.getMarketInfoUnsafe(market.marketIndex.toNumber()).icon
                    }), React.createElement(Markets$Mint$Header$TypedCharacters, {
                      str: market.name
                    })), React.createElement(Link, {
                  href: "/app/markets?marketIndex=" + String(marketIndex) + "&actionOption=" + actionOption,
                  children: React.createElement("div", {
                        className: "text-xxs hover:underline cursor-pointer"
                      }, "view details")
                }));
}

var Header = {
  TypedCharacters: TypedCharacters,
  make: Markets$Mint$Header
};

function Markets$Mint(Props) {
  var market = Props.market;
  var router = Router.useRouter();
  var actionOption = Belt_Option.getWithDefault(Js_dict.get(router.query, "actionOption"), "short");
  return React.createElement("div", {
              className: "mt-5 md:mt-0 md:w-mint-width p-6 mb-5 rounded-lg shine md:order-2 order-1"
            }, React.createElement(Markets$Mint$Header, {
                  market: market,
                  actionOption: actionOption,
                  marketIndex: market.marketIndex.toNumber()
                }), React.createElement("div", {
                  className: "px-1"
                }, React.createElement(MintForm.make, {
                      market: market,
                      isLong: actionOption !== "short"
                    })));
}

var Mint = {
  Header: Header,
  make: Markets$Mint
};

function floatToIntUnsafe(prim) {
  return prim;
}

function Markets(Props) {
  var marketsQuery = DataHooks.useGetMarkets(undefined);
  var router = Router.useRouter();
  var selectedStr = Belt_Option.getWithDefault(Js_dict.get(router.query, "selected"), "0");
  var selectedFloat = parseInt(selectedStr);
  var selectedInt = Number.isNaN(selectedFloat) ? 0 : selectedFloat;
  var marketIndexStr = Js_dict.get(router.query, "marketIndex");
  var isMarketPage = Belt_Option.isSome(marketIndexStr);
  var tmp;
  if (typeof marketsQuery === "number") {
    tmp = React.createElement(Loader.make, {});
  } else if (marketsQuery.TAG === /* GraphError */0) {
    tmp = marketsQuery._0;
  } else {
    var markets = marketsQuery._0;
    if (markets.length !== 0) {
      if (isMarketPage) {
        if (Belt_Option.mapWithDefault(Belt_Int.fromString(marketIndexStr), 1000, (function (x) {
                  return x;
                })) <= markets.length) {
          var selectedMarketData = Belt_Array.get(markets, Belt_Option.mapWithDefault(Belt_Int.fromString(marketIndexStr), 1000, (function (x) {
                      return x;
                    })) - 1 | 0);
          tmp = selectedMarketData !== undefined ? React.createElement(Market.make, {
                  marketData: selectedMarketData
                }) : null;
        } else {
          tmp = null;
        }
      } else {
        var selected = selectedInt >= 0 && selectedInt < markets.length ? selectedInt : 0;
        tmp = React.createElement("div", {
              className: "w-9/10 md:w-auto flex flex-col"
            }, React.createElement("div", {
                  className: "pb-6 flex md:order-1 order-2 flex-col md:flex-row w-full md:w-auto justify-center"
                }, Belt_Array.mapWithIndex(markets, (function (index, market) {
                        return React.createElement(Markets$PriceCard, {
                                    selected: selected === index,
                                    market: market,
                                    onClick: (function (param) {
                                        if (selected !== index) {
                                          router.query["selected"] = String(index);
                                          router.query["actionOption"] = "short";
                                          return Next.Router.pushObjShallow(router, {
                                                      pathname: router.pathname,
                                                      query: router.query
                                                    });
                                        }
                                        
                                      })
                                  });
                      })), markets.length < 3 ? React.createElement(React.Fragment, undefined, React.createElement(Markets$PriceCard$ComingSoon, {
                            releaseDate: 1633053600
                          }), markets.length < 2 ? React.createElement(Markets$PriceCard$ComingSoon, {
                              releaseDate: 1634263200
                            }) : null) : null), React.createElement(Markets$Mint, {
                  market: markets[selected],
                  key: selectedStr
                }));
      }
    } else {
      tmp = "Error fetching data for markets.";
    }
  }
  return React.createElement("div", {
              className: isMarketPage ? "w-full max-w-5xl mx-auto px-2 md:px-0" : "md:h-80-percent-screen flex flex-col items-center justify-center w-full"
            }, tmp);
}

var make = Markets;

var $$default = Markets;

exports.PriceCard = PriceCard;
exports.Mint = Mint;
exports.floatToIntUnsafe = floatToIntUnsafe;
exports.make = make;
exports.$$default = $$default;
exports.default = $$default;
exports.__esModule = true;
/* Misc Not a pure module */
