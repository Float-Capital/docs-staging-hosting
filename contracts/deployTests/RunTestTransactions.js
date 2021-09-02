// Generated by ReScript, PLEASE EDIT WITH CARE
'use strict';

var LetOps = require("../test-waffle/library/LetOps.js");
var Globals = require("../test-waffle/library/Globals.js");
var CONSTANTS = require("../test-waffle/CONSTANTS.js");
var DeployHelpers = require("./DeployHelpers.js");

function runTestTransactions(param) {
  var treasury = param.treasury;
  var paymentToken = param.paymentToken;
  var longShort = param.longShort;
  var staker = param.staker;
  return LetOps.Await.let_(ethers.getSigners(), (function (loadedAccounts) {
                var admin = loadedAccounts[1];
                var user1 = loadedAccounts[2];
                var user2 = loadedAccounts[3];
                var user3 = loadedAccounts[4];
                return LetOps.AwaitThen.let_(DeployHelpers.topupBalanceIfLow(admin, user1), (function (param) {
                              return LetOps.AwaitThen.let_(DeployHelpers.topupBalanceIfLow(admin, user2), (function (param) {
                                            return LetOps.AwaitThen.let_(DeployHelpers.topupBalanceIfLow(admin, user3), (function (param) {
                                                          console.log("deploying markets");
                                                          return LetOps.AwaitThen.let_(DeployHelpers.deployTestMarket("Eth Market", "FL_ETH", longShort, treasury, admin, paymentToken), (function (param) {
                                                                        return LetOps.AwaitThen.let_(DeployHelpers.deployTestMarket("The Flippening", "FL_FLIP", longShort, treasury, admin, paymentToken), (function (param) {
                                                                                      return LetOps.AwaitThen.let_(DeployHelpers.deployTestMarket("Doge Market", "FL_DOGE", longShort, treasury, admin, paymentToken), (function (param) {
                                                                                                    var initialMarkets = [
                                                                                                      1,
                                                                                                      2,
                                                                                                      3
                                                                                                    ];
                                                                                                    var longMintAmount = Globals.bnFromString("10000000000000000000");
                                                                                                    var shortMintAmount = Globals.div(longMintAmount, Globals.bnFromInt(2));
                                                                                                    var redeemShortAmount = Globals.div(shortMintAmount, Globals.bnFromInt(2));
                                                                                                    var longStakeAmount = Globals.div(longMintAmount, Globals.bnFromInt(2));
                                                                                                    var priceAndStateUpdate = function (param) {
                                                                                                      return LetOps.AwaitThen.let_(DeployHelpers.executeOnMarkets(initialMarkets, (function (__x) {
                                                                                                                        return DeployHelpers.setOracleManagerPrice(longShort, __x, admin);
                                                                                                                      })), (function (param) {
                                                                                                                    console.log("Executing update system state");
                                                                                                                    return DeployHelpers.executeOnMarkets(initialMarkets, (function (__x) {
                                                                                                                                  return DeployHelpers.updateSystemState(longShort, admin, __x);
                                                                                                                                }));
                                                                                                                  }));
                                                                                                    };
                                                                                                    console.log("Executing Long Mints");
                                                                                                    return LetOps.AwaitThen.let_(DeployHelpers.executeOnMarkets(initialMarkets, (function (__x) {
                                                                                                                      return DeployHelpers.mintLongNextPriceWithSystemUpdate(longMintAmount, __x, paymentToken, longShort, user1, admin);
                                                                                                                    })), (function (param) {
                                                                                                                  console.log("Executing Short Mints");
                                                                                                                  return LetOps.AwaitThen.let_(DeployHelpers.executeOnMarkets(initialMarkets, (function (__x) {
                                                                                                                                    return DeployHelpers.mintShortNextPriceWithSystemUpdate(shortMintAmount, __x, paymentToken, longShort, user1, admin);
                                                                                                                                  })), (function (param) {
                                                                                                                                console.log("Executing Short Position Redeem");
                                                                                                                                return LetOps.AwaitThen.let_(DeployHelpers.executeOnMarkets(initialMarkets, (function (__x) {
                                                                                                                                                  return DeployHelpers.redeemShortNextPriceWithSystemUpdate(redeemShortAmount, __x, longShort, user1, admin);
                                                                                                                                                })), (function (param) {
                                                                                                                                              return LetOps.AwaitThen.let_(priceAndStateUpdate(undefined), (function (param) {
                                                                                                                                                            return LetOps.AwaitThen.let_(DeployHelpers.executeOnMarkets(initialMarkets, (function (__x) {
                                                                                                                                                                              return DeployHelpers.mintLongNextPriceWithSystemUpdate(longMintAmount, __x, paymentToken, longShort, user1, admin);
                                                                                                                                                                            })), (function (param) {
                                                                                                                                                                          return LetOps.AwaitThen.let_(DeployHelpers.executeOnMarkets(initialMarkets, (function (__x) {
                                                                                                                                                                                            return DeployHelpers.shiftFromShortNextPriceWithSystemUpdate(redeemShortAmount, __x, longShort, user1, admin);
                                                                                                                                                                                          })), (function (param) {
                                                                                                                                                                                        return LetOps.AwaitThen.let_(priceAndStateUpdate(undefined), (function (param) {
                                                                                                                                                                                                      console.log("Staking long position");
                                                                                                                                                                                                      return LetOps.AwaitThen.let_(DeployHelpers.executeOnMarkets(initialMarkets, (function (__x) {
                                                                                                                                                                                                                        return DeployHelpers.stakeSynthLong(longStakeAmount, longShort, __x, user1);
                                                                                                                                                                                                                      })), (function (param) {
                                                                                                                                                                                                                    return LetOps.AwaitThen.let_(priceAndStateUpdate(undefined), (function (param) {
                                                                                                                                                                                                                                  console.log("Shifting stake");
                                                                                                                                                                                                                                  return LetOps.AwaitThen.let_(DeployHelpers.executeOnMarkets(initialMarkets, (function (marketIndex) {
                                                                                                                                                                                                                                                    return staker.connect(user1).shiftTokens(longStakeAmount.div(CONSTANTS.twoBn), marketIndex, true);
                                                                                                                                                                                                                                                  })), (function (param) {
                                                                                                                                                                                                                                                return LetOps.AwaitThen.let_(priceAndStateUpdate(undefined), (function (param) {
                                                                                                                                                                                                                                                              return LetOps.AwaitThen.let_(DeployHelpers.executeOnMarkets(initialMarkets, (function (marketIndex) {
                                                                                                                                                                                                                                                                                return staker.connect(user1).claimFloatCustom([marketIndex]);
                                                                                                                                                                                                                                                                              })), (function (param) {
                                                                                                                                                                                                                                                                            return Promise.resolve(undefined);
                                                                                                                                                                                                                                                                          }));
                                                                                                                                                                                                                                                            }));
                                                                                                                                                                                                                                              }));
                                                                                                                                                                                                                                }));
                                                                                                                                                                                                                  }));
                                                                                                                                                                                                    }));
                                                                                                                                                                                      }));
                                                                                                                                                                        }));
                                                                                                                                                          }));
                                                                                                                                            }));
                                                                                                                              }));
                                                                                                                }));
                                                                                                  }));
                                                                                    }));
                                                                      }));
                                                        }));
                                          }));
                            }));
              }));
}

exports.runTestTransactions = runTestTransactions;
/* Globals Not a pure module */
