// Generated by ReScript, PLEASE EDIT WITH CARE
'use strict';

var LetOps = require("../library/LetOps.js");
var Globals = require("../library/Globals.js");
var Helpers = require("../library/Helpers.js");
var Contract = require("../library/Contract.js");
var LazyRedeem = require("./longShort/LazyRedeem.js");
var LazyDeposit = require("./longShort/LazyDeposit.js");
var HelperActions = require("../library/HelperActions.js");
var InitializeMarket = require("./longShort/InitializeMarket.js");

describe("Float System", (function () {
        Globals.describeIntegration("LongShort", (function (param) {
                var contracts = {
                  contents: undefined
                };
                var accounts = {
                  contents: undefined
                };
                beforeEach(function () {
                      return LetOps.Await.let_(ethers.getSigners(), (function (loadedAccounts) {
                                    accounts.contents = loadedAccounts;
                                    return LetOps.AwaitThen.let_(Helpers.inititialize(accounts.contents[0], false), (function (deployedContracts) {
                                                  contracts.contents = deployedContracts;
                                                  var setupUser = accounts.contents[2];
                                                  return LetOps.Await.let_(HelperActions.stakeRandomlyInBothSidesOfMarket(deployedContracts.markets, setupUser, deployedContracts.longShort), (function (param) {
                                                                
                                                              }));
                                                }));
                                  }));
                    });
                describe("_updateSystemState", (function () {
                        
                      }));
                LazyDeposit.testIntegration(contracts, accounts);
                return LazyRedeem.testIntegration(contracts, accounts);
              }));
        return Globals.describeUnit("LongShort - internals exposed", (function (param) {
                      var contracts = {
                        contents: undefined
                      };
                      var accounts = {
                        contents: undefined
                      };
                      before(function () {
                            return LetOps.Await.let_(ethers.getSigners(), (function (loadedAccounts) {
                                          accounts.contents = loadedAccounts;
                                          
                                        }));
                          });
                      beforeEach(function () {
                            return LetOps.AwaitThen.let_(Helpers.inititialize(accounts.contents[0], true), (function (deployedContracts) {
                                          contracts.contents = deployedContracts;
                                          var firstMarketPaymentToken = deployedContracts.markets[1].paymentToken;
                                          var testUser = accounts.contents[1];
                                          return LetOps.Await.let_(Contract.PaymentTokenHelpers.mintAndApprove(firstMarketPaymentToken, testUser, ethers.BigNumber.from("10000000000000000000000"), deployedContracts.longShort.address), (function (param) {
                                                        
                                                      }));
                                        }));
                          });
                      return InitializeMarket.test(contracts, accounts);
                    }));
      }));

/*  Not a pure module */
