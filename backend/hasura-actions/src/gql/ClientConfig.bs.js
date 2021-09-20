// Generated by ReScript, PLEASE EDIT WITH CARE
'use strict';

var Caml_option = require("rescript/lib/js/caml_option.js");
var ApolloClient = require("reason-apollo-client/src/ApolloClient.bs.js");
var ApolloClient__ApolloClient = require("reason-apollo-client/src/@apollo/client/ApolloClient__ApolloClient.bs.js");
var ApolloClient__Link_Http_HttpLink = require("reason-apollo-client/src/@apollo/client/link/http/ApolloClient__Link_Http_HttpLink.bs.js");
var ApolloClient__Cache_InMemory_InMemoryCache = require("reason-apollo-client/src/@apollo/client/cache/inmemory/ApolloClient__Cache_InMemory_InMemoryCache.bs.js");

((require('isomorphic-fetch')));

function httpLink(headers, graphqlEndpoint, param) {
  return ApolloClient__Link_Http_HttpLink.make((function (param) {
                return graphqlEndpoint;
              }), undefined, Caml_option.some(fetch), Caml_option.some(headers), undefined, undefined, undefined, undefined);
}

function createInstance(headers, graphqlEndpoint, param) {
  return ApolloClient.make(undefined, undefined, undefined, Caml_option.some(httpLink(Caml_option.some(headers), graphqlEndpoint, undefined)), ApolloClient__Cache_InMemory_InMemoryCache.make(undefined, undefined, undefined, undefined, undefined, undefined), undefined, undefined, true, undefined, ApolloClient__ApolloClient.DefaultOptions.make(ApolloClient__ApolloClient.DefaultMutateOptions.make(undefined, undefined, true, /* All */2, undefined, undefined), ApolloClient__ApolloClient.DefaultQueryOptions.make(/* NetworkOnly */2, /* All */2, undefined, undefined), ApolloClient__ApolloClient.DefaultWatchQueryOptions.make(/* NetworkOnly */3, /* All */2, undefined, undefined), undefined), undefined, undefined, undefined, undefined, undefined, undefined, undefined);
}

exports.httpLink = httpLink;
exports.createInstance = createInstance;
/*  Not a pure module */
