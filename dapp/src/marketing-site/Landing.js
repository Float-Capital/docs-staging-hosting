// Generated by ReScript, PLEASE EDIT WITH CARE
'use strict';

var Next = require("../bindings/Next.js");
var React = require("react");
var Button = require("../components/UI/Base/Button.js");
var Config = require("../config/Config.js");
var SiteNav = require("./SiteNav.js");
var Router = require("next/router");
var FeaturedMarkets = require("./FeaturedMarkets.js");

function Landing(Props) {
  var router = Router.useRouter();
  return React.createElement("section", {
              className: "min-h-screen landing"
            }, React.createElement(SiteNav.make, {}), React.createElement("div", {
                  className: "min-h-screen flex flex-col md:flex-row items-center"
                }, React.createElement("div", {
                      className: "w-full md:w-2/5 mx-2 relative"
                    }, React.createElement("div", {
                          className: "v-align-in-responsive-height"
                        }, React.createElement("div", {
                              className: "block static"
                            }, React.createElement("div", {
                                  className: "text-2.5xl font-bold leading-none w-full md:min-w-400 my-2"
                                }, React.createElement("h1", undefined, "PEER TO PEER PERPETUAL "), React.createElement("h1", undefined, "SYNTHETIC ASSETS")), React.createElement("h2", undefined, "No overcollateralization"), React.createElement("h2", undefined, "No liquidiation"), React.createElement("h2", undefined, "No centralisation"), React.createElement("div", {
                                  className: "flex flex-row items-center w-1/2"
                                }, React.createElement(Button.make, {
                                      onClick: (function (param) {
                                          return Next.Router.pushShallow(router, "/markets");
                                        }),
                                      children: "APP"
                                    }), React.createElement("a", {
                                      href: Config.discordInviteLink,
                                      rel: "noopenner noreferer",
                                      target: "_"
                                    }, React.createElement("img", {
                                          className: "h-12 mx-4 cursor-pointer hover:opacity-75",
                                          src: "icons/discord-sq.svg"
                                        })), React.createElement("a", {
                                      href: "https://twitter.com/float_capital",
                                      rel: "noopenner noreferer",
                                      target: "_"
                                    }, React.createElement("img", {
                                          className: "h-12 cursor-pointer hover:opacity-75",
                                          src: "icons/twitter-sq.svg"
                                        })))))), React.createElement("div", {
                      className: "w-full md:w-3/5"
                    }, React.createElement(FeaturedMarkets.make, {}))));
}

var make = Landing;

exports.make = make;
/* react Not a pure module */
