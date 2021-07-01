// Generated by ReScript, PLEASE EDIT WITH CARE
'use strict';

var Chai = require("../../bindings/chai/Chai.js");
var LetOps = require("../../library/LetOps.js");
var Globals = require("../../library/Globals.js");
var Helpers = require("../../library/Helpers.js");
var Js_math = require("rescript/lib/js/js_math.js");
var Belt_Array = require("rescript/lib/js/belt_Array.js");
var StakerHelpers = require("./StakerHelpers.js");
var StakerSmocked = require("../../library/smock/StakerSmocked.js");
var LongShortSmocked = require("../../library/smock/LongShortSmocked.js");
var Smock = require("@eth-optimism/smock");

function randomLengthIntegerArr(minLength, maxLength) {
  return Belt_Array.makeBy(Js_math.random_int(minLength, maxLength + 1 | 0), (function (param) {
                return Helpers.randomJsInteger(undefined);
              }));
}

function test(contracts, accounts) {
  describe("claimFloatCustom", (function () {
          var stakerRef = {
            contents: ""
          };
          var longShortSmockedRef = {
            contents: undefined
          };
          var promiseRef = {
            contents: undefined
          };
          var setup = function (marketIndices, shouldWaitForTransactionToFinish) {
            return LetOps.AwaitThen.let_(StakerHelpers.deployAndSetupStakerToUnitTest(stakerRef, "claimFloatCustom", contracts, accounts), (function (param) {
                          return LetOps.AwaitThen.let_(Smock.smockit(contracts.contents.longShort), (function (longShortSmocked) {
                                        longShortSmockedRef.contents = longShortSmocked;
                                        LongShortSmocked.mock_updateSystemStateMultiToReturn(longShortSmocked);
                                        StakerSmocked.InternalMock.mock_claimFloatToReturn(undefined);
                                        return LetOps.AwaitThen.let_(stakerRef.contents.setClaimFloatCustomParams(longShortSmockedRef.contents.address), (function (param) {
                                                      var promise = stakerRef.contents.claimFloatCustom(marketIndices);
                                                      promiseRef.contents = promise;
                                                      if (shouldWaitForTransactionToFinish) {
                                                        return promise;
                                                      } else {
                                                        return Promise.resolve(undefined);
                                                      }
                                                    }));
                                      }));
                        }));
          };
          describe("case less than 51 markets", (function () {
                  var marketIndices = randomLengthIntegerArr(0, 50);
                  Globals.before_once$p(function (param) {
                        return setup(marketIndices, true);
                      });
                  it("calls LongShort.updateSystemStateMulti for the markets", (function () {
                          return Chai.recordEqualDeep(Belt_Array.getExn(LongShortSmocked._updateSystemStateMultiCalls(longShortSmockedRef.contents), 0), {
                                      marketIndexes: marketIndices
                                    });
                        }));
                  it("calls _claimFloat with the correct arguments", (function () {
                          return Chai.recordEqualDeep(Belt_Array.getExn(StakerSmocked.InternalMock._claimFloatCalls(undefined), 0), {
                                      marketIndexes: marketIndices
                                    });
                        }));
                  
                }));
          describe("case more than 50 markets", (function () {
                  beforeEach(function () {
                        return setup(randomLengthIntegerArr(51, 120), false);
                      });
                  it("reverts", (function () {
                          return Chai.expectRevertNoReason(promiseRef.contents);
                        }));
                  
                }));
          
        }));
  
}

exports.randomLengthIntegerArr = randomLengthIntegerArr;
exports.test = test;
/* Chai Not a pure module */
