// Generated by ReScript, PLEASE EDIT WITH CARE

import * as Curry from "bs-platform/lib/es6/curry.js";
import * as React from "react";
import * as Globals from "../../libraries/Globals.js";
import * as Queries from "../../data/Queries.js";
import * as StateChangeMonitor from "../../libraries/StateChangeMonitor.js";

function useUsersStakes(address) {
  var userId = Globals.ethAdrToStr(address).toLowerCase();
  var match = Curry.app(Queries.UsersStakes.useLazy, [
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
  var executeQuery = match[0];
  React.useEffect((function () {
          Curry._3(executeQuery, undefined, undefined, {
                userId: userId
              });
          
        }), [StateChangeMonitor.useDataFreshnessString(undefined)]);
  return Curry.app(Queries.UsersStakes.use, [
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
                userId: userId
              }
            ]);
}

export {
  useUsersStakes ,
  
}
/* react Not a pure module */
