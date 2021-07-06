// Generated by ReScript, PLEASE EDIT WITH CARE
'use strict';

var Chai = require("../../bindings/chai/Chai.js");
var Curry = require("rescript/lib/js/curry.js");
var LetOps = require("../../library/LetOps.js");
var Globals = require("../../library/Globals.js");
var Helpers = require("../../library/Helpers.js");
var CONSTANTS = require("../../CONSTANTS.js");
var HelperActions = require("../../library/HelperActions.js");

function testIntegration(contracts, accounts) {
  describe("lazyRedeem", (function () {
          var runLazyRedeemTest = function (isLong) {
            it("should work as expected happy path for redeem " + (
                  isLong ? "Long" : "Short"
                ), (function () {
                    var testUser = accounts.contents[8];
                    var amountToNextPriceMint = Helpers.randomTokenAmount(undefined);
                    var match = contracts.contents;
                    var longShort = match.longShort;
                    var longShortUserConnected = longShort.connect(testUser);
                    var match$1 = match.markets[0];
                    var marketIndex = match$1.marketIndex;
                    var oracleManager = match$1.oracleManager;
                    var paymentToken = match$1.paymentToken;
                    var testSynth = isLong ? match$1.longSynth : match$1.shortSynth;
                    var redeemNextPriceFunction = isLong ? (function (prim0, prim1, prim2) {
                          return prim0.redeemLongNextPrice(prim1, prim2);
                        }) : (function (prim0, prim1, prim2) {
                          return prim0.redeemShortNextPrice(prim1, prim2);
                        });
                    return LetOps.AwaitThen.let_(longShort.syntheticTokenPoolValue(marketIndex, isLong), (function (_longValueBefore) {
                                  return LetOps.AwaitThen.let_(paymentToken.mint(testUser.address, amountToNextPriceMint), (function (param) {
                                                return LetOps.AwaitThen.let_(paymentToken.setShouldMockTransfer(false), (function (param) {
                                                              return LetOps.AwaitThen.let_(paymentToken.connect(testUser).approve(longShort.address, amountToNextPriceMint), (function (param) {
                                                                            return LetOps.AwaitThen.let_(HelperActions.mintDirect(marketIndex, amountToNextPriceMint, paymentToken, testUser, longShort, oracleManager, isLong), (function (param) {
                                                                                          return LetOps.AwaitThen.let_(testSynth.balanceOf(testUser.address), (function (usersBalanceAvailableForRedeem) {
                                                                                                        return LetOps.AwaitThen.let_(Curry._3(redeemNextPriceFunction, longShortUserConnected, marketIndex, usersBalanceAvailableForRedeem), (function (param) {
                                                                                                                      return LetOps.AwaitThen.let_(testSynth.balanceOf(testUser.address), (function (usersBalanceAfterNextPriceRedeem) {
                                                                                                                                    Chai.bnEqual("Balance after price system update but before user settlement should be the same as after settlement", usersBalanceAfterNextPriceRedeem, CONSTANTS.zeroBn);
                                                                                                                                    return LetOps.AwaitThen.let_(paymentToken.balanceOf(testUser.address), (function (paymentTokenBalanceBeforeWithdrawal) {
                                                                                                                                                  return LetOps.AwaitThen.let_(oracleManager.getLatestPrice(), (function (previousPrice) {
                                                                                                                                                                var nextPrice = Globals.div(Globals.mul(previousPrice, Globals.bnFromInt(12)), Globals.bnFromInt(10));
                                                                                                                                                                return LetOps.AwaitThen.let_(oracleManager.setPrice(nextPrice), (function (param) {
                                                                                                                                                                              return LetOps.AwaitThen.let_(longShort.updateSystemState(marketIndex), (function (param) {
                                                                                                                                                                                            return LetOps.AwaitThen.let_(longShort.marketUpdateIndex(marketIndex), (function (latestUpdateIndex) {
                                                                                                                                                                                                          return LetOps.AwaitThen.let_(longShort.syntheticTokenPriceSnapshot(marketIndex, isLong, latestUpdateIndex), (function (redemptionPriceWithFees) {
                                                                                                                                                                                                                        var amountExpectedToBeRedeemed = Globals.div(Globals.mul(usersBalanceAvailableForRedeem, redemptionPriceWithFees), CONSTANTS.tenToThe18);
                                                                                                                                                                                                                        return LetOps.AwaitThen.let_(longShort.executeOutstandingNextPriceSettlementsUser(testUser.address, marketIndex), (function (param) {
                                                                                                                                                                                                                                      return LetOps.Await.let_(paymentToken.balanceOf(testUser.address), (function (paymentTokenBalanceAfterWithdrawal) {
                                                                                                                                                                                                                                                    var deltaBalanceChange = Globals.sub(paymentTokenBalanceAfterWithdrawal, paymentTokenBalanceBeforeWithdrawal);
                                                                                                                                                                                                                                                    return Chai.bnEqual("Balance of paymentToken didn't update correctly", deltaBalanceChange, amountExpectedToBeRedeemed);
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
            
          };
          runLazyRedeemTest(true);
          return runLazyRedeemTest(false);
        }));
  
}

exports.testIntegration = testIntegration;
/* Chai Not a pure module */
