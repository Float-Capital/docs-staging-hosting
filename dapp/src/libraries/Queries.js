// Generated by ReScript, PLEASE EDIT WITH CARE

import * as GqlConverters from "./GqlConverters.js";
import * as ApolloClient__React_Hooks_UseQuery from "rescript-apollo-client/src/@apollo/client/react/hooks/ApolloClient__React_Hooks_UseQuery.js";

var Raw = {};

var query = (require("@apollo/client").gql`
  query   {
    systemStates(first: 1, orderBy: timestamp, orderDirection: desc)  {
      __typename
      timestamp
      txHash
      blockNumber
      syntheticPrice
      longTokenPrice
      shortTokenPrice
      totalLockedLong
      totalLockedShort
      totalValueLocked
      setBy
    }
  }
`);

function parse(value) {
  var value$1 = value.systemStates;
  return {
          systemStates: value$1.map(function (value) {
                return {
                        __typename: value.__typename,
                        timestamp: GqlConverters.$$BigInt.parse(value.timestamp),
                        txHash: GqlConverters.Bytes.parse(value.txHash),
                        blockNumber: GqlConverters.$$BigInt.parse(value.blockNumber),
                        syntheticPrice: GqlConverters.$$BigInt.parse(value.syntheticPrice),
                        longTokenPrice: GqlConverters.$$BigInt.parse(value.longTokenPrice),
                        shortTokenPrice: GqlConverters.$$BigInt.parse(value.shortTokenPrice),
                        totalLockedLong: GqlConverters.$$BigInt.parse(value.totalLockedLong),
                        totalLockedShort: GqlConverters.$$BigInt.parse(value.totalLockedShort),
                        totalValueLocked: GqlConverters.$$BigInt.parse(value.totalValueLocked),
                        setBy: GqlConverters.Bytes.parse(value.setBy)
                      };
              })
        };
}

function serialize(value) {
  var value$1 = value.systemStates;
  var systemStates = value$1.map(function (value) {
        var value$1 = value.setBy;
        var value$2 = GqlConverters.Bytes.serialize(value$1);
        var value$3 = value.totalValueLocked;
        var value$4 = GqlConverters.$$BigInt.serialize(value$3);
        var value$5 = value.totalLockedShort;
        var value$6 = GqlConverters.$$BigInt.serialize(value$5);
        var value$7 = value.totalLockedLong;
        var value$8 = GqlConverters.$$BigInt.serialize(value$7);
        var value$9 = value.shortTokenPrice;
        var value$10 = GqlConverters.$$BigInt.serialize(value$9);
        var value$11 = value.longTokenPrice;
        var value$12 = GqlConverters.$$BigInt.serialize(value$11);
        var value$13 = value.syntheticPrice;
        var value$14 = GqlConverters.$$BigInt.serialize(value$13);
        var value$15 = value.blockNumber;
        var value$16 = GqlConverters.$$BigInt.serialize(value$15);
        var value$17 = value.txHash;
        var value$18 = GqlConverters.Bytes.serialize(value$17);
        var value$19 = value.timestamp;
        var value$20 = GqlConverters.$$BigInt.serialize(value$19);
        var value$21 = value.__typename;
        return {
                __typename: value$21,
                timestamp: value$20,
                txHash: value$18,
                blockNumber: value$16,
                syntheticPrice: value$14,
                longTokenPrice: value$12,
                shortTokenPrice: value$10,
                totalLockedLong: value$8,
                totalLockedShort: value$6,
                totalValueLocked: value$4,
                setBy: value$2
              };
      });
  return {
          systemStates: systemStates
        };
}

function serializeVariables(param) {
  
}

function makeVariables(param) {
  
}

function makeDefaultVariables(param) {
  
}

var LatestSystemState_inner = {
  Raw: Raw,
  query: query,
  parse: parse,
  serialize: serialize,
  serializeVariables: serializeVariables,
  makeVariables: makeVariables,
  makeDefaultVariables: makeDefaultVariables
};

var include = ApolloClient__React_Hooks_UseQuery.Extend({
      query: query,
      Raw: Raw,
      parse: parse,
      serialize: serialize,
      serializeVariables: serializeVariables
    });

var LatestSystemState_refetchQueryDescription = include.refetchQueryDescription;

var LatestSystemState_use = include.use;

var LatestSystemState_useLazy = include.useLazy;

var LatestSystemState_useLazyWithVariables = include.useLazyWithVariables;

var LatestSystemState = {
  LatestSystemState_inner: LatestSystemState_inner,
  Raw: Raw,
  query: query,
  parse: parse,
  serialize: serialize,
  serializeVariables: serializeVariables,
  makeVariables: makeVariables,
  makeDefaultVariables: makeDefaultVariables,
  refetchQueryDescription: LatestSystemState_refetchQueryDescription,
  use: LatestSystemState_use,
  useLazy: LatestSystemState_useLazy,
  useLazyWithVariables: LatestSystemState_useLazyWithVariables
};

var Raw$1 = {};

var query$1 = (require("@apollo/client").gql`
  query   {
    syntheticMarkets  {
      __typename
      name
      symbol
      marketIndex
      oracleAddress
      syntheticLong  {
        __typename
        id
        tokenAddress
      }
      syntheticShort  {
        __typename
        id
        tokenAddress
      }
    }
  }
`);

function parse$1(value) {
  var value$1 = value.syntheticMarkets;
  return {
          syntheticMarkets: value$1.map(function (value) {
                var value$1 = value.syntheticLong;
                var value$2 = value.syntheticShort;
                return {
                        __typename: value.__typename,
                        name: value.name,
                        symbol: value.symbol,
                        marketIndex: GqlConverters.$$BigInt.parse(value.marketIndex),
                        oracleAddress: GqlConverters.Bytes.parse(value.oracleAddress),
                        syntheticLong: {
                          __typename: value$1.__typename,
                          id: value$1.id,
                          tokenAddress: GqlConverters.Address.parse(value$1.tokenAddress)
                        },
                        syntheticShort: {
                          __typename: value$2.__typename,
                          id: value$2.id,
                          tokenAddress: GqlConverters.Address.parse(value$2.tokenAddress)
                        }
                      };
              })
        };
}

function serialize$1(value) {
  var value$1 = value.syntheticMarkets;
  var syntheticMarkets = value$1.map(function (value) {
        var value$1 = value.syntheticShort;
        var value$2 = value$1.tokenAddress;
        var value$3 = GqlConverters.Address.serialize(value$2);
        var value$4 = value$1.id;
        var value$5 = value$1.__typename;
        var syntheticShort = {
          __typename: value$5,
          id: value$4,
          tokenAddress: value$3
        };
        var value$6 = value.syntheticLong;
        var value$7 = value$6.tokenAddress;
        var value$8 = GqlConverters.Address.serialize(value$7);
        var value$9 = value$6.id;
        var value$10 = value$6.__typename;
        var syntheticLong = {
          __typename: value$10,
          id: value$9,
          tokenAddress: value$8
        };
        var value$11 = value.oracleAddress;
        var value$12 = GqlConverters.Bytes.serialize(value$11);
        var value$13 = value.marketIndex;
        var value$14 = GqlConverters.$$BigInt.serialize(value$13);
        var value$15 = value.symbol;
        var value$16 = value.name;
        var value$17 = value.__typename;
        return {
                __typename: value$17,
                name: value$16,
                symbol: value$15,
                marketIndex: value$14,
                oracleAddress: value$12,
                syntheticLong: syntheticLong,
                syntheticShort: syntheticShort
              };
      });
  return {
          syntheticMarkets: syntheticMarkets
        };
}

function serializeVariables$1(param) {
  
}

function makeVariables$1(param) {
  
}

function makeDefaultVariables$1(param) {
  
}

var MarketDetails_inner = {
  Raw: Raw$1,
  query: query$1,
  parse: parse$1,
  serialize: serialize$1,
  serializeVariables: serializeVariables$1,
  makeVariables: makeVariables$1,
  makeDefaultVariables: makeDefaultVariables$1
};

var include$1 = ApolloClient__React_Hooks_UseQuery.Extend({
      query: query$1,
      Raw: Raw$1,
      parse: parse$1,
      serialize: serialize$1,
      serializeVariables: serializeVariables$1
    });

var MarketDetails_refetchQueryDescription = include$1.refetchQueryDescription;

var MarketDetails_use = include$1.use;

var MarketDetails_useLazy = include$1.useLazy;

var MarketDetails_useLazyWithVariables = include$1.useLazyWithVariables;

var MarketDetails = {
  MarketDetails_inner: MarketDetails_inner,
  Raw: Raw$1,
  query: query$1,
  parse: parse$1,
  serialize: serialize$1,
  serializeVariables: serializeVariables$1,
  makeVariables: makeVariables$1,
  makeDefaultVariables: makeDefaultVariables$1,
  refetchQueryDescription: MarketDetails_refetchQueryDescription,
  use: MarketDetails_use,
  useLazy: MarketDetails_useLazy,
  useLazyWithVariables: MarketDetails_useLazyWithVariables
};

var Raw$2 = {};

var query$2 = (require("@apollo/client").gql`
  query   {
    syntheticTokens  {
      __typename
      id
      syntheticMarket  {
        __typename
        id
        name
      }
      tokenType
    }
  }
`);

function parse$2(value) {
  var value$1 = value.syntheticTokens;
  return {
          syntheticTokens: value$1.map(function (value) {
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
                return {
                        __typename: value.__typename,
                        id: value.id,
                        syntheticMarket: {
                          __typename: value$1.__typename,
                          id: value$1.id,
                          name: value$1.name
                        },
                        tokenType: tmp
                      };
              })
        };
}

function serialize$2(value) {
  var value$1 = value.syntheticTokens;
  var syntheticTokens = value$1.map(function (value) {
        var value$1 = value.tokenType;
        var tokenType = typeof value$1 === "string" ? (
            value$1 === "Long" ? "Long" : "Short"
          ) : value$1.VAL;
        var value$2 = value.syntheticMarket;
        var value$3 = value$2.name;
        var value$4 = value$2.id;
        var value$5 = value$2.__typename;
        var syntheticMarket = {
          __typename: value$5,
          id: value$4,
          name: value$3
        };
        var value$6 = value.id;
        var value$7 = value.__typename;
        return {
                __typename: value$7,
                id: value$6,
                syntheticMarket: syntheticMarket,
                tokenType: tokenType
              };
      });
  return {
          syntheticTokens: syntheticTokens
        };
}

function serializeVariables$2(param) {
  
}

function makeVariables$2(param) {
  
}

function makeDefaultVariables$2(param) {
  
}

var SyntheticTokens_inner = {
  Raw: Raw$2,
  query: query$2,
  parse: parse$2,
  serialize: serialize$2,
  serializeVariables: serializeVariables$2,
  makeVariables: makeVariables$2,
  makeDefaultVariables: makeDefaultVariables$2
};

var include$2 = ApolloClient__React_Hooks_UseQuery.Extend({
      query: query$2,
      Raw: Raw$2,
      parse: parse$2,
      serialize: serialize$2,
      serializeVariables: serializeVariables$2
    });

var SyntheticTokens_refetchQueryDescription = include$2.refetchQueryDescription;

var SyntheticTokens_use = include$2.use;

var SyntheticTokens_useLazy = include$2.useLazy;

var SyntheticTokens_useLazyWithVariables = include$2.useLazyWithVariables;

var SyntheticTokens = {
  SyntheticTokens_inner: SyntheticTokens_inner,
  Raw: Raw$2,
  query: query$2,
  parse: parse$2,
  serialize: serialize$2,
  serializeVariables: serializeVariables$2,
  makeVariables: makeVariables$2,
  makeDefaultVariables: makeDefaultVariables$2,
  refetchQueryDescription: SyntheticTokens_refetchQueryDescription,
  use: SyntheticTokens_use,
  useLazy: SyntheticTokens_useLazy,
  useLazyWithVariables: SyntheticTokens_useLazyWithVariables
};

export {
  LatestSystemState ,
  MarketDetails ,
  SyntheticTokens ,
  
}
/* query Not a pure module */
