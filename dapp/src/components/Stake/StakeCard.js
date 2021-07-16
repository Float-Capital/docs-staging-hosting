// Generated by ReScript, PLEASE EDIT WITH CARE
'use strict';

var Misc = require("../../libraries/Misc.js");
var React = require("react");
var Button = require("../UI/Base/Button.js");
var Ethers = require("../../ethereum/Ethers.js");
var CONSTANTS = require("../../CONSTANTS.js");
var MarketBar = require("../UI/MarketCard/MarketBar.js");
var Link = require("next/link").default;
var APYProvider = require("../../libraries/APYProvider.js");
var Router = require("next/router");
var StakeCardSide = require("../UI/StakeCard/StakeCardSide.js");
var MarketCalculationHelpers = require("../../libraries/MarketCalculationHelpers.js");

function calculateDollarValue(tokenPrice, amountStaked) {
  return tokenPrice.mul(amountStaked).div(CONSTANTS.tenToThe18);
}

function basicApyCalc(collateralTokenApy, longVal, shortVal, tokenType) {
  switch (tokenType) {
    case "long" :
        if (longVal !== 0.0) {
          return collateralTokenApy * shortVal / longVal;
        } else {
          return collateralTokenApy;
        }
    case "short" :
        if (shortVal !== 0.0) {
          return collateralTokenApy * longVal / shortVal;
        } else {
          return collateralTokenApy;
        }
    default:
      return collateralTokenApy;
  }
}

function mappedBasicCalc(apy, longVal, shortVal, tokenType) {
  if (typeof apy === "number" || apy.TAG !== /* Loaded */0) {
    return apy;
  } else {
    return {
            TAG: 0,
            _0: basicApyCalc(apy._0, longVal, shortVal, tokenType),
            [Symbol.for("name")]: "Loaded"
          };
  }
}

function StakeCard(Props) {
  var param = Props.syntheticMarket;
  var match = param.latestSystemState;
  var totalValueLocked = match.totalValueLocked;
  var totalLockedShort = match.totalLockedShort;
  var totalLockedLong = match.totalLockedLong;
  var currentTimestamp = match.timestamp;
  var match$1 = param.syntheticShort;
  var shortTokenAddress = match$1.tokenAddress;
  var match$2 = param.syntheticLong;
  var longTokenAddress = match$2.tokenAddress;
  var timestampCreated = param.timestampCreated;
  var marketIndex = param.marketIndex;
  var marketName = param.name;
  var router = Router.useRouter();
  var apy = APYProvider.useAPY(undefined);
  var longDollarValueStaked = calculateDollarValue(match.longTokenPrice.price.price, match$2.totalStaked);
  var shortDollarValueStaked = calculateDollarValue(match.shortTokenPrice.price.price, match$1.totalStaked);
  var totalDollarValueStake = longDollarValueStaked.add(shortDollarValueStaked);
  var longApy = mappedBasicCalc(apy, Number(Ethers.Utils.formatEther(totalLockedLong)), Number(Ethers.Utils.formatEther(totalLockedShort)), "long");
  var shortApy = mappedBasicCalc(apy, Number(Ethers.Utils.formatEther(totalLockedLong)), Number(Ethers.Utils.formatEther(totalLockedShort)), "short");
  var longFloatApy = MarketCalculationHelpers.calculateFloatAPY(totalLockedLong, totalLockedShort, CONSTANTS.kperiodHardcode, CONSTANTS.kmultiplierHardcode, timestampCreated, currentTimestamp, "long");
  var shortFloatApy = MarketCalculationHelpers.calculateFloatAPY(totalLockedLong, totalLockedShort, CONSTANTS.kperiodHardcode, CONSTANTS.kmultiplierHardcode, timestampCreated, currentTimestamp, "short");
  var stakeButtons = function (param) {
    return React.createElement("div", {
                className: "flex flex-wrap justify-evenly"
              }, React.createElement(Button.Small.make, {
                    onClick: (function ($$event) {
                        $$event.preventDefault();
                        router.push("/app/stake?marketIndex=" + marketIndex.toString() + "&actionOption=long&tokenId=" + Ethers.Utils.ethAdrToLowerStr(longTokenAddress), undefined, {
                              shallow: true,
                              scroll: false
                            });
                        
                      }),
                    children: "Stake Long"
                  }), React.createElement(Button.Small.make, {
                    onClick: (function ($$event) {
                        $$event.preventDefault();
                        router.push("/app/stake?marketIndex=" + marketIndex.toString() + "&actionOption=short&tokenId=" + Ethers.Utils.ethAdrToLowerStr(shortTokenAddress), undefined, {
                              shallow: true,
                              scroll: false
                            });
                        
                      }),
                    children: "Stake Short"
                  }));
  };
  var liquidityRatio = function (param) {
    return React.createElement("div", {
                className: "w-full"
              }, totalValueLocked.eq(CONSTANTS.zeroBN) ? null : React.createElement(MarketBar.make, {
                      totalLockedLong: totalLockedLong,
                      totalValueLocked: totalValueLocked
                    }));
  };
  return React.createElement(Link, {
              href: "/app/markets?marketIndex=" + marketIndex.toString() + "&tab=stake",
              children: React.createElement("div", {
                    className: "p-1 mb-8 rounded-lg flex flex-col bg-light-gold bg-opacity-75 hover:bg-opacity-60 cursor-pointer my-5 shadow-lg"
                  }, React.createElement("div", {
                        className: "flex justify-center w-full my-1"
                      }, React.createElement("h1", {
                            className: "font-bold text-xl font-alphbeta"
                          }, marketName)), React.createElement("div", {
                        className: "flex flex-wrap justify-center w-full"
                      }, React.createElement(StakeCardSide.make, {
                            orderPostion: 1,
                            orderPostionMobile: 2,
                            marketName: marketName,
                            isLong: true,
                            apy: longApy,
                            floatApy: Number(Ethers.Utils.formatEther(longFloatApy))
                          }), React.createElement("div", {
                            className: "w-full md:w-1/2 flex items-center flex-col order-1 md:order-2"
                          }, React.createElement("div", {
                                className: "flex flex-row items-center justify-between w-full "
                              }, React.createElement("div", undefined, React.createElement("div", undefined, React.createElement("h2", {
                                            className: "text-xxs mt-1"
                                          }, React.createElement("span", {
                                                className: "font-bold"
                                              }, "📈 Long"), " staked")), React.createElement("div", {
                                        className: "text-sm font-alphbeta tracking-wider py-1"
                                      }, "$" + Misc.NumberFormat.formatEther(undefined, longDollarValueStaked))), React.createElement("div", undefined, React.createElement("div", undefined, React.createElement("h2", {
                                            className: "text-xs mt-1 flex justify-center"
                                          }, React.createElement("span", {
                                                className: "font-bold pr-1"
                                              }, "TOTAL"), " Staked")), React.createElement("div", {
                                        className: "text-3xl font-alphbeta tracking-wider py-1"
                                      }, "$" + Misc.NumberFormat.formatEther(undefined, totalDollarValueStake))), React.createElement("div", {
                                    className: "text-right"
                                  }, React.createElement("div", undefined, React.createElement("h2", {
                                            className: "text-xxs mt-1"
                                          }, React.createElement("span", {
                                                className: "font-bold"
                                              }, "Short"), " staked 📉")), React.createElement("div", {
                                        className: "text-sm font-alphbeta tracking-wider py-1"
                                      }, "$" + Misc.NumberFormat.formatEther(undefined, shortDollarValueStaked)))), liquidityRatio(undefined), React.createElement("div", {
                                className: "md:block hidden w-full flex justify-around"
                              }, stakeButtons(undefined))), React.createElement(StakeCardSide.make, {
                            orderPostion: 3,
                            orderPostionMobile: 3,
                            marketName: marketName,
                            isLong: false,
                            apy: shortApy,
                            floatApy: Number(Ethers.Utils.formatEther(shortFloatApy))
                          }), React.createElement("div", {
                            className: "block md:hidden pt-5 order-4 w-full"
                          }, stakeButtons(undefined))))
            });
}

var make = StakeCard;

exports.calculateDollarValue = calculateDollarValue;
exports.basicApyCalc = basicApyCalc;
exports.mappedBasicCalc = mappedBasicCalc;
exports.make = make;
/* Misc Not a pure module */
