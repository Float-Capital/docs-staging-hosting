// Generated by ReScript, PLEASE EDIT WITH CARE
'use strict';

var Chai = require("./bindings/chai/Chai.js");
var LetOps = require("./library/LetOps.js");
var Globals = require("./library/Globals.js");
var Helpers = require("./library/Helpers.js");

describe("Float System", (function () {
        return Globals.describeBoth("Admin", (function (param) {
                      var contracts = {
                        contents: undefined
                      };
                      var accounts = {
                        contents: undefined
                      };
                      before(function () {
                            return LetOps.Await.let_(ethers.getSigners(), (function (loadedAccounts) {
                                          accounts.contents = loadedAccounts;
                                          return LetOps.Await.let_(Helpers.inititialize(accounts.contents[0], false), (function (deployedContracts) {
                                                        contracts.contents = deployedContracts;
                                                        
                                                      }));
                                        }));
                          });
                      describe("updateMarketOracle", (function () {
                              var newOracleManager = ethers.Wallet.createRandom().address;
                              it("should allow admin to update the oracle", (function () {
                                      return LetOps.Await.let_(contracts.contents.longShort.oracleManagers(1), (function (originalOracleAddress) {
                                                    return LetOps.Await.let_(contracts.contents.longShort.updateMarketOracle(1, newOracleManager), (function (param) {
                                                                  return LetOps.Await.let_(contracts.contents.longShort.oracleManagers(1), (function (updatedOracleAddress) {
                                                                                Chai.addressEqual(undefined, updatedOracleAddress, newOracleManager);
                                                                                return LetOps.Await.let_(contracts.contents.longShort.updateMarketOracle(1, originalOracleAddress), (function (param) {
                                                                                              
                                                                                            }));
                                                                              }));
                                                                }));
                                                  }));
                                    }));
                              it("shouldn't allow non admin to update the oracle", (function () {
                                      var attackerAddress = accounts.contents[5];
                                      return Chai.expectRevert(contracts.contents.longShort.connect(attackerAddress).updateMarketOracle(1, newOracleManager), "only admin");
                                    }));
                              
                            }));
                      describe("changeAdmin", (function () {
                              it("should allow admin to update the admin address", (function () {
                                      var originalAdminAddress = accounts.contents[0].address;
                                      var newAdmin = accounts.contents[5];
                                      var newAdminAddress = newAdmin.address;
                                      return LetOps.Await.let_(contracts.contents.longShort.changeAdmin(newAdminAddress), (function (param) {
                                                    return LetOps.Await.let_(contracts.contents.longShort.admin(), (function (adminFromContract) {
                                                                  Chai.addressEqual("Admin should be updated by 'changeAdmin' function", adminFromContract, newAdminAddress);
                                                                  return LetOps.Await.let_(contracts.contents.longShort.connect(newAdmin).changeAdmin(originalAdminAddress), (function (param) {
                                                                                
                                                                              }));
                                                                }));
                                                  }));
                                    }));
                              it("shouldn't allow non admin to update the Admin", (function () {
                                      var attackerAddress = accounts.contents[5];
                                      var newAdminAddress = accounts.contents[6].address;
                                      return Chai.expectRevert(contracts.contents.longShort.connect(attackerAddress).changeAdmin(newAdminAddress), "only admin");
                                    }));
                              
                            }));
                      describe("changeTreasury", (function () {
                              var newTreasuryAddress = ethers.Wallet.createRandom().address;
                              it("should allow admin to update the treasury address", (function () {
                                      return LetOps.Await.let_(contracts.contents.longShort.changeTreasury(newTreasuryAddress), (function (param) {
                                                    return LetOps.Await.let_(contracts.contents.longShort.treasury(), (function (treasuryFromContract) {
                                                                  return Chai.addressEqual(undefined, treasuryFromContract, newTreasuryAddress);
                                                                }));
                                                  }));
                                    }));
                              it("shouldn't allow non admin to update the treasury address", (function () {
                                      var attackerAddress = accounts.contents[5];
                                      return Chai.expectRevert(contracts.contents.longShort.connect(attackerAddress).changeTreasury(newTreasuryAddress), "only admin");
                                    }));
                              
                            }));
                      
                    }));
      }));

/*  Not a pure module */
