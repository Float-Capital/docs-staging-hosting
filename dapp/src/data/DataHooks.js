// Generated by ReScript, PLEASE EDIT WITH CARE

import * as Misc from "../libraries/Misc.js";
import * as Curry from "rescript/lib/es6/curry.js";
import * as React from "react";
import * as Client from "./Client.js";
import * as Ethers from "ethers";
import * as Globals from "../libraries/Globals.js";
import * as Queries from "./Queries.js";
import * as CONSTANTS from "../CONSTANTS.js";
import * as Belt_Array from "rescript/lib/es6/belt_Array.js";
import * as Caml_option from "rescript/lib/es6/caml_option.js";
import FromUnixTime from "date-fns/fromUnixTime";

function liftGraphResponse2(a, b) {
  if (typeof a === "number") {
    return /* Loading */0;
  } else if (a.TAG === /* GraphError */0) {
    return {
            TAG: /* GraphError */0,
            _0: a._0
          };
  } else if (typeof b === "number") {
    return /* Loading */0;
  } else if (b.TAG === /* GraphError */0) {
    return {
            TAG: /* GraphError */0,
            _0: b._0
          };
  } else {
    return {
            TAG: /* Response */1,
            _0: [
              a._0,
              b._0
            ]
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
            TAG: /* Response */1,
            _0: match.syntheticMarkets
          };
  }
  var match$1 = marketDetailsQuery.error;
  if (match$1 !== undefined) {
    return {
            TAG: /* GraphError */0,
            _0: match$1.message
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
      TAG: /* Response */1,
      _0: [
        CONSTANTS.zeroBN,
        CONSTANTS.zeroBN
      ]
    };
    return Belt_Array.reduce(match.currentStakes, initialState, (function (curState, stake) {
                  if (typeof curState === "number") {
                    return /* Loading */0;
                  }
                  if (curState.TAG === /* GraphError */0) {
                    return {
                            TAG: /* GraphError */0,
                            _0: curState._0
                          };
                  }
                  var match = curState._0;
                  var amount = stake.currentStake.amount;
                  var timestamp = stake.lastMintState.timestamp;
                  var lastAccumulativeFloatPerToken = stake.lastMintState.accumulativeFloatPerToken;
                  var accumulativeFloatPerToken = stake.syntheticToken.latestStakerState.accumulativeFloatPerToken;
                  var floatRatePerTokenOverInterval = stake.syntheticToken.latestStakerState.floatRatePerTokenOverInterval;
                  var claimableFloat = accumulativeFloatPerToken.sub(lastAccumulativeFloatPerToken).mul(amount).div(CONSTANTS.tenToThe42).add(match[0]);
                  var predictedFloat = currentTimestamp.sub(timestamp).mul(floatRatePerTokenOverInterval).mul(amount).div(CONSTANTS.tenToThe42).add(match[1]);
                  return {
                          TAG: /* Response */1,
                          _0: [
                            claimableFloat,
                            predictedFloat
                          ]
                        };
                }));
  }
  var match$1 = floatQuery.error;
  if (match$1 !== undefined) {
    return {
            TAG: /* GraphError */0,
            _0: match$1.message
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
            TAG: /* Response */1,
            _0: match.currentStakes
          };
  }
  var match$1 = activeStakesQuery.error;
  if (match$1 !== undefined) {
    return {
            TAG: /* GraphError */0,
            _0: match$1.message
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
    if (match$1 === undefined) {
      return {
              TAG: /* Response */1,
              _0: {
                totalBalance: CONSTANTS.zeroBN,
                balances: []
              }
            };
    }
    var result = Belt_Array.reduce(match$1.tokenBalances, {
          totalBalance: CONSTANTS.zeroBN,
          balances: []
        }, (function (param, param$1) {
            var match = param$1.syntheticToken;
            var match$1 = match.syntheticMarket;
            var tokenBalance = param$1.tokenBalance;
            var isLong = match.tokenType === "Long";
            var newToken_addr = Ethers.utils.getAddress(match.id);
            var newToken_name = match$1.name;
            var newToken_symbol = match$1.symbol;
            var newToken_tokensValue = match.latestPrice.price.price.mul(tokenBalance).div(CONSTANTS.tenToThe18);
            var newToken = {
              addr: newToken_addr,
              name: newToken_name,
              symbol: newToken_symbol,
              isLong: isLong,
              tokenBalance: tokenBalance,
              tokensValue: newToken_tokensValue
            };
            return {
                    totalBalance: param.totalBalance.add(newToken_tokensValue),
                    balances: Belt_Array.concat(param.balances, [newToken])
                  };
          }));
    return {
            TAG: /* Response */1,
            _0: result
          };
  }
  var match$2 = usersTokensQuery.error;
  if (match$2 !== undefined) {
    return {
            TAG: /* GraphError */0,
            _0: match$2.message
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
              TAG: /* Response */1,
              _0: {
                floatBalance: user.floatTokenBalance,
                floatMinted: user.totalMintedFloat
              }
            };
    } else {
      return {
              TAG: /* Response */1,
              _0: {
                floatBalance: CONSTANTS.zeroBN,
                floatMinted: CONSTANTS.zeroBN
              }
            };
    }
  }
  var match$1 = usersStateQuery.error;
  if (match$1 !== undefined) {
    return {
            TAG: /* GraphError */0,
            _0: match$1.message
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
              TAG: /* Response */1,
              _0: /* ExistingUser */{
                _0: {
                  id: match$1.id,
                  joinedAt: FromUnixTime(match$1.timestampJoined.toNumber()),
                  gasUsed: match$1.totalGasUsed,
                  floatMinted: match$1.totalMintedFloat,
                  floatBalance: match$1.floatTokenBalance,
                  transactionCount: match$1.numberOfTransactions
                }
              }
            };
    } else {
      return {
              TAG: /* Response */1,
              _0: /* NewUser */0
            };
    }
  }
  var match$2 = userQuery.error;
  if (match$2 !== undefined) {
    return {
            TAG: /* GraphError */0,
            _0: match$2.message
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
                TAG: /* Response */1,
                _0: match$3.tokenBalance
              };
      }
      
    }
    
  }
  var match$4 = syntheticBalanceQuery.error;
  if (match$4 !== undefined) {
    return {
            TAG: /* GraphError */0,
            _0: match$4.message
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
              TAG: /* Response */1,
              _0: CONSTANTS.zeroBN
            };
    }
    var match$2 = match$1.tokenBalances;
    if (match$2.length !== 1) {
      return {
              TAG: /* Response */1,
              _0: CONSTANTS.zeroBN
            };
    }
    var match$3 = match$2[0];
    return {
            TAG: /* Response */1,
            _0: match$3.tokenBalance
          };
  }
  var match$4 = syntheticBalanceQuery.error;
  if (match$4 !== undefined) {
    return {
            TAG: /* GraphError */0,
            _0: match$4.message
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
            TAG: /* Ok */0,
            _0: /* Loading */0
          };
  } else if (maybeData.TAG === /* GraphError */0) {
    return {
            TAG: /* Error */1,
            _0: maybeData._0
          };
  } else {
    return {
            TAG: /* Ok */0,
            _0: /* Data */{
              _0: maybeData._0
            }
          };
  }
}

function queryToResponse(query) {
  var response = query.data;
  var match = query.error;
  if (match !== undefined) {
    return {
            TAG: /* GraphError */0,
            _0: match.message
          };
  } else if (response !== undefined) {
    return {
            TAG: /* Response */1,
            _0: Caml_option.valFromOption(response)
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
              TAG: /* Response */1,
              _0: match$1.syntheticMarket.id
            };
    } else {
      return {
              TAG: /* Response */1,
              _0: "1"
            };
    }
  }
  var match$2 = marketIdQuery.error;
  if (match$2 !== undefined) {
    return {
            TAG: /* GraphError */0,
            _0: match$2.message
          };
  } else {
    return /* Loading */0;
  }
}

var ethAdrToLowerStr = Globals.ethAdrToLowerStr;

export {
  liftGraphResponse2 ,
  ethAdrToLowerStr ,
  useGetMarkets ,
  useTotalClaimableFloatForUser ,
  useClaimableFloatForUser ,
  useStakesForUser ,
  useUsersBalances ,
  useFloatBalancesForUser ,
  useBasicUserInfo ,
  useSyntheticTokenBalance ,
  useSyntheticTokenBalanceOrZero ,
  Util ,
  useTokenMarketId ,
  
}
/* Misc Not a pure module */
