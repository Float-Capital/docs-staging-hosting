// Generated by ReScript, PLEASE EDIT WITH CARE
'use strict';

var Chai = require("../../bindings/chai/Chai.js");
var LetOps = require("../../library/LetOps.js");
var Globals = require("../../library/Globals.js");
var Helpers = require("../../library/Helpers.js");
var CONSTANTS = require("../../CONSTANTS.js");

function testIntegration(contracts, accounts) {
  return Globals.describe("mintLongLazy")(undefined, undefined, undefined, (function (param) {
                return Globals.it$prime("should work as expected happy path")(undefined, undefined, undefined, (function (param) {
                              var testUser = accounts.contents[8];
                              var amountToLazyMint = Helpers.randomTokenAmount(undefined);
                              var match = contracts.contents;
                              var longShort = match.longShort;
                              var match$1 = match.markets[0];
                              var marketIndex = match$1.marketIndex;
                              var longSynth = match$1.longSynth;
                              var oracleManager = match$1.oracleManager;
                              var paymentToken = match$1.paymentToken;
                              return LetOps.AwaitThen.let_(longShort.syntheticTokenBackedValue(CONSTANTS.longTokenType, marketIndex), (function (_longValueBefore) {
                                            return LetOps.AwaitThen.let_(paymentToken.mint(testUser.address, amountToLazyMint), (function (param) {
                                                          return LetOps.AwaitThen.let_(paymentToken.connect(testUser).approve(longShort.address, amountToLazyMint), (function (param) {
                                                                        return LetOps.AwaitThen.let_(longShort.connect(testUser).mintLongLazy(marketIndex, amountToLazyMint), (function (param) {
                                                                                      return LetOps.AwaitThen.let_(oracleManager.getLatestPrice(), (function (previousPrice) {
                                                                                                    var nextPrice = Globals.div(Globals.mul(previousPrice, Globals.bnFromInt(12)), Globals.bnFromInt(10));
                                                                                                    return LetOps.AwaitThen.let_(oracleManager.setPrice(nextPrice), (function (param) {
                                                                                                                  return LetOps.AwaitThen.let_(longShort._updateSystemState(marketIndex), (function (param) {
                                                                                                                                return LetOps.AwaitThen.let_(longSynth.balanceOf(testUser.address), (function (usersBalanceBeforeSettlement) {
                                                                                                                                              return LetOps.AwaitThen.let_(longShort.connect(testUser).mintLongLazy(marketIndex, Globals.bnFromInt(0)), (function (param) {
                                                                                                                                                            return LetOps.AwaitThen.let_(longSynth.balanceOf(testUser.address), (function (usersUpdatedBalance) {
                                                                                                                                                                          Chai.bnEqual("Balance after price system update but before user settlement should be the same as after settlement", usersBalanceBeforeSettlement, usersUpdatedBalance);
                                                                                                                                                                          return LetOps.Await.let_(longShort.longTokenPrice(marketIndex), (function (longTokenPrice) {
                                                                                                                                                                                        var expectedNumberOfTokensToRecieve = Globals.div(Globals.mul(amountToLazyMint, CONSTANTS.tenToThe18), longTokenPrice);
                                                                                                                                                                                        return Chai.bnEqual("balance is incorrect", expectedNumberOfTokensToRecieve, usersUpdatedBalance);
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

function testExposed(contracts, accounts) {
  return Globals.describe("lazyDeposits")(undefined, undefined, undefined, (function (param) {
                Globals.it$prime("calls the executeOutstandingLazySettlements modifier")(undefined, undefined, undefined, (function (param) {
                        var match = contracts.contents;
                        var longShort = match.longShort;
                        var amount = Globals.bnFromInt(1);
                        var testWallet = accounts.contents[1];
                        return LetOps.Await.let_(longShort.setUseexecuteOutstandingLazySettlementsMock(true), (function (param) {
                                      Chai.callEmitEvents(longShort.connect(testWallet).mintLongLazy(1, amount), longShort, "executeOutstandingLazySettlementsMock");
                                      
                                    }));
                      }));
                return Globals.describe("mintLongLazy")(undefined, undefined, undefined, (function (param) {
                              var mintLongLazyTxPromise = {
                                contents: undefined
                              };
                              var amount = Globals.bnFromInt(1);
                              Globals.before_each(undefined)(undefined, undefined, undefined, (function (param) {
                                      var match = contracts.contents;
                                      var testWallet = accounts.contents[1];
                                      mintLongLazyTxPromise.contents = match.longShort.connect(testWallet).mintLongLazy(1, amount);
                                      
                                    }));
                              Globals.it$prime("should emit the correct event")(undefined, undefined, undefined, (function (param) {
                                      var match = contracts.contents;
                                      var testWallet = accounts.contents[1];
                                      return Chai.callEmitEvents(mintLongLazyTxPromise.contents, match.longShort, "LazyLongMinted").withArgs(1, amount, testWallet.address, amount, 1);
                                    }));
                              Globals.it$prime("transfer all the payment tokens to the LongShort contract")(undefined, undefined, undefined, (function (param) {
                                      var match = contracts.contents;
                                      var paymentToken = match.markets[1].paymentToken;
                                      return Chai.changeBallance((function (param) {
                                                    return mintLongLazyTxPromise.contents;
                                                  }), paymentToken, match.longShort, amount);
                                    }));
                              Globals.it$prime("updates the mintLong value for the market")(undefined, undefined, undefined, (function (param) {
                                      var match = contracts.contents;
                                      var longShort = match.longShort;
                                      return LetOps.AwaitThen.let_(mintLongLazyTxPromise.contents, (function (param) {
                                                    return LetOps.Await.let_(longShort.batchedLazyDeposit(1), (function (param) {
                                                                  return Chai.bnEqual("Incorrect batched lazy deposit mint long", amount, param.mintLong);
                                                                }));
                                                  }));
                                    }));
                              Globals.it$prime("updates the user's batched mint long amount")(undefined, undefined, undefined, (function (param) {
                                      return Promise.resolve(undefined);
                                    }));
                              return Globals.it$prime("updates the user's oracle index for lazy minting")(undefined, undefined, undefined, (function (param) {
                                            return Promise.resolve(undefined);
                                          }));
                            }));
              }));
}

exports.testIntegration = testIntegration;
exports.testExposed = testExposed;
/* Chai Not a pure module */
