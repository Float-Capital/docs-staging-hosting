// Generated by ReScript, PLEASE EDIT WITH CARE

import * as Card from "./components/UI/Card.js";
import * as Login from "./components/Login/Login.js";
import * as React from "react";
import * as Js_dict from "bs-platform/lib/es6/js_dict.js";
import * as DaiBalance from "./components/ExampleViewFunctions/DaiBalance.js";
import * as Router from "next/router";
import * as StakeDetails from "./StakeDetails.js";
import * as AccessControl from "./components/AccessControl.js";

function Profile$Profile(Props) {
  var router = Router.useRouter();
  var userAddress = Js_dict.get(router.query, "address");
  return React.createElement(AccessControl.make, {
              children: React.createElement("section", undefined, userAddress !== undefined ? React.createElement("div", undefined, React.createElement("p", {
                              className: "text-xs"
                            }, "User: ", userAddress), React.createElement("div", {
                              className: "flex w-full justify-between"
                            }, React.createElement("div", {
                                  className: "w-full mr-3"
                                }, React.createElement(Card.make, {
                                      children: React.createElement(DaiBalance.make, {})
                                    })), React.createElement("div", {
                                  className: "w-full ml-3"
                                }, React.createElement(StakeDetails.make, {})))) : null),
              alternateComponent: React.createElement("h1", {
                    onClick: (function (param) {
                        router.push("/login?nextPath=/");
                        
                      })
                  }, React.createElement(Login.make, {}))
            });
}

var Profile = {
  make: Profile$Profile
};

function $$default(param) {
  return React.createElement(Profile$Profile, {});
}

export {
  Profile ,
  $$default ,
  $$default as default,
  
}
/* Card Not a pure module */
