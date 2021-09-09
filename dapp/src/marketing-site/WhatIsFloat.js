// Generated by ReScript, PLEASE EDIT WITH CARE
'use strict';

var React = require("react");
var Button = require("../components/UI/Base/Button.js");
var FeaturedMarkets = require("./FeaturedMarkets.js");

function WhatIsFloat(Props) {
  return React.createElement("section", {
              className: "py-10 bg-white min-h-screen w-screen flex flex-col items-center justify-center purple-moon relative",
              id: "what-is-float"
            }, React.createElement("div", {
                  className: "flex flex-col items-center"
                }, React.createElement("div", {
                      className: "flex flex-row my-4 items-center justify-between max-w-6xl"
                    }, React.createElement("div", {
                          className: "w-full md:w-1/2 m-4 md:m-0 "
                        }, React.createElement("h3", {
                              className: "text-2xl leading-tight md:text-4xl flex flex-row items-center my-2 font-bold"
                            }, "Synthetic Assets Reimagined"), React.createElement("p", {
                              className: "text-lg md:text-xl my-2"
                            }, React.createElement("span", undefined, "The "), React.createElement("span", {
                                  className: "font-bold"
                                }, "easiest"), React.createElement("span", undefined, " and most "), React.createElement("span", {
                                  className: "font-bold"
                                }, "efficient"), React.createElement("span", undefined, " way to gain "), React.createElement("span", {
                                  className: "italic"
                                }, "long"), React.createElement("span", undefined, " or "), React.createElement("span", {
                                  className: "italic"
                                }, "short"), React.createElement("span", undefined, " exposure to a wide variety of assets.")), React.createElement("ul", {
                              className: "my-2"
                            }, React.createElement("li", undefined, React.createElement("span", {
                                      className: "font-vt323 font-bold mr-2"
                                    }, ">"), "No liquidations"), React.createElement("li", undefined, React.createElement("span", {
                                      className: "font-vt323 font-bold mr-2"
                                    }, ">"), "No over-collateralization"), React.createElement("li", undefined, React.createElement("span", {
                                      className: "font-vt323 font-bold mr-2"
                                    }, ">"), "No front-running"), React.createElement("li", undefined, React.createElement("span", {
                                      className: "font-vt323 font-bold mr-2"
                                    }, ">"), "No trading fees")), React.createElement("div", {
                              className: "my-2 inline-block"
                            }, React.createElement("a", {
                                  href: "https://docs.float.capital/docs/",
                                  rel: "noopener noreferrer",
                                  target: "_blank"
                                }, React.createElement(Button.make, {
                                      children: "Learn more"
                                    }))))), React.createElement("div", {
                      className: "hidden md:block absolute bottom-10 right-10"
                    }, React.createElement(FeaturedMarkets.make, {}))));
}

var make = WhatIsFloat;

exports.make = make;
/* react Not a pure module */
