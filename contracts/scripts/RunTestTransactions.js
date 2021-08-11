// Generated by ReScript, PLEASE EDIT WITH CARE
'use strict';

var LetOps = require("../test-waffle/library/LetOps.js");
var DeployHelpers = require("./DeployHelpers.js");

function runTestTransactions(param) {
  var treasury = param.treasury;
  var paymentToken = param.paymentToken;
  var longShort = param.longShort;
  return LetOps.Await.let_(ethers.getSigners(), (function (loadedAccounts) {
                var admin = loadedAccounts[1];
                var user1 = loadedAccounts[2];
                var user2 = loadedAccounts[3];
                var user3 = loadedAccounts[4];
                return LetOps.AwaitThen.let_(DeployHelpers.topupBalanceIfLow(admin, user1), (function (param) {
                              return LetOps.AwaitThen.let_(DeployHelpers.topupBalanceIfLow(admin, user2), (function (param) {
                                            return LetOps.AwaitThen.let_(DeployHelpers.topupBalanceIfLow(admin, user3), (function (param) {
                                                          return LetOps.AwaitThen.let_(DeployHelpers.deployTestMarket("syntheticName", "syntheticSymbol", longShort, treasury, admin, "networkName", paymentToken), (function (param) {
                                                                        console.log("Happy console log");
                                                                        return Promise.resolve(undefined);
                                                                      }));
                                                        }));
                                          }));
                            }));
              }));
}

exports.runTestTransactions = runTestTransactions;
/* DeployHelpers Not a pure module */
