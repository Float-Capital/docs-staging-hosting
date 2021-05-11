// Generated by ReScript, PLEASE EDIT WITH CARE
'use strict';

var Js_int = require("rescript/lib/js/js_int.js");
var Js_math = require("rescript/lib/js/js_math.js");
var Contract = require("./Contract.js");
var Belt_Array = require("rescript/lib/js/belt_Array.js");

function mintAndStake(marketIndex, amount, token, user, longShort, isLong) {
  Contract.PaymentToken.mintAndApprove(token, user.address, amount, longShort.address);
  var contract = longShort.attach(user.address);
  if (isLong) {
    return contract.mintLongAndStake(marketIndex, amount);
  } else {
    return contract.mintShortAndStake(marketIndex, amount);
  }
}

function randomTokenAmount(param) {
  return ethers.BigNumber.from(Js_math.random_int(0, Js_int.max)).mul(ethers.BigNumber.from(100000));
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

function createSyntheticMarket(admin, longShort, fundToken, marketName, marketSymbol) {
  return Promise.all([
                Contract.OracleManagerMock.make(admin),
                Contract.YieldManagerMock.make(admin, longShort.address, fundToken.address)
              ]).then(function (param) {
              var yieldManager = param[1];
              Contract.PaymentToken.grantMintRole(fundToken, yieldManager.address);
              return longShort.newSyntheticMarket(marketName, marketSymbol, fundToken.address, param[0].address, yieldManager.address);
            });
}

function getAllMarkets(longShort) {
  return longShort.latestMarket().then(function (nextMarketIndex) {
              var marketIndex = nextMarketIndex - 1 | 0;
              return Promise.all(Belt_Array.map(Belt_Array.range(1, marketIndex), (function (marketIndex) {
                                return Promise.all([
                                              longShort.longTokens(marketIndex).then(Contract.SyntheticToken.at),
                                              longShort.shortTokens(marketIndex).then(Contract.SyntheticToken.at),
                                              longShort.fundTokens(marketIndex).then(Contract.PaymentToken.at),
                                              longShort.oracleManagers(marketIndex).then(Contract.OracleManagerMock.at),
                                              longShort.yieldManagers(marketIndex).then(Contract.YieldManagerMock.at)
                                            ]).then(function (param) {
                                            var oracleManager = param[3];
                                            console.log("oracleManager", oracleManager);
                                            return {
                                                    paymentToken: param[2],
                                                    oracleManager: oracleManager,
                                                    yieldManager: param[4],
                                                    longSynth: param[0],
                                                    shortSynth: param[1],
                                                    marketIndex: marketIndex
                                                  };
                                          });
                              })));
            });
}

function inititialize(admin) {
  return Promise.all([
                Contract.FloatCapital_v0.make(undefined),
                Contract.Treasury_v0.make(undefined),
                Contract.FloatToken.make(undefined),
                Contract.Staker.make(undefined),
                Contract.LongShort.make(undefined),
                Promise.all([
                      Contract.PaymentToken.make("Pay Token 1", "PT1"),
                      Contract.PaymentToken.make("Pay Token 2", "PT2")
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
              return Contract.TokenFactory.make(admin.address, longShort.address).then(function (tokenFactory) {
                          return Promise.all([
                                          floatToken["initialize(string,string,address)"]("Float token", "FLOAT TOKEN", staker.address),
                                          treasury.initialize(admin.address),
                                          longShort.initialize(admin.address, treasury.address, tokenFactory.address, staker.address),
                                          staker.initialize(admin.address, longShort.address, floatToken.address, floatCapital.address)
                                        ]).then(function (param) {
                                        console.log("will create the markets now!!!");
                                        return Promise.all(Belt_Array.mapWithIndex([
                                                          payToken1,
                                                          payToken1,
                                                          payToken2,
                                                          payToken1
                                                        ], (function (index, paymentToken) {
                                                            return createSyntheticMarket(admin.address, longShort, paymentToken, "Test Market " + String(index), "TM" + String(index));
                                                          }))).then(function (param) {
                                                    return getAllMarkets(longShort);
                                                  });
                                      }).then(function (markets) {
                                      return {
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

exports.mintAndStake = mintAndStake;
exports.randomTokenAmount = randomTokenAmount;
exports.randomMintLongShort = randomMintLongShort;
exports.createSyntheticMarket = createSyntheticMarket;
exports.getAllMarkets = getAllMarkets;
exports.inititialize = inititialize;
/* No side effect */
