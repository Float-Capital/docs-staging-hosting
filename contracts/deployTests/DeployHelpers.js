// Generated by ReScript, PLEASE EDIT WITH CARE
'use strict';

var Curry = require("rescript/lib/js/curry.js");
var Js_exn = require("rescript/lib/js/js_exn.js");
var LetOps = require("../test-waffle/library/LetOps.js");
var Globals = require("../test-waffle/library/Globals.js");
var Belt_Array = require("rescript/lib/js/belt_Array.js");
var SyntheticToken = require("../test-waffle/library/contracts/SyntheticToken.js");
var YieldManagerMock = require("../test-waffle/library/contracts/YieldManagerMock.js");
var OracleManagerMock = require("../test-waffle/library/contracts/OracleManagerMock.js");

var minSenderBalance = Globals.bnFromString("50000000000000000");

var minRecieverBalance = Globals.bnFromString("20000000000000000");

function topupBalanceIfLow(from, to_) {
  return LetOps.AwaitThen.let_(from.getBalance(), (function (senderBalance) {
                if (Globals.bnLt(senderBalance, minSenderBalance)) {
                  Js_exn.raiseError("WARNING - Sender doesn't have enough eth - need at least 0.05 ETH! (top up to over 1 ETH to be safe)");
                }
                return LetOps.Await.let_(to_.getBalance(), (function (recieverBalance) {
                              if (Globals.bnLt(recieverBalance, minRecieverBalance)) {
                                from.sendTransaction({
                                      to_: to_.address,
                                      value: minRecieverBalance
                                    });
                                return ;
                              }
                              
                            }));
              }));
}

function updateSystemState(longShort, admin, marketIndex) {
  return longShort.connect(admin).updateSystemState(marketIndex);
}

function mintAndApprove(paymentToken, amount, user, approvedAddress) {
  return LetOps.AwaitThen.let_(paymentToken.mint(user.address, amount), (function (param) {
                return paymentToken.connect(user).approve(approvedAddress, amount);
              }));
}

function stakeSynthLong(amount, longShort, marketIndex, user) {
  return LetOps.AwaitThen.let_(longShort.syntheticTokens(marketIndex, true), (function (longAddress) {
                return LetOps.AwaitThen.let_(SyntheticToken.at(longAddress), (function (synth) {
                              return LetOps.Await.let_(synth.balanceOf(user.address), (function (usersSyntheticTokenBalance) {
                                            if (Globals.bnGt(usersSyntheticTokenBalance, Globals.bnFromString("0"))) {
                                              synth.connect(user).stake(amount);
                                              return ;
                                            }
                                            
                                          }));
                            }));
              }));
}

function executeOnMarkets(marketIndexes, functionToExecute) {
  return Belt_Array.reduce(marketIndexes, Promise.resolve(undefined), (function (previousPromise, marketIndex) {
                return LetOps.AwaitThen.let_(previousPromise, (function (param) {
                              return Curry._1(functionToExecute, marketIndex);
                            }));
              }));
}

function setOracleManagerPrice(longShort, marketIndex, admin) {
  return LetOps.AwaitThen.let_(longShort.oracleManagers(marketIndex), (function (oracleManagerAddr) {
                return LetOps.AwaitThen.let_(OracleManagerMock.at(oracleManagerAddr), (function (oracleManager) {
                              return LetOps.AwaitThen.let_(oracleManager.getLatestPrice(), (function (currentPrice) {
                                            var nextPrice = Globals.div(Globals.mul(currentPrice, Globals.bnFromInt(101)), Globals.bnFromInt(100));
                                            return oracleManager.connect(admin).setPrice(nextPrice);
                                          }));
                            }));
              }));
}

function redeemShortNextPriceWithSystemUpdate(amount, marketIndex, longShort, user, admin) {
  return LetOps.AwaitThen.let_(longShort.connect(user).redeemShortNextPrice(marketIndex, amount), (function (param) {
                return LetOps.AwaitThen.let_(setOracleManagerPrice(longShort, marketIndex, admin), (function (param) {
                              return updateSystemState(longShort, admin, marketIndex);
                            }));
              }));
}

function shiftFromShortNextPriceWithSystemUpdate(amount, marketIndex, longShort, user, admin) {
  return LetOps.AwaitThen.let_(longShort.connect(user).shiftPositionFromShortNextPrice(marketIndex, amount), (function (param) {
                return LetOps.AwaitThen.let_(setOracleManagerPrice(longShort, marketIndex, admin), (function (param) {
                              return longShort.updateSystemState(marketIndex);
                            }));
              }));
}

function shiftFromLongNextPriceWithSystemUpdate(amount, marketIndex, longShort, user, admin) {
  return LetOps.AwaitThen.let_(longShort.connect(user).shiftPositionFromLongNextPrice(marketIndex, amount), (function (param) {
                return LetOps.AwaitThen.let_(setOracleManagerPrice(longShort, marketIndex, admin), (function (param) {
                              return longShort.updateSystemState(marketIndex);
                            }));
              }));
}

function mintLongNextPriceWithSystemUpdate(amount, marketIndex, paymentToken, longShort, user, admin) {
  return LetOps.AwaitThen.let_(mintAndApprove(paymentToken, amount, user, longShort.address), (function (param) {
                return LetOps.AwaitThen.let_(longShort.connect(user).mintLongNextPrice(marketIndex, amount), (function (param) {
                              return LetOps.AwaitThen.let_(setOracleManagerPrice(longShort, marketIndex, admin), (function (param) {
                                            return updateSystemState(longShort, admin, marketIndex);
                                          }));
                            }));
              }));
}

function mintShortNextPriceWithSystemUpdate(amount, marketIndex, paymentToken, longShort, user, admin) {
  return LetOps.AwaitThen.let_(mintAndApprove(paymentToken, amount, user, longShort.address), (function (param) {
                return LetOps.AwaitThen.let_(longShort.connect(user).mintShortNextPrice(marketIndex, amount), (function (param) {
                              return LetOps.AwaitThen.let_(setOracleManagerPrice(longShort, marketIndex, admin), (function (param) {
                                            return updateSystemState(longShort, admin, marketIndex);
                                          }));
                            }));
              }));
}

function deployTestMarket(syntheticName, syntheticSymbol, longShortInstance, treasuryInstance, admin, networkName, paymentToken) {
  return LetOps.AwaitThen.let_(OracleManagerMock.make(admin.address), (function (oracleManager) {
                return LetOps.AwaitThen.let_(YieldManagerMock.make(longShortInstance.address, treasuryInstance.address, paymentToken.address), (function (yieldManager) {
                              return LetOps.AwaitThen.let_(paymentToken.MINTER_ROLE(), (function (mintRole) {
                                            return LetOps.AwaitThen.let_(paymentToken.grantRole(mintRole, yieldManager.address), (function (param) {
                                                          return LetOps.AwaitThen.let_(longShortInstance.connect(admin).createNewSyntheticMarket(syntheticName, syntheticSymbol, paymentToken.address, oracleManager.address, yieldManager.address), (function (param) {
                                                                        return LetOps.AwaitThen.let_(longShortInstance.latestMarket(), (function (latestMarket) {
                                                                                      var kInitialMultiplier = Globals.bnFromString("5000000000000000000");
                                                                                      var kPeriod = Globals.bnFromInt(864000);
                                                                                      return LetOps.AwaitThen.let_(mintAndApprove(paymentToken, Globals.bnFromString("2000000000000000000"), admin, longShortInstance.address), (function (param) {
                                                                                                    var unstakeFee_e18 = Globals.bnFromString("5000000000000000");
                                                                                                    var initialMarketSeedForEachMarketSide = Globals.bnFromString("1000000000000000000");
                                                                                                    return longShortInstance.connect(admin).initializeMarket(latestMarket, kInitialMultiplier, kPeriod, unstakeFee_e18, initialMarketSeedForEachMarketSide, Globals.bnFromInt(5), Globals.bnFromInt(0), Globals.bnFromInt(1));
                                                                                                  }));
                                                                                    }));
                                                                      }));
                                                        }));
                                          }));
                            }));
              }));
}

exports.minSenderBalance = minSenderBalance;
exports.minRecieverBalance = minRecieverBalance;
exports.topupBalanceIfLow = topupBalanceIfLow;
exports.updateSystemState = updateSystemState;
exports.mintAndApprove = mintAndApprove;
exports.stakeSynthLong = stakeSynthLong;
exports.executeOnMarkets = executeOnMarkets;
exports.setOracleManagerPrice = setOracleManagerPrice;
exports.redeemShortNextPriceWithSystemUpdate = redeemShortNextPriceWithSystemUpdate;
exports.shiftFromShortNextPriceWithSystemUpdate = shiftFromShortNextPriceWithSystemUpdate;
exports.shiftFromLongNextPriceWithSystemUpdate = shiftFromLongNextPriceWithSystemUpdate;
exports.mintLongNextPriceWithSystemUpdate = mintLongNextPriceWithSystemUpdate;
exports.mintShortNextPriceWithSystemUpdate = mintShortNextPriceWithSystemUpdate;
exports.deployTestMarket = deployTestMarket;
/* minSenderBalance Not a pure module */
