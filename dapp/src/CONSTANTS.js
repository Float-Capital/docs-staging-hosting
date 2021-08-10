// Generated by ReScript, PLEASE EDIT WITH CARE
'use strict';

var Ethers = require("ethers");

var zeroAddressStr = "0x0000000000000000000000000000000000000000";

var zeroAddress = Ethers.utils.getAddress(zeroAddressStr);

var zeroBN = Ethers.BigNumber.from(0);

var twoBN = Ethers.BigNumber.from(2);

var fiveBN = Ethers.BigNumber.from(5);

var tenToThe5 = Ethers.BigNumber.from("100000");

var tenToThe6 = Ethers.BigNumber.from("1000000");

var tenToThe9 = Ethers.BigNumber.from("1000000000");

var tenToThe18 = Ethers.BigNumber.from("1000000000000000000");

var oneHundredThousandInWei = tenToThe18.mul(tenToThe5);

var fiveHundredThousandInWei = tenToThe18.mul(tenToThe6).div(twoBN);

var oneMillionInWei = tenToThe18.mul(tenToThe6);

var tenToThe42 = tenToThe6.mul(tenToThe18).mul(tenToThe18);

var oneHundredEth = Ethers.BigNumber.from("100000000000000000000");

var oneThousandInWei = Ethers.BigNumber.from("1000000000000000000000");

var stakeDivisorForSafeExponentiation = twoBN.pow(Ethers.BigNumber.from(52));

var stakeDivisorForSafeExponentiationDiv2 = stakeDivisorForSafeExponentiation.div(twoBN);

var tenToThe18Div2 = tenToThe18.div(twoBN);

var PriceGraphLabels = {
  max: "MAX",
  day: "1D",
  week: "1W",
  month: "1M",
  threeMonth: "3M",
  year: "1Y"
};

var kperiodHardcode = Ethers.BigNumber.from("1664000");

var kmultiplierHardcode = Ethers.BigNumber.from("5000000000000000000");

var floatCapitalPercentE18HardCode = tenToThe18.div(fiveBN);

var oneYearInSecondsMulTenToThe18 = Ethers.BigNumber.from(31536000).mul(tenToThe18);

var fiveMinutesInSeconds = 300;

var oneHourInSeconds = 3600;

var halfDayInSeconds = 43200;

var oneDayInSeconds = 86400;

var threeDaysInSeconds = 259200;

var oneWeekInSeconds = 604800;

var twoWeeksInSeconds = 1209600;

var oneMonthInSeconds = 2628029;

var threeMonthsInSeconds = 7884087;

var oneYearInSeconds = 31536000;

var hotAPYThreshold = 0.15;

var multiplierHotAPYThreshold = 1.0;

var equilibriumOffsetHardcode = zeroBN;

var balanceIncentiveExponentHardcode = twoBN;

var yieldGradientHardcode = tenToThe18;

var daiDisplayToken = {
  name: "DAI",
  iconUrl: "/icons/dai.svg"
};

var polygonDisplayToken = {
  name: "Polygon",
  iconUrl: "/icons/polygon.png"
};

var mumbai = {
  name: "mumbai",
  chainId: 80001
};

var polygon = {
  name: "polygon",
  chainId: 137
};

exports.zeroAddressStr = zeroAddressStr;
exports.zeroAddress = zeroAddress;
exports.zeroBN = zeroBN;
exports.twoBN = twoBN;
exports.fiveBN = fiveBN;
exports.tenToThe5 = tenToThe5;
exports.tenToThe6 = tenToThe6;
exports.tenToThe9 = tenToThe9;
exports.tenToThe18 = tenToThe18;
exports.oneHundredThousandInWei = oneHundredThousandInWei;
exports.fiveHundredThousandInWei = fiveHundredThousandInWei;
exports.oneMillionInWei = oneMillionInWei;
exports.tenToThe42 = tenToThe42;
exports.oneHundredEth = oneHundredEth;
exports.oneThousandInWei = oneThousandInWei;
exports.stakeDivisorForSafeExponentiation = stakeDivisorForSafeExponentiation;
exports.stakeDivisorForSafeExponentiationDiv2 = stakeDivisorForSafeExponentiationDiv2;
exports.tenToThe18Div2 = tenToThe18Div2;
exports.fiveMinutesInSeconds = fiveMinutesInSeconds;
exports.oneHourInSeconds = oneHourInSeconds;
exports.halfDayInSeconds = halfDayInSeconds;
exports.oneDayInSeconds = oneDayInSeconds;
exports.threeDaysInSeconds = threeDaysInSeconds;
exports.oneWeekInSeconds = oneWeekInSeconds;
exports.twoWeeksInSeconds = twoWeeksInSeconds;
exports.oneMonthInSeconds = oneMonthInSeconds;
exports.PriceGraphLabels = PriceGraphLabels;
exports.threeMonthsInSeconds = threeMonthsInSeconds;
exports.oneYearInSeconds = oneYearInSeconds;
exports.hotAPYThreshold = hotAPYThreshold;
exports.multiplierHotAPYThreshold = multiplierHotAPYThreshold;
exports.kperiodHardcode = kperiodHardcode;
exports.kmultiplierHardcode = kmultiplierHardcode;
exports.equilibriumOffsetHardcode = equilibriumOffsetHardcode;
exports.balanceIncentiveExponentHardcode = balanceIncentiveExponentHardcode;
exports.yieldGradientHardcode = yieldGradientHardcode;
exports.floatCapitalPercentE18HardCode = floatCapitalPercentE18HardCode;
exports.oneYearInSecondsMulTenToThe18 = oneYearInSecondsMulTenToThe18;
exports.daiDisplayToken = daiDisplayToken;
exports.polygonDisplayToken = polygonDisplayToken;
exports.mumbai = mumbai;
exports.polygon = polygon;
/* zeroAddress Not a pure module */
