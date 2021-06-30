// Generated by ReScript, PLEASE EDIT WITH CARE
'use strict';

var Chai = require("../../bindings/chai/Chai.js");
var Js_int = require("rescript/lib/js/js_int.js");
var LetOps = require("../../library/LetOps.js");
var Globals = require("../../library/Globals.js");
var Helpers = require("../../library/Helpers.js");
var Js_math = require("rescript/lib/js/js_math.js");
var CONSTANTS = require("../../CONSTANTS.js");
var Belt_Array = require("rescript/lib/js/belt_Array.js");
var StakerHelpers = require("./StakerHelpers.js");
var StakerSmocked = require("../../library/smock/StakerSmocked.js");

function test(contracts, accounts) {
  describe("_stake", (function () {
          var stakerRef = {
            contents: undefined
          };
          var token = Helpers.randomAddress(undefined);
          var match = Helpers.Tuple.make2(Helpers.randomTokenAmount);
          var userAmountToStake = match[1];
          var userAmountStaked = match[0];
          var user = Helpers.randomAddress(undefined);
          var marketIndex = Helpers.randomJsInteger(undefined);
          var promiseRef = {
            contents: undefined
          };
          var setup = function (userLastRewardIndex, latestRewardIndex) {
            return LetOps.Await.let_(StakerHelpers.deployAndSetupStakerToUnitTest(stakerRef, "_stake", contracts, accounts), (function (param) {
                          StakerSmocked.InternalMock.mockMintAccumulatedFloatToReturn(undefined);
                          return LetOps.AwaitThen.let_(stakerRef.contents.set_stakeParams(user, marketIndex, latestRewardIndex, token, userAmountStaked, userLastRewardIndex), (function (param) {
                                        var promise = stakerRef.contents._stakeExternal(token, userAmountToStake, user);
                                        promiseRef.contents = promise;
                                        return promise;
                                      }));
                        }));
          };
          describe("case user has outstanding float to be minted", (function () {
                  var latestRewardIndex = ethers.BigNumber.from(Js_math.random_int(2, Js_int.max));
                  var randomRewardIndexBelow = function (num) {
                    return ethers.BigNumber.from(Js_math.random_int(1, num.toNumber()));
                  };
                  Globals.before_once$p(function (param) {
                        return setup(randomRewardIndexBelow(latestRewardIndex), latestRewardIndex);
                      });
                  it("calls mintAccumulatedFloat with correct args", (function () {
                          return Chai.recordEqualFlat(Belt_Array.getExn(StakerSmocked.InternalMock.mintAccumulatedFloatCalls(undefined), 0), {
                                      marketIndex: marketIndex,
                                      user: user
                                    });
                        }));
                  it("mutates userAmountStaked", (function () {
                          return LetOps.Await.let_(stakerRef.contents.userAmountStaked(token, user), (function (amountStaked) {
                                        return Chai.bnEqual(undefined, amountStaked, userAmountStaked.add(userAmountToStake));
                                      }));
                        }));
                  it("mutates userIndexOfLastClaimedReward", (function () {
                          return LetOps.Await.let_(stakerRef.contents.userIndexOfLastClaimedReward(marketIndex, user), (function (lastClaimedReward) {
                                        return Chai.bnEqual(undefined, lastClaimedReward, latestRewardIndex);
                                      }));
                        }));
                  it("emits StakeAdded", (function () {
                          return Chai.callEmitEvents(promiseRef.contents, stakerRef.contents, "StakeAdded").withArgs(user, token, userAmountToStake, latestRewardIndex);
                        }));
                  
                }));
          describe("case user has last claimed index of 0", (function () {
                  Globals.before_once$p(function (param) {
                        return setup(CONSTANTS.zeroBn, Helpers.randomInteger(undefined));
                      });
                  it("doesn't call mintAccumulatedFloat", (function () {
                          return Chai.intEqual(undefined, StakerSmocked.InternalMock.mintAccumulatedFloatCalls(undefined).length, 0);
                        }));
                  
                }));
          describe("case users last claimed index == latestRewardIndex for market", (function () {
                  var index = Helpers.randomInteger(undefined);
                  Globals.before_once$p(function (param) {
                        return setup(index, index);
                      });
                  it("doesn't call mintAccumulatedFloat", (function () {
                          return Chai.intEqual(undefined, StakerSmocked.InternalMock.mintAccumulatedFloatCalls(undefined).length, 0);
                        }));
                  
                }));
          
        }));
  
}

exports.test = test;
/* Chai Not a pure module */
