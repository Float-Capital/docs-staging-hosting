// Generated by ReScript, PLEASE EDIT WITH CARE
'use strict';

var Chai = require("../../bindings/chai/Chai.js");
var LetOps = require("../../library/LetOps.js");
var Globals = require("../../library/Globals.js");
var Helpers = require("../../library/Helpers.js");
var CONSTANTS = require("../../CONSTANTS.js");
var StakerSmocked = require("../../library/smock/StakerSmocked.js");

function randomAddress(param) {
  return ethers.Wallet.createRandom().address;
}

function test(contracts) {
  return Globals.describe("addNewStakingFund")(undefined, undefined, undefined, (function (param) {
                var stakerRef = {
                  contents: ""
                };
                var sampleLongAddress = ethers.Wallet.createRandom().address;
                var sampleShortAddress = ethers.Wallet.createRandom().address;
                var sampleMockAddress = ethers.Wallet.createRandom().address;
                var kInitialMultiplier = Helpers.randomInteger(undefined);
                var kPeriod = Helpers.randomInteger(undefined);
                var timestampRef = {
                  contents: 0
                };
                var promiseRef = {
                  contents: Promise.resolve(undefined)
                };
                Globals.before_once$prime(function (param) {
                      var match = contracts.contents;
                      stakerRef.contents = match.staker;
                      return LetOps.AwaitThen.let_(StakerSmocked.InternalMock.setup(stakerRef.contents), (function (param) {
                                    return LetOps.AwaitThen.let_(StakerSmocked.InternalMock.setupFunctionForUnitTesting(stakerRef.contents, "addNewStakingFund"), (function (param) {
                                                  StakerSmocked.InternalMock.mock_changeMarketLaunchIncentiveParametersToReturn(undefined);
                                                  StakerSmocked.InternalMock.mockonlyFloatToReturn(undefined);
                                                  return LetOps.AwaitThen.let_(stakerRef.contents.setAddNewStakingFundParams(1, sampleLongAddress, sampleShortAddress, sampleMockAddress), (function (param) {
                                                                return LetOps.AwaitThen.let_(Helpers.getBlock(undefined), (function (param) {
                                                                              timestampRef.contents = param.timestamp;
                                                                              var promise = stakerRef.contents.addNewStakingFund(1, sampleLongAddress, sampleShortAddress, kInitialMultiplier, kPeriod);
                                                                              promiseRef.contents = promise;
                                                                              return LetOps.Await.let_(promise, (function (param) {
                                                                                            
                                                                                          }));
                                                                            }));
                                                              }));
                                                }));
                                  }));
                    });
                Globals.it$prime$prime("calls the onlyFloatModifier", (function (param) {
                        return Chai.intEqual(undefined, StakerSmocked.InternalMock.onlyFloatCalls(undefined).length, 1);
                      }));
                Globals.it$prime$prime("calls \\_changeMarketLaunchIncentiveParameters with correct arguments", (function (param) {
                        return Chai.recordEqualFlat(StakerSmocked.InternalMock._changeMarketLaunchIncentiveParametersCalls(undefined)[0], {
                                    marketIndex: 1,
                                    period: kPeriod,
                                    initialMultiplier: kInitialMultiplier
                                  });
                      }));
                Globals.it$prime("mutates syntheticRewardParams")(undefined, undefined, undefined, (function (param) {
                        return LetOps.Await.let_(stakerRef.contents.syntheticRewardParams(1, CONSTANTS.zeroBn), (function (params) {
                                      return Chai.recordEqualFlat(params, {
                                                  timestamp: ethers.BigNumber.from(timestampRef.contents + 1 | 0),
                                                  accumulativeFloatPerLongToken: CONSTANTS.zeroBn,
                                                  accumulativeFloatPerShortToken: CONSTANTS.zeroBn
                                                });
                                    }));
                      }));
                Globals.it$prime("mutates syntheticTokens")(undefined, undefined, undefined, (function (param) {
                        return LetOps.Await.let_(stakerRef.contents.syntheticTokens(1), (function (tokens) {
                                      return Chai.recordEqualFlat(tokens, {
                                                  shortToken: sampleShortAddress,
                                                  longToken: sampleLongAddress
                                                });
                                    }));
                      }));
                Globals.it$prime("mutates marketIndexOfToken")(undefined, undefined, undefined, (function (param) {
                        return LetOps.AwaitThen.let_(stakerRef.contents.marketIndexOfToken(sampleLongAddress), (function (longMarketIndex) {
                                      return LetOps.Await.let_(stakerRef.contents.marketIndexOfToken(sampleShortAddress), (function (shortMarketIndex) {
                                                    Chai.intEqual(undefined, 1, longMarketIndex);
                                                    return Chai.intEqual(undefined, 1, shortMarketIndex);
                                                  }));
                                    }));
                      }));
                return Globals.it$prime("emits StateAddedEvent")(undefined, undefined, undefined, (function (param) {
                              return Chai.callEmitEvents(promiseRef.contents, stakerRef.contents, "StateAdded").withArgs(1, CONSTANTS.zeroBn, ethers.BigNumber.from(timestampRef.contents + 1 | 0), CONSTANTS.zeroBn, CONSTANTS.zeroBn);
                            }));
              }));
}

exports.randomAddress = randomAddress;
exports.test = test;
/* Chai Not a pure module */
