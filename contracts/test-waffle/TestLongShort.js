// Generated by ReScript, PLEASE EDIT WITH CARE
'use strict';

var LetOps = require("./library/LetOps.js");
var Globals = require("./library/Globals.js");
var Helpers = require("./library/Helpers.js");
var Contract = require("./library/Contract.js");
var LazyRedeem = require("./tests/longshort/LazyRedeem.js");
var LazyDeposit = require("./tests/longshort/LazyDeposit.js");
var HelperActions = require("./library/HelperActions.js");

Globals.describe("Float System")(undefined, undefined, undefined, (function (param) {
        return Globals.describe("LongShort")(undefined, undefined, undefined, (function (param) {
                      var contracts = {
                        contents: undefined
                      };
                      var accounts = {
                        contents: undefined
                      };
                      Globals.before_each$prime(undefined)(undefined, undefined, undefined, (function (param) {
                              return LetOps.Await.let_(ethers.getSigners(), (function (loadedAccounts) {
                                            accounts.contents = loadedAccounts;
                                            return LetOps.AwaitThen.let_(Helpers.inititialize(accounts.contents[0], false), (function (deployedContracts) {
                                                          contracts.contents = deployedContracts;
                                                          var setupUser = accounts.contents[2];
                                                          return LetOps.Await.let_(HelperActions.stakeRandomlyInBothSidesOfMarket(deployedContracts.markets, setupUser, deployedContracts.longShort), (function (param) {
                                                                        
                                                                      }));
                                                        }));
                                          }));
                            }));
                      Globals.describe("_updateSystemState")(undefined, undefined, undefined, (function (param) {
                              
                            }));
                      LazyDeposit.testIntegration(contracts, accounts);
                      LazyRedeem.testIntegration(contracts, accounts);
                      return Globals.describe("LongShort - internals exposed")(undefined, undefined, undefined, (function (param) {
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
                                    return Globals.before_each$prime(undefined)(undefined, undefined, undefined, (function (param) {
                                                  return LetOps.AwaitThen.let_(Helpers.inititialize(accounts.contents[0], true), (function (deployedContracts) {
                                                                contracts.contents = deployedContracts;
                                                                var firstMarketPaymentToken = deployedContracts.markets[1].paymentToken;
                                                                var testUser = accounts.contents[1];
                                                                return LetOps.Await.let_(Contract.PaymentTokenHelpers.mintAndApprove(firstMarketPaymentToken, testUser, ethers.BigNumber.from("10000000000000000000000"), deployedContracts.longShort.address), (function (param) {
                                                                              
                                                                            }));
                                                              }));
                                                }));
                                  }));
                    }));
      }));

/*  Not a pure module */
