// Generated by ReScript, PLEASE EDIT WITH CARE

import * as Curry from "rescript/lib/es6/curry.js";
import * as React from "react";
import * as Button from "../UI/Button.js";
import * as Ethers from "../../ethereum/Ethers.js";
import * as Loader from "../UI/Loader.js";
import * as Ethers$1 from "ethers";
import * as Globals from "../../libraries/Globals.js";
import * as Js_dict from "rescript/lib/es6/js_dict.js";
import * as Tooltip from "../UI/Tooltip.js";
import * as CONSTANTS from "../../CONSTANTS.js";
import * as JsPromise from "../../libraries/Js.Promise/JsPromise.js";
import * as MarketBar from "../UI/MarketCard/MarketBar.js";
import * as StakeForm from "./StakeForm.js";
import * as APYProvider from "../../libraries/APYProvider.js";
import * as Belt_Option from "rescript/lib/es6/belt_Option.js";
import * as Caml_option from "rescript/lib/es6/caml_option.js";
import * as Router from "next/router";
import * as StakeCardSide from "../UI/StakeCard/StakeCardSide.js";
import * as ToastProvider from "../UI/ToastProvider.js";
import * as Belt_HashSetString from "rescript/lib/es6/belt_HashSetString.js";

var zero = Ethers$1.BigNumber.from("0");

var oneHundred = Ethers$1.BigNumber.from("100000000000000000000");

var oneInWei = Ethers$1.BigNumber.from("1000000000000000000");

function calculateDollarValue(tokenPrice, amountStaked) {
  return tokenPrice.mul(amountStaked).div(oneInWei);
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
            TAG: /* Loaded */0,
            _0: basicApyCalc(apy._0, longVal, shortVal, tokenType)
          };
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
  var $staropt$star = Props.optUserBalanceAddressSet;
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
  var optUserBalanceAddressSet = $staropt$star !== undefined ? Caml_option.valFromOption($staropt$star) : undefined;
  var router = Router.useRouter();
  var toastDispatch = React.useContext(ToastProvider.DispatchToastContext.context);
  var apy = APYProvider.useAPY(undefined);
  var longDollarValueStaked = calculateDollarValue(match.longTokenPrice.price.price, match$2.totalStaked);
  var shortDollarValueStaked = calculateDollarValue(match.shortTokenPrice.price.price, match$1.totalStaked);
  longDollarValueStaked.add(shortDollarValueStaked);
  var longApy = mappedBasicCalc(apy, Number(Ethers.Utils.formatEther(totalLockedLong)), Number(Ethers.Utils.formatEther(totalLockedShort)), "long");
  var shortApy = mappedBasicCalc(apy, Number(Ethers.Utils.formatEther(totalLockedLong)), Number(Ethers.Utils.formatEther(totalLockedShort)), "short");
  var longFloatApy = myfloatCalc(totalLockedLong, totalLockedShort, kperiodHardcode, kmultiplierHardcode, timestampCreated, currentTimestamp, "long");
  var shortFloatApy = myfloatCalc(totalLockedLong, totalLockedShort, kperiodHardcode, kmultiplierHardcode, timestampCreated, currentTimestamp, "short");
  var stakeOption = Js_dict.get(router.query, "tokenAddress");
  var stakeButtons = function (param) {
    return React.createElement("div", {
                className: "flex flex-wrap justify-evenly"
              }, React.createElement(Button.Small.make, {
                    onClick: (function (param) {
                        router.push("/stake?tokenAddress=" + Globals.ethAdrToLowerStr(longTokenAddress), undefined, {
                              shallow: true,
                              scroll: false
                            });
                        
                      }),
                    children: "Stake Long"
                  }), React.createElement(Button.Small.make, {
                    onClick: (function (param) {
                        router.push("/stake?tokenAddress=" + Globals.ethAdrToLowerStr(shortTokenAddress), undefined, {
                              shallow: true,
                              scroll: false
                            });
                        
                      }),
                    children: "Stake Short"
                  }));
  };
  var stakeButtonPressState = Belt_Option.mapWithDefault(stakeOption, /* WaitingForInteraction */0, (function (tokenAddress) {
          var longAdrLower = Globals.ethAdrToLowerStr(longTokenAddress);
          var shortAdrLower = Globals.ethAdrToLowerStr(shortTokenAddress);
          if (!(tokenAddress === longAdrLower || tokenAddress === shortAdrLower)) {
            return /* WaitingForInteraction */0;
          }
          var redirect = function (param) {
            return {
                    TAG: /* Redirect */1,
                    marketIndex: marketIndex.toString(),
                    actionOption: tokenAddress === longAdrLower ? "long" : "short"
                  };
          };
          if (optUserBalanceAddressSet !== undefined) {
            if (typeof optUserBalanceAddressSet === "number") {
              return /* Loading */1;
            } else if (optUserBalanceAddressSet.TAG === /* GraphError */0 || !Belt_HashSetString.has(optUserBalanceAddressSet._0, Ethers.Utils.ethAdrToStr(Ethers$1.utils.getAddress(tokenAddress)))) {
              return redirect(undefined);
            } else {
              return {
                      TAG: /* Form */0,
                      _0: tokenAddress
                    };
            }
          } else {
            return redirect(undefined);
          }
        }));
  React.useEffect((function () {
          if (typeof stakeButtonPressState !== "number" && stakeButtonPressState.TAG === /* Redirect */1) {
            var actionOption = stakeButtonPressState.actionOption;
            var marketIndex = stakeButtonPressState.marketIndex;
            var routeToMint = function (param) {
              return JsPromise.$$catch(router.push("/markets?marketIndex=" + marketIndex + "&actionOption=" + actionOption + "&tab=mint").then(function (param) {
                              Curry._1(toastDispatch, /* Show */{
                                    _0: "Mint some  " + marketName + " " + actionOption + " tokens to stake.",
                                    _1: "",
                                    _2: /* Info */2
                                  });
                              return Promise.resolve(undefined);
                            }), (function (e) {
                            console.log(e);
                            return Promise.resolve(undefined);
                          }));
            };
            JsPromise.$$catch(router.replace("/stake", undefined, {
                        shallow: true,
                        scroll: false
                      }).then(function (param) {
                      return Promise.resolve(routeToMint(undefined));
                    }), (function (e) {
                    console.log(e);
                    return Promise.resolve(routeToMint(undefined));
                  }));
          }
          
        }), [stakeButtonPressState]);
  var liquidityRatio = function (param) {
    return React.createElement("div", {
                className: "w-full"
              }, totalValueLocked.eq(CONSTANTS.zeroBN) ? null : React.createElement(MarketBar.make, {
                      totalLockedLong: totalLockedLong,
                      totalValueLocked: totalValueLocked
                    }));
  };
  var closeStakeFormButton = function (param) {
    return React.createElement("button", {
                className: "absolute left-full pl-4 text-3xl leading-none outline-none focus:outline-none",
                onClick: (function (param) {
                    router.push("/stake", undefined, {
                          shallow: true,
                          scroll: false
                        });
                    
                  })
              }, React.createElement("span", {
                    className: "opacity-4 block outline-none focus:outline-none"
                  }, "×"));
  };
  var tmp;
  tmp = typeof stakeButtonPressState === "number" ? (
      stakeButtonPressState === /* WaitingForInteraction */0 ? null : React.createElement(Loader.make, {})
    ) : (
      stakeButtonPressState.TAG === /* Form */0 ? React.createElement("div", {
              className: "w-96 mx-auto relative"
            }, closeStakeFormButton(undefined), React.createElement(StakeForm.make, {
                  tokenId: stakeButtonPressState._0
                })) : null
    );
  return React.createElement(React.Fragment, undefined, React.createElement("div", {
                  className: "p-1 mb-8 rounded-lg flex flex-col bg-white bg-opacity-75 my-5 shadow-lg"
                }, React.createElement("div", {
                      className: "flex justify-center w-full my-1"
                    }, React.createElement("h1", {
                          className: "font-bold text-xl font-alphbeta"
                        }, marketName, React.createElement(Tooltip.make, {
                              tip: "This market tracks " + marketName
                            }))), React.createElement("div", {
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
<<<<<<< HEAD
                                    }, "$" + FormatMoney.formatEther(undefined, longDollarValueStaked))), React.createElement("div", undefined, React.createElement("div", undefined, React.createElement("h2", {
                                          className: "text-xs mt-1 flex justify-center"
=======
                                    }, "$${longDollarValueStaked->FormatMoney.formatEther}")), React.createElement("div", undefined, React.createElement("div", undefined, React.createElement("h2", {
                                          className: "text-xs mt-1"
>>>>>>> Everything compiles!
                                        }, React.createElement("span", {
                                              className: "font-bold pr-1"
                                            }, "TOTAL"), " Staked")), React.createElement("div", {
                                      className: "text-3xl font-alphbeta tracking-wider py-1"
                                    }, "$${totalDollarValueStake->FormatMoney.formatEther}")), React.createElement("div", {
                                  className: "text-right"
                                }, React.createElement("div", undefined, React.createElement("h2", {
                                          className: "text-xxs mt-1"
                                        }, React.createElement("span", {
                                              className: "font-bold"
                                            }, "Short"), " staked 📉")), React.createElement("div", {
                                      className: "text-sm font-alphbeta tracking-wider py-1"
                                    }, "$${shortDollarValueStaked->FormatMoney.formatEther}"))), liquidityRatio(undefined), React.createElement("div", {
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
                        }, stakeButtons(undefined))), tmp));
}

var make = StakeCard;

export {
  zero ,
  oneHundred ,
  oneInWei ,
  calculateDollarValue ,
  basicApyCalc ,
  mappedBasicCalc ,
  kperiodHardcode ,
  kmultiplierHardcode ,
  kCalc ,
  myfloatCalc ,
  make ,
  
}
/* zero Not a pure module */
