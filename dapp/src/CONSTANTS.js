// Generated by ReScript, PLEASE EDIT WITH CARE
'use strict';

var Ethers = require("ethers");

var zeroAddressStr = "0x0000000000000000000000000000000000000000";

var zeroAddress = Ethers.utils.getAddress(zeroAddressStr);

var zeroBN = Ethers.BigNumber.from(0);

var tenToThe6 = Ethers.BigNumber.from("1000000");

var tenToThe9 = Ethers.BigNumber.from("1000000000");

var tenToThe18 = Ethers.BigNumber.from("1000000000000000000");

var tenToThe42 = tenToThe6.mul(tenToThe18).mul(tenToThe18);

var oneHundredEth = Ethers.BigNumber.from("100000000000000000000");

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

exports.zeroAddressStr = zeroAddressStr;
exports.zeroAddress = zeroAddress;
exports.zeroBN = zeroBN;
exports.tenToThe6 = tenToThe6;
exports.tenToThe9 = tenToThe9;
exports.tenToThe18 = tenToThe18;
exports.tenToThe42 = tenToThe42;
exports.oneHundredEth = oneHundredEth;
exports.fiveMinutesInSeconds = fiveMinutesInSeconds;
exports.oneHourInSeconds = oneHourInSeconds;
exports.halfDayInSeconds = halfDayInSeconds;
exports.oneDayInSeconds = oneDayInSeconds;
exports.threeDaysInSeconds = threeDaysInSeconds;
exports.oneWeekInSeconds = oneWeekInSeconds;
exports.twoWeeksInSeconds = twoWeeksInSeconds;
exports.oneMonthInSeconds = oneMonthInSeconds;
exports.threeMonthsInSeconds = threeMonthsInSeconds;
exports.oneYearInSeconds = oneYearInSeconds;
/* zeroAddress Not a pure module */
