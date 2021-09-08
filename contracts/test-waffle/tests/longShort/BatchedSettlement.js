// Generated by ReScript, PLEASE EDIT WITH CARE
'use strict';

var Chai = require("../../bindings/chai/Chai.js");
var Chai$1 = require("chai");
var LetOps = require("../../library/LetOps.js");
var Globals = require("../../library/Globals.js");
var Helpers = require("../../library/Helpers.js");
var Contract = require("../../library/Contract.js");
var LongShortSmocked = require("../../library/smock/LongShortSmocked.js");
var LongShortStateSetters = require("../../library/LongShortStateSetters.js");
var SyntheticTokenSmocked = require("../../library/smock/SyntheticTokenSmocked.js");
var YieldManagerAaveSmocked = require("../../library/smock/YieldManagerAaveSmocked.js");

function testUnit(contracts, param) {
  return Globals.describeUnit("Batched Settlement", (function (param) {
                var marketIndex = Helpers.randomJsInteger(undefined);
                describe("_batchConfirmOutstandingPendingActions", (function () {
                        var syntheticTokenPrice_inPaymentTokens_long = Helpers.randomTokenAmount(undefined);
                        var syntheticTokenPrice_inPaymentTokens_short = Helpers.randomTokenAmount(undefined);
                        var setup = function (batched_amountPaymentToken_depositLong, batched_amountPaymentToken_depositShort, batched_amountSyntheticToken_redeemLong, batched_amountSyntheticToken_redeemShort, batchedAmountSyntheticTokenToShiftFromLong, batchedAmountSyntheticTokenToShiftFromShort) {
                          var match = contracts.contents;
                          var longShort = match.longShort;
                          return LetOps.AwaitThen.let_(LongShortSmocked.InternalMock.setupFunctionForUnitTesting(longShort, "_batchConfirmOutstandingPendingActions"), (function (param) {
                                        return LetOps.AwaitThen.let_(longShort.setPerformOutstandingBatchedSettlementsGlobals(marketIndex, batched_amountPaymentToken_depositLong, batched_amountPaymentToken_depositShort, batched_amountSyntheticToken_redeemLong, batched_amountSyntheticToken_redeemShort, batchedAmountSyntheticTokenToShiftFromLong, batchedAmountSyntheticTokenToShiftFromShort), (function (param) {
                                                      return longShort.callStatic._batchConfirmOutstandingPendingActionsExposed(marketIndex, syntheticTokenPrice_inPaymentTokens_long, syntheticTokenPrice_inPaymentTokens_short);
                                                    }));
                                      }));
                        };
                        var runTest = function (batched_amountPaymentToken_depositLong, batched_amountPaymentToken_depositShort, batched_amountSyntheticToken_redeemLong, batched_amountSyntheticToken_redeemShort, batchedAmountSyntheticTokenToShiftFromLong, batchedAmountSyntheticTokenToShiftFromShort) {
                          var batchedAmountSyntheticTokenToMintLong = {
                            contents: undefined
                          };
                          var batchedAmountSyntheticTokenToMintShort = {
                            contents: undefined
                          };
                          var batchedAmountOfPaymentTokensToBurnLong = {
                            contents: undefined
                          };
                          var batchedAmountOfPaymentTokensToBurnShort = {
                            contents: undefined
                          };
                          var batchedAmountOfPaymentTokensToShiftToLong = {
                            contents: undefined
                          };
                          var batchedAmountOfPaymentTokensToShiftToShort = {
                            contents: undefined
                          };
                          var batchedAmountSyntheticTokenToShiftToLong = {
                            contents: undefined
                          };
                          var batchedAmountSyntheticTokenToShiftToShort = {
                            contents: undefined
                          };
                          var calculatedValueChangeForLong = {
                            contents: undefined
                          };
                          var calculatedValueChangeForShort = {
                            contents: undefined
                          };
                          var calculatedValueChangeInSynthSupplyLong = {
                            contents: undefined
                          };
                          var calculatedValueChangeInSynthSupplyShort = {
                            contents: undefined
                          };
                          var returnOfPerformOutstandingBatchedSettlements = {
                            contents: undefined
                          };
                          Globals.before_once$p(function (param) {
                                return LetOps.Await.let_(setup(batched_amountPaymentToken_depositLong, batched_amountPaymentToken_depositShort, batched_amountSyntheticToken_redeemLong, batched_amountSyntheticToken_redeemShort, batchedAmountSyntheticTokenToShiftFromLong, batchedAmountSyntheticTokenToShiftFromShort), (function (functionCallReturn) {
                                              batchedAmountSyntheticTokenToMintLong.contents = Contract.LongShortHelpers.calcAmountSyntheticToken(batched_amountPaymentToken_depositLong, syntheticTokenPrice_inPaymentTokens_long);
                                              batchedAmountSyntheticTokenToMintShort.contents = Contract.LongShortHelpers.calcAmountSyntheticToken(batched_amountPaymentToken_depositShort, syntheticTokenPrice_inPaymentTokens_short);
                                              batchedAmountOfPaymentTokensToBurnLong.contents = Contract.LongShortHelpers.calcAmountPaymentToken(batched_amountSyntheticToken_redeemLong, syntheticTokenPrice_inPaymentTokens_long);
                                              batchedAmountOfPaymentTokensToBurnShort.contents = Contract.LongShortHelpers.calcAmountPaymentToken(batched_amountSyntheticToken_redeemShort, syntheticTokenPrice_inPaymentTokens_short);
                                              batchedAmountOfPaymentTokensToShiftToLong.contents = Contract.LongShortHelpers.calcAmountPaymentToken(batchedAmountSyntheticTokenToShiftFromShort, syntheticTokenPrice_inPaymentTokens_short);
                                              batchedAmountOfPaymentTokensToShiftToShort.contents = Contract.LongShortHelpers.calcAmountPaymentToken(batchedAmountSyntheticTokenToShiftFromLong, syntheticTokenPrice_inPaymentTokens_long);
                                              batchedAmountSyntheticTokenToShiftToShort.contents = Contract.LongShortHelpers.calcEquivalentAmountSyntheticTokensOnTargetSide(batchedAmountSyntheticTokenToShiftFromLong, syntheticTokenPrice_inPaymentTokens_long, syntheticTokenPrice_inPaymentTokens_short);
                                              batchedAmountSyntheticTokenToShiftToLong.contents = Contract.LongShortHelpers.calcEquivalentAmountSyntheticTokensOnTargetSide(batchedAmountSyntheticTokenToShiftFromShort, syntheticTokenPrice_inPaymentTokens_short, syntheticTokenPrice_inPaymentTokens_long);
                                              calculatedValueChangeForLong.contents = Globals.sub(Globals.add(Globals.sub(batched_amountPaymentToken_depositLong, batchedAmountOfPaymentTokensToBurnLong.contents), batchedAmountOfPaymentTokensToShiftToLong.contents), batchedAmountOfPaymentTokensToShiftToShort.contents);
                                              calculatedValueChangeForShort.contents = Globals.sub(Globals.add(Globals.sub(batched_amountPaymentToken_depositShort, batchedAmountOfPaymentTokensToBurnShort.contents), batchedAmountOfPaymentTokensToShiftToShort.contents), batchedAmountOfPaymentTokensToShiftToLong.contents);
                                              calculatedValueChangeInSynthSupplyLong.contents = Globals.sub(Globals.add(Globals.sub(batchedAmountSyntheticTokenToMintLong.contents, batched_amountSyntheticToken_redeemLong), batchedAmountSyntheticTokenToShiftToLong.contents), batchedAmountSyntheticTokenToShiftFromLong);
                                              calculatedValueChangeInSynthSupplyShort.contents = Globals.sub(Globals.add(Globals.sub(batchedAmountSyntheticTokenToMintShort.contents, batched_amountSyntheticToken_redeemShort), batchedAmountSyntheticTokenToShiftToShort.contents), batchedAmountSyntheticTokenToShiftFromShort);
                                              returnOfPerformOutstandingBatchedSettlements.contents = functionCallReturn;
                                              
                                            }));
                              });
                          it("call handleChangeInSyntheticTokensTotalSupply with the correct parameters", (function () {
                                  LongShortSmocked.InternalMock._handleChangeInSyntheticTokensTotalSupplyCallCheck({
                                        marketIndex: marketIndex,
                                        isLong: true,
                                        changeInSyntheticTokensTotalSupply: calculatedValueChangeInSynthSupplyLong.contents
                                      });
                                  return LongShortSmocked.InternalMock._handleChangeInSyntheticTokensTotalSupplyCallCheck({
                                              marketIndex: marketIndex,
                                              isLong: false,
                                              changeInSyntheticTokensTotalSupply: calculatedValueChangeInSynthSupplyShort.contents
                                            });
                                }));
                          it("call handleTotalValueChangeForMarketWithYieldManager with the correct parameters", (function () {
                                  var totalPaymentTokenValueChangeForMarket = Globals.add(calculatedValueChangeForLong.contents, calculatedValueChangeForShort.contents);
                                  return LongShortSmocked.InternalMock._handleTotalPaymentTokenValueChangeForMarketWithYieldManagerCallCheck({
                                              marketIndex: marketIndex,
                                              totalPaymentTokenValueChangeForMarket: totalPaymentTokenValueChangeForMarket
                                            });
                                }));
                          it("should return the correct values", (function () {
                                  return Chai.recordEqualDeep(undefined, returnOfPerformOutstandingBatchedSettlements.contents, {
                                              long_changeInMarketValue_inPaymentToken: calculatedValueChangeForLong.contents,
                                              short_changeInMarketValue_inPaymentToken: calculatedValueChangeForShort.contents
                                            });
                                }));
                          
                        };
                        describe("there are no actions in the batch", (function () {
                                return runTest(Globals.zeroBn, Globals.zeroBn, Globals.zeroBn, Globals.zeroBn, Globals.zeroBn, Globals.zeroBn);
                              }));
                        describe("there is 1 deposit long", (function () {
                                return runTest(Helpers.randomTokenAmount(undefined), Globals.zeroBn, Globals.zeroBn, Globals.zeroBn, Globals.zeroBn, Globals.zeroBn);
                              }));
                        describe("there is 1 deposit short", (function () {
                                return runTest(Globals.zeroBn, Helpers.randomTokenAmount(undefined), Globals.zeroBn, Globals.zeroBn, Globals.zeroBn, Globals.zeroBn);
                              }));
                        describe("there is 1 withdraw long", (function () {
                                return runTest(Globals.zeroBn, Globals.zeroBn, Helpers.randomTokenAmount(undefined), Globals.zeroBn, Globals.zeroBn, Globals.zeroBn);
                              }));
                        describe("there is 1 withdraw short", (function () {
                                return runTest(Globals.zeroBn, Globals.zeroBn, Globals.zeroBn, Helpers.randomTokenAmount(undefined), Globals.zeroBn, Globals.zeroBn);
                              }));
                        describe("there is 1 shift from long to short", (function () {
                                runTest(Globals.zeroBn, Globals.zeroBn, Globals.zeroBn, Globals.zeroBn, Helpers.randomTokenAmount(undefined), Globals.zeroBn);
                                it("should set batched_amountSyntheticToken_toShiftAwayFrom_marketSide long to zero", (function () {
                                        return LetOps.Await.let_(contracts.contents.longShort._batchConfirmOutstandingPendingActionsExposed(marketIndex, syntheticTokenPrice_inPaymentTokens_long, syntheticTokenPrice_inPaymentTokens_short), (function (param) {
                                                      return LetOps.Await.let_(contracts.contents.longShort.batched_amountSyntheticToken_toShiftAwayFrom_marketSide(marketIndex, true), (function (resultAfterCall) {
                                                                    return Chai.bnEqual(undefined, resultAfterCall, Globals.zeroBn);
                                                                  }));
                                                    }));
                                      }));
                                
                              }));
                        describe("there is 1 shift from short to long", (function () {
                                runTest(Globals.zeroBn, Globals.zeroBn, Globals.zeroBn, Globals.zeroBn, Globals.zeroBn, Helpers.randomTokenAmount(undefined));
                                it("should set batched_amountSyntheticToken_toShiftAwayFrom_marketSide short to zero", (function () {
                                        return LetOps.Await.let_(contracts.contents.longShort._batchConfirmOutstandingPendingActionsExposed(marketIndex, syntheticTokenPrice_inPaymentTokens_long, syntheticTokenPrice_inPaymentTokens_short), (function (param) {
                                                      return LetOps.Await.let_(contracts.contents.longShort.batched_amountSyntheticToken_toShiftAwayFrom_marketSide(marketIndex, false), (function (resultAfterCall) {
                                                                    return Chai.bnEqual(undefined, resultAfterCall, Globals.zeroBn);
                                                                  }));
                                                    }));
                                      }));
                                
                              }));
                        describe("there are random deposits and withdrawals (we could be more specific with this test possibly?)", (function () {
                                return runTest(Helpers.randomTokenAmount(undefined), Helpers.randomTokenAmount(undefined), Helpers.randomTokenAmount(undefined), Helpers.randomTokenAmount(undefined), Helpers.randomTokenAmount(undefined), Helpers.randomTokenAmount(undefined));
                              }));
                        
                      }));
                describe("_handleChangeInSyntheticTokensTotalSupply", (function () {
                        Globals.before_once$p(function (param) {
                              var match = contracts.contents;
                              return match.longShort.setHandleChangeInSyntheticTokensTotalSupplyGlobals(marketIndex, match.syntheticToken1Smocked.address, match.syntheticToken2Smocked.address);
                            });
                        var testHandleChangeInSyntheticTokensTotalSupply = function (isLong) {
                          describe("changeInSyntheticTokensTotalSupply > 0", (function () {
                                  var changeInSyntheticTokensTotalSupply = Helpers.randomTokenAmount(undefined);
                                  Globals.before_once$p(function (param) {
                                        var match = contracts.contents;
                                        return match.longShort._handleChangeInSyntheticTokensTotalSupplyExposed(marketIndex, isLong, changeInSyntheticTokensTotalSupply);
                                      });
                                  it("should call the mint function on the correct synthetic token with correct arguments.", (function () {
                                          var match = contracts.contents;
                                          var syntheticToken = isLong ? match.syntheticToken1Smocked : match.syntheticToken2Smocked;
                                          return SyntheticTokenSmocked.mintCallCheck(syntheticToken, {
                                                      _to: match.longShort.address,
                                                      amount: changeInSyntheticTokensTotalSupply
                                                    });
                                        }));
                                  it("should NOT call the burn function.", (function () {
                                          var match = contracts.contents;
                                          var syntheticToken = isLong ? match.syntheticToken1Smocked : match.syntheticToken2Smocked;
                                          Chai$1.expect(syntheticToken.burn).to.have.callCount(0);
                                          
                                        }));
                                  
                                }));
                          describe("changeInSyntheticTokensTotalSupply < 0", (function () {
                                  var changeInSyntheticTokensTotalSupply = Globals.sub(Globals.zeroBn, Helpers.randomTokenAmount(undefined));
                                  Globals.before_once$p(function (param) {
                                        var match = contracts.contents;
                                        var syntheticToken = isLong ? match.syntheticToken1Smocked : match.syntheticToken2Smocked;
                                        syntheticToken.mint.reset();
                                        return match.longShort._handleChangeInSyntheticTokensTotalSupplyExposed(marketIndex, isLong, changeInSyntheticTokensTotalSupply);
                                      });
                                  it("should NOT call the mint function on the correct synthetic token.", (function () {
                                          var match = contracts.contents;
                                          var syntheticToken = isLong ? match.syntheticToken1Smocked : match.syntheticToken2Smocked;
                                          Chai$1.expect(syntheticToken.mint).to.have.callCount(0);
                                          
                                        }));
                                  it("should call the burn function on the correct synthetic token with correct arguments.", (function () {
                                          var match = contracts.contents;
                                          var syntheticToken = isLong ? match.syntheticToken1Smocked : match.syntheticToken2Smocked;
                                          return SyntheticTokenSmocked.burnCallCheck(syntheticToken, {
                                                      amount: Globals.sub(Globals.zeroBn, changeInSyntheticTokensTotalSupply)
                                                    });
                                        }));
                                  
                                }));
                          describe("changeInSyntheticTokensTotalSupply == 0", (function () {
                                  it("should call NEITHER the mint NOR burn function.", (function () {
                                          var match = contracts.contents;
                                          var syntheticToken = isLong ? match.syntheticToken1Smocked : match.syntheticToken2Smocked;
                                          syntheticToken.mint.reset();
                                          syntheticToken.burn.reset();
                                          return LetOps.Await.let_(match.longShort._handleChangeInSyntheticTokensTotalSupplyExposed(marketIndex, isLong, Globals.zeroBn), (function (param) {
                                                        Chai$1.expect(syntheticToken.mint).to.have.callCount(0);
                                                        Chai$1.expect(syntheticToken.burn).to.have.callCount(0);
                                                        
                                                      }));
                                        }));
                                  
                                }));
                          
                        };
                        describe("LongSide", (function () {
                                testHandleChangeInSyntheticTokensTotalSupply(true);
                                return testHandleChangeInSyntheticTokensTotalSupply(false);
                              }));
                        
                      }));
                describe("_handleTotalPaymentTokenValueChangeForMarketWithYieldManager", (function () {
                        Globals.before_once$p(function (param) {
                              var match = contracts.contents;
                              return LongShortStateSetters.setYieldManager(match.longShort, marketIndex, match.yieldManagerSmocked.address);
                            });
                        describe("totalPaymentTokenValueChangeForMarket > 0", (function () {
                                var totalPaymentTokenValueChangeForMarket = Helpers.randomTokenAmount(undefined);
                                Globals.before_once$p(function (param) {
                                      var match = contracts.contents;
                                      return match.longShort._handleTotalPaymentTokenValueChangeForMarketWithYieldManagerExposed(marketIndex, totalPaymentTokenValueChangeForMarket);
                                    });
                                it("should call the depositPaymentToken function on the correct synthetic token with correct arguments.", (function () {
                                        return YieldManagerAaveSmocked.depositPaymentTokenCallCheck(contracts.contents.yieldManagerSmocked, {
                                                    amount: totalPaymentTokenValueChangeForMarket
                                                  });
                                      }));
                                it("should NOT call the removePaymentTokenFromMarket function.", (function () {
                                        Chai$1.expect(contracts.contents.yieldManagerSmocked.removePaymentTokenFromMarket).to.have.callCount(0);
                                        
                                      }));
                                
                              }));
                        describe("totalPaymentTokenValueChangeForMarket < 0", (function () {
                                var totalPaymentTokenValueChangeForMarket = Globals.sub(Globals.zeroBn, Helpers.randomTokenAmount(undefined));
                                Globals.before_once$p(function (param) {
                                      var match = contracts.contents;
                                      match.yieldManagerSmocked.depositPaymentToken.reset();
                                      return match.longShort._handleTotalPaymentTokenValueChangeForMarketWithYieldManagerExposed(marketIndex, totalPaymentTokenValueChangeForMarket);
                                    });
                                it("should NOT call the depositPaymentToken function on the correct synthetic token.", (function () {
                                        Chai$1.expect(contracts.contents.yieldManagerSmocked.depositPaymentToken).to.have.callCount(0);
                                        
                                      }));
                                it("should call the removePaymentTokenFromMarket function on the correct synthetic token with correct arguments.", (function () {
                                        return YieldManagerAaveSmocked.removePaymentTokenFromMarketCallCheck(contracts.contents.yieldManagerSmocked, {
                                                    amount: Globals.sub(Globals.zeroBn, totalPaymentTokenValueChangeForMarket)
                                                  });
                                      }));
                                
                              }));
                        describe("totalPaymentTokenValueChangeForMarket == 0", (function () {
                                it("should call NEITHER the depositPaymentToken NOR removePaymentTokenFromMarket function.", (function () {
                                        var match = contracts.contents;
                                        var yieldManagerSmocked = match.yieldManagerSmocked;
                                        yieldManagerSmocked.depositPaymentToken.reset();
                                        yieldManagerSmocked.removePaymentTokenFromMarket.reset();
                                        return LetOps.Await.let_(match.longShort._handleTotalPaymentTokenValueChangeForMarketWithYieldManagerExposed(marketIndex, Globals.zeroBn), (function (param) {
                                                      Chai$1.expect(yieldManagerSmocked.depositPaymentToken).to.have.callCount(0);
                                                      Chai$1.expect(yieldManagerSmocked.removePaymentTokenFromMarket).to.have.callCount(0);
                                                      
                                                    }));
                                      }));
                                
                              }));
                        
                      }));
                
              }));
}

exports.testUnit = testUnit;
/* Chai Not a pure module */
