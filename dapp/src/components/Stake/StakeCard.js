// Generated by ReScript, PLEASE EDIT WITH CARE

import * as React from "react";
import * as Button from "../UI/Button.js";
import * as Ethers from "../../ethereum/Ethers.js";
import * as Ethers$1 from "ethers";
import * as Globals from "../../libraries/Globals.js";
import * as Tooltip from "../UI/Tooltip.js";
import * as StakeBar from "../UI/StakeCard/StakeBar.js";
import * as Belt_Float from "bs-platform/lib/es6/belt_Float.js";
import * as Belt_Option from "bs-platform/lib/es6/belt_Option.js";
import * as FormatMoney from "../UI/FormatMoney.js";
import * as Router from "next/router";
import * as StakeCardSide from "../UI/StakeCard/StakeCardSide.js";

var zero = Ethers$1.BigNumber.from("0");

var oneHundred = Ethers$1.BigNumber.from("100000000000000000000");

var oneInWei = Ethers$1.BigNumber.from("1000000000000000000");

function percentStr(n, outOf) {
  if (outOf.eq(zero)) {
    return "0.00";
  } else {
    return Ethers.Utils.formatEtherToPrecision(n.mul(oneHundred).div(outOf), 2);
  }
}

function calculateDollarValue(tokenPrice, amountStaked) {
  return tokenPrice.mul(amountStaked).div(oneInWei);
}

function basicApyCalc(busdApy, longVal, shortVal, tokenType) {
  switch (tokenType) {
    case "long" :
        if (longVal !== 0.0) {
          return busdApy * shortVal / longVal;
        } else {
          return busdApy;
        }
    case "short" :
        if (shortVal !== 0.0) {
          return busdApy * longVal / shortVal;
        } else {
          return busdApy;
        }
    default:
      return busdApy;
  }
}

var kperiodHardcode = Ethers$1.BigNumber.from("1664000");

var kmultiplierHardcode = Ethers$1.BigNumber.from("5000000000000000000");

function kCalc(kperiod, kmultiplier, initialTimestamp, currentTimestamp) {
  if (currentTimestamp.sub(initialTimestamp).lte(kperiod)) {
    return kmultiplier.sub(kmultiplier.sub(oneInWei).mul(currentTimestamp.sub(initialTimestamp)).div(kperiod));
  } else {
    return oneInWei;
  }
}

function myfloatCalc(longVal, shortVal, kperiod, kmultiplier, initialTimestamp, currentTimestamp, tokenType) {
  var total = longVal.add(shortVal);
  var k = kCalc(kperiod, kmultiplier, initialTimestamp, currentTimestamp);
  switch (tokenType) {
    case "long" :
        var match = Number(Ethers.Utils.formatEther(longVal));
        if (match !== 0.0) {
          return k.mul(shortVal).div(total);
        } else {
          return zero;
        }
    case "short" :
        var match$1 = Number(Ethers.Utils.formatEther(shortVal));
        if (match$1 !== 0.0) {
          return k.mul(longVal).div(total);
        } else {
          return zero;
        }
    default:
      return oneHundred;
  }
}

function StakeCard(Props) {
  var param = Props.syntheticMarket;
  var match = param.latestSystemState;
  var totalLockedShort = match.totalLockedShort;
  var totalLockedLong = match.totalLockedLong;
  var currentTimestamp = match.timestamp;
  var match$1 = param.syntheticShort;
  var shortTokenAddress = match$1.tokenAddress;
  var match$2 = param.syntheticLong;
  var longTokenAddress = match$2.tokenAddress;
  var timestampCreated = param.timestampCreated;
  var marketName = param.name;
  var router = Router.useRouter();
  var longDollarValueStaked = calculateDollarValue(match.longTokenPrice.price.price, match$2.totalStaked);
  var shortDollarValueStaked = calculateDollarValue(match.shortTokenPrice.price.price, match$1.totalStaked);
  var totalDollarValueStake = longDollarValueStaked.add(shortDollarValueStaked);
  var percentStrLong = percentStr(longDollarValueStaked, totalDollarValueStake);
  var percentStrShort = (100.0 - Belt_Option.getExn(Belt_Float.fromString(percentStrLong))).toFixed(2);
  var longApy = basicApyCalc(0.12, Number(Ethers.Utils.formatEther(totalLockedLong)), Number(Ethers.Utils.formatEther(totalLockedShort)), "long");
  var shortApy = basicApyCalc(0.12, Number(Ethers.Utils.formatEther(totalLockedLong)), Number(Ethers.Utils.formatEther(totalLockedShort)), "short");
  var longFloatApy = myfloatCalc(totalLockedLong, totalLockedShort, kperiodHardcode, kmultiplierHardcode, timestampCreated, currentTimestamp, "long");
  var shortFloatApy = myfloatCalc(totalLockedLong, totalLockedShort, kperiodHardcode, kmultiplierHardcode, timestampCreated, currentTimestamp, "short");
  return React.createElement(React.Fragment, undefined, React.createElement("div", {
                  className: "p-1 mb-8 rounded-lg flex flex-col bg-white bg-opacity-75 my-5 shadow-lg"
                }, React.createElement("div", {
                      className: "flex justify-center w-full my-1"
                    }, React.createElement("h1", {
                          className: "font-bold text-xl font-alphbeta"
                        }, marketName, React.createElement(Tooltip.make, {
                              tip: "This market tracks " + marketName
                            }))), React.createElement("div", {
                      className: "flex justify-center w-full"
                    }, React.createElement(StakeCardSide.make, {
                          marketName: marketName,
                          isLong: true,
                          apy: longApy,
                          floatApy: Number(Ethers.Utils.formatEther(longFloatApy))
                        }), React.createElement("div", {
                          className: "w-1/2 flex items-center flex-col"
                        }, React.createElement("h2", {
                              className: "text-xs mt-1"
                            }, React.createElement("span", {
                                  className: "font-bold"
                                }, "📈 TOTAL"), " Staked"), React.createElement("div", {
                              className: "text-3xl font-alphbeta tracking-wider py-1"
                            }, "$" + FormatMoney.formatEther(undefined, totalDollarValueStake)), totalDollarValueStake.eq(zero) ? null : React.createElement(StakeBar.make, {
                                percentStrLong: percentStrLong,
                                percentStrShort: percentStrShort
                              }), React.createElement("div", {
                              className: "w-full flex justify-around"
                            }, React.createElement(Button.Small.make, {
                                  onClick: (function (param) {
                                      router.push("/stake?tokenAddress=" + Globals.ethAdrToLowerStr(longTokenAddress));
                                      
                                    }),
                                  children: "Stake Long"
                                }), React.createElement(Button.Small.make, {
                                  onClick: (function (param) {
                                      router.push("/stake?tokenAddress=" + Globals.ethAdrToLowerStr(shortTokenAddress));
                                      
                                    }),
                                  children: "Stake Short"
                                }))), React.createElement(StakeCardSide.make, {
                          marketName: marketName,
                          isLong: false,
                          apy: shortApy,
                          floatApy: Number(Ethers.Utils.formatEther(shortFloatApy))
                        }))));
}

var make = StakeCard;

export {
  zero ,
  oneHundred ,
  oneInWei ,
  percentStr ,
  calculateDollarValue ,
  basicApyCalc ,
  kperiodHardcode ,
  kmultiplierHardcode ,
  kCalc ,
  myfloatCalc ,
  make ,
  
}
/* zero Not a pure module */
