// Generated by ReScript, PLEASE EDIT WITH CARE
'use strict';

var React = require("react");
var Config = require("../../../config/Config.js");
var Format = require("date-fns/format").default;
var FromUnixTime = require("date-fns/fromUnixTime").default;
var FormatDistanceToNow = require("date-fns/formatDistanceToNow").default;

function FloatProtocolHighlightsCard(Props) {
  var liveSince = Props.liveSince;
  var totalUsers = Props.totalUsers;
  var txHash = Props.txHash;
  var numberOfSynths = Props.numberOfSynths;
  var deploymentDateObj = FromUnixTime(liveSince.toNumber());
  return React.createElement("div", {
              className: "bg-white w-full bg-opacity-75 rounded-lg shadow-lg mb-2 md:mb-5 p-6"
            }, React.createElement("h1", {
                  className: "font-bold text-center text-lg font-alphbeta mb-2"
                }, "🌊🌊 Float Capital Protocol 🌊🌊"), React.createElement("ul", undefined, React.createElement("a", {
                      className: "mt-2",
                      href: Config.blockExplorer + "/tx/" + txHash
                    }, React.createElement("li", undefined, React.createElement("span", {
                              className: "text-sm mr-2"
                            }, "🗓️ Live since:"), React.createElement("span", {
                              className: "text-md"
                            }, Format(deploymentDateObj, "do MMM ''yy")))), React.createElement("li", {
                      className: "mt-2"
                    }, React.createElement("span", {
                          className: "text-sm mr-2"
                        }, "📅 Days live:"), React.createElement("span", {
                          className: "text-md"
                        }, FormatDistanceToNow(deploymentDateObj))), React.createElement("li", {
                      className: "mt-2"
                    }, React.createElement("span", {
                          className: "text-sm mr-2"
                        }, "👯‍♀️ No. users:"), React.createElement("span", {
                          className: "text-md"
                        }, totalUsers.toString())), React.createElement("li", {
                      className: "mt-2"
                    }, React.createElement("span", {
                          className: "text-sm mr-2"
                        }, "👷‍♀️ No. synths:"), React.createElement("span", {
                          className: "text-md"
                        }, numberOfSynths))));
}

var make = FloatProtocolHighlightsCard;

exports.make = make;
/* react Not a pure module */
