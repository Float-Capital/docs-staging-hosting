// Generated by ReScript, PLEASE EDIT WITH CARE
'use strict';

var React = require("react");
var CONSTANTS = require("../../../CONSTANTS.js");
var Link = require("next/link").default;

function isHotAPY(apy) {
  return apy > CONSTANTS.hotAPYThreshold;
}

function mapVal(apy) {
  return (apy * 100).toFixed(2) + "%" + (
          apy > CONSTANTS.hotAPYThreshold ? "🔥" : ""
        );
}

function StatsStakeCard(Props) {
  var marketName = Props.marketName;
  var isLong = Props.isLong;
  var $$yield = Props.yield;
  var rewards = Props.rewards;
  var stakeYield = Props.stakeYield;
  return React.createElement(Link, {
              href: "/app/stake-markets",
              children: React.createElement("div", {
                    className: "my-2 flex w-full mx-auto border-2 border-light-purple rounded-lg z-10 shadow cursor-pointer"
                  }, React.createElement("div", {
                        className: "my-2 ml-5 text-sm"
                      }, marketName, React.createElement("br", {
                            className: "mt-1"
                          }), isLong ? "Long↗️" : "Short↘️"), React.createElement("div", {
                        className: "flex-1 my-2 text-sm flex flex-col items-center"
                      }, React.createElement("div", undefined, React.createElement("div", undefined, React.createElement("span", {
                                    className: "text-xxs font-bold mr-2"
                                  }, "alphaFloat rewards:"), mapVal(rewards)), React.createElement("div", {
                                className: "mt-2"
                              }, React.createElement("span", {
                                    className: "text-xs font-bold mr-2"
                                  }, "Synthetic Yield:"), mapVal($$yield)), React.createElement("div", {
                                className: "mt-2"
                              }, React.createElement("span", {
                                    className: "text-xs font-bold mr-2"
                                  }, "Stake Yield:"), mapVal(stakeYield)))))
            });
}

var make = StatsStakeCard;

exports.isHotAPY = isHotAPY;
exports.mapVal = mapVal;
exports.make = make;
/* react Not a pure module */
