// Generated by ReScript, PLEASE EDIT WITH CARE
'use strict';

var Curry = require("rescript/lib/js/curry.js");
var Ethers = require("../bindings/ethers/Ethers.js");
var Js_int = require("rescript/lib/js/js_int.js");
var Staker = require("./contracts/Staker.js");
var Globals = require("./Globals.js");
var Js_math = require("rescript/lib/js/js_math.js");
var CONSTANTS = require("../CONSTANTS.js");
var ERC20Mock = require("./contracts/ERC20Mock.js");
var LongShort = require("./contracts/LongShort.js");
var Belt_Array = require("rescript/lib/js/belt_Array.js");
var FloatToken = require("./contracts/FloatToken.js");
var Caml_option = require("rescript/lib/js/caml_option.js");
var Treasury_v0 = require("./contracts/Treasury_v0.js");
var TokenFactory = require("./contracts/TokenFactory.js");
var StakerSmocked = require("./smock/StakerSmocked.js");
var SyntheticToken = require("./contracts/SyntheticToken.js");
var FloatCapital_v0 = require("./contracts/FloatCapital_v0.js");
var LongShortSmocked = require("./smock/LongShortSmocked.js");
var YieldManagerAave = require("./contracts/YieldManagerAave.js");
var YieldManagerMock = require("./contracts/YieldManagerMock.js");
var FloatTokenSmocked = require("./smock/FloatTokenSmocked.js");
var OracleManagerMock = require("./contracts/OracleManagerMock.js");
var TokenFactorySmocked = require("./smock/TokenFactorySmocked.js");
var SyntheticTokenSmocked = require("./smock/SyntheticTokenSmocked.js");
var YieldManagerAaveSmocked = require("./smock/YieldManagerAaveSmocked.js");
var OracleManagerMockSmocked = require("./smock/OracleManagerMockSmocked.js");

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

function randomBigIntInRange(x, y) {
  return ethers.BigNumber.from(Js_math.random_int(x, y));
}

function randomJsInteger(param) {
  return Js_math.random_int(0, Js_int.max);
}

function randomRatio1e18(param) {
  return Globals.bnFromString(String(Js_math.random_int(0, 1000000000)) + String(Js_math.random_int(0, 1000000000)));
}

function adjustNumberRandomlyWithinRange(basisPointsMin, basisPointsMax, number) {
  var numerator = Globals.bnFromInt(Js_math.random_int(basisPointsMin, basisPointsMax));
  return Globals.add(number, Globals.div(Globals.mul(number, numerator), Globals.bnFromInt(100000)));
}

function accessControlErrorMessage(address, roleBytesStr) {
  return "AccessControl: account " + Ethers.Utils.ethAdrToLowerStr(address) + " is missing role " + roleBytesStr;
}

var adminRoleBytesString = "0xa49807205ce4d355092ef5a8a18f56e8913cf4a201fbe287825b095693c21775";

function adminErrorMessage(address) {
  return accessControlErrorMessage(address, adminRoleBytesString);
}

function randomTokenAmount(param) {
  return ethers.BigNumber.from(Js_math.random_int(1, Js_int.max)).mul(ethers.BigNumber.from("10000000000000000"));
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

function createSyntheticMarket(admin, initialMarketSeedForEachMarketSideOpt, paymentToken, treasury, marketName, marketSymbol, longShort) {
  var initialMarketSeedForEachMarketSide = initialMarketSeedForEachMarketSideOpt !== undefined ? Caml_option.valFromOption(initialMarketSeedForEachMarketSideOpt) : CONSTANTS.tenToThe18;
  return Promise.all([
                OracleManagerMock.make(admin),
                YieldManagerMock.make(longShort.address, treasury, paymentToken.address),
                paymentToken.mint(admin, Globals.mul(initialMarketSeedForEachMarketSide, Globals.bnFromInt(100))).then(function (param) {
                      return paymentToken.approve(longShort.address, Globals.mul(initialMarketSeedForEachMarketSide, Globals.bnFromInt(100)));
                    })
              ]).then(function (param) {
              var yieldManager = param[1];
              paymentToken.MINTER_ROLE().then(function (minterRole) {
                    return paymentToken.grantRole(minterRole, yieldManager.address);
                  });
              return longShort.createNewSyntheticMarket(marketName, marketSymbol, paymentToken.address, param[0].address, yieldManager.address).then(function (param) {
                            return longShort.latestMarket();
                          }).then(function (marketIndex) {
                          return longShort.initializeMarket(marketIndex, ethers.BigNumber.from("1000000000000000000"), ethers.BigNumber.from(0), ethers.BigNumber.from(50), initialMarketSeedForEachMarketSide, Globals.bnFromInt(5), Globals.bnFromInt(0), Globals.bnFromInt(1));
                        });
            });
}

function getAllMarkets(longShort) {
  return longShort.latestMarket().then(function (nextMarketIndex) {
              return Promise.all(Belt_Array.map(Belt_Array.range(1, nextMarketIndex), (function (marketIndex) {
                                return Promise.all([
                                              longShort.syntheticTokens(marketIndex, true).then(SyntheticToken.at),
                                              longShort.syntheticTokens(marketIndex, false).then(SyntheticToken.at),
                                              longShort.paymentTokens(marketIndex).then(ERC20Mock.at),
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

function initialize(admin, exposeInternals) {
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
              return TokenFactory.make(longShort.address).then(function (tokenFactory) {
                          return Promise.all([
                                          floatToken.initialize("Float token", "FLOAT TOKEN", staker.address),
                                          treasury.initialize(admin.address, payToken1.address, floatToken.address),
                                          longShort.initialize(admin.address, tokenFactory.address, staker.address),
                                          staker.initialize(admin.address, longShort.address, floatToken.address, floatCapital.address, floatCapital.address, admin.address, Globals.bnFromString("250000000000000000"))
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

function initializeStakerUnit(param) {
  return Promise.all([
                Staker.Exposed.makeSmock(undefined).then(function (staker) {
                      return StakerSmocked.InternalMock.setup(staker).then(function (param) {
                                  return staker;
                                });
                    }),
                LongShortSmocked.make(undefined),
                FloatTokenSmocked.make(undefined),
                SyntheticTokenSmocked.make(undefined),
                FloatCapital_v0.make(undefined)
              ]).then(function (param) {
              var floatCapitalSmocked = param[4];
              var syntheticTokenSmocked = param[3];
              var floatTokenSmocked = param[2];
              var longShortSmocked = param[1];
              var staker = param[0];
              return Staker.setVariable(staker, "longShort", longShortSmocked.address).then(function (param) {
                          return {
                                  staker: staker,
                                  longShortSmocked: longShortSmocked,
                                  floatTokenSmocked: floatTokenSmocked,
                                  syntheticTokenSmocked: syntheticTokenSmocked,
                                  floatCapitalSmocked: floatCapitalSmocked
                                };
                        });
            });
}

function deployAYieldManager(longShort, lendingPoolAddressesProvider) {
  return ERC20Mock.make("Pay Token 1", "PT1").then(function (paymentToken) {
              return YieldManagerAave.make(undefined).then(function (manager) {
                          return manager.initialize(longShort, ethers.Wallet.createRandom().address, paymentToken.address, ethers.Wallet.createRandom().address, lendingPoolAddressesProvider, ethers.Wallet.createRandom().address, 0, ethers.Wallet.createRandom().address).then(function (param) {
                                      return manager;
                                    });
                        });
            });
}

function initializeLongShortUnit(param) {
  return Promise.all([
                LongShort.Exposed.makeSmock(undefined).then(function (staker) {
                      return LongShortSmocked.InternalMock.setup(staker).then(function (param) {
                                  return staker;
                                });
                    }),
                StakerSmocked.make(undefined),
                FloatTokenSmocked.make(undefined),
                SyntheticTokenSmocked.make(undefined),
                SyntheticTokenSmocked.make(undefined),
                TokenFactorySmocked.make(undefined),
                YieldManagerAaveSmocked.make(undefined),
                OracleManagerMockSmocked.make(undefined)
              ]).then(function (param) {
              return {
                      longShort: param[0],
                      stakerSmocked: param[1],
                      floatTokenSmocked: param[2],
                      syntheticToken1Smocked: param[3],
                      syntheticToken2Smocked: param[4],
                      tokenFactorySmocked: param[5],
                      yieldManagerSmocked: param[6],
                      oracleManagerSmocked: param[7]
                    };
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
exports.randomBigIntInRange = randomBigIntInRange;
exports.randomJsInteger = randomJsInteger;
exports.randomRatio1e18 = randomRatio1e18;
exports.adjustNumberRandomlyWithinRange = adjustNumberRandomlyWithinRange;
exports.accessControlErrorMessage = accessControlErrorMessage;
exports.adminRoleBytesString = adminRoleBytesString;
exports.adminErrorMessage = adminErrorMessage;
exports.randomTokenAmount = randomTokenAmount;
exports.randomMintLongShort = randomMintLongShort;
exports.randomAddress = randomAddress;
exports.createSyntheticMarket = createSyntheticMarket;
exports.getAllMarkets = getAllMarkets;
exports.initialize = initialize;
exports.initializeStakerUnit = initializeStakerUnit;
exports.deployAYieldManager = deployAYieldManager;
exports.initializeLongShortUnit = initializeLongShortUnit;
exports.increaseTime = increaseTime;
exports.getBlock = getBlock;
exports.getRandomTimestampInPast = getRandomTimestampInPast;
/* Staker Not a pure module */
