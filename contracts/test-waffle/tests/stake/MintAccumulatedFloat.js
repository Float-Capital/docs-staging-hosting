// Generated by ReScript, PLEASE EDIT WITH CARE
'use strict';

var Chai = require("../../bindings/chai/Chai.js");
var LetOps = require("../../library/LetOps.js");
var Globals = require("../../library/Globals.js");
var Helpers = require("../../library/Helpers.js");
var CONSTANTS = require("../../CONSTANTS.js");
var Belt_Array = require("rescript/lib/js/belt_Array.js");
var StakerHelpers = require("./StakerHelpers.js");
var StakerSmocked = require("../../library/smock/StakerSmocked.js");

function test(contracts, accounts) {
  describe("mintAccumulatedFloat", (function () {
          var stakerRef = {
            contents: undefined
          };
          var marketIndex = Helpers.randomJsInteger(undefined);
          var match = Helpers.Tuple.make3(Helpers.randomTokenAmount);
          var latestRewardIndexForMarket = match[2];
          var floatToMintShort = match[1];
          var floatToMintLong = match[0];
          var user = Helpers.randomAddress(undefined);
          var promiseRef = {
            contents: undefined
          };
          var setup = function (floatToMintLong, floatToMintShort) {
            return LetOps.AwaitThen.let_(StakerHelpers.deployAndSetupStakerToUnitTest(stakerRef, "mintAccumulatedFloat", contracts, accounts), (function (param) {
                          StakerSmocked.InternalMock.mockCalculateAccumulatedFloatToReturn(floatToMintLong, floatToMintShort);
                          StakerSmocked.InternalMock.mock_mintFloatToReturn(undefined);
                          return LetOps.AwaitThen.let_(stakerRef.contents.setMintAccumulatedFloatParams(marketIndex, latestRewardIndexForMarket), (function (param) {
                                        promiseRef.contents = stakerRef.contents.mintAccumulatedFloatExternal(marketIndex, user);
                                        return LetOps.Await.let_(promiseRef.contents, (function (param) {
                                                      return promiseRef.contents;
                                                    }));
                                      }));
                        }));
          };
          describe("case floatToMint > 0", (function () {
                  Globals.before_once$p(function (param) {
                        return setup(floatToMintLong, floatToMintShort);
                      });
                  it("calls calculateAccumulatedFloat with correct arguments", (function () {
                          return Chai.recordEqualFlat(Belt_Array.getExn(StakerSmocked.InternalMock.calculateAccumulatedFloatCalls(undefined), 0), {
                                      marketIndex: marketIndex,
                                      user: user
                                    });
                        }));
                  it("calls mintFloat with correct arguments", (function () {
                          return Chai.recordEqualFlat(Belt_Array.getExn(StakerSmocked.InternalMock._mintFloatCalls(undefined), 0), {
                                      user: user,
                                      floatToMint: floatToMintLong.add(floatToMintShort)
                                    });
                        }));
                  it("emits FloatMinted event", (function () {
                          return Chai.callEmitEvents(promiseRef.contents, stakerRef.contents, "FloatMinted").withArgs(user, marketIndex, floatToMintLong, floatToMintShort, latestRewardIndexForMarket);
                        }));
                  it("mutates userIndexOfLastClaimedReward", (function () {
                          return LetOps.Await.let_(stakerRef.contents.userIndexOfLastClaimedReward(marketIndex, user), (function (lastClaimed) {
                                        return Chai.bnEqual(undefined, lastClaimed, latestRewardIndexForMarket);
                                      }));
                        }));
                  
                }));
          describe("case floatToMint == 0", (function () {
                  Globals.before_once$p(function (param) {
                        return setup(CONSTANTS.zeroBn, CONSTANTS.zeroBn);
                      });
                  it("calls calculateAccumulatedFloat with correct arguments", (function () {
                          return Chai.recordEqualFlat(Belt_Array.getExn(StakerSmocked.InternalMock.calculateAccumulatedFloatCalls(undefined), 0), {
                                      marketIndex: marketIndex,
                                      user: user
                                    });
                        }));
                  it("doesn't call mintFloat", (function () {
                          return Chai.intEqual(undefined, StakerSmocked.InternalMock._mintFloatCalls(undefined).length, 0);
                        }));
                  it("doesn't mutate userIndexOfLastClaimed", (function () {
                          return LetOps.Await.let_(stakerRef.contents.userIndexOfLastClaimedReward(marketIndex, user), (function (lastClaimed) {
                                        return Chai.bnEqual(undefined, lastClaimed, CONSTANTS.zeroBn);
                                      }));
                        }));
                  it("doesn't emit FloatMinted event", (function () {
                          return Chai.expectToNotEmit(Chai.callEmitEvents(promiseRef.contents, stakerRef.contents, "FloatMinted"));
                        }));
                  
                }));
          
        }));
  
}

exports.test = test;
/* Chai Not a pure module */
