// Generated by ReScript, PLEASE EDIT WITH CARE
'use strict';

var Chai = require("../../bindings/chai/Chai.js");
var LetOps = require("../../library/LetOps.js");
var Helpers = require("../../library/Helpers.js");
var ERC20Mock = require("../../library/contracts/ERC20Mock.js");
var YieldManagerAave = require("../../library/contracts/YieldManagerAave.js");

describe("YieldManagerAave", (function () {
        describe("WithdrawTokens", (function () {
                describe("WithdrawWmaticToTreasury mocks", (function () {
                        var accounts = {
                          contents: undefined
                        };
                        var contracts = {
                          contents: undefined
                        };
                        var amountOfWMaticInYieldManager = Helpers.randomTokenAmount(undefined);
                        beforeEach(function () {
                              return LetOps.AwaitThen.let_(ethers.getSigners(), (function (loadedAccounts) {
                                            accounts.contents = loadedAccounts;
                                            var admin = loadedAccounts[0];
                                            var treasury = loadedAccounts[1];
                                            var daiAddress = ethers.Wallet.createRandom().address;
                                            var longShortAddress = ethers.Wallet.createRandom().address;
                                            var lendingPoolAddress = ethers.Wallet.createRandom().address;
                                            var fundTokenAddress = ethers.Wallet.createRandom().address;
                                            return LetOps.AwaitThen.let_(ERC20Mock.make("TestADAI", "ADAI"), (function (erc20Mock) {
                                                          return LetOps.AwaitThen.let_(YieldManagerAave.make(admin.address, longShortAddress, treasury.address, daiAddress, fundTokenAddress, lendingPoolAddress, 6543), (function (yieldManagerAave) {
                                                                        return LetOps.Await.let_(erc20Mock.mint(yieldManagerAave.address, amountOfWMaticInYieldManager), (function (param) {
                                                                                      contracts.contents = {
                                                                                        erc20Mock: erc20Mock,
                                                                                        yieldManagerAave: yieldManagerAave
                                                                                      };
                                                                                      
                                                                                    }));
                                                                      }));
                                                        }));
                                          }));
                            });
                        it("allows treasury to call 'transfer' function on any erc20 to transfer it to the treasury", (function () {
                                var treasury = accounts.contents[1];
                                var withdrawErc20TokenToTreasuryTxPromise = contracts.contents.yieldManagerAave.connect(treasury).withdrawErc20TokenToTreasury(contracts.contents.erc20Mock.address);
                                return Chai.callEmitEvents(withdrawErc20TokenToTreasuryTxPromise, contracts.contents.erc20Mock, "TransferCalled").withArgs(contracts.contents.yieldManagerAave.address, treasury.address, amountOfWMaticInYieldManager);
                              }));
                        it("Should withdraw WMATIC to the treasury", (function () {
                                return Promise.resolve(undefined);
                              }));
                        it("should revert if not called by treasury", (function () {
                                return Promise.resolve(undefined);
                              }));
                        it("should revert if trying to withdraw aToken", (function () {
                                return Promise.resolve(undefined);
                              }));
                        
                      }));
                
              }));
        
      }));

/*  Not a pure module */
