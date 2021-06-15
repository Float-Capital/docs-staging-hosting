// Generated by ReScript, PLEASE EDIT WITH CARE
'use strict';

var LetOps = require("./LetOps.js");
var Staker = require("./contracts/Staker.js");
var Globals = require("./Globals.js");
var CONSTANTS = require("../CONSTANTS.js");

function mintAndApprove(t, user, amount, spender) {
  return t.mint(user.address, amount).then(function (param) {
              return t.connect(user).approve(spender, amount);
            });
}

var PaymentTokenHelpers = {
  mintAndApprove: mintAndApprove
};

function marketIndexOfSynth(longShort, syntheticToken) {
  return longShort.staker().then(Staker.at).then(function (__x) {
              return __x.marketIndexOfToken(syntheticToken.address);
            });
}

var DataFetchers = {
  marketIndexOfSynth: marketIndexOfSynth
};

function getFeesMint(longShort, marketIndex, amount, valueInEntrySide, valueInOtherSide) {
  return LetOps.AwaitThen.let_(longShort.badLiquidityEntryFee(marketIndex), (function (badLiquidityEntryFee) {
                return LetOps.Await.let_(longShort.feeUnitsOfPrecision(), (function (feeUnitsOfPrecision) {
                              var baseFee = Globals.bnFromInt(0);
                              if (Globals.bnGte(valueInEntrySide, valueInOtherSide)) {
                                return Globals.add(baseFee, Globals.div(Globals.mul(amount, badLiquidityEntryFee), feeUnitsOfPrecision));
                              }
                              if (!Globals.bnGt(Globals.add(valueInEntrySide, amount), valueInOtherSide)) {
                                return baseFee;
                              }
                              var amountImbalancing = Globals.sub(amount, Globals.sub(valueInOtherSide, valueInEntrySide));
                              var penaltyFee = Globals.div(Globals.mul(amountImbalancing, badLiquidityEntryFee), feeUnitsOfPrecision);
                              return Globals.add(baseFee, penaltyFee);
                            }));
              }));
}

function getFeesRedeemLazy(longShort, marketIndex, amount, valueInRemovalSide, valueInOtherSide) {
  return LetOps.AwaitThen.let_(longShort.badLiquidityExitFee(marketIndex), (function (badLiquidityExitFee) {
                return LetOps.Await.let_(longShort.feeUnitsOfPrecision(), (function (feeUnitsOfPrecision) {
                              if (Globals.bnGte(valueInOtherSide, valueInRemovalSide)) {
                                return Globals.add(CONSTANTS.zeroBn, Globals.div(Globals.mul(amount, badLiquidityExitFee), feeUnitsOfPrecision));
                              }
                              if (!Globals.bnGt(Globals.add(valueInOtherSide, amount), valueInRemovalSide)) {
                                return CONSTANTS.zeroBn;
                              }
                              var amountImbalancing = Globals.sub(amount, Globals.sub(valueInRemovalSide, valueInOtherSide));
                              var penaltyFee = Globals.div(Globals.mul(amountImbalancing, badLiquidityExitFee), feeUnitsOfPrecision);
                              return Globals.add(CONSTANTS.zeroBn, penaltyFee);
                            }));
              }));
}

function getMarketBalance(longShort, marketIndex) {
  return LetOps.AwaitThen.let_(longShort.syntheticTokenBackedValue(CONSTANTS.longTokenType, marketIndex), (function (longValue) {
                return LetOps.Await.let_(longShort.syntheticTokenBackedValue(CONSTANTS.shortTokenType, marketIndex), (function (shortValue) {
                              return {
                                      longValue: longValue,
                                      shortValue: shortValue
                                    };
                            }));
              }));
}

var LongShortHelpers = {
  getFeesMint: getFeesMint,
  getFeesRedeemLazy: getFeesRedeemLazy,
  getMarketBalance: getMarketBalance
};

function getIsLong(synthToken) {
  return LetOps.Await.let_(synthToken.syntheticTokenType(), (function (syntheticTokenType) {
                return syntheticTokenType === CONSTANTS.longTokenType;
              }));
}

var SyntheticTokenHelpers = {
  getIsLong: getIsLong
};

exports.PaymentTokenHelpers = PaymentTokenHelpers;
exports.DataFetchers = DataFetchers;
exports.LongShortHelpers = LongShortHelpers;
exports.SyntheticTokenHelpers = SyntheticTokenHelpers;
/* CONSTANTS Not a pure module */
