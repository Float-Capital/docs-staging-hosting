// Generated by ReScript, PLEASE EDIT WITH CARE
'use strict';

var Globals = require("./Globals.js");
var CONSTANTS = require("../CONSTANTS.js");

function calculateBeta(totalValueLocked, totalLockedLong, totalLockedShort, isLong) {
  if (totalValueLocked.eq(CONSTANTS.zeroBN) || totalLockedLong.eq(CONSTANTS.zeroBN) || totalLockedShort.eq(CONSTANTS.zeroBN)) {
    return "0";
  } else if (totalLockedLong.eq(totalLockedShort)) {
    return "100";
  } else if (isLong && totalLockedShort.lt(totalLockedLong)) {
    return Globals.percentStr(totalLockedShort, totalLockedLong);
  } else if (!isLong && totalLockedLong.lt(totalLockedShort)) {
    return Globals.percentStr(totalLockedLong, totalLockedShort);
  } else {
    return "100";
  }
}

function kCalc(kperiod, kmultiplier, initialTimestamp, currentTimestamp) {
  if (currentTimestamp.sub(initialTimestamp).lte(kperiod)) {
    return kmultiplier.sub(kmultiplier.sub(CONSTANTS.tenToThe18).mul(currentTimestamp.sub(initialTimestamp)).div(kperiod));
  } else {
    return CONSTANTS.tenToThe18;
  }
}

function xor(a, b) {
  if (!a && b) {
    return true;
  } else if (b) {
    return !a;
  } else {
    return false;
  }
}

function calcPaymentTokenFloatPerSecondUnscaled(tokenType, longVal, shortVal, equibOffset, balanceIncentiveExponent) {
  var totalLocked = longVal.add(shortVal);
  var equibOffsetScaled = equibOffset.mul(totalLocked).div(CONSTANTS.tenToThe18);
  var shortValAfterOffset = shortVal.sub(equibOffsetScaled);
  var longIsSideWithMoreValAfterOffset = shortValAfterOffset.lt(longVal);
  var sideWithLessValAfterEquibOffset = longIsSideWithMoreValAfterOffset ? shortValAfterOffset : longVal.add(equibOffsetScaled);
  var rewardsForSideMoreValAfterOffset;
  if (sideWithLessValAfterEquibOffset.lte(CONSTANTS.zeroBN)) {
    rewardsForSideMoreValAfterOffset = CONSTANTS.zeroBN;
  } else {
    var numerator = sideWithLessValAfterEquibOffset.div(CONSTANTS.stakeDivisorForSafeExponentiationDiv2).pow(balanceIncentiveExponent);
    var denominator = totalLocked.div(CONSTANTS.stakeDivisorForSafeExponentiation).pow(balanceIncentiveExponent);
    rewardsForSideMoreValAfterOffset = numerator.mul(CONSTANTS.tenToThe18Div2).div(denominator);
  }
  if (xor(tokenType === "long", longIsSideWithMoreValAfterOffset)) {
    return CONSTANTS.tenToThe18.sub(rewardsForSideMoreValAfterOffset);
  } else {
    return rewardsForSideMoreValAfterOffset;
  }
}

function calculateFloatAPY(longVal, shortVal, kperiod, kmultiplier, initialTimestamp, currentTimestamp, equilibriumOffset, balanceIncentiveExponent, floatTokenDollarWorth, tokenType) {
  var k = kCalc(kperiod, kmultiplier, initialTimestamp, currentTimestamp);
  return k.mul(calcPaymentTokenFloatPerSecondUnscaled(tokenType, longVal, shortVal, equilibriumOffset, balanceIncentiveExponent)).mul(CONSTANTS.oneYearInSecondsMulTenToThe18).div(CONSTANTS.tenToThe42).mul(floatTokenDollarWorth).div(CONSTANTS.tenToThe18);
}

function calculateLendingProviderAPYForSide(collateralTokenApy, longVal, shortVal, tokenType) {
  switch (tokenType) {
    case "long" :
        if (longVal >= shortVal) {
          return 0.0;
        } else {
          return collateralTokenApy * (shortVal - longVal) / longVal;
        }
    case "short" :
        if (shortVal >= longVal) {
          return 0.0;
        } else {
          return collateralTokenApy * (longVal - shortVal) / shortVal;
        }
    default:
      return collateralTokenApy;
  }
}

function calculateLendingProviderAPYForSideMapped(apy, longVal, shortVal, tokenType) {
  if (typeof apy === "number" || apy.TAG !== /* Loaded */0) {
    return apy;
  } else {
    return {
            TAG: 0,
            _0: calculateLendingProviderAPYForSide(apy._0, longVal, shortVal, tokenType),
            [Symbol.for("name")]: "Loaded"
          };
  }
}

exports.calculateBeta = calculateBeta;
exports.kCalc = kCalc;
exports.xor = xor;
exports.calcPaymentTokenFloatPerSecondUnscaled = calcPaymentTokenFloatPerSecondUnscaled;
exports.calculateFloatAPY = calculateFloatAPY;
exports.calculateLendingProviderAPYForSide = calculateLendingProviderAPYForSide;
exports.calculateLendingProviderAPYForSideMapped = calculateLendingProviderAPYForSideMapped;
/* Globals Not a pure module */
