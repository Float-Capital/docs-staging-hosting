// Generated by ReScript, PLEASE EDIT WITH CARE
'use strict';

var Chai = require("./bindings/chai/Chai.js");
var LetOps = require("./library/LetOps.js");
var Globals = require("./library/Globals.js");
var Helpers = require("./library/Helpers.js");
var Contract = require("./library/Contract.js");
var CONSTANTS = require("./CONSTANTS.js");
var Belt_Array = require("bs-platform/lib/js/belt_Array.js");
var HelperActions = require("./library/HelperActions.js");
var CalculateAccumulatedFloat = require("./tests/stake/CalculateAccumulatedFloat.js");

Globals.describe("Float System")(undefined, undefined, undefined, (function (param) {
        Globals.describe("Staking")(undefined, undefined, undefined, (function (param) {
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
                return Globals.it_skip$prime("[BROKEN TEST] - should correctly be able to stake their long/short tokens and view their staked amount immediately")(undefined, undefined, undefined, (function (param) {
                              var match = contracts.contents;
                              var longShort = match.longShort;
                              var staker = match.staker;
                              var testUser = accounts.contents[1];
                              return LetOps.Await.let_(HelperActions.stakeRandomlyInMarkets(match.markets, testUser, longShort), (function (param) {
                                            return LetOps.Await.let_(Promise.all(Belt_Array.map(param[0], (function (param) {
                                                                  var priceOfSynthForAction = param.priceOfSynthForAction;
                                                                  var amount = param.amount;
                                                                  var synth = param.synth;
                                                                  return LetOps.AwaitThen.let_(Contract.LongShortHelpers.getFeesMint(longShort, param.marketIndex, amount, param.valueInEntrySide, param.valueInOtherSide), (function (amountOfFees) {
                                                                                return LetOps.Await.let_(staker.userAmountStaked(synth.address, testUser.address), (function (amountStaked) {
                                                                                              var expectedStakeAmount = Globals.div(Globals.mul(Globals.sub(amount, amountOfFees), CONSTANTS.tenToThe18), priceOfSynthForAction);
                                                                                              return Chai.bnEqual("amount staked is greater than expected", amountStaked, expectedStakeAmount);
                                                                                            }));
                                                                              }));
                                                                }))), (function (param) {
                                                          
                                                        }));
                                          }));
                            }));
              }));
        return Globals.describe("Staking - internals exposed")(undefined, undefined, undefined, (function (param) {
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
                              return LetOps.Await.let_(Helpers.inititialize(accounts.contents[0], true), (function (deployedContracts) {
                                            contracts.contents = deployedContracts;
                                            
                                          }));
                            }));
                      return CalculateAccumulatedFloat.test(contracts);
                    }));
      }));

/*  Not a pure module */
