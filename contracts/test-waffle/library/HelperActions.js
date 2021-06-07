// Generated by ReScript, PLEASE EDIT WITH CARE
'use strict';

var LetOps = require("./LetOps.js");
var Helpers = require("./Helpers.js");
var Contract = require("./Contract.js");
var CONSTANTS = require("../CONSTANTS.js");
var Belt_Array = require("bs-platform/lib/js/belt_Array.js");

function mintAndStake(marketIndex, amount, token, user, longShort, isLong) {
  return LetOps.Await.let_(Contract.PaymentTokenHelpers.mintAndApprove(token, user, amount, longShort.address), (function (param) {
                var contract = longShort.connect(user);
                if (isLong) {
                  return contract.mintLongAndStake(marketIndex, amount);
                } else {
                  return contract.mintShortAndStake(marketIndex, amount);
                }
              }));
}

function getMarketBalance(longShort, marketIndex) {
  return LetOps.AwaitThen.let_(longShort.syntheticTokenBackedValue(CONSTANTS.longTokenType, marketIndex), (function (longValue) {
                return LetOps.Await.let_(longShort.syntheticTokenBackedValue(CONSTANTS.shortTokenType, marketIndex), (function (shortValue) {
                              return {
                                      longValue: longValue,
                                      shortValue: shortValue
                                    };
                            }));
              }));
}

function stakeRandomlyInMarkets(marketsToStakeIn, userToStakeWith, longShort) {
  return Belt_Array.reduce([marketsToStakeIn[0]], Promise.resolve([
                  [],
                  []
                ]), (function (currentValues, param) {
                var marketIndex = param.marketIndex;
                var shortSynth = param.shortSynth;
                var longSynth = param.longSynth;
                var paymentToken = param.paymentToken;
                return LetOps.AwaitThen.let_(currentValues, (function (param) {
                              var marketsUserHasStakedIn = param[1];
                              var synthsUserHasStakedIn = param[0];
                              var mintStake = function (param) {
                                return function (param$1) {
                                  return mintAndStake(marketIndex, param, paymentToken, userToStakeWith, longShort, param$1);
                                };
                              };
                              return LetOps.AwaitThen.let_(getMarketBalance(longShort, marketIndex), (function (param) {
                                            var valueShortBefore = param.shortValue;
                                            var valueLongBefore = param.longValue;
                                            var amount = Helpers.randomMintLongShort(undefined);
                                            var tmp;
                                            switch (amount.TAG | 0) {
                                              case /* Long */0 :
                                                  var amount$1 = amount._0;
                                                  tmp = LetOps.AwaitThen.let_(mintStake(amount$1)(true), (function (param) {
                                                          return LetOps.Await.let_(longShort.syntheticTokenPrice(CONSTANTS.longTokenType, marketIndex), (function (longTokenPrice) {
                                                                        return Belt_Array.concat(synthsUserHasStakedIn, [{
                                                                                      marketIndex: marketIndex,
                                                                                      synth: longSynth,
                                                                                      amount: amount$1,
                                                                                      priceOfSynthForAction: longTokenPrice,
                                                                                      valueInEntrySide: valueLongBefore,
                                                                                      valueInOtherSide: valueShortBefore
                                                                                    }]);
                                                                      }));
                                                        }));
                                                  break;
                                              case /* Short */1 :
                                                  var amount$2 = amount._0;
                                                  tmp = LetOps.AwaitThen.let_(mintStake(amount$2)(false), (function (param) {
                                                          return LetOps.Await.let_(longShort.syntheticTokenPrice(CONSTANTS.shortTokenType, marketIndex), (function (shortTokenPrice) {
                                                                        return Belt_Array.concat(synthsUserHasStakedIn, [{
                                                                                      marketIndex: marketIndex,
                                                                                      synth: shortSynth,
                                                                                      amount: amount$2,
                                                                                      priceOfSynthForAction: shortTokenPrice,
                                                                                      valueInEntrySide: valueShortBefore,
                                                                                      valueInOtherSide: valueLongBefore
                                                                                    }]);
                                                                      }));
                                                        }));
                                                  break;
                                              case /* Both */2 :
                                                  var shortAmount = amount._1;
                                                  var longAmount = amount._0;
                                                  tmp = LetOps.AwaitThen.let_(mintStake(longAmount)(true), (function (param) {
                                                          return LetOps.AwaitThen.let_(longShort.syntheticTokenPrice(CONSTANTS.longTokenType, marketIndex), (function (longTokenPrice) {
                                                                        var newSynthsUserHasStakedIn = Belt_Array.concat(synthsUserHasStakedIn, [{
                                                                                marketIndex: marketIndex,
                                                                                synth: longSynth,
                                                                                amount: longAmount,
                                                                                priceOfSynthForAction: longTokenPrice,
                                                                                valueInEntrySide: valueLongBefore,
                                                                                valueInOtherSide: valueShortBefore
                                                                              }]);
                                                                        return LetOps.AwaitThen.let_(getMarketBalance(longShort, marketIndex), (function (param) {
                                                                                      var valueShortBefore = param.shortValue;
                                                                                      var valueLongBefore = param.longValue;
                                                                                      return LetOps.AwaitThen.let_(mintStake(shortAmount)(false), (function (param) {
                                                                                                    return LetOps.Await.let_(longShort.syntheticTokenPrice(CONSTANTS.shortTokenType, marketIndex), (function (shortTokenPrice) {
                                                                                                                  return Belt_Array.concat(newSynthsUserHasStakedIn, [{
                                                                                                                                marketIndex: marketIndex,
                                                                                                                                synth: shortSynth,
                                                                                                                                amount: shortAmount,
                                                                                                                                priceOfSynthForAction: shortTokenPrice,
                                                                                                                                valueInEntrySide: valueShortBefore,
                                                                                                                                valueInOtherSide: valueLongBefore
                                                                                                                              }]);
                                                                                                                }));
                                                                                                  }));
                                                                                    }));
                                                                      }));
                                                        }));
                                                  break;
                                              
                                            }
                                            return LetOps.Await.let_(tmp, (function (newSynthsUserHasStakedIn) {
                                                          return [
                                                                  newSynthsUserHasStakedIn,
                                                                  Belt_Array.concat(marketsUserHasStakedIn, [marketIndex])
                                                                ];
                                                        }));
                                          }));
                            }));
              }));
}

function stakeRandomlyInBothSidesOfMarket(marketsToStakeIn, userToStakeWith, longShort) {
  return Belt_Array.reduce(marketsToStakeIn, Promise.resolve(undefined), (function (prevPromise, param) {
                var marketIndex = param.marketIndex;
                var paymentToken = param.paymentToken;
                return LetOps.AwaitThen.let_(prevPromise, (function (param) {
                              var mintStake = function (param) {
                                return function (param$1) {
                                  return mintAndStake(marketIndex, param, paymentToken, userToStakeWith, longShort, param$1);
                                };
                              };
                              return LetOps.AwaitThen.let_(mintStake(Helpers.randomTokenAmount(undefined))(true), (function (param) {
                                            return LetOps.Await.let_(mintStake(Helpers.randomTokenAmount(undefined))(false), (function (param) {
                                                          
                                                        }));
                                          }));
                            }));
              }));
}

exports.mintAndStake = mintAndStake;
exports.getMarketBalance = getMarketBalance;
exports.stakeRandomlyInMarkets = stakeRandomlyInMarkets;
exports.stakeRandomlyInBothSidesOfMarket = stakeRandomlyInBothSidesOfMarket;
/* Helpers Not a pure module */
