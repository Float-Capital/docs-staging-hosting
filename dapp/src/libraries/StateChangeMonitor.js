// Generated by ReScript, PLEASE EDIT WITH CARE

import * as Misc from "./Misc.js";
import * as Curry from "bs-platform/lib/es6/curry.js";
import * as React from "react";
import * as Client from "../data/Client.js";
import * as Ethers from "ethers";
import * as Globals from "./Globals.js";
import * as Queries from "../data/Queries.js";
import * as Belt_Array from "bs-platform/lib/es6/belt_Array.js";
import * as Belt_Option from "bs-platform/lib/es6/belt_Option.js";
import * as Caml_option from "bs-platform/lib/es6/caml_option.js";
import * as RootProvider from "./RootProvider.js";
import * as GqlConverters from "./GqlConverters.js";

function queryLatestStateChanges(client, pollVariables) {
  return Curry._6(client.rescript_query, {
              query: Queries.StateChangePoll.query,
              Raw: Queries.StateChangePoll.Raw,
              parse: Queries.StateChangePoll.parse,
              serialize: Queries.StateChangePoll.serialize,
              serializeVariables: Queries.StateChangePoll.serializeVariables
            }, undefined, undefined, /* NetworkOnly */2, undefined, pollVariables);
}

var initialLatestStateChangeId = Ethers.BigNumber.from(Misc.Time.getCurrentTimestamp(undefined));

var context = React.createContext(initialLatestStateChangeId.toString());

var provider = context.Provider;

function StateChangeMonitor(Props) {
  var children = Props.children;
  var match = React.useState(function () {
        return initialLatestStateChangeId;
      });
  var setLatestStateChangeTimestamp = match[1];
  var latestStateChangeTimestamp = match[0];
  var optCurrentUser = RootProvider.useCurrentUser(undefined);
  var client = Client.useApolloClient(undefined);
  React.useEffect((function () {
          if (optCurrentUser === undefined) {
            return ;
          }
          var currentUser = Caml_option.valFromOption(optCurrentUser);
          var interval = setInterval((function (param) {
                  var currentUser$1 = Globals.ethAdrToLowerStr(currentUser);
                  var pollVariables_timestamp = GqlConverters.$$BigInt.serialize(latestStateChangeTimestamp);
                  var pollVariables = {
                    userId: currentUser$1,
                    timestamp: pollVariables_timestamp
                  };
                  queryLatestStateChanges(client, pollVariables).then(function (queryResult) {
                        if (queryResult.TAG !== /* Ok */0) {
                          return ;
                        }
                        var stateChanges = queryResult._0.data.stateChanges;
                        if (stateChanges.length !== 0) {
                          Belt_Array.map(stateChanges, (function (param) {
                                  var timestamp = param.timestamp;
                                  if (timestamp.gt(latestStateChangeTimestamp)) {
                                    Curry._1(setLatestStateChangeTimestamp, (function (param) {
                                            return timestamp;
                                          }));
                                    Belt_Option.map(param.affectedUsers, (function (users) {
                                            return Belt_Array.map(users, (function (param) {
                                                          var tokenBalances = param.tokenBalances;
                                                          var id = param.basicUserInfo.id;
                                                          var balanceReadQuery = Curry._5(client.rescript_readQuery, {
                                                                query: Queries.UsersBalances.query,
                                                                Raw: Queries.UsersBalances.Raw,
                                                                parse: Queries.UsersBalances.parse,
                                                                serialize: Queries.UsersBalances.serialize,
                                                                serializeVariables: Queries.UsersBalances.serializeVariables
                                                              }, undefined, undefined, undefined, {
                                                                userId: id
                                                              });
                                                          if (balanceReadQuery !== undefined && balanceReadQuery.TAG === /* Ok */0) {
                                                            var match = balanceReadQuery._0.user;
                                                            if (match !== undefined) {
                                                              var usersCurrentBalances = match.tokenBalances;
                                                              if (usersCurrentBalances !== undefined && tokenBalances !== undefined) {
                                                                var containsBalanceItem = function (listOfBalances, param) {
                                                                  var comparisonId = param.id;
                                                                  return Belt_Array.getIndexBy(listOfBalances, (function (param) {
                                                                                return comparisonId === param.id;
                                                                              }));
                                                                };
                                                                var updatedTokenBalances = Belt_Array.reduce(tokenBalances, usersCurrentBalances, (function (currentBalances, newBalance) {
                                                                        var index = containsBalanceItem(currentBalances, newBalance);
                                                                        if (index !== undefined) {
                                                                          Belt_Array.set(currentBalances, index, newBalance);
                                                                          return currentBalances;
                                                                        } else {
                                                                          return Belt_Array.concat(currentBalances, [newBalance]);
                                                                        }
                                                                      }));
                                                                Curry._6(client.rescript_writeQuery, {
                                                                      query: Queries.UsersBalances.query,
                                                                      Raw: Queries.UsersBalances.Raw,
                                                                      parse: Queries.UsersBalances.parse,
                                                                      serialize: Queries.UsersBalances.serialize,
                                                                      serializeVariables: Queries.UsersBalances.serializeVariables
                                                                    }, undefined, {
                                                                      user: {
                                                                        __typename: match.__typename,
                                                                        tokenBalances: updatedTokenBalances
                                                                      }
                                                                    }, undefined, undefined, {
                                                                      userId: id
                                                                    });
                                                                return ;
                                                              }
                                                              
                                                            }
                                                            
                                                          }
                                                          console.log("No balances loaded for user yet, will fetch the users balances from graph");
                                                          Curry._6(client.rescript_query, {
                                                                query: Queries.UsersBalances.query,
                                                                Raw: Queries.UsersBalances.Raw,
                                                                parse: Queries.UsersBalances.parse,
                                                                serialize: Queries.UsersBalances.serialize,
                                                                serializeVariables: Queries.UsersBalances.serializeVariables
                                                              }, undefined, undefined, undefined, undefined, {
                                                                userId: id
                                                              });
                                                          
                                                        }));
                                          }));
                                    return ;
                                  }
                                  
                                }));
                          return ;
                        }
                        
                      });
                  
                }), 3000);
          return (function (param) {
                    clearInterval(interval);
                    
                  });
        }), [
        optCurrentUser,
        latestStateChangeTimestamp
      ]);
  return React.createElement(provider, {
              value: latestStateChangeTimestamp.toString(),
              children: children
            });
}

function useDataFreshnessString(param) {
  return React.useContext(context);
}

var make = StateChangeMonitor;

export {
  queryLatestStateChanges ,
  initialLatestStateChangeId ,
  context ,
  provider ,
  make ,
  useDataFreshnessString ,
  
}
/* initialLatestStateChangeId Not a pure module */
