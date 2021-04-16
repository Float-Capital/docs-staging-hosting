// Generated by ReScript, PLEASE EDIT WITH CARE

import * as Curry from "bs-platform/lib/es6/curry.js";
import * as React from "react";
import * as Config from "./Config.js";
import * as Ethers from "./ethereum/Ethers.js";
import * as Masonry from "./components/UI/Masonry.js";
import * as Queries from "./data/Queries.js";
import * as Tooltip from "./components/UI/Tooltip.js";
import Link from "next/link";
import * as Belt_Array from "bs-platform/lib/es6/belt_Array.js";
import * as MiniLoader from "./components/UI/MiniLoader.js";
import * as APYProvider from "./libraries/APYProvider.js";
import * as Caml_option from "bs-platform/lib/es6/caml_option.js";
import * as DashboardLi from "./components/UI/Dashboard/DashboardLi.js";
import * as DashboardUl from "./components/UI/Dashboard/DashboardUl.js";
import * as FormatMoney from "./components/UI/FormatMoney.js";
import * as DashboardCalcs from "./libraries/DashboardCalcs.js";
import Format from "date-fns/format";
import * as DashboardStakeCard from "./components/UI/Dashboard/DashboardStakeCard.js";
import FromUnixTime from "date-fns/fromUnixTime";
import FormatDistanceToNow from "date-fns/formatDistanceToNow";

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
              }, React.createElement(MiniLoader.make, {}));
  }
  if (marketDetailsQuery.error !== undefined) {
    return "Error loading data";
  }
  if (match === undefined) {
    return "You might think this is impossible, but depending on the situation it might not be!";
  }
  if (typeof apy === "number") {
    return React.createElement(MiniLoader.make, {});
  }
  if (apy.TAG !== /* Loaded */0) {
    return React.createElement(MiniLoader.make, {});
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
                  className: "text-green-700"
                }, "$" + FormatMoney.formatEther(undefined, totalValueLocked)));
}

function floatProtocolCard(liveSince, totalTxs, totalUsers, totalGasUsed, txHash) {
  var dateObj = FromUnixTime(liveSince.toNumber());
  return React.createElement(Masonry.Card.make, {
              children: null
            }, React.createElement(Masonry.Header.make, {
                  children: "Float Protocol 🏗️"
                }), React.createElement(DashboardUl.make, {
                  list: [
                    DashboardLi.Props.createDashboardLiProps(undefined, "📅 Live since:", Format(dateObj, "do MMM ''yy") + " (" + FormatDistanceToNow(dateObj) + ")", Config.blockExplorer + "/tx/" + txHash, undefined),
                    DashboardLi.Props.createDashboardLiProps(undefined, "📈 No. txs:", totalTxs.toString(), undefined, undefined),
                    DashboardLi.Props.createDashboardLiProps(undefined, "👯‍♀️ No. users:", totalUsers.toString(), undefined, undefined),
                    DashboardLi.Props.createDashboardLiProps(undefined, "⛽ Gas used:", FormatMoney.formatInt(totalGasUsed.toString()), undefined, undefined)
                  ]
                }));
}

function syntheticAssetsCard(totalSynthValue, numberOfSynths) {
  return React.createElement(Masonry.Card.make, {
              children: null
            }, React.createElement(Masonry.Header.make, {
                  children: null
                }, "Synthetic Assets", React.createElement("img", {
                      className: "inline h-5 ml-2",
                      src: "/img/coin.png"
                    })), React.createElement(DashboardUl.make, {
                  list: [
                    DashboardLi.Props.createDashboardLiProps(Caml_option.some(React.createElement(Tooltip.make, {
                                  tip: "Redeemable value of synths in the open market"
                                })), "💰 Total synth value: ", "$" + FormatMoney.formatEther(undefined, totalSynthValue), undefined, undefined),
                    DashboardLi.Props.createDashboardLiProps(undefined, "👷‍♀️ No. synths:", numberOfSynths, undefined, undefined)
                  ]
                }), React.createElement(Link, {
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
                                })), "🕶️ Float supply:", Ethers.Utils.formatEtherToPrecision(totalFloatMinted, 2), undefined, undefined),
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
                }, React.createElement("span", {
                      className: "text-sm mr-1"
                    }, "💰 Total staked value: "), React.createElement("span", {
                      className: "text-green-700"
                    }, "$" + FormatMoney.formatEther(undefined, totalValueStaked))), React.createElement("div", {
                  className: "text-left mt-4 pl-4 text-sm"
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
    tmp = React.createElement(MiniLoader.make, {});
  } else if (marketDetailsQuery.loading) {
    tmp = React.createElement(MiniLoader.make, {});
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
              className: "min-w-3/4 max-w-full flex flex-col self-center items-center justify-start"
            }, totalValueCard(totalValueLocked), React.createElement(Masonry.Container.make, {
                  children: null
                }, React.createElement(Masonry.Divider.make, {
                      children: floatProtocolCard(match$2.timestampLaunched, match$2.totalTxs, match$2.totalUsers, match$2.totalGasUsed, match$2.txHash)
                    }), React.createElement(Masonry.Divider.make, {
                      children: null
                    }, syntheticAssetsCard(totalSynthValue, numberOfSynths), floatTokenCard(match$2.totalFloatMinted)), React.createElement(Masonry.Divider.make, {
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
              className: "w-screen absolute flex flex-col left-0 top-0 mt-40 overflow-x-hidden"
            }, tmp);
}

var make = Dashboard;

var $$default = Dashboard;

export {
  TrendingStakes ,
  totalValueCard ,
  floatProtocolCard ,
  syntheticAssetsCard ,
  floatTokenCard ,
  stakingCard ,
  make ,
  $$default ,
  $$default as default,
  
}
/* react Not a pure module */
