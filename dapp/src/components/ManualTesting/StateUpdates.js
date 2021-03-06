// Generated by ReScript, PLEASE EDIT WITH CARE

import * as Misc from "../../libraries/Misc.js";
import * as Curry from "bs-platform/lib/es6/curry.js";
import * as Login from "../Login/Login.js";
import * as React from "react";
import * as Client from "../../data/Client.js";
import * as Config from "../../Config.js";
import * as Ethers from "../../ethereum/Ethers.js";
import * as Ethers$1 from "ethers";
import * as Globals from "../../libraries/Globals.js";
import * as Queries from "../../data/Queries.js";
import * as Contracts from "../../ethereum/Contracts.js";
import * as Belt_Array from "bs-platform/lib/es6/belt_Array.js";
import * as Belt_Option from "bs-platform/lib/es6/belt_Option.js";
import * as Caml_option from "bs-platform/lib/es6/caml_option.js";
import * as RootProvider from "../../libraries/RootProvider.js";
import * as AccessControl from "../AccessControl.js";
import * as GqlConverters from "../../libraries/GqlConverters.js";
import * as ContractActions from "../../ethereum/ContractActions.js";
import Format from "date-fns/format";
import FromUnixTime from "date-fns/fromUnixTime";
import FormatDistanceToNow from "date-fns/formatDistanceToNow";

function queryLatestStateChanges(client, pollVariables) {
  return Curry._6(client.rescript_query, {
              query: Queries.StateChangePoll.query,
              Raw: Queries.StateChangePoll.Raw,
              parse: Queries.StateChangePoll.parse,
              serialize: Queries.StateChangePoll.serialize,
              serializeVariables: Queries.StateChangePoll.serializeVariables
            }, undefined, undefined, /* NetworkOnly */2, undefined, pollVariables);
}

function StateUpdates$TestTxButton(Props) {
  var signer = ContractActions.useSignerExn(undefined);
  var match = ContractActions.useContractFunction(signer);
  var contractExecutionHandler = match[0];
  var longShortAddress = Config.useLongShortAddress(undefined);
  return React.createElement("button", {
              onClick: (function (param) {
                  var arg = Ethers$1.BigNumber.from(3);
                  var arg$1 = Ethers.Utils.parseEther("1");
                  return Curry._2(contractExecutionHandler, (function (param) {
                                return Contracts.LongShort.make(longShortAddress, param);
                              }), (function (param) {
                                return param.mintShortAndStake(arg, arg$1);
                              }));
                })
            }, ">>Make test transaction<<");
}

var TestTxButton = {
  make: StateUpdates$TestTxButton
};

function StateUpdates$ExampleStateUpdates(Props) {
  var match = React.useState(function () {
        return Ethers$1.BigNumber.from(Misc.Time.getCurrentTimestamp(undefined));
      });
  var setLatestStateChangeTimestamp = match[1];
  var latestStateChangeTimestamp = match[0];
  var optCurrentUser = RootProvider.useCurrentUser(undefined);
  var client = Client.useApolloClient(undefined);
  var basicUserQuery = Curry.app(Queries.UserQuery.use, [
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
          userId: Belt_Option.mapWithDefault(optCurrentUser, "0x374252d2c9f0075b7e2ca2a9868b44f1f62fba80", Globals.ethAdrToLowerStr)
        }
      ]);
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
                                  }
                                  Belt_Option.map(param.affectedUsers, (function (affectedUsers) {
                                          return Belt_Array.map(affectedUsers, (function (userData) {
                                                        Curry._6(client.rescript_writeFragment, {
                                                              query: Queries.BasicUserInfo.query,
                                                              Raw: Queries.BasicUserInfo.Raw,
                                                              parse: Queries.BasicUserInfo.parse,
                                                              serialize: Queries.BasicUserInfo.serialize
                                                            }, {
                                                              __typename: userData.__typename,
                                                              id: userData.id,
                                                              totalMintedFloat: userData.totalMintedFloat,
                                                              floatTokenBalance: userData.floatTokenBalance,
                                                              numberOfTransactions: userData.numberOfTransactions,
                                                              totalGasUsed: userData.totalGasUsed
                                                            }, undefined, "User:" + "0x374252d2c9f0075b7e2ca2a9868b44f1f62fba80", undefined, undefined);
                                                        
                                                      }));
                                        }));
                                  
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
  var lastChangeJsDate = FromUnixTime(latestStateChangeTimestamp.toNumber());
  var match$1 = basicUserQuery.data;
  var tmp;
  if (match$1 !== undefined) {
    var match$2 = match$1.user;
    tmp = match$2 !== undefined ? React.createElement(React.Fragment, undefined, "you have done " + match$2.numberOfTransactions.toString() + " transactions and used " + match$2.totalGasUsed.toString() + " in the float platform") : (
        basicUserQuery.error !== undefined ? "Error loading users float data" : "Loading total minted by user"
      );
  } else {
    tmp = basicUserQuery.error !== undefined ? "Error loading users float data" : "Loading total minted by user";
  }
  return React.createElement(React.Fragment, undefined, React.createElement("div", undefined, "Latest timestamp: " + Format(lastChangeJsDate, "PPPppp") + " (" + FormatDistanceToNow(lastChangeJsDate) + " ago)"), React.createElement("hr", undefined), React.createElement("hr", undefined), React.createElement("hr", undefined), React.createElement("div", undefined, tmp), React.createElement(AccessControl.make, {
                  children: React.createElement(StateUpdates$TestTxButton, {}),
                  alternateComponent: React.createElement(Login.make, {})
                }));
}

var ExampleStateUpdates = {
  make: StateUpdates$ExampleStateUpdates
};

function $$default(param) {
  return React.createElement(StateUpdates$ExampleStateUpdates, {});
}

export {
  queryLatestStateChanges ,
  TestTxButton ,
  ExampleStateUpdates ,
  $$default ,
  $$default as default,
  
}
/* Misc Not a pure module */
