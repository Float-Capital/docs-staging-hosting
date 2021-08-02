// Generated by ReScript, PLEASE EDIT WITH CARE
'use strict';

var Misc = require("../../libraries/Misc.js");
var React = require("react");
var Ethers = require("../../ethereum/Ethers.js");
var CONSTANTS = require("../../CONSTANTS.js");
var MarketBar = require("../UI/MarketCard/MarketBar.js");
var APYProvider = require("../../libraries/APYProvider.js");
var MarketStakeCardSide = require("./MarketStakeCardSide.js");
var MarketCalculationHelpers = require("../../libraries/MarketCalculationHelpers.js");

function MarketStakeCard(Props) {
  var param = Props.syntheticMarket;
  var match = param.latestSystemState;
  var totalValueLocked = match.totalValueLocked;
  var totalLockedShort = match.totalLockedShort;
  var totalLockedLong = match.totalLockedLong;
  var currentTimestamp = match.timestamp;
  var timestampCreated = param.timestampCreated;
  var marketName = param.name;
  var longBeta = MarketCalculationHelpers.calculateBeta(totalValueLocked, totalLockedLong, totalLockedShort, true);
  var shortBeta = MarketCalculationHelpers.calculateBeta(totalValueLocked, totalLockedLong, totalLockedShort, false);
  var apy = APYProvider.useAPY(undefined);
  var longApy = MarketCalculationHelpers.calculateLendingProviderAPYForSideMapped(apy, Number(Ethers.Utils.formatEther(totalLockedLong)), Number(Ethers.Utils.formatEther(totalLockedShort)), "long");
  var shortApy = MarketCalculationHelpers.calculateLendingProviderAPYForSideMapped(apy, Number(Ethers.Utils.formatEther(totalLockedLong)), Number(Ethers.Utils.formatEther(totalLockedShort)), "short");
  var longFloatApy = MarketCalculationHelpers.calculateFloatAPY(totalLockedLong, totalLockedShort, CONSTANTS.kperiodHardcode, CONSTANTS.kmultiplierHardcode, timestampCreated, currentTimestamp, CONSTANTS.equilibriumOffsetHardcode, CONSTANTS.balanceIncentiveExponentHardcode, "long");
  var shortFloatApy = MarketCalculationHelpers.calculateFloatAPY(totalLockedLong, totalLockedShort, CONSTANTS.kperiodHardcode, CONSTANTS.kmultiplierHardcode, timestampCreated, currentTimestamp, CONSTANTS.equilibriumOffsetHardcode, CONSTANTS.balanceIncentiveExponentHardcode, "short");
  return React.createElement("div", {
              className: "p-4 rounded-lg flex flex-col justify-center bg-white bg-opacity-75 shadow-lg h-full"
            }, React.createElement("div", {
                  className: "flex flex-wrap justify-center w-full"
                }, React.createElement(MarketStakeCardSide.make, {
                      orderPostion: 1,
                      orderPostionMobile: 2,
                      marketName: marketName,
                      isLong: true,
                      apy: longApy,
                      floatApy: Number(Ethers.Utils.formatEther(longFloatApy)),
                      beta: longBeta
                    }), React.createElement("div", {
                      className: "w-full md:w-1/2 flex items-center justify-center flex-col order-1 md:order-2"
                    }, React.createElement("div", {
                          className: "flex justify-center w-full mb-2"
                        }, React.createElement("h1", {
                              className: "font-bold text-xl font-alphbeta"
                            }, marketName)), React.createElement("div", {
                          className: "flex flex-row items-center justify-between w-full mb-4"
                        }, React.createElement("div", undefined, React.createElement("div", undefined, React.createElement("h2", {
                                      className: "text-xxxs mt-1"
                                    }, React.createElement("span", {
                                          className: "font-bold "
                                        }, "📈 Long"), React.createElement("br", undefined), "liquidity")), React.createElement("div", {
                                  className: "text-xs font-alphbeta tracking-wider py-1 text-gray-600"
                                }, "$" + Misc.NumberFormat.formatEther(undefined, totalLockedLong))), React.createElement("div", undefined, React.createElement("div", undefined, React.createElement("h2", {
                                      className: "text-xs mt-1 text-center"
                                    }, React.createElement("span", {
                                          className: "font-bold pr-1"
                                        }, "TOTAL"), React.createElement("br", undefined), "Liquidity")), React.createElement("div", {
                                  className: "text-2xl font-alphbeta tracking-wider "
                                }, "$" + Misc.NumberFormat.formatEther(undefined, totalValueLocked))), React.createElement("div", {
                              className: "text-right"
                            }, React.createElement("div", undefined, React.createElement("h2", {
                                      className: "text-xxxs mt-1"
                                    }, React.createElement("span", {
                                          className: "font-bold"
                                        }, "Short 📉"), React.createElement("br", undefined), "liquidity")), React.createElement("div", {
                                  className: "text-xs font-alphbeta tracking-wider py-1 text-gray-600"
                                }, "$" + Misc.NumberFormat.formatEther(undefined, totalLockedShort)))), React.createElement("div", {
                          className: "w-full"
                        }, totalValueLocked.eq(CONSTANTS.zeroBN) ? null : React.createElement(MarketBar.make, {
                                totalLockedLong: totalLockedLong,
                                totalValueLocked: totalValueLocked
                              }))), React.createElement(MarketStakeCardSide.make, {
                      orderPostion: 3,
                      orderPostionMobile: 3,
                      marketName: marketName,
                      isLong: false,
                      apy: shortApy,
                      floatApy: Number(Ethers.Utils.formatEther(shortFloatApy)),
                      beta: shortBeta
                    })));
}

var make = MarketStakeCard;

exports.make = make;
/* Misc Not a pure module */
