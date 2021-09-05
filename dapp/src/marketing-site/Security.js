// Generated by ReScript, PLEASE EDIT WITH CARE
'use strict';

var React = require("react");
var Footer = require("./Footer.js");
var Heading = require("./components/Heading.js");

function Security(Props) {
  return React.createElement("section", {
              className: "min-h-screen w-screen electric-lines",
              id: "security"
            }, React.createElement("div", {
                  className: " flex flex-col items-center justify-center pb-16 custom-height-for-above-footer"
                }, React.createElement("div", {
                      className: "max-w-5xl flex flex-col justify-evenly items-center mx-auto"
                    }, React.createElement(Heading.make, {
                          title: "security",
                          suffixEmoji: "🔐"
                        }), React.createElement("div", {
                          className: "grid grid-cols-1 md:grid-cols-3 gap-10 items-center justify-center my-4"
                        }, React.createElement("div", {
                              className: "mx-4 order-3 md:order-1 bg-white bg-opacity-70 md:p-4 p-1 rounded w-46"
                            }, React.createElement("a", {
                                  className: "custom-cursor",
                                  href: "https://docs.float.capital/docs/security",
                                  rel: "noopener noreferrer",
                                  target: "_blank"
                                }, React.createElement("img", {
                                      className: "h-16 md:h-32 mx-auto  hover:opacity-80",
                                      src: "/icons/coverage.svg"
                                    }), React.createElement("p", {
                                      className: "text-center font-bold mx-auto hover:underline"
                                    }, "Contract coverage"), React.createElement("p", {
                                      className: "text-center mx-auto text-xs text-gray-500"
                                    }, "coming soon"))), React.createElement("div", {
                              className: "mx-4 order-2  bg-white bg-opacity-70 md:p-4 p-1 rounded  w-46"
                            }, React.createElement("a", {
                                  className: "custom-cursor",
                                  href: "https://docs.float.capital/docs/security",
                                  rel: "noopener noreferrer",
                                  target: "_blank"
                                }, React.createElement("img", {
                                      className: "h-16 md:h-32 mx-auto  hover:opacity-80",
                                      src: "/icons/github-color.svg"
                                    }), React.createElement("p", {
                                      className: "text-center font-bold mx-auto hover:underline"
                                    }, "Github code"), React.createElement("p", {
                                      className: "text-center mx-auto text-xs text-gray-500"
                                    }, "coming soon"))), React.createElement("div", {
                              className: "mx-4  order-1 md:order-3  bg-white bg-opacity-70 md:p-4 p-1 rounded  w-46 "
                            }, React.createElement("a", {
                                  className: "custom-cursor",
                                  href: "https://docs.float.capital/docs/security",
                                  rel: "noopener noreferrer",
                                  target: "_blank"
                                }, React.createElement("img", {
                                      className: "h-16 md:h-32 mx-auto  hover:opacity-80",
                                      src: "/icons/code-arena-sq-dark.png"
                                    }), React.createElement("p", {
                                      className: "text-center font-bold mx-auto hover:underline"
                                    }, "Audit"), React.createElement("p", {
                                      className: "text-center mx-auto text-xs text-gray-500"
                                    }, "coming soon")))))), React.createElement(Footer.make, {}));
}

var make = Security;

exports.make = make;
/* react Not a pure module */
