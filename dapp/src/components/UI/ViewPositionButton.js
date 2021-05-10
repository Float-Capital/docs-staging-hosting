// Generated by ReScript, PLEASE EDIT WITH CARE
'use strict';

var React = require("react");
var Ethers = require("../../ethereum/Ethers.js");
var Link = require("next/link").default;
var Caml_option = require("rescript/lib/js/caml_option.js");
var RootProvider = require("../../libraries/RootProvider.js");

function ViewPositionButton(Props) {
  var optCurrentUser = RootProvider.useCurrentUser(undefined);
  var userPage = optCurrentUser !== undefined ? "/user/" + Ethers.Utils.ethAdrToLowerStr(Caml_option.valFromOption(optCurrentUser)) : "/";
  return React.createElement(Link, {
              href: userPage,
              children: React.createElement("button", {
                    className: "w-44 h-12 text-sm my-2 shadow-md rounded-lg border-2 focus:outline-none border-gray-200 hover:bg-gray-200 flex justify-center items-center mx-auto"
                  }, React.createElement("span", {
                        className: "mx-2"
                      }, "View position"))
            });
}

var make = ViewPositionButton;

exports.make = make;
/* react Not a pure module */
