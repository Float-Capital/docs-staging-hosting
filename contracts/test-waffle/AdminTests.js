// Generated by ReScript, PLEASE EDIT WITH CARE
'use strict';

var Chai = require("./bindings/chai/Chai.js");
var Helpers = require("./library/Helpers.js");
var Mocha$BsMocha = require("bs-mocha/src/Mocha.js");
var Promise$BsMocha = require("bs-mocha/src/Promise.js");

Mocha$BsMocha.describe("Float System")(undefined, undefined, undefined, (function (param) {
        return Mocha$BsMocha.describe("Admin")(undefined, undefined, undefined, (function (param) {
                      var contracts = {
                        contents: undefined
                      };
                      var accounts = {
                        contents: undefined
                      };
                      Promise$BsMocha.before(undefined)(undefined, undefined, undefined, (function (param) {
                              return ethers.getSigners().then(function (loadedAccounts) {
                                          accounts.contents = loadedAccounts;
                                          
                                        });
                            }));
                      Promise$BsMocha.before_each(undefined)(undefined, undefined, undefined, (function (param) {
                              return Helpers.inititialize(accounts.contents[0]).then(function (deployedContracts) {
                                          contracts.contents = deployedContracts;
                                          
                                        });
                            }));
                      return Promise$BsMocha.it("shouldn't allow non admin to update the oracle")(undefined, undefined, undefined, (function (param) {
                                    var newOracleAddress = ethers.Wallet.createRandom().address;
                                    return Chai.expectRevert(contracts.contents.longShort.attach(accounts.contents[5].address).updateMarketOracle(1, newOracleAddress), "only admin");
                                  }));
                    }));
      }));

var it$prime = Promise$BsMocha.it;

var it_skip$prime = Promise$BsMocha.it_skip;

var before_each = Promise$BsMocha.before_each;

var before = Promise$BsMocha.before;

var describe = Mocha$BsMocha.describe;

var it = Mocha$BsMocha.it;

var it_skip = Mocha$BsMocha.it_skip;

exports.it$prime = it$prime;
exports.it_skip$prime = it_skip$prime;
exports.before_each = before_each;
exports.before = before;
exports.describe = describe;
exports.it = it;
exports.it_skip = it_skip;
/*  Not a pure module */
