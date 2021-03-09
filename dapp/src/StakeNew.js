// Generated by ReScript, PLEASE EDIT WITH CARE

import * as React from "react";
import * as Js_dict from "bs-platform/lib/es6/js_dict.js";
import * as StakeForm from "./components/Stake/StakeForm.js";
import * as StakeList from "./components/Stake/StakeList.js";
import * as Router from "next/router";

function StakeNew$Markets(Props) {
  var router = Router.useRouter();
  var stakeOption = Js_dict.get(router.query, "tokenAddress");
  return React.createElement(React.Fragment, undefined, stakeOption !== undefined ? React.createElement(StakeForm.make, {
                    tokenId: stakeOption
                  }) : null, React.createElement(StakeList.make, {}));
}

var Markets = {
  make: StakeNew$Markets
};

function $$default(param) {
  return React.createElement(StakeNew$Markets, {});
}

export {
  Markets ,
  $$default ,
  $$default as default,
  
}
/* react Not a pure module */
