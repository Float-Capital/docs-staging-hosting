// Generated by ReScript, PLEASE EDIT WITH CARE
'use strict';

var Ramp = require("../libraries/Ramp.js");
var Curry = require("rescript/lib/js/curry.js");
var React = require("react");
var Button = require("../components/UI/Base/Button.js");

function FiatOnramp(Props) {
  var onramp = Ramp.useRamp(undefined);
  return React.createElement("section", {
              className: "max-w-2xl mx-auto p-5  flex-col items-center justify-between bg-white bg-opacity-75 rounded-lg shadow-lg"
            }, React.createElement("div", {
                  className: "text-center p-6 pt-0"
                }, React.createElement("h1", {
                      className: "text-lg p-2"
                    }, "You can use this fiat onramp to buy DAI on Polygon")), React.createElement("div", {
                  className: "mx-auto max-w-sm"
                }, React.createElement(Button.make, {
                      onClick: (function (param) {
                          return Curry._1(onramp.show, undefined);
                        }),
                      children: "Buy Polygon DAI"
                    })));
}

var make = FiatOnramp;

var $$default = FiatOnramp;

exports.make = make;
exports.$$default = $$default;
exports.default = $$default;
exports.__esModule = true;
/* Ramp Not a pure module */
