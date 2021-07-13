// Generated by ReScript, PLEASE EDIT WITH CARE
'use strict';

var Misc = require("../libraries/Misc.js");
var Curry = require("rescript/lib/js/curry.js");
var React = require("react");
var Client = require("./Client.js");
var Ethers = require("../ethereum/Ethers.js");
var Globals = require("../libraries/Globals.js");
var Queries = require("./Queries.js");
var CONSTANTS = require("../CONSTANTS.js");
var Belt_Array = require("rescript/lib/js/belt_Array.js");
var Caml_option = require("rescript/lib/js/caml_option.js");
var FromUnixTime = require("date-fns/fromUnixTime").default;

function liftGraphResponse2(a, b) {
  if (typeof a === "number") {
    return /* Loading */0;
  } else if (a.TAG === /* GraphError */0) {
    return {
            TAG: 0,
            _0: a._0,
            [Symbol.for("name")]: "GraphError"
          };
  } else if (typeof b === "number") {
    return /* Loading */0;
  } else if (b.TAG === /* GraphError */0) {
    return {
            TAG: 0,
            _0: b._0,
            [Symbol.for("name")]: "GraphError"
          };
  } else {
    return {
            TAG: 1,
            _0: [
              a._0,
              b._0
            ],
            [Symbol.for("name")]: "Response"
          };
  }
}

function useGetMarkets(param) {
  var marketDetailsQuery = Curry.app(Queries.MarketDetails.use, [
        undefined,
        undefined,
        undefined,
        undefined,
        undefined,
        undefined,
        undefined,
        undefined,
        undefined,
        undefined,
        undefined,
        undefined,
        undefined,
        undefined
      ]);
  var client = Client.useApolloClient(undefined);
  React.useEffect((function () {
          Curry._6(client.rescript_query, {
                  query: Queries.MarketDetails.query,
                  Raw: Queries.MarketDetails.Raw,
                  parse: Queries.MarketDetails.parse,
                  serialize: Queries.MarketDetails.serialize,
                  serializeVariables: Queries.MarketDetails.serializeVariables
                }, undefined, undefined, undefined, undefined, undefined).then(function (queryResult) {
                if (queryResult.TAG !== /* Ok */0) {
                  return ;
                }
                Belt_Array.map(queryResult._0.data.syntheticMarkets, (function (param) {
                        var syntheticShort = param.syntheticShort;
                        var syntheticLong = param.syntheticLong;
                        Curry._6(client.rescript_writeQuery, {
                              query: Queries.SyntheticToken.query,
                              Raw: Queries.SyntheticToken.Raw,
                              parse: Queries.SyntheticToken.parse,
                              serialize: Queries.SyntheticToken.serialize,
                              serializeVariables: Queries.SyntheticToken.serializeVariables
                            }, undefined, {
                              syntheticToken: syntheticLong
                            }, undefined, undefined, {
                              tokenId: syntheticLong.id
                            });
                        Curry._6(client.rescript_writeQuery, {
                              query: Queries.SyntheticToken.query,
                              Raw: Queries.SyntheticToken.Raw,
                              parse: Queries.SyntheticToken.parse,
                              serialize: Queries.SyntheticToken.serialize,
                              serializeVariables: Queries.SyntheticToken.serializeVariables
                            }, undefined, {
                              syntheticToken: syntheticShort
                            }, undefined, undefined, {
                              tokenId: syntheticShort.id
                            });
                        
                      }));
                
              });
          
        }), []);
  var match = marketDetailsQuery.data;
  if (match !== undefined) {
    return {
            TAG: 1,
            _0: match.syntheticMarkets,
            [Symbol.for("name")]: "Response"
          };
  }
  var match$1 = marketDetailsQuery.error;
  if (match$1 !== undefined) {
    return {
            TAG: 0,
            _0: match$1.message,
            [Symbol.for("name")]: "GraphError"
          };
  } else {
    return /* Loading */0;
  }
}

function useTotalClaimableFloatForUser(userId, synthTokens) {
  var currentTimestamp = Misc.Time.useCurrentTimeBN(1000);
  var floatQuery = Curry.app(Queries.UsersFloatDetails.use, [
        undefined,
        undefined,
        undefined,
        undefined,
        undefined,
        undefined,
        undefined,
        undefined,
        undefined,
        undefined,
        undefined,
        undefined,
        undefined,
        {
          userId: userId,
          synthTokens: synthTokens
        }
      ]);
  var match = floatQuery.data;
  if (match !== undefined) {
    var initialState = {
      TAG: 1,
      _0: [
        CONSTANTS.zeroBN,
        CONSTANTS.zeroBN
      ],
      [Symbol.for("name")]: "Response"
    };
    return Belt_Array.reduce(match.currentStakes, initialState, (function (curState, stake) {
                  if (typeof curState === "number") {
                    return /* Loading */0;
                  }
                  if (curState.TAG === /* GraphError */0) {
                    return {
                            TAG: 0,
                            _0: curState._0,
                            [Symbol.for("name")]: "GraphError"
                          };
                  }
                  var match = curState._0;
                  var amount = stake.currentStake.amount;
                  var timestamp = stake.lastMintState.timestamp;
                  var isLong = stake.syntheticToken.id === stake.lastMintState.longToken.id;
                  var lastAccumulativeFloatPerToken = isLong ? stake.lastMintState.accumulativeFloatPerTokenLong : stake.lastMintState.accumulativeFloatPerTokenShort;
                  var accumulativeFloatPerToken = isLong ? stake.syntheticMarket.latestStakerState.accumulativeFloatPerTokenLong : stake.syntheticMarket.latestStakerState.accumulativeFloatPerTokenShort;
                  var floatRatePerTokenOverInterval = isLong ? stake.syntheticMarket.latestStakerState.floatRatePerTokenOverIntervalLong : stake.syntheticMarket.latestStakerState.floatRatePerTokenOverIntervalShort;
                  var claimableFloat = accumulativeFloatPerToken.sub(lastAccumulativeFloatPerToken).mul(amount).div(CONSTANTS.tenToThe42).add(match[0]);
                  var predictedFloat = currentTimestamp.sub(timestamp).mul(floatRatePerTokenOverInterval).mul(amount).div(CONSTANTS.tenToThe42).add(match[1]);
                  return {
                          TAG: 1,
                          _0: [
                            claimableFloat,
                            predictedFloat
                          ],
                          [Symbol.for("name")]: "Response"
                        };
                }));
  }
  var match$1 = floatQuery.error;
  if (match$1 !== undefined) {
    return {
            TAG: 0,
            _0: match$1.message,
            [Symbol.for("name")]: "GraphError"
          };
  } else {
    return /* Loading */0;
  }
}

function useClaimableFloatForUser(userId, synthToken) {
  return useTotalClaimableFloatForUser(userId, [synthToken]);
}

function useStakesForUser(userId) {
  var activeStakesQuery = Curry.app(Queries.UsersStakes.use, [
        undefined,
        undefined,
        undefined,
        undefined,
        undefined,
        undefined,
        undefined,
        undefined,
        undefined,
        undefined,
        undefined,
        undefined,
        undefined,
        {
          userId: userId
        }
      ]);
  var match = activeStakesQuery.data;
  if (match !== undefined) {
    return {
            TAG: 1,
            _0: match.currentStakes,
            [Symbol.for("name")]: "Response"
          };
  }
  var match$1 = activeStakesQuery.error;
  if (match$1 !== undefined) {
    return {
            TAG: 0,
            _0: match$1.message,
            [Symbol.for("name")]: "GraphError"
          };
  } else {
    return /* Loading */0;
  }
}

function useUsersBalances(userId) {
  var usersTokensQuery = Curry.app(Queries.UsersBalances.use, [
        undefined,
        undefined,
        undefined,
        undefined,
        undefined,
        undefined,
        undefined,
        undefined,
        undefined,
        undefined,
        undefined,
        undefined,
        undefined,
        {
          userId: userId
        }
      ]);
  var match = usersTokensQuery.data;
  if (match !== undefined) {
    var match$1 = match.user;
    if (match$1 !== undefined) {
      return {
              TAG: 1,
              _0: match$1.tokenBalances,
              [Symbol.for("name")]: "Response"
            };
    } else {
      return {
              TAG: 1,
              _0: [],
              [Symbol.for("name")]: "Response"
            };
    }
  }
  var match$2 = usersTokensQuery.error;
  if (match$2 !== undefined) {
    return {
            TAG: 0,
            _0: match$2.message,
            [Symbol.for("name")]: "GraphError"
          };
  } else {
    return /* Loading */0;
  }
}

function useUsersPendingMints(userId) {
  var usersPendingMintsQuery = Curry.app(Queries.UsersPendingMints.use, [
        undefined,
        undefined,
        undefined,
        undefined,
        undefined,
        undefined,
        undefined,
        undefined,
        undefined,
        undefined,
        undefined,
        undefined,
        undefined,
        {
          userId: userId
        }
      ]);
  var match = usersPendingMintsQuery.data;
  if (match !== undefined) {
    var match$1 = match.user;
    if (match$1 === undefined) {
      return {
              TAG: 1,
              _0: [{
                  isLong: false,
                  amount: CONSTANTS.zeroBN,
                  marketIndex: CONSTANTS.zeroBN,
                  confirmedTimestamp: CONSTANTS.zeroBN
                }],
              [Symbol.for("name")]: "Response"
            };
    }
    var result = Belt_Array.map(Belt_Array.keep(match$1.pendingNextPriceActions, (function (pendingNextPriceAction) {
                if (pendingNextPriceAction.amountPaymentTokenForDepositShort.gt(CONSTANTS.zeroBN)) {
                  return true;
                } else {
                  return pendingNextPriceAction.amountPaymentTokenForDepositLong.gt(CONSTANTS.zeroBN);
                }
              })), (function (pendingNextPriceAction) {
            var isLong = pendingNextPriceAction.amountPaymentTokenForDepositLong.gt(CONSTANTS.zeroBN);
            return {
                    isLong: isLong,
                    amount: isLong ? pendingNextPriceAction.amountPaymentTokenForDepositLong : pendingNextPriceAction.amountPaymentTokenForDepositShort,
                    marketIndex: pendingNextPriceAction.marketIndex,
                    confirmedTimestamp: pendingNextPriceAction.confirmedTimestamp
                  };
          }));
    return {
            TAG: 1,
            _0: result,
            [Symbol.for("name")]: "Response"
          };
  }
  var match$2 = usersPendingMintsQuery.error;
  if (match$2 !== undefined) {
    return {
            TAG: 0,
            _0: match$2.message,
            [Symbol.for("name")]: "GraphError"
          };
  } else {
    return /* Loading */0;
  }
}

function useUsersConfirmedMints(userId) {
  var usersConfirmedMintsQuery = Curry.app(Queries.UsersConfirmedMints.use, [
        undefined,
        undefined,
        undefined,
        undefined,
        /* NetworkOnly */3,
        undefined,
        undefined,
        undefined,
        undefined,
        undefined,
        undefined,
        undefined,
        undefined,
        {
          userId: userId
        }
      ]);
  var match = usersConfirmedMintsQuery.data;
  if (match !== undefined) {
    var match$1 = match.user;
    if (match$1 === undefined) {
      return {
              TAG: 1,
              _0: [{
                  isLong: false,
                  amount: CONSTANTS.zeroBN,
                  marketIndex: CONSTANTS.zeroBN
                }],
              [Symbol.for("name")]: "Response"
            };
    }
    var result = Belt_Array.map(Belt_Array.keep(match$1.confirmedNextPriceActions, (function (confirmedNextPriceAction) {
                if (confirmedNextPriceAction.amountPaymentTokenForDepositShort.gt(CONSTANTS.zeroBN)) {
                  return true;
                } else {
                  return confirmedNextPriceAction.amountPaymentTokenForDepositLong.gt(CONSTANTS.zeroBN);
                }
              })), (function (confirmedNextPriceAction) {
            var isLong = confirmedNextPriceAction.amountPaymentTokenForDepositLong.gt(CONSTANTS.zeroBN);
            return {
                    isLong: isLong,
                    amount: isLong ? confirmedNextPriceAction.amountPaymentTokenForDepositLong : confirmedNextPriceAction.amountPaymentTokenForDepositShort,
                    marketIndex: confirmedNextPriceAction.marketIndex
                  };
          }));
    return {
            TAG: 1,
            _0: result,
            [Symbol.for("name")]: "Response"
          };
  }
  var match$2 = usersConfirmedMintsQuery.error;
  if (match$2 !== undefined) {
    return {
            TAG: 0,
            _0: match$2.message,
            [Symbol.for("name")]: "GraphError"
          };
  } else {
    return /* Loading */0;
  }
}

function useFloatBalancesForUser(userId) {
  var usersStateQuery = Curry.app(Queries.UserQuery.use, [
        undefined,
        undefined,
        undefined,
        undefined,
        undefined,
        undefined,
        undefined,
        undefined,
        undefined,
        undefined,
        undefined,
        undefined,
        undefined,
        {
          userId: userId
        }
      ]);
  var match = usersStateQuery.data;
  if (match !== undefined) {
    var user = match.user;
    if (user !== undefined) {
      return {
              TAG: 1,
              _0: {
                floatBalance: user.floatTokenBalance,
                floatMinted: user.totalMintedFloat
              },
              [Symbol.for("name")]: "Response"
            };
    } else {
      return {
              TAG: 1,
              _0: {
                floatBalance: CONSTANTS.zeroBN,
                floatMinted: CONSTANTS.zeroBN
              },
              [Symbol.for("name")]: "Response"
            };
    }
  }
  var match$1 = usersStateQuery.error;
  if (match$1 !== undefined) {
    return {
            TAG: 0,
            _0: match$1.message,
            [Symbol.for("name")]: "GraphError"
          };
  } else {
    return /* Loading */0;
  }
}

function useBasicUserInfo(userId) {
  var userQuery = Curry.app(Queries.UserQuery.use, [
        undefined,
        undefined,
        undefined,
        undefined,
        undefined,
        undefined,
        undefined,
        undefined,
        undefined,
        undefined,
        undefined,
        undefined,
        undefined,
        {
          userId: userId
        }
      ]);
  var match = userQuery.data;
  if (match !== undefined) {
    var match$1 = match.user;
    if (match$1 !== undefined) {
      return {
              TAG: 1,
              _0: {
                _0: {
                  id: match$1.id,
                  joinedAt: FromUnixTime(match$1.timestampJoined.toNumber()),
                  gasUsed: match$1.totalGasUsed,
                  floatMinted: match$1.totalMintedFloat,
                  floatBalance: match$1.floatTokenBalance,
                  transactionCount: match$1.numberOfTransactions
                },
                [Symbol.for("name")]: "ExistingUser"
              },
              [Symbol.for("name")]: "Response"
            };
    } else {
      return {
              TAG: 1,
              _0: /* NewUser */0,
              [Symbol.for("name")]: "Response"
            };
    }
  }
  var match$2 = userQuery.error;
  if (match$2 !== undefined) {
    return {
            TAG: 0,
            _0: match$2.message,
            [Symbol.for("name")]: "GraphError"
          };
  } else {
    return /* Loading */0;
  }
}

function useSyntheticTokenBalance(user, tokenAddress) {
  var syntheticBalanceQuery = Curry.app(Queries.UsersBalance.use, [
        undefined,
        undefined,
        undefined,
        undefined,
        undefined,
        undefined,
        undefined,
        undefined,
        undefined,
        undefined,
        undefined,
        undefined,
        undefined,
        {
          userId: Globals.ethAdrToLowerStr(user),
          tokenAdr: Globals.ethAdrToLowerStr(tokenAddress)
        }
      ]);
  var match = syntheticBalanceQuery.data;
  if (match !== undefined) {
    var match$1 = match.user;
    if (match$1 !== undefined) {
      var match$2 = match$1.tokenBalances;
      if (match$2.length === 1) {
        var match$3 = match$2[0];
        return {
                TAG: 1,
                _0: match$3.tokenBalance,
                [Symbol.for("name")]: "Response"
              };
      }
      
    }
    
  }
  var match$4 = syntheticBalanceQuery.error;
  if (match$4 !== undefined) {
    return {
            TAG: 0,
            _0: match$4.message,
            [Symbol.for("name")]: "GraphError"
          };
  } else {
    return /* Loading */0;
  }
}

function useSyntheticTokenBalanceOrZero(user, tokenAddress) {
  var syntheticBalanceQuery = Curry.app(Queries.UsersBalance.use, [
        undefined,
        undefined,
        undefined,
        undefined,
        undefined,
        undefined,
        undefined,
        undefined,
        undefined,
        undefined,
        undefined,
        undefined,
        undefined,
        {
          userId: Globals.ethAdrToLowerStr(user),
          tokenAdr: Globals.ethAdrToLowerStr(tokenAddress)
        }
      ]);
  var match = syntheticBalanceQuery.data;
  if (match !== undefined) {
    var match$1 = match.user;
    if (match$1 === undefined) {
      return {
              TAG: 1,
              _0: CONSTANTS.zeroBN,
              [Symbol.for("name")]: "Response"
            };
    }
    var match$2 = match$1.tokenBalances;
    if (match$2.length !== 1) {
      return {
              TAG: 1,
              _0: CONSTANTS.zeroBN,
              [Symbol.for("name")]: "Response"
            };
    }
    var match$3 = match$2[0];
    return {
            TAG: 1,
            _0: match$3.tokenBalance,
            [Symbol.for("name")]: "Response"
          };
  }
  var match$4 = syntheticBalanceQuery.error;
  if (match$4 !== undefined) {
    return {
            TAG: 0,
            _0: match$4.message,
            [Symbol.for("name")]: "GraphError"
          };
  } else {
    return /* Loading */0;
  }
}

function useTokenPriceAtTime(tokenAddress, timestamp) {
  var query = Curry.app(Queries.TokenPrice.use, [
        undefined,
        undefined,
        undefined,
        undefined,
        undefined,
        undefined,
        undefined,
        undefined,
        undefined,
        undefined,
        undefined,
        undefined,
        undefined,
        {
          tokenAddress: Ethers.Utils.ethAdrToLowerStr(tokenAddress),
          timestamp: timestamp.toNumber()
        }
      ]);
  var match = query.data;
  if (match !== undefined) {
    var match$1 = match.prices;
    if (match$1.length !== 1) {
      return {
              TAG: 0,
              _0: "Couldn't find price with that timestamp.",
              [Symbol.for("name")]: "GraphError"
            };
    }
    var match$2 = match$1[0];
    return {
            TAG: 1,
            _0: match$2.price,
            [Symbol.for("name")]: "Response"
          };
  }
  var match$3 = query.error;
  if (match$3 !== undefined) {
    return {
            TAG: 0,
            _0: match$3.message,
            [Symbol.for("name")]: "GraphError"
          };
  } else {
    return /* Loading */0;
  }
}

function graphResponseToOption(maybeData) {
  if (typeof maybeData === "number" || maybeData.TAG === /* GraphError */0) {
    return ;
  } else {
    return Caml_option.some(maybeData._0);
  }
}

function graphResponseToResult(maybeData) {
  if (typeof maybeData === "number") {
    return {
            TAG: 0,
            _0: /* Loading */0,
            [Symbol.for("name")]: "Ok"
          };
  } else if (maybeData.TAG === /* GraphError */0) {
    return {
            TAG: 1,
            _0: maybeData._0,
            [Symbol.for("name")]: "Error"
          };
  } else {
    return {
            TAG: 0,
            _0: {
              _0: maybeData._0,
              [Symbol.for("name")]: "Data"
            },
            [Symbol.for("name")]: "Ok"
          };
  }
}

function queryToResponse(query) {
  var response = query.data;
  var match = query.error;
  if (match !== undefined) {
    return {
            TAG: 0,
            _0: match.message,
            [Symbol.for("name")]: "GraphError"
          };
  } else if (response !== undefined) {
    return {
            TAG: 1,
            _0: Caml_option.valFromOption(response),
            [Symbol.for("name")]: "Response"
          };
  } else {
    return /* Loading */0;
  }
}

var Util = {
  graphResponseToOption: graphResponseToOption,
  graphResponseToResult: graphResponseToResult,
  queryToResponse: queryToResponse
};

function useTokenMarketId(tokenId) {
  var marketIdQuery = Curry.app(Queries.TokenMarketId.use, [
        undefined,
        undefined,
        undefined,
        undefined,
        undefined,
        undefined,
        undefined,
        undefined,
        undefined,
        undefined,
        undefined,
        undefined,
        undefined,
        {
          tokenId: tokenId
        }
      ]);
  var match = marketIdQuery.data;
  if (match !== undefined) {
    var match$1 = match.syntheticToken;
    if (match$1 !== undefined) {
      return {
              TAG: 1,
              _0: match$1.syntheticMarket.id,
              [Symbol.for("name")]: "Response"
            };
    } else {
      return {
              TAG: 1,
              _0: "1",
              [Symbol.for("name")]: "Response"
            };
    }
  }
  var match$2 = marketIdQuery.error;
  if (match$2 !== undefined) {
    return {
            TAG: 0,
            _0: match$2.message,
            [Symbol.for("name")]: "GraphError"
          };
  } else {
    return /* Loading */0;
  }
}

function getUnixTime(date) {
  return date.getTime() / 1000 | 0;
}

function useOracleLastUpdate(marketIndex) {
  var oracleLastUpdateQuery = Curry.app(Queries.OraclesLastUpdate.use, [
        undefined,
        undefined,
        undefined,
        undefined,
        /* NetworkOnly */3,
        undefined,
        undefined,
        undefined,
        undefined,
        undefined,
        undefined,
        undefined,
        undefined,
        {
          marketIndex: marketIndex
        }
      ]);
  var match = oracleLastUpdateQuery.data;
  if (match !== undefined) {
    var match$1 = match.underlyingPrices;
    if (match$1.length === 1) {
      var match$2 = match$1[0];
      return {
              TAG: 1,
              _0: match$2.timeUpdated,
              [Symbol.for("name")]: "Response"
            };
    }
    
  }
  var match$3 = oracleLastUpdateQuery.error;
  if (match$3 !== undefined) {
    return {
            TAG: 0,
            _0: match$3.message,
            [Symbol.for("name")]: "GraphError"
          };
  } else {
    return /* Loading */0;
  }
}

var ethAdrToLowerStr = Globals.ethAdrToLowerStr;

exports.liftGraphResponse2 = liftGraphResponse2;
exports.ethAdrToLowerStr = ethAdrToLowerStr;
exports.useGetMarkets = useGetMarkets;
exports.useTotalClaimableFloatForUser = useTotalClaimableFloatForUser;
exports.useClaimableFloatForUser = useClaimableFloatForUser;
exports.useStakesForUser = useStakesForUser;
exports.useUsersBalances = useUsersBalances;
exports.useUsersPendingMints = useUsersPendingMints;
exports.useUsersConfirmedMints = useUsersConfirmedMints;
exports.useFloatBalancesForUser = useFloatBalancesForUser;
exports.useBasicUserInfo = useBasicUserInfo;
exports.useSyntheticTokenBalance = useSyntheticTokenBalance;
exports.useSyntheticTokenBalanceOrZero = useSyntheticTokenBalanceOrZero;
exports.useTokenPriceAtTime = useTokenPriceAtTime;
exports.Util = Util;
exports.useTokenMarketId = useTokenMarketId;
exports.getUnixTime = getUnixTime;
exports.useOracleLastUpdate = useOracleLastUpdate;
/* Misc Not a pure module */
