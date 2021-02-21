// Generated by ReScript, PLEASE EDIT WITH CARE

import * as Curry from "bs-platform/lib/es6/curry.js";
import * as Login from "./components/Login/Login.js";
import * as React from "react";
import * as Loader from "./components/UI/Loader.js";
import * as Js_dict from "bs-platform/lib/es6/js_dict.js";
import * as Queries from "./libraries/Queries.js";
import * as Belt_Int from "bs-platform/lib/es6/belt_Int.js";
import * as MintForm from "./components/Trade/MintForm.js";
import * as Belt_Array from "bs-platform/lib/es6/belt_Array.js";
import * as Belt_Option from "bs-platform/lib/es6/belt_Option.js";
import * as Router from "next/router";
import * as AccessControl from "./components/AccessControl.js";

function Mint$Mint(Props) {
  var router = Router.useRouter();
  var markets = Curry.app(Queries.MarketDetails.use, [
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
  var marketIndex = Belt_Option.getWithDefault(Js_dict.get(router.query, "marketIndex"), "1");
  var match = markets.data;
  var tmp;
  if (markets.loading) {
    tmp = React.createElement(Loader.make, {});
  } else if (markets.error !== undefined) {
    tmp = "Error loading data";
  } else if (match !== undefined) {
    var optFirstMarket = Belt_Array.get(match.syntheticMarkets, Belt_Option.getWithDefault(Belt_Int.fromString(marketIndex), 1) - 1 | 0);
    tmp = optFirstMarket !== undefined ? React.createElement(MintForm.make, {
            market: optFirstMarket
          }) : React.createElement("p", undefined, "No markets exist");
  } else {
    tmp = "You might think this is impossible, but depending on the situation it might not be!";
  }
  return React.createElement(AccessControl.make, {
              children: React.createElement("section", undefined, tmp),
              alternateComponent: React.createElement("h1", {
                    onClick: (function (param) {
                        router.push("/login?nextPath=/mint");
                        
                      })
                  }, React.createElement(Login.make, {}))
            });
}

var Mint = {
  make: Mint$Mint
};

function $$default(param) {
  return React.createElement(Mint$Mint, {});
}

export {
  Mint ,
  $$default ,
  $$default as default,
  
}
/* Login Not a pure module */
