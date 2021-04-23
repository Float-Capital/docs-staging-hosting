// Generated by ReScript, PLEASE EDIT WITH CARE
'use strict';

var React = require("react");
var Config = require("../Config.js");
var Ethers = require("../ethereum/Ethers.js");
var Caml_option = require("rescript/lib/js/caml_option.js");
var ApolloClient = require("rescript-apollo-client/src/ApolloClient.js");
var Client = require("@apollo/client");
var ReasonMLCommunity__ApolloClient = require("rescript-apollo-client/src/ReasonMLCommunity__ApolloClient.js");
var ApolloClient__Link_Http_HttpLink = require("rescript-apollo-client/src/@apollo/client/link/http/ApolloClient__Link_Http_HttpLink.js");
var ApolloClient__Cache_InMemory_InMemoryCache = require("rescript-apollo-client/src/@apollo/client/cache/inmemory/ApolloClient__Cache_InMemory_InMemoryCache.js");

function createContext(queryType) {
  return {
          context: queryType
        };
}

function httpLink(uri) {
  return ApolloClient__Link_Http_HttpLink.make((function (param) {
                return uri;
              }), undefined, undefined, undefined, undefined, undefined, undefined, undefined);
}

function setSignInData(ethAddress, ethSignature) {
  localStorage.setItem(ethAddress, ethSignature);
  
}

function getAuthHeaders(user) {
  if (user === undefined) {
    return ;
  }
  var u = Caml_option.valFromOption(user);
  var getUserSignature = function (__x) {
    return Caml_option.null_to_opt(__x.getItem(Ethers.Utils.ethAdrToLowerStr(u)));
  };
  var uS = getUserSignature(localStorage);
  if (uS !== undefined) {
    return {
            "eth-address": Ethers.Utils.ethAdrToLowerStr(u),
            "eth-signature": uS
          };
  }
  
}

function querySwitcherLink(user) {
  var headers = getAuthHeaders(user);
  return ReasonMLCommunity__ApolloClient.Link.split((function (operation) {
                var context = operation.getContext();
                if (context === undefined) {
                  return true;
                }
                var context$1 = context.context;
                if (context$1 !== undefined) {
                  return context$1 === 0;
                } else {
                  return true;
                }
              }), httpLink(Config.graphEndpoint), ReasonMLCommunity__ApolloClient.Link.split((function (operation) {
                    var context = operation.getContext();
                    var isPriceHistory;
                    if (context !== undefined) {
                      var match = context.context;
                      isPriceHistory = match !== undefined ? match === 1 : false;
                    } else {
                      isPriceHistory = false;
                    }
                    console.log("isPriceHistory", isPriceHistory);
                    return isPriceHistory;
                  }), httpLink(Config.priceHistoryGraphEndpoint), ApolloClient__Link_Http_HttpLink.make((function (param) {
                        return "TODO: no (hasura) backend configured yet - http://localhost:8080/v1/graphql";
                      }), undefined, undefined, Caml_option.some(headers !== undefined ? headers : (function (prim) {
                              return {};
                            })), undefined, undefined, undefined, undefined)));
}

function makeClient(user) {
  return ApolloClient.make(undefined, undefined, undefined, Caml_option.some(querySwitcherLink(user)), ApolloClient__Cache_InMemory_InMemoryCache.make(undefined, undefined, undefined, undefined, undefined, undefined), undefined, undefined, true, undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined);
}

var defaultClient = makeClient(undefined);

var context = React.createContext(defaultClient);

var provider = context.Provider;

function useApolloClient(param) {
  return React.useContext(context);
}

function Client$GraphQl(Props) {
  var children = Props.children;
  var client = React.useContext(context);
  return React.createElement(Client.ApolloProvider, {
              client: client,
              children: children
            });
}

var GraphQl = {
  make: Client$GraphQl
};

function Client$Provider(Props) {
  var children = Props.children;
  return React.createElement(provider, {
              value: defaultClient,
              children: children
            });
}

var Provider = {
  make: Client$Provider
};

function Client$1(Props) {
  var children = Props.children;
  return React.createElement(Client$Provider, {
              children: React.createElement(Client$GraphQl, {
                    children: children
                  })
            });
}

var make = Client$1;

exports.createContext = createContext;
exports.httpLink = httpLink;
exports.setSignInData = setSignInData;
exports.getAuthHeaders = getAuthHeaders;
exports.querySwitcherLink = querySwitcherLink;
exports.makeClient = makeClient;
exports.defaultClient = defaultClient;
exports.context = context;
exports.provider = provider;
exports.useApolloClient = useApolloClient;
exports.GraphQl = GraphQl;
exports.Provider = Provider;
exports.make = make;
/* defaultClient Not a pure module */
