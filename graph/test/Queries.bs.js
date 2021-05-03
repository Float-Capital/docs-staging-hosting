// Generated by ReScript, PLEASE EDIT WITH CARE
'use strict';

var Curry = require("rescript/lib/js/curry.js");
var Client = require("./util/Client.bs.js");
var GqlConverters = require("./util/GqlConverters.bs.js");
var ApolloClient__React_Hooks_UseQuery = require("rescript-apollo-client/src/@apollo/client/react/hooks/ApolloClient__React_Hooks_UseQuery.bs.js");

var Raw = {};

var query = (require("@apollo/client").gql`
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

function parse(value) {
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

function serialize(value) {
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

var GetAllStateChanges_refetchQueryDescription = include.refetchQueryDescription;

var GetAllStateChanges_use = include.use;

var GetAllStateChanges_useLazy = include.useLazy;

var GetAllStateChanges_useLazyWithVariables = include.useLazyWithVariables;

var GetAllStateChanges = {
  GetAllStateChanges_inner: GetAllStateChanges_inner,
  Raw: Raw,
  query: query,
  parse: parse,
  serialize: serialize,
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
        query: query,
        Raw: Raw,
        parse: parse,
        serialize: serialize,
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

var Raw$1 = {};

var query$1 = (require("@apollo/client").gql`
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
      totalTxs
      totalGasUsed
      totalUsers
      timestampLaunched
      txHash
    }
  }
`);

function parse$1(value) {
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
      totalTxs: GqlConverters.$$BigInt.parse(value$1.totalTxs),
      totalGasUsed: GqlConverters.$$BigInt.parse(value$1.totalGasUsed),
      totalUsers: GqlConverters.$$BigInt.parse(value$1.totalUsers),
      timestampLaunched: GqlConverters.$$BigInt.parse(value$1.timestampLaunched),
      txHash: GqlConverters.Address.parse(value$1.txHash)
    };
  }
  return {
          globalState: tmp
        };
}

function serialize$1(value) {
  var value$1 = value.globalState;
  var globalState;
  if (value$1 !== undefined) {
    var value$2 = value$1.txHash;
    var value$3 = GqlConverters.Address.serialize(value$2);
    var value$4 = value$1.timestampLaunched;
    var value$5 = GqlConverters.$$BigInt.serialize(value$4);
    var value$6 = value$1.totalUsers;
    var value$7 = GqlConverters.$$BigInt.serialize(value$6);
    var value$8 = value$1.totalGasUsed;
    var value$9 = GqlConverters.$$BigInt.serialize(value$8);
    var value$10 = value$1.totalTxs;
    var value$11 = GqlConverters.$$BigInt.serialize(value$10);
    var value$12 = value$1.totalFloatMinted;
    var value$13 = GqlConverters.$$BigInt.serialize(value$12);
    var value$14 = value$1.longShort;
    var value$15 = value$14.address;
    var value$16 = GqlConverters.Address.serialize(value$15);
    var value$17 = value$14.id;
    var value$18 = value$14.__typename;
    var longShort = {
      __typename: value$18,
      id: value$17,
      address: value$16
    };
    var value$19 = value$1.adminAddress;
    var value$20 = GqlConverters.Address.serialize(value$19);
    var value$21 = value$1.tokenFactory;
    var value$22 = value$21.address;
    var value$23 = GqlConverters.Address.serialize(value$22);
    var value$24 = value$21.id;
    var value$25 = value$21.__typename;
    var tokenFactory = {
      __typename: value$25,
      id: value$24,
      address: value$23
    };
    var value$26 = value$1.staker;
    var value$27 = value$26.address;
    var value$28 = GqlConverters.Address.serialize(value$27);
    var value$29 = value$26.id;
    var value$30 = value$26.__typename;
    var staker = {
      __typename: value$30,
      id: value$29,
      address: value$28
    };
    var value$31 = value$1.latestMarketIndex;
    var value$32 = GqlConverters.$$BigInt.serialize(value$31);
    var value$33 = value$1.contractVersion;
    var value$34 = GqlConverters.$$BigInt.serialize(value$33);
    var value$35 = value$1.id;
    var value$36 = value$1.__typename;
    globalState = {
      __typename: value$36,
      id: value$35,
      contractVersion: value$34,
      latestMarketIndex: value$32,
      staker: staker,
      tokenFactory: tokenFactory,
      adminAddress: value$20,
      longShort: longShort,
      totalFloatMinted: value$13,
      totalTxs: value$11,
      totalGasUsed: value$9,
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
  Raw: Raw$1,
  query: query$1,
  parse: parse$1,
  serialize: serialize$1,
  serializeVariables: serializeVariables$1,
  makeVariables: makeVariables$1
};

var include$1 = ApolloClient__React_Hooks_UseQuery.Extend({
      query: query$1,
      Raw: Raw$1,
      parse: parse$1,
      serialize: serialize$1,
      serializeVariables: serializeVariables$1
    });

var GetGlobalState_refetchQueryDescription = include$1.refetchQueryDescription;

var GetGlobalState_use = include$1.use;

var GetGlobalState_useLazy = include$1.useLazy;

var GetGlobalState_useLazyWithVariables = include$1.useLazyWithVariables;

var GetGlobalState = {
  GetGlobalState_inner: GetGlobalState_inner,
  Raw: Raw$1,
  query: query$1,
  parse: parse$1,
  serialize: serialize$1,
  serializeVariables: serializeVariables$1,
  makeVariables: makeVariables$1,
  refetchQueryDescription: GetGlobalState_refetchQueryDescription,
  use: GetGlobalState_use,
  useLazy: GetGlobalState_useLazy,
  useLazyWithVariables: GetGlobalState_useLazyWithVariables
};

function getGlobalStateAtBlock(blockNumber) {
  var __x = Curry._6(Client.instance.rescript_query, {
        query: query$1,
        Raw: Raw$1,
        parse: parse$1,
        serialize: serialize$1,
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

var ApolloQueryResult;

exports.ApolloQueryResult = ApolloQueryResult;
exports.GetAllStateChanges = GetAllStateChanges;
exports.getAllStateChanges = getAllStateChanges;
exports.GetGlobalState = GetGlobalState;
exports.getGlobalStateAtBlock = getGlobalStateAtBlock;
/* query Not a pure module */
