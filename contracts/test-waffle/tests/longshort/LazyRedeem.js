// Generated by ReScript, PLEASE EDIT WITH CARE
'use strict';

var Chai = require("../../bindings/chai/Chai.js");
var LetOps = require("../../library/LetOps.js");
var Globals = require("../../library/Globals.js");
var Helpers = require("../../library/Helpers.js");
var CONSTANTS = require("../../CONSTANTS.js");
var HelperActions = require("../../library/HelperActions.js");

function testIntegration(contracts, accounts) {
  describe("lazyRedeem", (function (param) {
          it("[THIS TEST IS FLAKY] should work as expected happy path", (function (param) {
                  var testUser = accounts.contents[8];
                  var amountToNextPriceMint = Helpers.randomTokenAmount(undefined);
                  var match = contracts.contents;
                  var longShort = match.longShort;
                  var longShortUserConnected = longShort.connect(testUser);
                  var match$1 = match.markets[0];
                  var marketIndex = match$1.marketIndex;
                  var longSynth = match$1.longSynth;
                  var oracleManager = match$1.oracleManager;
                  var paymentToken = match$1.paymentToken;
                  return LetOps.AwaitThen.let_(longShort.syntheticTokenPoolValue(marketIndex, CONSTANTS.longTokenType), (function (_longValueBefore) {
                                return LetOps.AwaitThen.let_(paymentToken.mint(testUser.address, amountToNextPriceMint), (function (param) {
                                              return LetOps.AwaitThen.let_(paymentToken.setShouldMockTransfer(false), (function (param) {
                                                            return LetOps.AwaitThen.let_(paymentToken.connect(testUser).approve(longShort.address, amountToNextPriceMint), (function (param) {
                                                                          return LetOps.AwaitThen.let_(HelperActions.mintDirect(marketIndex, amountToNextPriceMint, paymentToken, testUser, longShort, oracleManager, true), (function (param) {
                                                                                        return LetOps.AwaitThen.let_(longSynth.balanceOf(testUser.address), (function (usersBalanceAvailableForRedeem) {
                                                                                                      return LetOps.AwaitThen.let_(longShortUserConnected.redeemLongNextPrice(marketIndex, usersBalanceAvailableForRedeem), (function (param) {
                                                                                                                    return LetOps.AwaitThen.let_(longSynth.balanceOf(testUser.address), (function (usersBalanceAfterNextPriceRedeem) {
                                                                                                                                  Chai.bnEqual("Balance after price system update but before user settlement should be the same as after settlement", usersBalanceAfterNextPriceRedeem, CONSTANTS.zeroBn);
                                                                                                                                  return LetOps.AwaitThen.let_(paymentToken.balanceOf(testUser.address), (function (paymentTokenBalanceBeforeWithdrawal) {
                                                                                                                                                return LetOps.AwaitThen.let_(oracleManager.getLatestPrice(), (function (previousPrice) {
                                                                                                                                                              var nextPrice = Globals.div(Globals.mul(previousPrice, Globals.bnFromInt(12)), Globals.bnFromInt(10));
                                                                                                                                                              return LetOps.AwaitThen.let_(oracleManager.setPrice(nextPrice), (function (param) {
                                                                                                                                                                            return LetOps.AwaitThen.let_(longShort._updateSystemState(marketIndex), (function (param) {
                                                                                                                                                                                          return LetOps.AwaitThen.let_(longShort.marketUpdateIndex(marketIndex), (function (latestUpdateIndex) {
                                                                                                                                                                                                        return LetOps.AwaitThen.let_(longShort.redeemPriceSnapshot(marketIndex, CONSTANTS.longTokenType, latestUpdateIndex), (function (redemptionPriceWithFees) {
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
          
        }));
  
}

exports.testIntegration = testIntegration;
/* Chai Not a pure module */
