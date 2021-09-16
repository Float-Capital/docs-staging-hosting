// Generated by ReScript, PLEASE EDIT WITH CARE
'use strict';

var Curry = require("rescript/lib/js/curry.js");
var Config = require("./library/Config.bs.js");
var Ethers = require("./library/Ethers.bs.js");
var Ethers$1 = require("ethers");
var Contracts = require("./library/Contracts.bs.js");
var JsPromise = require("./library/Js.Promise/JsPromise.bs.js");
var Belt_Array = require("rescript/lib/js/belt_Array.js");
var Belt_Option = require("rescript/lib/js/belt_Option.js");

((require('isomorphic-fetch')));

var oneGweiInWei = Ethers$1.BigNumber.from(1000000000);

function getGasPrice(param) {
  return JsPromise.$$catch(fetch("https://gasstation-mainnet.matic.network").then(function (prim) {
                          return prim.json();
                        }).then(function (response) {
                        return response.fast;
                      }), (function (err) {
                      console.log("Error fetching gas price:", err);
                      return Promise.resolve(85);
                    })).then(function (result) {
                  return Belt_Option.getWithDefault(result, 85);
                }).then(function (prim) {
                return Ethers$1.BigNumber.from(prim);
              }).then(function (param) {
              return oneGweiInWei.mul(param);
            });
}

function getAggregatorAddresses(chainlinkOracleAddresses, wallet) {
  var signer = Ethers.getSigner(wallet);
  return Promise.all(Belt_Array.map(Object.keys(chainlinkOracleAddresses), (function (addressString) {
                    var address = Ethers$1.utils.getAddress(addressString);
                    var oracle = Contracts.Oracle.make(address, signer);
                    return oracle.phaseId().then(function (id) {
                                return oracle.phaseAggregators(id);
                              });
                  })));
}

function mapWalletBalance(wallet, fn) {
  return wallet.getBalance().then(Curry.__1(fn));
}

function getJsonProviders(providerUrls) {
  return Promise.all(Belt_Array.map(providerUrls, (function (url) {
                    return new (Ethers$1.providers.JsonRpcProvider)(url, Belt_Option.getWithDefault(Config.config.chainId, 80001));
                  })));
}

function getProvider(urls) {
  return getJsonProviders(urls).then(function (providers) {
              return new (Ethers$1.providers.FallbackProvider)(providers, 1);
            });
}

var wallet = {
  contents: undefined
};

var provider = {
  contents: undefined
};

var updateCounter = {
  contents: 0
};

function runUpdateSystemStateMulti(marketsToUpdate) {
  updateCounter.contents = updateCounter.contents + 1 | 0;
  console.log("running update", updateCounter.contents);
  var balanceBefore = {
    contents: undefined
  };
  return mapWalletBalance(wallet.contents, (function (balance) {
                    balanceBefore.contents = balance;
                    console.log("Matic balance pre contract call: ", Ethers.Utils.formatEther(balance));
                    
                  })).then(function (param) {
                var contract = Contracts.LongShort.make(Config.config.longShortContractAddress, Ethers.getSigner(wallet.contents));
                return getGasPrice(undefined).then(function (gasPrice) {
                            var transactionOptions = {
                              gasPrice: gasPrice
                            };
                            console.log(marketsToUpdate, transactionOptions);
                            return contract.functions.updateSystemStateMulti(marketsToUpdate, transactionOptions).then(function (update) {
                                            console.log("submitted transaction", update.hash);
                                            return update.wait();
                                          }).then(function (param) {
                                          return function (param) {
                                            console.log("Transaction processes", param);
                                            
                                          };
                                        }).catch(function (e) {
                                        console.log("ERROR");
                                        console.log("-------------------");
                                        console.log(e);
                                        
                                      });
                          });
              }).then(function (param) {
              return mapWalletBalance(wallet.contents, (function (balance) {
                            console.log("Matic balance post contract call:", Ethers.Utils.formatEther(balance), "gas used", Ethers.Utils.formatEther(balanceBefore.contents.sub(balance)));
                            
                          }));
            });
}

function setup(param) {
  return Promise.all([
                    getProvider(Config.secrets.providerUrls),
                    new (Ethers$1.Wallet.fromMnemonic)(Config.secrets.mnemonic)
                  ]).then(function (param) {
                  var _provider = param[0];
                  console.log("Got network.");
                  provider.contents = _provider;
                  wallet.contents = param[1].connect(_provider);
                  console.log("Initial update system state");
                  return runUpdateSystemStateMulti(Config.config.defaultMarkets);
                }).then(function (param) {
                console.log("-------------------------");
                console.log("Getting aggregator addresses");
                return getAggregatorAddresses(Config.config.chainlinkOracleAddresses, wallet.contents);
              }).then(function (aggregatorAddresses) {
              Belt_Array.forEachWithIndex(aggregatorAddresses, (function (index, address) {
                      var filter_topics = [Ethers$1.utils.id("AnswerUpdated(int256,uint256,uint256)")];
                      var filter = {
                        address: address,
                        topics: filter_topics
                      };
                      provider.contents.on(filter, (function (param) {
                              var updatedOracleAddress = Object.keys(Config.config.chainlinkOracleAddresses)[index];
                              var linkedMarketIds = Config.config.chainlinkOracleAddresses[updatedOracleAddress].linkedMarketIds;
                              console.log("Price updated for oracle " + updatedOracleAddress);
                              runUpdateSystemStateMulti(linkedMarketIds);
                              
                            }));
                      
                    }));
              console.log("Listening for new answers.");
              
            });
}

setup(undefined);

var config = Config.config;

var secrets = Config.secrets;

var defaultGasPriceInGwei = 85;

exports.config = config;
exports.secrets = secrets;
exports.oneGweiInWei = oneGweiInWei;
exports.defaultGasPriceInGwei = defaultGasPriceInGwei;
exports.getGasPrice = getGasPrice;
exports.getAggregatorAddresses = getAggregatorAddresses;
exports.mapWalletBalance = mapWalletBalance;
exports.getJsonProviders = getJsonProviders;
exports.getProvider = getProvider;
exports.wallet = wallet;
exports.provider = provider;
exports.updateCounter = updateCounter;
exports.runUpdateSystemStateMulti = runUpdateSystemStateMulti;
exports.setup = setup;
/*  Not a pure module */
