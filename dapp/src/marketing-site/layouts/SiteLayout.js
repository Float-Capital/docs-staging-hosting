// Generated by ReScript, PLEASE EDIT WITH CARE
'use strict';

var React = require("react");
var SiteNav = require("./SiteNav.js");
var ComingSoon = require("../../components/ComingSoon.js");

function SiteLayout(Props) {
  var children = Props.children;
  return React.createElement("div", {
              className: "flex lg:justify-center min-h-screen"
            }, React.createElement("div", {
                  className: "w-full text-gray-900 font-base"
                }, React.createElement("div", {
                      className: "flex flex-col"
                    }, React.createElement(ComingSoon.make, {}), React.createElement(SiteNav.make, {}), React.createElement("div", {
                          className: "m-auto w-full"
                        }, children))));
}

var make = SiteLayout;

exports.make = make;
/* react Not a pure module */
