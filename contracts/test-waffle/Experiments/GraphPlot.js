// Generated by ReScript, PLEASE EDIT WITH CARE
'use strict';

var Fs = require("fs");
var Config = require("../library/Config.js");
var Ethers = require("../bindings/ethers/Ethers.js");
var LetOps = require("../library/LetOps.js");
var Globals = require("../library/Globals.js");
var Helpers = require("../library/Helpers.js");
var Contract = require("../library/Contract.js");
var CONSTANTS = require("../CONSTANTS.js");
var Belt_Array = require("bs-platform/lib/js/belt_Array.js");
var HelperActions = require("../library/HelperActions.js");

function generateTestData(contracts, accounts, initialPrice, initialAmountShort, initialAmountLong, prices, name) {
  return Globals.describe("generating graph" + name)(undefined, undefined, undefined, (function (param) {
                var numberOfItems = Globals.bnToInt(Globals.div(initialPrice, CONSTANTS.tenToThe18));
                Globals.before_each$prime(undefined)(undefined, undefined, undefined, (function (param) {
                        var match = contracts.contents;
                        var longShort = match.longShort;
                        var match$1 = match.markets[0];
                        var marketIndex = match$1.marketIndex;
                        var oracleManager = match$1.oracleManager;
                        var paymentToken = match$1.paymentToken;
                        var testUser = accounts.contents[1];
                        return LetOps.AwaitThen.let_(oracleManager.setPrice(initialPrice), (function (param) {
                                      return LetOps.AwaitThen.let_(longShort._updateSystemState(marketIndex), (function (param) {
                                                    return LetOps.AwaitThen.let_(Contract.PaymentTokenHelpers.mintAndApprove(paymentToken, testUser, ethers.BigNumber.from("10000000000000000000000000000"), longShort.address), (function (param) {
                                                                  return LetOps.AwaitThen.let_(HelperActions.mintDirect(marketIndex, initialAmountLong, paymentToken, testUser, longShort, oracleManager, true), (function (param) {
                                                                                return Promise.resolve(undefined);
                                                                              }));
                                                                }));
                                                  }));
                                    }));
                      }));
                Globals.it$prime("below")(undefined, undefined, undefined, (function (param) {
                        var match = contracts.contents;
                        var longShort = match.longShort;
                        var match$1 = match.markets[0];
                        var marketIndex = match$1.marketIndex;
                        var oracleManager = match$1.oracleManager;
                        var testUser = accounts.contents[1];
                        return LetOps.AwaitThen.let_(HelperActions.mintDirect(marketIndex, initialAmountShort, match$1.paymentToken, testUser, longShort, oracleManager, false), (function (param) {
                                      var pricesBelow = Belt_Array.makeBy(numberOfItems - 1 | 0, (function (i) {
                                              return i;
                                            }));
                                      return LetOps.AwaitThen.let_(Belt_Array.reduce(pricesBelow, Promise.resolve([
                                                          initialPrice,
                                                          []
                                                        ]), (function (lastPromise, param) {
                                                        return LetOps.AwaitThen.let_(lastPromise, (function (param) {
                                                                      var results = param[1];
                                                                      var newPrice = Globals.sub(param[0], CONSTANTS.tenToThe18);
                                                                      return LetOps.AwaitThen.let_(oracleManager.setPrice(newPrice), (function (param) {
                                                                                    return LetOps.AwaitThen.let_(longShort._updateSystemState(marketIndex), (function (param) {
                                                                                                  return LetOps.AwaitThen.let_(longShort.syntheticTokenBackedValue(CONSTANTS.shortTokenType, marketIndex), (function (shortValue) {
                                                                                                                return LetOps.AwaitThen.let_(longShort.syntheticTokenBackedValue(CONSTANTS.longTokenType, marketIndex), (function (longValue) {
                                                                                                                              return Promise.resolve([
                                                                                                                                          newPrice,
                                                                                                                                          Belt_Array.concat([[
                                                                                                                                                  Ethers.Utils.formatEther(newPrice),
                                                                                                                                                  Ethers.Utils.formatEther(shortValue),
                                                                                                                                                  Ethers.Utils.formatEther(longValue)
                                                                                                                                                ]], results)
                                                                                                                                        ]);
                                                                                                                            }));
                                                                                                              }));
                                                                                                }));
                                                                                  }));
                                                                    }));
                                                      })), (function (param) {
                                                    prices.contents = Belt_Array.concat(Belt_Array.concat(prices.contents, param[1]), [[
                                                            Ethers.Utils.formatEther(initialPrice),
                                                            Ethers.Utils.formatEther(initialAmountShort),
                                                            Ethers.Utils.formatEther(initialAmountLong)
                                                          ]]);
                                                    return Promise.resolve(undefined);
                                                  }));
                                    }));
                      }));
                return Globals.it$prime("above")(undefined, undefined, undefined, (function (param) {
                              var match = contracts.contents;
                              var longShort = match.longShort;
                              var match$1 = match.markets[0];
                              var marketIndex = match$1.marketIndex;
                              var oracleManager = match$1.oracleManager;
                              var testUser = accounts.contents[1];
                              return LetOps.AwaitThen.let_(HelperActions.mintDirect(marketIndex, initialAmountShort, match$1.paymentToken, testUser, longShort, oracleManager, false), (function (param) {
                                            var pricesAbove = Belt_Array.makeBy((numberOfItems << 2), (function (i) {
                                                    return i;
                                                  }));
                                            return LetOps.AwaitThen.let_(Belt_Array.reduce(pricesAbove, Promise.resolve([
                                                                initialPrice,
                                                                []
                                                              ]), (function (lastPromise, param) {
                                                              return LetOps.AwaitThen.let_(lastPromise, (function (param) {
                                                                            var results = param[1];
                                                                            var newPrice = Globals.add(param[0], CONSTANTS.tenToThe18);
                                                                            return LetOps.AwaitThen.let_(oracleManager.setPrice(newPrice), (function (param) {
                                                                                          return LetOps.AwaitThen.let_(longShort._updateSystemState(marketIndex), (function (param) {
                                                                                                        return LetOps.AwaitThen.let_(longShort.syntheticTokenBackedValue(CONSTANTS.shortTokenType, marketIndex), (function (shortValue) {
                                                                                                                      return LetOps.AwaitThen.let_(longShort.syntheticTokenBackedValue(CONSTANTS.longTokenType, marketIndex), (function (longValue) {
                                                                                                                                    return Promise.resolve([
                                                                                                                                                newPrice,
                                                                                                                                                Belt_Array.concat(results, [[
                                                                                                                                                        Ethers.Utils.formatEther(newPrice),
                                                                                                                                                        Ethers.Utils.formatEther(shortValue),
                                                                                                                                                        Ethers.Utils.formatEther(longValue)
                                                                                                                                                      ]])
                                                                                                                                              ]);
                                                                                                                                  }));
                                                                                                                    }));
                                                                                                      }));
                                                                                        }));
                                                                          }));
                                                            })), (function (param) {
                                                          prices.contents = Belt_Array.concat(prices.contents, param[1]);
                                                          Fs.writeFileSync("./generatedDataForModels/" + (name + ".txt"), Belt_Array.reduce(prices.contents, "", (function (priceString, param) {
                                                                      return priceString + ("\n" + (param[0] + ("," + (param[1] + ("," + param[2])))));
                                                                    })), "utf8");
                                                          return Promise.resolve(undefined);
                                                        }));
                                          }));
                            }));
              }));
}

var describeSkippable = Config.runValueSimulations ? Globals.describe : Globals.describe_skip;

describeSkippable("Float System")(undefined, undefined, undefined, (function (param) {
        var contracts = {
          contents: undefined
        };
        var accounts = {
          contents: undefined
        };
        Globals.before$prime(undefined)(undefined, undefined, undefined, (function (param) {
                return LetOps.Await.let_(ethers.getSigners(), (function (loadedAccounts) {
                              accounts.contents = loadedAccounts;
                              
                            }));
              }));
        Globals.before_each$prime(undefined)(undefined, undefined, undefined, (function (param) {
                return LetOps.Await.let_(Helpers.inititialize(accounts.contents[0], false), (function (deployedContracts) {
                              contracts.contents = deployedContracts;
                              
                            }));
              }));
        var initialPrice = Globals.mul(Globals.bnFromInt(50), CONSTANTS.tenToThe18);
        var initialAmountLong = Globals.mul(Globals.bnFromInt(100), CONSTANTS.tenToThe18);
        var initialAmountShort = Globals.mul(Globals.bnFromInt(100), CONSTANTS.tenToThe18);
        var prices = {
          contents: []
        };
        generateTestData(contracts, accounts, initialPrice, initialAmountShort, initialAmountLong, prices, "balancedStart");
        var initialPrice$1 = Globals.mul(Globals.bnFromInt(50), CONSTANTS.tenToThe18);
        var initialAmountLong$1 = Globals.mul(Globals.bnFromInt(200), CONSTANTS.tenToThe18);
        var initialAmountShort$1 = Globals.mul(Globals.bnFromInt(100), CONSTANTS.tenToThe18);
        var prices$1 = {
          contents: []
        };
        generateTestData(contracts, accounts, initialPrice$1, initialAmountShort$1, initialAmountLong$1, prices$1, "imbalancedLong");
        var initialPrice$2 = Globals.mul(Globals.bnFromInt(50), CONSTANTS.tenToThe18);
        var initialAmountLong$2 = Globals.mul(Globals.bnFromInt(100), CONSTANTS.tenToThe18);
        var initialAmountShort$2 = Globals.mul(Globals.bnFromInt(200), CONSTANTS.tenToThe18);
        var prices$2 = {
          contents: []
        };
        return generateTestData(contracts, accounts, initialPrice$2, initialAmountShort$2, initialAmountLong$2, prices$2, "imbalancedShort");
      }));

exports.generateTestData = generateTestData;
exports.describeSkippable = describeSkippable;
/*  Not a pure module */
