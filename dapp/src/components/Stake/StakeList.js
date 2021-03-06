// Generated by ReScript, PLEASE EDIT WITH CARE

import * as Curry from "bs-platform/lib/es6/curry.js";
import * as Login from "../Login/Login.js";
import * as React from "react";
import * as Queries from "../../data/Queries.js";
import * as StakeCard from "./StakeCard.js";
import * as Belt_Array from "bs-platform/lib/es6/belt_Array.js";
import * as MiniLoader from "../UI/MiniLoader.js";
import * as Router from "next/router";
import * as AccessControl from "../AccessControl.js";

function StakeList(Props) {
  var router = Router.useRouter();
  var stakeDetailsQuery = Curry.app(Queries.StakingDetails.use, [
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
  var match = stakeDetailsQuery.data;
  return React.createElement(AccessControl.make, {
              children: React.createElement("div", {
                    className: "w-full max-w-4xl mx-auto"
                  }, stakeDetailsQuery.loading ? React.createElement("div", {
                          className: "m-auto"
                        }, React.createElement(MiniLoader.make, {})) : (
                      stakeDetailsQuery.error !== undefined ? "Error loading data" : (
                          match !== undefined ? React.createElement(React.Fragment, undefined, Belt_Array.map(match.syntheticMarkets, (function (param) {
                                        var match = param.latestSystemState;
                                        var match$1 = param.syntheticShort;
                                        var match$2 = param.syntheticLong;
                                        var name = param.name;
                                        return React.createElement(StakeCard.make, {
                                                    marketName: name,
                                                    totalLockedLong: match.totalLockedLong,
                                                    totalLockedShort: match.totalLockedShort,
                                                    router: router,
                                                    longTokenPrice: match.longTokenPrice,
                                                    shortTokenPrice: match.shortTokenPrice,
                                                    longStaked: match$2.longTotalStaked,
                                                    shortStaked: match$1.shortTotalStaked,
                                                    shortAddress: match$1.shortTokenAddress,
                                                    longAddress: match$2.longTokenAddress,
                                                    currentTimestamp: match.timestamp,
                                                    createdTimestamp: param.timestampCreated,
                                                    key: name
                                                  });
                                      }))) : "You might think this is impossible, but depending on the situation it might not be!"
                        )
                    )),
              alternateComponent: React.createElement("h1", {
                    onClick: (function (param) {
                        router.push("/login?nextPath=/dashboard");
                        
                      })
                  }, React.createElement(Login.make, {}))
            });
}

var make = StakeList;

export {
  make ,
  
}
/* Login Not a pure module */
