// Generated by ReScript, PLEASE EDIT WITH CARE
'use strict';

var Curry = require("rescript/lib/js/curry.js");
var Js_int = require("rescript/lib/js/js_int.js");
var Staker = require("./contracts/Staker.js");
var Globals = require("./Globals.js");
var Js_math = require("rescript/lib/js/js_math.js");
var ERC20Mock = require("./contracts/ERC20Mock.js");
var LongShort = require("./contracts/LongShort.js");
var Belt_Array = require("rescript/lib/js/belt_Array.js");
var FloatToken = require("./contracts/FloatToken.js");
var Caml_option = require("rescript/lib/js/caml_option.js");
var Treasury_v0 = require("./contracts/Treasury_v0.js");
var TokenFactory = require("./contracts/TokenFactory.js");
var SyntheticToken = require("./contracts/SyntheticToken.js");
var FloatCapital_v0 = require("./contracts/FloatCapital_v0.js");
var YieldManagerMock = require("./contracts/YieldManagerMock.js");
var OracleManagerMock = require("./contracts/OracleManagerMock.js");

function make2(fn) {
  return [
          Curry._1(fn, undefined),
          Curry._1(fn, undefined)
        ];
}

function make3(fn) {
  return [
          Curry._1(fn, undefined),
          Curry._1(fn, undefined),
          Curry._1(fn, undefined)
        ];
}

function make4(fn) {
  return [
          Curry._1(fn, undefined),
          Curry._1(fn, undefined),
          Curry._1(fn, undefined),
          Curry._1(fn, undefined)
        ];
}

function make5(fn) {
  return [
          Curry._1(fn, undefined),
          Curry._1(fn, undefined),
          Curry._1(fn, undefined),
          Curry._1(fn, undefined),
          Curry._1(fn, undefined)
        ];
}

function make6(fn) {
  return [
          Curry._1(fn, undefined),
          Curry._1(fn, undefined),
          Curry._1(fn, undefined),
          Curry._1(fn, undefined),
          Curry._1(fn, undefined),
          Curry._1(fn, undefined)
        ];
}

function make7(fn) {
  return [
          Curry._1(fn, undefined),
          Curry._1(fn, undefined),
          Curry._1(fn, undefined),
          Curry._1(fn, undefined),
          Curry._1(fn, undefined),
          Curry._1(fn, undefined),
          Curry._1(fn, undefined)
        ];
}

function make8(fn) {
  return [
          Curry._1(fn, undefined),
          Curry._1(fn, undefined),
          Curry._1(fn, undefined),
          Curry._1(fn, undefined),
          Curry._1(fn, undefined),
          Curry._1(fn, undefined),
          Curry._1(fn, undefined),
          Curry._1(fn, undefined)
        ];
}

var Tuple = {
  make2: make2,
  make3: make3,
  make4: make4,
  make5: make5,
  make6: make6,
  make7: make7,
  make8: make8
};

function randomInteger(param) {
  return ethers.BigNumber.from(Js_math.random_int(1, Js_int.max));
}

function randomJsInteger(param) {
  return Js_math.random_int(0, Js_int.max);
}

function randomTokenAmount(param) {
  return ethers.BigNumber.from(Js_math.random_int(1, Js_int.max)).mul(ethers.BigNumber.from("10000000000000"));
}

function randomMintLongShort(param) {
  var match = Js_math.random_int(0, 3);
  switch (match) {
    case 0 :
        return {
                TAG: /* Long */0,
                _0: randomTokenAmount(undefined)
              };
    case 1 :
        return {
                TAG: /* Short */1,
                _0: randomTokenAmount(undefined)
              };
    case 2 :
        return {
                TAG: /* Both */2,
                _0: randomTokenAmount(undefined),
                _1: randomTokenAmount(undefined)
              };
    default:
      return {
              TAG: /* Both */2,
              _0: randomTokenAmount(undefined),
              _1: randomTokenAmount(undefined)
            };
  }
}

function randomAddress(param) {
  return ethers.Wallet.createRandom().address;
}

function createSyntheticMarket(admin, initialMarketSeedOpt, fundToken, treasury, marketName, marketSymbol, longShort) {
  var initialMarketSeed = initialMarketSeedOpt !== undefined ? Caml_option.valFromOption(initialMarketSeedOpt) : Globals.bnFromString("500000000000000000");
  return Promise.all([
                OracleManagerMock.make(admin),
                YieldManagerMock.make(admin, longShort.address, treasury, fundToken.address),
                fundToken.mint(admin, Globals.mul(initialMarketSeed, Globals.bnFromInt(100))).then(function (param) {
                      return fundToken.approve(longShort.address, Globals.mul(initialMarketSeed, Globals.bnFromInt(100)));
                    })
              ]).then(function (param) {
              var yieldManager = param[1];
              fundToken.MINTER_ROLE().then(function (minterRole) {
                    return fundToken.grantRole(minterRole, yieldManager.address);
                  });
              return longShort.newSyntheticMarket(marketName, marketSymbol, fundToken.address, param[0].address, yieldManager.address).then(function (param) {
                            return longShort.latestMarket();
                          }).then(function (marketIndex) {
                          return longShort.initializeMarket(marketIndex, ethers.BigNumber.from(0), ethers.BigNumber.from(0), ethers.BigNumber.from(50), ethers.BigNumber.from(50), ethers.BigNumber.from("1000000000000000000"), ethers.BigNumber.from(0), initialMarketSeed);
                        });
            });
}

function getAllMarkets(longShort) {
  return longShort.latestMarket().then(function (nextMarketIndex) {
              return Promise.all(Belt_Array.map(Belt_Array.range(1, nextMarketIndex), (function (marketIndex) {
                                return Promise.all([
                                              longShort.syntheticTokens(marketIndex, true).then(SyntheticToken.at),
                                              longShort.syntheticTokens(marketIndex, false).then(SyntheticToken.at),
                                              longShort.fundTokens(marketIndex).then(ERC20Mock.at),
                                              longShort.oracleManagers(marketIndex).then(OracleManagerMock.at),
                                              longShort.yieldManagers(marketIndex).then(YieldManagerMock.at)
                                            ]).then(function (param) {
                                            return {
                                                    paymentToken: param[2],
                                                    oracleManager: param[3],
                                                    yieldManager: param[4],
                                                    longSynth: param[0],
                                                    shortSynth: param[1],
                                                    marketIndex: marketIndex
                                                  };
                                          });
                              })));
            });
}

function inititialize(admin, exposeInternals) {
  return Promise.all([
                FloatCapital_v0.make(undefined),
                Treasury_v0.make(undefined),
                FloatToken.make(undefined),
                exposeInternals ? Staker.Exposed.make(undefined) : Staker.make(undefined),
                exposeInternals ? LongShort.Exposed.make(undefined) : LongShort.make(undefined),
                Promise.all([
                      ERC20Mock.make("Pay Token 1", "PT1"),
                      ERC20Mock.make("Pay Token 2", "PT2")
                    ])
              ]).then(function (param) {
              var match = param[5];
              var payToken2 = match[1];
              var payToken1 = match[0];
              var longShort = param[4];
              var staker = param[3];
              var floatToken = param[2];
              var treasury = param[1];
              var floatCapital = param[0];
              return TokenFactory.make(admin.address, longShort.address).then(function (tokenFactory) {
                          return Promise.all([
                                          floatToken.initialize3("Float token", "FLOAT TOKEN", staker.address),
                                          treasury.initialize(admin.address),
                                          longShort.initialize(admin.address, treasury.address, tokenFactory.address, staker.address),
                                          staker.initialize(admin.address, longShort.address, floatToken.address, floatCapital.address)
                                        ]).then(function (param) {
                                        return Belt_Array.reduceWithIndex([
                                                      payToken1,
                                                      payToken1,
                                                      payToken2,
                                                      payToken1
                                                    ], Promise.resolve(undefined), (function (previousPromise, paymentToken, index) {
                                                        return previousPromise.then(function (param) {
                                                                    return createSyntheticMarket(admin.address, undefined, paymentToken, treasury.address, "Test Market " + String(index), "TM" + String(index), longShort);
                                                                  });
                                                      })).then(function (param) {
                                                    return getAllMarkets(longShort);
                                                  });
                                      }).then(function (markets) {
                                      return {
                                              floatCapital_v0: floatCapital,
                                              tokenFactory: tokenFactory,
                                              treasury: treasury,
                                              floatToken: floatToken,
                                              staker: staker,
                                              longShort: longShort,
                                              markets: markets
                                            };
                                    });
                        });
            });
}

var increaseTime = ((seconds) => ethers.provider.send("evm_increaseTime", [seconds]));

var getBlock = (() => ethers.provider.getBlock());

function getRandomTimestampInPast(param) {
  return Curry._1(getBlock, undefined).then(function (param) {
              return Promise.resolve(ethers.BigNumber.from(param.timestamp - Js_math.random_int(200, 630720000) | 0));
            });
}

exports.Tuple = Tuple;
exports.randomInteger = randomInteger;
exports.randomJsInteger = randomJsInteger;
exports.randomTokenAmount = randomTokenAmount;
exports.randomMintLongShort = randomMintLongShort;
exports.randomAddress = randomAddress;
exports.createSyntheticMarket = createSyntheticMarket;
exports.getAllMarkets = getAllMarkets;
exports.inititialize = inititialize;
exports.increaseTime = increaseTime;
exports.getBlock = getBlock;
exports.getRandomTimestampInPast = getRandomTimestampInPast;
/* No side effect */
