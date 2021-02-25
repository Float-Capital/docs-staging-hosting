// Generated by ReScript, PLEASE EDIT WITH CARE

import * as ApolloClient__React_Hooks_UseMutation from "rescript-apollo-client/src/@apollo/client/react/hooks/ApolloClient__React_Hooks_UseMutation.js";

var Raw = {};

var query = (require("@apollo/client").gql`
  mutation test($userAddress: String!, $userName: String)  {
    createUser(usersAddress: $userAddress, userName: $userName)  {
      __typename
      success
    }
  }
`);

function parse(value) {
  var value$1 = value.createUser;
  return {
          createUser: {
            __typename: value$1.__typename,
            success: value$1.success
          }
        };
}

function serialize(value) {
  var value$1 = value.createUser;
  var value$2 = value$1.success;
  var value$3 = value$1.__typename;
  var createUser = {
    __typename: value$3,
    success: value$2
  };
  return {
          createUser: createUser
        };
}

function serializeVariables(inp) {
  var a = inp.userName;
  return {
          userAddress: inp.userAddress,
          userName: a !== undefined ? a : undefined
        };
}

function makeVariables(userAddress, userName, param) {
  return {
          userAddress: userAddress,
          userName: userName
        };
}

var CreateUser_inner = {
  Raw: Raw,
  query: query,
  parse: parse,
  serialize: serialize,
  serializeVariables: serializeVariables,
  makeVariables: makeVariables
};

var include = ApolloClient__React_Hooks_UseMutation.Extend({
      query: query,
      Raw: Raw,
      parse: parse,
      serialize: serialize,
      serializeVariables: serializeVariables
    });

var CreateUser_use = include.use;

var CreateUser_useWithVariables = include.useWithVariables;

var CreateUser = {
  CreateUser_inner: CreateUser_inner,
  Raw: Raw,
  query: query,
  parse: parse,
  serialize: serialize,
  serializeVariables: serializeVariables,
  makeVariables: makeVariables,
  use: CreateUser_use,
  useWithVariables: CreateUser_useWithVariables
};

export {
  CreateUser ,
  
}
/* query Not a pure module */
