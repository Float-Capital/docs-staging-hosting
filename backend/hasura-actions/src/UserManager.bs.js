// Generated by ReScript, PLEASE EDIT WITH CARE
'use strict';

var Curry = require("bs-platform/lib/js/curry.js");
var Decco = require("decco/src/Decco.bs.js");
var Serbet = require("serbet/src/Serbet.bs.js");
var Js_dict = require("bs-platform/lib/js/js_dict.js");
var Js_json = require("bs-platform/lib/js/js_json.js");
var AuthHook = require("./AuthHook.bs.js");
var Belt_Option = require("bs-platform/lib/js/belt_Option.js");
var ClientConfig = require("./gql/ClientConfig.bs.js");

function usersData_decode(v) {
  var dict = Js_json.classify(v);
  if (typeof dict === "number") {
    return Decco.error(undefined, "Not an object", v);
  }
  if (dict.TAG !== /* JSONObject */2) {
    return Decco.error(undefined, "Not an object", v);
  }
  var dict$1 = dict._0;
  var usersAddress = Decco.stringFromJson(Belt_Option.getWithDefault(Js_dict.get(dict$1, "usersAddress"), null));
  if (usersAddress.TAG === /* Ok */0) {
    var userName = Decco.optionFromJson(Decco.stringFromJson, Belt_Option.getWithDefault(Js_dict.get(dict$1, "userName"), null));
    if (userName.TAG === /* Ok */0) {
      return {
              TAG: /* Ok */0,
              _0: {
                usersAddress: usersAddress._0,
                userName: userName._0
              }
            };
    }
    var e = userName._0;
    return {
            TAG: /* Error */1,
            _0: {
              path: ".userName" + e.path,
              message: e.message,
              value: e.value
            }
          };
  }
  var e$1 = usersAddress._0;
  return {
          TAG: /* Error */1,
          _0: {
            path: ".usersAddress" + e$1.path,
            message: e$1.message,
            value: e$1.value
          }
        };
}

function body_in_decode(v) {
  var dict = Js_json.classify(v);
  if (typeof dict === "number") {
    return Decco.error(undefined, "Not an object", v);
  }
  if (dict.TAG !== /* JSONObject */2) {
    return Decco.error(undefined, "Not an object", v);
  }
  var input = usersData_decode(Belt_Option.getWithDefault(Js_dict.get(dict._0, "input"), null));
  if (input.TAG === /* Ok */0) {
    return {
            TAG: /* Ok */0,
            _0: {
              input: input._0
            }
          };
  }
  var e = input._0;
  return {
          TAG: /* Error */1,
          _0: {
            path: ".input" + e.path,
            message: e.message,
            value: e.value
          }
        };
}

function body_out_encode(v) {
  return Js_dict.fromArray([
              [
                "success",
                Decco.boolToJson(v.success)
              ],
              [
                "error",
                Decco.optionToJson(Decco.stringToJson, v.error)
              ]
            ]);
}

var gqlClient = ClientConfig.createInstance({
      "x-hasura-admin-secret": "testing"
    }, "http://graphql-engine:8080/v1/graphql", undefined);

var createUser = Serbet.endpoint(undefined, {
      path: "/create-user",
      verb: /* POST */1,
      handler: (function (req) {
          return Curry._1(req.requireBody, body_in_decode).then(function (param) {
                      var result = AuthHook.getAuthHeaders(req.req);
                      console.log([
                            "RESULT",
                            result
                          ]);
                      console.log("Eth address to register " + param.input.usersAddress);
                      return {
                              TAG: /* OkJson */4,
                              _0: body_out_encode({
                                    success: true,
                                    error: undefined
                                  })
                            };
                    });
        })
    });

var ApolloQueryResult;

exports.ApolloQueryResult = ApolloQueryResult;
exports.usersData_decode = usersData_decode;
exports.body_in_decode = body_in_decode;
exports.body_out_encode = body_out_encode;
exports.gqlClient = gqlClient;
exports.createUser = createUser;
/* gqlClient Not a pure module */
