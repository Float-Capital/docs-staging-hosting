// Generated by ReScript, PLEASE EDIT WITH CARE
'use strict';

var Chai = require("../../bindings/chai/Chai.js");
var LetOps = require("../../library/LetOps.js");
var Helpers = require("../../library/Helpers.js");

function test(contracts) {
  var marketIndex = Helpers.randomJsInteger(undefined);
  var latestMarketIndex = Helpers.randomInteger(undefined);
  describe("calculateTimeDelta", (function () {
          it("returns the time difference since the last reward state for a market", (function () {
                  return LetOps.Await.let_(Helpers.getRandomTimestampInPast(undefined), (function (pastTimestamp) {
                                return LetOps.AwaitThen.let_(contracts.contents.staker.setCalculateTimeDeltaParams(marketIndex, latestMarketIndex, pastTimestamp), (function (param) {
                                              return LetOps.AwaitThen.let_(Helpers.getBlock(undefined), (function (param) {
                                                            var expectedDelta = ethers.BigNumber.from(param.timestamp).sub(pastTimestamp);
                                                            return LetOps.Await.let_(contracts.contents.staker._calculateTimeDeltaFromLastAccumulativeIssuancePerStakedSynthSnapshotExposed(marketIndex, latestMarketIndex), (function (delta) {
                                                                          return Chai.bnEqual(undefined, delta, expectedDelta);
                                                                        }));
                                                          }));
                                            }));
                              }));
                }));
          
        }));
  
}

exports.test = test;
/* Chai Not a pure module */
