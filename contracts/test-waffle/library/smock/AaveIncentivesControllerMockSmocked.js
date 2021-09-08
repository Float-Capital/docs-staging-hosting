// Generated by ReScript, PLEASE EDIT WITH CARE
'use strict';

var Chai = require("chai");
var Belt_Array = require("rescript/lib/js/belt_Array.js");
var Smock = require("@defi-wonderland/smock");

const { expect, use } = require("chai");
use(require('@defi-wonderland/smock').smock.matchers);
;

function make(param) {
  return Smock.smock.fake("AaveIncentivesControllerMock");
}

function claimRewardsOld(_r) {
  var array = _r.claimRewards.calls;
  return Belt_Array.map(array, (function (param) {
                return {
                        assets: param[0],
                        amount: param[1],
                        _to: param[2]
                      };
              }));
}

function claimRewardsCallCheck(contract, param) {
  Chai.expect(contract.claimRewards).to.have.been.calledWith(param.assets, param.amount, param._to);
  
}

function getUserUnclaimedRewardsOld(_r) {
  var array = _r.getUserUnclaimedRewards.calls;
  return Belt_Array.map(array, (function (_m) {
                var user = _m[0];
                return {
                        user: user
                      };
              }));
}

function getUserUnclaimedRewardsCallCheck(contract, param) {
  Chai.expect(contract.getUserUnclaimedRewards).to.have.been.calledWith(param.user);
  
}

var uninitializedValue;

exports.make = make;
exports.uninitializedValue = uninitializedValue;
exports.claimRewardsOld = claimRewardsOld;
exports.claimRewardsCallCheck = claimRewardsCallCheck;
exports.getUserUnclaimedRewardsOld = getUserUnclaimedRewardsOld;
exports.getUserUnclaimedRewardsCallCheck = getUserUnclaimedRewardsCallCheck;
/*  Not a pure module */
