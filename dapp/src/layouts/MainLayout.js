// Generated by ReScript, PLEASE EDIT WITH CARE

import * as Lost from "../components/UI/Lost.js";
import * as React from "react";
import * as Navigation from "./Navigation.js";

function MainLayout(Props) {
  var children = Props.children;
  return React.createElement("div", {
              className: "flex lg:justify-center min-h-screen"
            }, React.createElement("div", {
                  className: "max-w-5xl w-full text-gray-900 font-base"
                }, React.createElement("div", {
                      className: "flex flex-col h-screen"
                    }, React.createElement(Navigation.make, {}), React.createElement("div", {
                          className: "m-auto w-full"
                        }, children))), React.createElement(Lost.make, {}));
}

var make = MainLayout;

export {
  make ,
  
}
/* Lost Not a pure module */
