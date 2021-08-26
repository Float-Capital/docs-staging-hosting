// Generated by ReScript, PLEASE EDIT WITH CARE
'use strict';

var Misc = require("../../libraries/Misc.js");
var Curry = require("rescript/lib/js/curry.js");
var React = require("react");
var Loader = require("../../components/UI/Base/Loader.js");
var Queries = require("../../data/Queries.js");
var CONSTANTS = require("../../CONSTANTS.js");

function TVL(Props) {
  var tvlQuery = Curry.app(Queries.TVL.use, [
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
  var match = tvlQuery.data;
  if (tvlQuery.loading) {
    return React.createElement(Loader.Tiny.make, {});
  }
  if (tvlQuery.error !== undefined) {
    return React.createElement("div", {
                className: "fixed bottom-3 left-3 flex flex-col items-end invisible md:visible bg-white bg-opacity-75 rounded-lg shadow-lg px-2 py-1"
              }, React.createElement("span", {
                    className: "text-xxs"
                  }, "Error loading TVL"));
  }
  if (match === undefined) {
    return React.createElement(React.Fragment, undefined, "");
  }
  var match$1 = match.globalState;
  if (match$1 === undefined) {
    return React.createElement(React.Fragment, undefined, "");
  }
  var totalValueLocked = match$1.totalValueLocked;
  if (totalValueLocked.gte(CONSTANTS.fiveHundredThousandInWei)) {
    return React.createElement("div", {
                className: "fixed bottom-3 left-3 flex flex-col items-end invisible md:visible bg-white bg-opacity-75 rounded-lg shadow-lg px-2 py-1"
              }, React.createElement("div", {
                    className: "text-sm flex flex-row items-center"
                  }, React.createElement("span", undefined, "TVL: $"), React.createElement("span", {
                        className: "font-bold"
                      }, Misc.NumberFormat.formatEther(undefined, totalValueLocked)), React.createElement("img", {
                        className: "h-6 mx-1",
                        src: "/icons/dollar-coin.png"
                      })));
  } else {
    return null;
  }
}

var make = TVL;

exports.make = make;
/* Misc Not a pure module */
