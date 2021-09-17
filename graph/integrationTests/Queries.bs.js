// Generated by ReScript, PLEASE EDIT WITH CARE
'use strict';

var Curry = require("rescript/lib/js/curry.js");
var Client = require("./util/Client.bs.js");
var GqlConverters = require("./util/GqlConverters.bs.js");
var ApolloClient__React_Hooks_UseQuery = require("rescript-apollo-client/src/@apollo/client/react/hooks/ApolloClient__React_Hooks_UseQuery.bs.js");

var Raw = {};

var query = (require("@apollo/client").gql`
  fragment StakerStateInfo on AccumulativeFloatIssuanceSnapshot   {
    __typename
    id
    blockNumber
    creationTxHash
    index
    longToken  {
      __typename
      id
    }
    shortToken  {
      __typename
      id
    }
    timestamp
    accumulativeFloatPerTokenLong
    accumulativeFloatPerTokenShort
    floatRatePerTokenOverIntervalLong
    floatRatePerTokenOverIntervalShort
    timeSinceLastUpdate
  }
`);

function parse(value) {
  var value$1 = value.longToken;
  var value$2 = value.shortToken;
  return {
          __typename: value.__typename,
          id: value.id,
          blockNumber: GqlConverters.$$BigInt.parse(value.blockNumber),
          creationTxHash: GqlConverters.Address.parse(value.creationTxHash),
          index: GqlConverters.$$BigInt.parse(value.index),
          longToken: {
            __typename: value$1.__typename,
            id: value$1.id
          },
          shortToken: {
            __typename: value$2.__typename,
            id: value$2.id
          },
          timestamp: GqlConverters.$$BigInt.parse(value.timestamp),
          accumulativeFloatPerTokenLong: GqlConverters.$$BigInt.parse(value.accumulativeFloatPerTokenLong),
          accumulativeFloatPerTokenShort: GqlConverters.$$BigInt.parse(value.accumulativeFloatPerTokenShort),
          floatRatePerTokenOverIntervalLong: GqlConverters.$$BigInt.parse(value.floatRatePerTokenOverIntervalLong),
          floatRatePerTokenOverIntervalShort: GqlConverters.$$BigInt.parse(value.floatRatePerTokenOverIntervalShort),
          timeSinceLastUpdate: GqlConverters.$$BigInt.parse(value.timeSinceLastUpdate)
        };
}

function serialize(value) {
  var value$1 = value.timeSinceLastUpdate;
  var value$2 = GqlConverters.$$BigInt.serialize(value$1);
  var value$3 = value.floatRatePerTokenOverIntervalShort;
  var value$4 = GqlConverters.$$BigInt.serialize(value$3);
  var value$5 = value.floatRatePerTokenOverIntervalLong;
  var value$6 = GqlConverters.$$BigInt.serialize(value$5);
  var value$7 = value.accumulativeFloatPerTokenShort;
  var value$8 = GqlConverters.$$BigInt.serialize(value$7);
  var value$9 = value.accumulativeFloatPerTokenLong;
  var value$10 = GqlConverters.$$BigInt.serialize(value$9);
  var value$11 = value.timestamp;
  var value$12 = GqlConverters.$$BigInt.serialize(value$11);
  var value$13 = value.shortToken;
  var value$14 = value$13.id;
  var value$15 = value$13.__typename;
  var shortToken = {
    __typename: value$15,
    id: value$14
  };
  var value$16 = value.longToken;
  var value$17 = value$16.id;
  var value$18 = value$16.__typename;
  var longToken = {
    __typename: value$18,
    id: value$17
  };
  var value$19 = value.index;
  var value$20 = GqlConverters.$$BigInt.serialize(value$19);
  var value$21 = value.creationTxHash;
  var value$22 = GqlConverters.Address.serialize(value$21);
  var value$23 = value.blockNumber;
  var value$24 = GqlConverters.$$BigInt.serialize(value$23);
  var value$25 = value.id;
  var value$26 = value.__typename;
  return {
          __typename: value$26,
          id: value$25,
          blockNumber: value$24,
          creationTxHash: value$22,
          index: value$20,
          longToken: longToken,
          shortToken: shortToken,
          timestamp: value$12,
          accumulativeFloatPerTokenLong: value$10,
          accumulativeFloatPerTokenShort: value$8,
          floatRatePerTokenOverIntervalLong: value$6,
          floatRatePerTokenOverIntervalShort: value$4,
          timeSinceLastUpdate: value$2
        };
}

function verifyArgsAndParse(_StakerStateInfo, value) {
  return parse(value);
}

function verifyName(param) {
  
}

var StakerStateInfo = {
  Raw: Raw,
  query: query,
  parse: parse,
  serialize: serialize,
  verifyArgsAndParse: verifyArgsAndParse,
  verifyName: verifyName
};

var Raw$1 = {};

var query$1 = (require("@apollo/client").gql`
  fragment PriceInfo on Price   {
    __typename
    id
    price
    timeUpdated
    token  {
      __typename
      id
    }
  }
`);

function parse$1(value) {
  var value$1 = value.token;
  return {
          __typename: value.__typename,
          id: value.id,
          price: GqlConverters.$$BigInt.parse(value.price),
          timeUpdated: GqlConverters.$$BigInt.parse(value.timeUpdated),
          token: {
            __typename: value$1.__typename,
            id: value$1.id
          }
        };
}

function serialize$1(value) {
  var value$1 = value.token;
  var value$2 = value$1.id;
  var value$3 = value$1.__typename;
  var token = {
    __typename: value$3,
    id: value$2
  };
  var value$4 = value.timeUpdated;
  var value$5 = GqlConverters.$$BigInt.serialize(value$4);
  var value$6 = value.price;
  var value$7 = GqlConverters.$$BigInt.serialize(value$6);
  var value$8 = value.id;
  var value$9 = value.__typename;
  return {
          __typename: value$9,
          id: value$8,
          price: value$7,
          timeUpdated: value$5,
          token: token
        };
}

function verifyArgsAndParse$1(_PriceInfo, value) {
  return parse$1(value);
}

function verifyName$1(param) {
  
}

var PriceInfo = {
  Raw: Raw$1,
  query: query$1,
  parse: parse$1,
  serialize: serialize$1,
  verifyArgsAndParse: verifyArgsAndParse$1,
  verifyName: verifyName$1
};

var Raw$2 = {};

var query$2 = (require("@apollo/client").gql`
  fragment SyntheticTokenInfo on SyntheticToken   {
    __typename
    id
    tokenAddress
    syntheticMarket  {
      __typename
      id
    }
    tokenType
    tokenSupply
    floatMintedFromSpecificToken
    latestPrice  {
      __typename
      id
      price  {
        __typename
        id
      }
    }
    priceHistory  {
      __typename
      id
    }
  }
`);

function parse$2(value) {
  var value$1 = value.syntheticMarket;
  var value$2 = value.tokenType;
  var tmp;
  switch (value$2) {
    case "Long" :
        tmp = "Long";
        break;
    case "Short" :
        tmp = "Short";
        break;
    default:
      tmp = {
        NAME: "FutureAddedValue",
        VAL: value$2
      };
  }
  var value$3 = value.latestPrice;
  var value$4 = value$3.price;
  var value$5 = value.priceHistory;
  return {
          __typename: value.__typename,
          id: value.id,
          tokenAddress: GqlConverters.Address.parse(value.tokenAddress),
          syntheticMarket: {
            __typename: value$1.__typename,
            id: value$1.id
          },
          tokenType: tmp,
          tokenSupply: GqlConverters.$$BigInt.parse(value.tokenSupply),
          floatMintedFromSpecificToken: GqlConverters.$$BigInt.parse(value.floatMintedFromSpecificToken),
          latestPrice: {
            __typename: value$3.__typename,
            id: value$3.id,
            price: {
              __typename: value$4.__typename,
              id: value$4.id
            }
          },
          priceHistory: value$5.map(function (value) {
                return {
                        __typename: value.__typename,
                        id: value.id
                      };
              })
        };
}

function serialize$2(value) {
  var value$1 = value.priceHistory;
  var priceHistory = value$1.map(function (value) {
        var value$1 = value.id;
        var value$2 = value.__typename;
        return {
                __typename: value$2,
                id: value$1
              };
      });
  var value$2 = value.latestPrice;
  var value$3 = value$2.price;
  var value$4 = value$3.id;
  var value$5 = value$3.__typename;
  var price = {
    __typename: value$5,
    id: value$4
  };
  var value$6 = value$2.id;
  var value$7 = value$2.__typename;
  var latestPrice = {
    __typename: value$7,
    id: value$6,
    price: price
  };
  var value$8 = value.floatMintedFromSpecificToken;
  var value$9 = GqlConverters.$$BigInt.serialize(value$8);
  var value$10 = value.tokenSupply;
  var value$11 = GqlConverters.$$BigInt.serialize(value$10);
  var value$12 = value.tokenType;
  var tokenType = typeof value$12 === "object" ? value$12.VAL : (
      value$12 === "Long" ? "Long" : "Short"
    );
  var value$13 = value.syntheticMarket;
  var value$14 = value$13.id;
  var value$15 = value$13.__typename;
  var syntheticMarket = {
    __typename: value$15,
    id: value$14
  };
  var value$16 = value.tokenAddress;
  var value$17 = GqlConverters.Address.serialize(value$16);
  var value$18 = value.id;
  var value$19 = value.__typename;
  return {
          __typename: value$19,
          id: value$18,
          tokenAddress: value$17,
          syntheticMarket: syntheticMarket,
          tokenType: tokenType,
          tokenSupply: value$11,
          floatMintedFromSpecificToken: value$9,
          latestPrice: latestPrice,
          priceHistory: priceHistory
        };
}

function verifyArgsAndParse$2(_SyntheticTokenInfo, value) {
  return parse$2(value);
}

function verifyName$2(param) {
  
}

var SyntheticTokenInfo = {
  Raw: Raw$2,
  query: query$2,
  parse: parse$2,
  serialize: serialize$2,
  verifyArgsAndParse: verifyArgsAndParse$2,
  verifyName: verifyName$2
};

var Raw$3 = {};

var query$3 = (require("@apollo/client").gql`
  fragment SystemStateInfo on SystemState   {
    __typename
    id
    timestamp
    txHash
    blockNumber
    marketIndex
    underlyingPrice  {
      __typename
      id
    }
    longTokenPrice  {
      __typename
      id
    }
    shortTokenPrice  {
      __typename
      id
    }
    longToken  {
      __typename
      id
    }
    shortToken  {
      __typename
      id
    }
    totalLockedLong
    totalLockedShort
    totalValueLocked
  }
`);

function parse$3(value) {
  var value$1 = value.underlyingPrice;
  var value$2 = value.longTokenPrice;
  var value$3 = value.shortTokenPrice;
  var value$4 = value.longToken;
  var value$5 = value.shortToken;
  return {
          __typename: value.__typename,
          id: value.id,
          timestamp: GqlConverters.$$BigInt.parse(value.timestamp),
          txHash: GqlConverters.Address.parse(value.txHash),
          blockNumber: GqlConverters.$$BigInt.parse(value.blockNumber),
          marketIndex: GqlConverters.$$BigInt.parse(value.marketIndex),
          underlyingPrice: {
            __typename: value$1.__typename,
            id: value$1.id
          },
          longTokenPrice: {
            __typename: value$2.__typename,
            id: value$2.id
          },
          shortTokenPrice: {
            __typename: value$3.__typename,
            id: value$3.id
          },
          longToken: {
            __typename: value$4.__typename,
            id: value$4.id
          },
          shortToken: {
            __typename: value$5.__typename,
            id: value$5.id
          },
          totalLockedLong: GqlConverters.$$BigInt.parse(value.totalLockedLong),
          totalLockedShort: GqlConverters.$$BigInt.parse(value.totalLockedShort),
          totalValueLocked: GqlConverters.$$BigInt.parse(value.totalValueLocked)
        };
}

function serialize$3(value) {
  var value$1 = value.totalValueLocked;
  var value$2 = GqlConverters.$$BigInt.serialize(value$1);
  var value$3 = value.totalLockedShort;
  var value$4 = GqlConverters.$$BigInt.serialize(value$3);
  var value$5 = value.totalLockedLong;
  var value$6 = GqlConverters.$$BigInt.serialize(value$5);
  var value$7 = value.shortToken;
  var value$8 = value$7.id;
  var value$9 = value$7.__typename;
  var shortToken = {
    __typename: value$9,
    id: value$8
  };
  var value$10 = value.longToken;
  var value$11 = value$10.id;
  var value$12 = value$10.__typename;
  var longToken = {
    __typename: value$12,
    id: value$11
  };
  var value$13 = value.shortTokenPrice;
  var value$14 = value$13.id;
  var value$15 = value$13.__typename;
  var shortTokenPrice = {
    __typename: value$15,
    id: value$14
  };
  var value$16 = value.longTokenPrice;
  var value$17 = value$16.id;
  var value$18 = value$16.__typename;
  var longTokenPrice = {
    __typename: value$18,
    id: value$17
  };
  var value$19 = value.underlyingPrice;
  var value$20 = value$19.id;
  var value$21 = value$19.__typename;
  var underlyingPrice = {
    __typename: value$21,
    id: value$20
  };
  var value$22 = value.marketIndex;
  var value$23 = GqlConverters.$$BigInt.serialize(value$22);
  var value$24 = value.blockNumber;
  var value$25 = GqlConverters.$$BigInt.serialize(value$24);
  var value$26 = value.txHash;
  var value$27 = GqlConverters.Address.serialize(value$26);
  var value$28 = value.timestamp;
  var value$29 = GqlConverters.$$BigInt.serialize(value$28);
  var value$30 = value.id;
  var value$31 = value.__typename;
  return {
          __typename: value$31,
          id: value$30,
          timestamp: value$29,
          txHash: value$27,
          blockNumber: value$25,
          marketIndex: value$23,
          underlyingPrice: underlyingPrice,
          longTokenPrice: longTokenPrice,
          shortTokenPrice: shortTokenPrice,
          longToken: longToken,
          shortToken: shortToken,
          totalLockedLong: value$6,
          totalLockedShort: value$4,
          totalValueLocked: value$2
        };
}

function verifyArgsAndParse$3(_SystemStateInfo, value) {
  return parse$3(value);
}

function verifyName$3(param) {
  
}

var SystemStateInfo = {
  Raw: Raw$3,
  query: query$3,
  parse: parse$3,
  serialize: serialize$3,
  verifyArgsAndParse: verifyArgsAndParse$3,
  verifyName: verifyName$3
};

var Raw$4 = {};

var query$4 = (require("@apollo/client").gql`
  fragment PaymentTokenInfo on PaymentToken   {
    __typename
    id
    linkedMarkets  {
      __typename
      id
    }
  }
`);

function parse$4(value) {
  var value$1 = value.linkedMarkets;
  return {
          __typename: value.__typename,
          id: value.id,
          linkedMarkets: value$1.map(function (value) {
                return {
                        __typename: value.__typename,
                        id: value.id
                      };
              })
        };
}

function serialize$4(value) {
  var value$1 = value.linkedMarkets;
  var linkedMarkets = value$1.map(function (value) {
        var value$1 = value.id;
        var value$2 = value.__typename;
        return {
                __typename: value$2,
                id: value$1
              };
      });
  var value$2 = value.id;
  var value$3 = value.__typename;
  return {
          __typename: value$3,
          id: value$2,
          linkedMarkets: linkedMarkets
        };
}

function verifyArgsAndParse$4(_PaymentTokenInfo, value) {
  return parse$4(value);
}

function verifyName$4(param) {
  
}

var PaymentTokenInfo = {
  Raw: Raw$4,
  query: query$4,
  parse: parse$4,
  serialize: serialize$4,
  verifyArgsAndParse: verifyArgsAndParse$4,
  verifyName: verifyName$4
};

var Raw$5 = {};

var query$5 = (require("@apollo/client").gql`
  fragment SyntheticMarketInfo on SyntheticMarket   {
    __typename
    id
    timestampCreated
    txHash
    blockNumberCreated
    paymentToken  {
      __typename
      id
    }
    name
    symbol
    marketIndex
    oracleAddress
    previousOracleAddresses
    syntheticLong  {
      __typename
      id
    }
    syntheticShort  {
      __typename
      id
    }
    latestSystemState  {
      __typename
      id
    }
    kPeriod
    kMultiplier
  }
`);

function parse$5(value) {
  var value$1 = value.paymentToken;
  var value$2 = value.previousOracleAddresses;
  var value$3 = value.syntheticLong;
  var value$4 = value.syntheticShort;
  var value$5 = value.latestSystemState;
  return {
          __typename: value.__typename,
          id: value.id,
          timestampCreated: GqlConverters.$$BigInt.parse(value.timestampCreated),
          txHash: GqlConverters.Address.parse(value.txHash),
          blockNumberCreated: GqlConverters.$$BigInt.parse(value.blockNumberCreated),
          paymentToken: {
            __typename: value$1.__typename,
            id: value$1.id
          },
          name: value.name,
          symbol: value.symbol,
          marketIndex: GqlConverters.$$BigInt.parse(value.marketIndex),
          oracleAddress: GqlConverters.Address.parse(value.oracleAddress),
          previousOracleAddresses: value$2.map(function (value) {
                return GqlConverters.Address.parse(value);
              }),
          syntheticLong: {
            __typename: value$3.__typename,
            id: value$3.id
          },
          syntheticShort: {
            __typename: value$4.__typename,
            id: value$4.id
          },
          latestSystemState: {
            __typename: value$5.__typename,
            id: value$5.id
          },
          kPeriod: GqlConverters.$$BigInt.parse(value.kPeriod),
          kMultiplier: GqlConverters.$$BigInt.parse(value.kMultiplier)
        };
}

function serialize$5(value) {
  var value$1 = value.kMultiplier;
  var value$2 = GqlConverters.$$BigInt.serialize(value$1);
  var value$3 = value.kPeriod;
  var value$4 = GqlConverters.$$BigInt.serialize(value$3);
  var value$5 = value.latestSystemState;
  var value$6 = value$5.id;
  var value$7 = value$5.__typename;
  var latestSystemState = {
    __typename: value$7,
    id: value$6
  };
  var value$8 = value.syntheticShort;
  var value$9 = value$8.id;
  var value$10 = value$8.__typename;
  var syntheticShort = {
    __typename: value$10,
    id: value$9
  };
  var value$11 = value.syntheticLong;
  var value$12 = value$11.id;
  var value$13 = value$11.__typename;
  var syntheticLong = {
    __typename: value$13,
    id: value$12
  };
  var value$14 = value.previousOracleAddresses;
  var previousOracleAddresses = value$14.map(function (value) {
        return GqlConverters.Address.serialize(value);
      });
  var value$15 = value.oracleAddress;
  var value$16 = GqlConverters.Address.serialize(value$15);
  var value$17 = value.marketIndex;
  var value$18 = GqlConverters.$$BigInt.serialize(value$17);
  var value$19 = value.symbol;
  var value$20 = value.name;
  var value$21 = value.paymentToken;
  var value$22 = value$21.id;
  var value$23 = value$21.__typename;
  var paymentToken = {
    __typename: value$23,
    id: value$22
  };
  var value$24 = value.blockNumberCreated;
  var value$25 = GqlConverters.$$BigInt.serialize(value$24);
  var value$26 = value.txHash;
  var value$27 = GqlConverters.Address.serialize(value$26);
  var value$28 = value.timestampCreated;
  var value$29 = GqlConverters.$$BigInt.serialize(value$28);
  var value$30 = value.id;
  var value$31 = value.__typename;
  return {
          __typename: value$31,
          id: value$30,
          timestampCreated: value$29,
          txHash: value$27,
          blockNumberCreated: value$25,
          paymentToken: paymentToken,
          name: value$20,
          symbol: value$19,
          marketIndex: value$18,
          oracleAddress: value$16,
          previousOracleAddresses: previousOracleAddresses,
          syntheticLong: syntheticLong,
          syntheticShort: syntheticShort,
          latestSystemState: latestSystemState,
          kPeriod: value$4,
          kMultiplier: value$2
        };
}

function verifyArgsAndParse$5(_SyntheticMarketInfo, value) {
  return parse$5(value);
}

function verifyName$5(param) {
  
}

var SyntheticMarketInfo = {
  Raw: Raw$5,
  query: query$5,
  parse: parse$5,
  serialize: serialize$5,
  verifyArgsAndParse: verifyArgsAndParse$5,
  verifyName: verifyName$5
};

var Raw$6 = {};

var query$6 = (require("@apollo/client").gql`
  query   {
    stateChanges(first: 1000)  {
      __typename
      id
      txEventParamList  {
        __typename
        eventName
        params  {
          __typename
          param
          paramName
          paramType
        }
      }
      affectedStakes  {
        __typename
        id
      }
      blockNumber
      timestamp
      affectedUsers  {
        __typename
        id
        address
      }
    }
  }
`);

function parse$6(value) {
  var value$1 = value.stateChanges;
  return {
          stateChanges: value$1.map(function (value) {
                var value$1 = value.txEventParamList;
                var value$2 = value.affectedStakes;
                var value$3 = value.affectedUsers;
                return {
                        __typename: value.__typename,
                        id: value.id,
                        txEventParamList: value$1.map(function (value) {
                              var value$1 = value.params;
                              return {
                                      __typename: value.__typename,
                                      eventName: value.eventName,
                                      params: value$1.map(function (value) {
                                            return {
                                                    __typename: value.__typename,
                                                    param: value.param,
                                                    paramName: value.paramName,
                                                    paramType: value.paramType
                                                  };
                                          })
                                    };
                            }),
                        affectedStakes: value$2.map(function (value) {
                              return {
                                      __typename: value.__typename,
                                      id: value.id
                                    };
                            }),
                        blockNumber: GqlConverters.$$BigInt.parse(value.blockNumber),
                        timestamp: GqlConverters.$$BigInt.parse(value.timestamp),
                        affectedUsers: value$3.map(function (value) {
                              return {
                                      __typename: value.__typename,
                                      id: value.id,
                                      address: GqlConverters.Address.parse(value.address)
                                    };
                            })
                      };
              })
        };
}

function serialize$6(value) {
  var value$1 = value.stateChanges;
  var stateChanges = value$1.map(function (value) {
        var value$1 = value.affectedUsers;
        var affectedUsers = value$1.map(function (value) {
              var value$1 = value.address;
              var value$2 = GqlConverters.Address.serialize(value$1);
              var value$3 = value.id;
              var value$4 = value.__typename;
              return {
                      __typename: value$4,
                      id: value$3,
                      address: value$2
                    };
            });
        var value$2 = value.timestamp;
        var value$3 = GqlConverters.$$BigInt.serialize(value$2);
        var value$4 = value.blockNumber;
        var value$5 = GqlConverters.$$BigInt.serialize(value$4);
        var value$6 = value.affectedStakes;
        var affectedStakes = value$6.map(function (value) {
              var value$1 = value.id;
              var value$2 = value.__typename;
              return {
                      __typename: value$2,
                      id: value$1
                    };
            });
        var value$7 = value.txEventParamList;
        var txEventParamList = value$7.map(function (value) {
              var value$1 = value.params;
              var params = value$1.map(function (value) {
                    var value$1 = value.paramType;
                    var value$2 = value.paramName;
                    var value$3 = value.param;
                    var value$4 = value.__typename;
                    return {
                            __typename: value$4,
                            param: value$3,
                            paramName: value$2,
                            paramType: value$1
                          };
                  });
              var value$2 = value.eventName;
              var value$3 = value.__typename;
              return {
                      __typename: value$3,
                      eventName: value$2,
                      params: params
                    };
            });
        var value$8 = value.id;
        var value$9 = value.__typename;
        return {
                __typename: value$9,
                id: value$8,
                txEventParamList: txEventParamList,
                affectedStakes: affectedStakes,
                blockNumber: value$5,
                timestamp: value$3,
                affectedUsers: affectedUsers
              };
      });
  return {
          stateChanges: stateChanges
        };
}

function serializeVariables(param) {
  
}

function makeVariables(param) {
  
}

function makeDefaultVariables(param) {
  
}

var GetAllStateChanges_inner = {
  Raw: Raw$6,
  query: query$6,
  parse: parse$6,
  serialize: serialize$6,
  serializeVariables: serializeVariables,
  makeVariables: makeVariables,
  makeDefaultVariables: makeDefaultVariables
};

var include = ApolloClient__React_Hooks_UseQuery.Extend({
      query: query$6,
      Raw: Raw$6,
      parse: parse$6,
      serialize: serialize$6,
      serializeVariables: serializeVariables
    });

var GetAllStateChanges_refetchQueryDescription = include.refetchQueryDescription;

var GetAllStateChanges_use = include.use;

var GetAllStateChanges_useLazy = include.useLazy;

var GetAllStateChanges_useLazyWithVariables = include.useLazyWithVariables;

var GetAllStateChanges = {
  GetAllStateChanges_inner: GetAllStateChanges_inner,
  Raw: Raw$6,
  query: query$6,
  parse: parse$6,
  serialize: serialize$6,
  serializeVariables: serializeVariables,
  makeVariables: makeVariables,
  makeDefaultVariables: makeDefaultVariables,
  refetchQueryDescription: GetAllStateChanges_refetchQueryDescription,
  use: GetAllStateChanges_use,
  useLazy: GetAllStateChanges_useLazy,
  useLazyWithVariables: GetAllStateChanges_useLazyWithVariables
};

function getAllStateChanges(param) {
  var __x = Curry._6(Client.instance.rescript_query, {
        query: query$6,
        Raw: Raw$6,
        parse: parse$6,
        serialize: serialize$6,
        serializeVariables: serializeVariables
      }, undefined, undefined, undefined, undefined, undefined);
  return __x.then(function (result) {
              if (result.TAG === /* Ok */0) {
                return Promise.resolve(result._0.data.stateChanges);
              } else {
                return Promise.reject(result._0);
              }
            });
}

var Raw$7 = {};

var query$7 = (require("@apollo/client").gql`
  query ($blockNumber: Int!)  {
    globalState(id: "globalState", block: {number: $blockNumber})  {
      __typename
      id
      contractVersion
      latestMarketIndex
      staker  {
        __typename
        id
        address
      }
      tokenFactory  {
        __typename
        id
        address
      }
      adminAddress
      longShort  {
        __typename
        id
        address
      }
      totalFloatMinted
      totalUsers
      timestampLaunched
      txHash
    }
  }
`);

function parse$7(value) {
  var value$1 = value.globalState;
  var tmp;
  if (value$1 == null) {
    tmp = undefined;
  } else {
    var value$2 = value$1.staker;
    var value$3 = value$1.tokenFactory;
    var value$4 = value$1.longShort;
    tmp = {
      __typename: value$1.__typename,
      id: value$1.id,
      contractVersion: GqlConverters.$$BigInt.parse(value$1.contractVersion),
      latestMarketIndex: GqlConverters.$$BigInt.parse(value$1.latestMarketIndex),
      staker: {
        __typename: value$2.__typename,
        id: value$2.id,
        address: GqlConverters.Address.parse(value$2.address)
      },
      tokenFactory: {
        __typename: value$3.__typename,
        id: value$3.id,
        address: GqlConverters.Address.parse(value$3.address)
      },
      adminAddress: GqlConverters.Address.parse(value$1.adminAddress),
      longShort: {
        __typename: value$4.__typename,
        id: value$4.id,
        address: GqlConverters.Address.parse(value$4.address)
      },
      totalFloatMinted: GqlConverters.$$BigInt.parse(value$1.totalFloatMinted),
      totalUsers: GqlConverters.$$BigInt.parse(value$1.totalUsers),
      timestampLaunched: GqlConverters.$$BigInt.parse(value$1.timestampLaunched),
      txHash: GqlConverters.Address.parse(value$1.txHash)
    };
  }
  return {
          globalState: tmp
        };
}

function serialize$7(value) {
  var value$1 = value.globalState;
  var globalState;
  if (value$1 !== undefined) {
    var value$2 = value$1.txHash;
    var value$3 = GqlConverters.Address.serialize(value$2);
    var value$4 = value$1.timestampLaunched;
    var value$5 = GqlConverters.$$BigInt.serialize(value$4);
    var value$6 = value$1.totalUsers;
    var value$7 = GqlConverters.$$BigInt.serialize(value$6);
    var value$8 = value$1.totalFloatMinted;
    var value$9 = GqlConverters.$$BigInt.serialize(value$8);
    var value$10 = value$1.longShort;
    var value$11 = value$10.address;
    var value$12 = GqlConverters.Address.serialize(value$11);
    var value$13 = value$10.id;
    var value$14 = value$10.__typename;
    var longShort = {
      __typename: value$14,
      id: value$13,
      address: value$12
    };
    var value$15 = value$1.adminAddress;
    var value$16 = GqlConverters.Address.serialize(value$15);
    var value$17 = value$1.tokenFactory;
    var value$18 = value$17.address;
    var value$19 = GqlConverters.Address.serialize(value$18);
    var value$20 = value$17.id;
    var value$21 = value$17.__typename;
    var tokenFactory = {
      __typename: value$21,
      id: value$20,
      address: value$19
    };
    var value$22 = value$1.staker;
    var value$23 = value$22.address;
    var value$24 = GqlConverters.Address.serialize(value$23);
    var value$25 = value$22.id;
    var value$26 = value$22.__typename;
    var staker = {
      __typename: value$26,
      id: value$25,
      address: value$24
    };
    var value$27 = value$1.latestMarketIndex;
    var value$28 = GqlConverters.$$BigInt.serialize(value$27);
    var value$29 = value$1.contractVersion;
    var value$30 = GqlConverters.$$BigInt.serialize(value$29);
    var value$31 = value$1.id;
    var value$32 = value$1.__typename;
    globalState = {
      __typename: value$32,
      id: value$31,
      contractVersion: value$30,
      latestMarketIndex: value$28,
      staker: staker,
      tokenFactory: tokenFactory,
      adminAddress: value$16,
      longShort: longShort,
      totalFloatMinted: value$9,
      totalUsers: value$7,
      timestampLaunched: value$5,
      txHash: value$3
    };
  } else {
    globalState = null;
  }
  return {
          globalState: globalState
        };
}

function serializeVariables$1(inp) {
  return {
          blockNumber: inp.blockNumber
        };
}

function makeVariables$1(blockNumber, param) {
  return {
          blockNumber: blockNumber
        };
}

var GetGlobalState_inner = {
  Raw: Raw$7,
  query: query$7,
  parse: parse$7,
  serialize: serialize$7,
  serializeVariables: serializeVariables$1,
  makeVariables: makeVariables$1
};

var include$1 = ApolloClient__React_Hooks_UseQuery.Extend({
      query: query$7,
      Raw: Raw$7,
      parse: parse$7,
      serialize: serialize$7,
      serializeVariables: serializeVariables$1
    });

var GetGlobalState_refetchQueryDescription = include$1.refetchQueryDescription;

var GetGlobalState_use = include$1.use;

var GetGlobalState_useLazy = include$1.useLazy;

var GetGlobalState_useLazyWithVariables = include$1.useLazyWithVariables;

var GetGlobalState = {
  GetGlobalState_inner: GetGlobalState_inner,
  Raw: Raw$7,
  query: query$7,
  parse: parse$7,
  serialize: serialize$7,
  serializeVariables: serializeVariables$1,
  makeVariables: makeVariables$1,
  refetchQueryDescription: GetGlobalState_refetchQueryDescription,
  use: GetGlobalState_use,
  useLazy: GetGlobalState_useLazy,
  useLazyWithVariables: GetGlobalState_useLazyWithVariables
};

function getGlobalStateAtBlock(blockNumber) {
  var __x = Curry._6(Client.instance.rescript_query, {
        query: query$7,
        Raw: Raw$7,
        parse: parse$7,
        serialize: serialize$7,
        serializeVariables: serializeVariables$1
      }, undefined, undefined, undefined, undefined, {
        blockNumber: blockNumber
      });
  return __x.then(function (result) {
              if (result.TAG !== /* Ok */0) {
                return Promise.reject(result._0);
              }
              var globalState = result._0.data.globalState;
              if (globalState !== undefined) {
                return Promise.resolve(globalState);
              } else {
                return Promise.resolve(undefined);
              }
            });
}

var Raw$8 = {};

var query$8 = ((frag_0) => require("@apollo/client").gql`
  query ($marketId: String!, $blockNumber: Int!)  {
    syntheticMarket(id: $marketId, block: {number: $blockNumber})  {
      ...SyntheticMarketInfo
    }
  }
  ${frag_0}
`)(query$5);

function parse$8(value) {
  var value$1 = value.syntheticMarket;
  return {
          syntheticMarket: !(value$1 == null) ? parse$5(value$1) : undefined
        };
}

function serialize$8(value) {
  var value$1 = value.syntheticMarket;
  var syntheticMarket = value$1 !== undefined ? serialize$5(value$1) : null;
  return {
          syntheticMarket: syntheticMarket
        };
}

function serializeVariables$2(inp) {
  return {
          marketId: inp.marketId,
          blockNumber: inp.blockNumber
        };
}

function makeVariables$2(marketId, blockNumber, param) {
  return {
          marketId: marketId,
          blockNumber: blockNumber
        };
}

var SyntheticMarket_inner = {
  Raw: Raw$8,
  query: query$8,
  parse: parse$8,
  serialize: serialize$8,
  serializeVariables: serializeVariables$2,
  makeVariables: makeVariables$2
};

var include$2 = ApolloClient__React_Hooks_UseQuery.Extend({
      query: query$8,
      Raw: Raw$8,
      parse: parse$8,
      serialize: serialize$8,
      serializeVariables: serializeVariables$2
    });

var SyntheticMarket_refetchQueryDescription = include$2.refetchQueryDescription;

var SyntheticMarket_use = include$2.use;

var SyntheticMarket_useLazy = include$2.useLazy;

var SyntheticMarket_useLazyWithVariables = include$2.useLazyWithVariables;

var SyntheticMarket = {
  SyntheticMarket_inner: SyntheticMarket_inner,
  Raw: Raw$8,
  query: query$8,
  parse: parse$8,
  serialize: serialize$8,
  serializeVariables: serializeVariables$2,
  makeVariables: makeVariables$2,
  refetchQueryDescription: SyntheticMarket_refetchQueryDescription,
  use: SyntheticMarket_use,
  useLazy: SyntheticMarket_useLazy,
  useLazyWithVariables: SyntheticMarket_useLazyWithVariables
};

var Raw$9 = {};

var query$9 = ((frag_0) => require("@apollo/client").gql`
  query ($tokenId: String!, $blockNumber: Int!)  {
    syntheticToken(id: $tokenId, block: {number: $blockNumber})  {
      ...SyntheticTokenInfo
    }
  }
  ${frag_0}
`)(query$2);

function parse$9(value) {
  var value$1 = value.syntheticToken;
  return {
          syntheticToken: !(value$1 == null) ? parse$2(value$1) : undefined
        };
}

function serialize$9(value) {
  var value$1 = value.syntheticToken;
  var syntheticToken = value$1 !== undefined ? serialize$2(value$1) : null;
  return {
          syntheticToken: syntheticToken
        };
}

function serializeVariables$3(inp) {
  return {
          tokenId: inp.tokenId,
          blockNumber: inp.blockNumber
        };
}

function makeVariables$3(tokenId, blockNumber, param) {
  return {
          tokenId: tokenId,
          blockNumber: blockNumber
        };
}

var SyntheticToken_inner = {
  Raw: Raw$9,
  query: query$9,
  parse: parse$9,
  serialize: serialize$9,
  serializeVariables: serializeVariables$3,
  makeVariables: makeVariables$3
};

var include$3 = ApolloClient__React_Hooks_UseQuery.Extend({
      query: query$9,
      Raw: Raw$9,
      parse: parse$9,
      serialize: serialize$9,
      serializeVariables: serializeVariables$3
    });

var SyntheticToken_refetchQueryDescription = include$3.refetchQueryDescription;

var SyntheticToken_use = include$3.use;

var SyntheticToken_useLazy = include$3.useLazy;

var SyntheticToken_useLazyWithVariables = include$3.useLazyWithVariables;

var SyntheticToken = {
  SyntheticToken_inner: SyntheticToken_inner,
  Raw: Raw$9,
  query: query$9,
  parse: parse$9,
  serialize: serialize$9,
  serializeVariables: serializeVariables$3,
  makeVariables: makeVariables$3,
  refetchQueryDescription: SyntheticToken_refetchQueryDescription,
  use: SyntheticToken_use,
  useLazy: SyntheticToken_useLazy,
  useLazyWithVariables: SyntheticToken_useLazyWithVariables
};

function getSyntheticMarketAtBlock(marketId, blockNumber) {
  var __x = Curry._6(Client.instance.rescript_query, {
        query: query$8,
        Raw: Raw$8,
        parse: parse$8,
        serialize: serialize$8,
        serializeVariables: serializeVariables$2
      }, undefined, undefined, undefined, undefined, {
        marketId: marketId,
        blockNumber: blockNumber
      });
  return __x.then(function (result) {
              if (result.TAG !== /* Ok */0) {
                return Promise.reject(result._0);
              }
              var syntheticMarket = result._0.data.syntheticMarket;
              if (syntheticMarket !== undefined) {
                return Promise.resolve(syntheticMarket);
              } else {
                return Promise.resolve(undefined);
              }
            });
}

function getSyntheticTokenAtBlock(tokenId, blockNumber) {
  var __x = Curry._6(Client.instance.rescript_query, {
        query: query$9,
        Raw: Raw$9,
        parse: parse$9,
        serialize: serialize$9,
        serializeVariables: serializeVariables$3
      }, undefined, undefined, undefined, undefined, {
        tokenId: tokenId,
        blockNumber: blockNumber
      });
  return __x.then(function (result) {
              if (result.TAG !== /* Ok */0) {
                return Promise.reject(result._0);
              }
              var syntheticToken = result._0.data.syntheticToken;
              if (syntheticToken !== undefined) {
                return Promise.resolve(syntheticToken);
              } else {
                return Promise.resolve(undefined);
              }
            });
}

var ApolloQueryResult;

exports.ApolloQueryResult = ApolloQueryResult;
exports.StakerStateInfo = StakerStateInfo;
exports.PriceInfo = PriceInfo;
exports.SyntheticTokenInfo = SyntheticTokenInfo;
exports.SystemStateInfo = SystemStateInfo;
exports.PaymentTokenInfo = PaymentTokenInfo;
exports.SyntheticMarketInfo = SyntheticMarketInfo;
exports.GetAllStateChanges = GetAllStateChanges;
exports.getAllStateChanges = getAllStateChanges;
exports.GetGlobalState = GetGlobalState;
exports.getGlobalStateAtBlock = getGlobalStateAtBlock;
exports.SyntheticMarket = SyntheticMarket;
exports.SyntheticToken = SyntheticToken;
exports.getSyntheticMarketAtBlock = getSyntheticMarketAtBlock;
exports.getSyntheticTokenAtBlock = getSyntheticTokenAtBlock;
/* query Not a pure module */
