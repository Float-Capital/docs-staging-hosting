// Generated by ReScript, PLEASE EDIT WITH CARE
'use strict';

var Misc = require("./libraries/Misc.js");
var Curry = require("rescript/lib/js/curry.js");
var React = require("react");
var Config = require("./Config.js");
var Loader = require("./components/UI/Base/Loader.js");
var Masonry = require("./components/UI/Masonry.js");
var Queries = require("./data/Queries.js");
var Tooltip = require("./components/UI/Base/Tooltip.js");
var Link = require("next/link").default;
var Belt_Array = require("rescript/lib/js/belt_Array.js");
var APYProvider = require("./libraries/APYProvider.js");
var Caml_option = require("rescript/lib/js/caml_option.js");
var DashboardLi = require("./components/UI/Dashboard/DashboardLi.js");
var DashboardUl = require("./components/UI/Dashboard/DashboardUl.js");
var DashboardCalcs = require("./libraries/DashboardCalcs.js");
var Format = require("date-fns/format").default;
var DashboardStakeCard = require("./components/UI/Dashboard/DashboardStakeCard.js");
var FromUnixTime = require("date-fns/fromUnixTime").default;
var FormatDistanceToNow = require("date-fns/formatDistanceToNow").default;

function Dashboard$TrendingStakes(Props) {
  var marketDetailsQuery = Curry.app(Queries.MarketDetails.use, [
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
      ]);
  var apy = APYProvider.useAPY(undefined);
  var match = marketDetailsQuery.data;
  if (marketDetailsQuery.loading) {
    return React.createElement("div", {
                className: "m-auto"
              }, React.createElement(Loader.Mini.make, {}));
  }
  if (marketDetailsQuery.error !== undefined) {
    return "Error loading data";
  }
  if (match === undefined) {
    return "You might think this is impossible, but depending on the situation it might not be!";
  }
  if (typeof apy === "number") {
    return React.createElement(Loader.Mini.make, {});
  }
  if (apy.TAG !== /* Loaded */0) {
    return React.createElement(Loader.Mini.make, {});
  }
  var trendingStakes = DashboardCalcs.trendingStakes(match.syntheticMarkets, apy._0);
  return Belt_Array.map(trendingStakes, (function (param) {
                var isLong = param.isLong;
                var marketName = param.marketName;
                return React.createElement(DashboardStakeCard.make, {
                            marketName: marketName,
                            isLong: isLong,
                            yield: param.apy,
                            rewards: param.floatApy,
                            key: marketName + (
                              isLong ? "-long" : "-short"
                            )
                          });
              }));
}

var TrendingStakes = {
  make: Dashboard$TrendingStakes
};

function totalValueCard(totalValueLocked) {
  return React.createElement("div", {
              className: "mb-2 md:mb-5 mx-3 p-5 md:mt-7 self-center text-center bg-white bg-opacity-75 rounded-lg shadow-lg"
            }, React.createElement("span", {
                  className: "font-alphbeta text-xl"
                }, "Total Value"), React.createElement("span", {
                  className: "text-sm"
                }, " 🏦 in Float Protocol: "), React.createElement("span", {
                  className: "text-green-700 font-bold text-xl"
                }, "$" + Misc.NumberFormat.formatEther(undefined, totalValueLocked)));
}

function floatProtocolCard(liveSince, totalTxs, totalUsers, totalGasUsed, txHash, numberOfSynths) {
  var dateObj = FromUnixTime(liveSince.toNumber());
  return React.createElement(Masonry.Card.make, {
              children: null
            }, React.createElement(Masonry.Header.make, {
                  children: "Float Protocol 🏗️"
                }), React.createElement(DashboardUl.make, {
                  list: [
                    DashboardLi.Props.createDashboardLiProps(undefined, "🗓️ Live since:", Format(dateObj, "do MMM ''yy"), Config.blockExplorer + "/tx/" + txHash, undefined),
                    DashboardLi.Props.createDashboardLiProps(undefined, "📅 Days live:", FormatDistanceToNow(dateObj), undefined, undefined),
                    DashboardLi.Props.createDashboardLiProps(undefined, "📈 No. txs:", totalTxs.toString(), undefined, undefined),
                    DashboardLi.Props.createDashboardLiProps(undefined, "👯‍♀️ No. users:", totalUsers.toString(), undefined, undefined),
                    DashboardLi.Props.createDashboardLiProps(undefined, "👷‍♀️ No. synths:", numberOfSynths, undefined, undefined),
                    DashboardLi.Props.createDashboardLiProps(undefined, "⛽ Gas used:", Misc.NumberFormat.formatInt(totalGasUsed.toString()), undefined, undefined)
                  ]
                }));
}

function syntheticAssetsCard(totalSynthValue) {
  return React.createElement(Masonry.Card.make, {
              children: null
            }, React.createElement(Masonry.Header.make, {
                  children: null
                }, "Synthetic Assets", React.createElement("img", {
                      className: "inline h-5 ml-2",
                      src: "/img/coin.png"
                    })), React.createElement("div", {
                  className: "p-6 py-4 text-center"
                }, React.createElement("div", undefined, React.createElement("span", {
                          className: "text-sm mr-2"
                        }, "💰 Total synth value"), React.createElement("div", {
                          className: "text-green-700 text-xl "
                        }, "$" + Misc.NumberFormat.formatEther(undefined, totalSynthValue), React.createElement("span", {
                              className: "text-black"
                            }, React.createElement(Tooltip.make, {
                                  tip: "Redeemable value of synths in the open market"
                                }))))), React.createElement(Link, {
                  href: "/markets",
                  children: React.createElement("div", {
                        className: "w-full pb-4 text-sm cursor-pointer hover:opacity-70 mx-auto"
                      }, React.createElement("div", {
                            className: "flex justify-center"
                          }, React.createElement("div", {
                                className: "inline-block mx-auto"
                              }, React.createElement("p", undefined, "👀 See markets"), React.createElement("p", {
                                    className: "ml-5"
                                  }, "to learn more..."))))
                }));
}

function floatTokenCard(totalFloatMinted) {
  return React.createElement(Masonry.Card.make, {
              children: null
            }, React.createElement(Masonry.Header.make, {
                  children: "🌊🌊 Float Token 🌊🌊"
                }), React.createElement(DashboardUl.make, {
                  list: [
                    DashboardLi.Props.createDashboardLiProps(undefined, "😏 Float price:", "...", undefined, undefined),
                    DashboardLi.Props.createDashboardLiProps(Caml_option.some(React.createElement(Tooltip.make, {
                                  tip: "The number of Float tokens in circulation"
                                })), "🗳 Float supply:", Misc.NumberFormat.formatEther(undefined, totalFloatMinted), undefined, undefined),
                    DashboardLi.Props.createDashboardLiProps(undefined, "🧢 Market cap: ", "...", undefined, undefined)
                  ]
                }));
}

function stakingCard(totalValueStaked) {
  return React.createElement(Masonry.Card.make, {
              children: null
            }, React.createElement(Masonry.Header.make, {
                  children: "Staking 🔥"
                }), React.createElement("div", {
                  className: "text-center mt-5"
                }, React.createElement("div", {
                      className: "text-sm"
                    }, "💰 Total staked value "), React.createElement("div", {
                      className: "text-green-700 text-xl "
                    }, "$" + Misc.NumberFormat.formatEther(undefined, totalValueStaked))), React.createElement("div", {
                  className: "text-left mt-4 pl-4 text-sm font-bold"
                }, "Trending"), React.createElement("div", {
                  className: "pt-2 pb-5"
                }, React.createElement(Dashboard$TrendingStakes, {})));
}

function Dashboard(Props) {
  var globalStateQuery = Curry.app(Queries.GlobalState.use, [
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
      ]);
  var marketDetailsQuery = Curry.app(Queries.MarketDetails.use, [
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
      ]);
  var match = globalStateQuery.data;
  var tmp;
  if (globalStateQuery.loading) {
    tmp = React.createElement(Loader.Mini.make, {});
  } else if (marketDetailsQuery.loading) {
    tmp = React.createElement(Loader.Mini.make, {});
  } else if (marketDetailsQuery.error !== undefined || globalStateQuery.error !== undefined) {
    tmp = "Error loading data";
  } else if (match !== undefined) {
    var match$1 = match.globalStates;
    if (match$1.length !== 1) {
      tmp = "Query returned wrong number of results";
    } else {
      var match$2 = match$1[0];
      var match$3 = marketDetailsQuery.data;
      if (match$3 !== undefined) {
        var syntheticMarkets = match$3.syntheticMarkets;
        var match$4 = DashboardCalcs.getTotalValueLockedAndTotalStaked(syntheticMarkets);
        var totalValueStaked = match$4.totalValueStaked;
        var totalValueLocked = match$4.totalValueLocked;
        var totalSynthValue = DashboardCalcs.getTotalSynthValue(totalValueLocked, totalValueStaked);
        var numberOfSynths = String((syntheticMarkets.length << 1));
        tmp = React.createElement("div", {
              className: "w-full max-w-7xl flex flex-col self-center items-center justify-start"
            }, totalValueCard(totalValueLocked), React.createElement(Masonry.Container.make, {
                  children: null
                }, React.createElement(Masonry.Divider.make, {
                      children: floatProtocolCard(match$2.timestampLaunched, match$2.totalTxs, match$2.totalUsers, match$2.totalGasUsed, match$2.txHash, numberOfSynths)
                    }), React.createElement(Masonry.Divider.make, {
                      children: null
                    }, syntheticAssetsCard(totalSynthValue), floatTokenCard(match$2.totalFloatMinted)), React.createElement(Masonry.Divider.make, {
                      children: stakingCard(totalValueStaked)
                    })));
      } else {
        tmp = "Query returned wrong number of results";
      }
    }
  } else {
    tmp = marketDetailsQuery.data !== undefined ? "Query returned wrong number of results" : "Error getting data";
  }
  return React.createElement("div", {
              className: "w-screen flex flex-col overflow-x-hidden"
            }, tmp);
}

var make = Dashboard;

var $$default = Dashboard;

exports.TrendingStakes = TrendingStakes;
exports.totalValueCard = totalValueCard;
exports.floatProtocolCard = floatProtocolCard;
exports.syntheticAssetsCard = syntheticAssetsCard;
exports.floatTokenCard = floatTokenCard;
exports.stakingCard = stakingCard;
exports.make = make;
exports.$$default = $$default;
exports.default = $$default;
exports.__esModule = true;
/* Misc Not a pure module */
