// Generated by ReScript, PLEASE EDIT WITH CARE
'use strict';

var React = require("react");
var LandingNav = require("./components/LandingNav.js");
var EcosystemPartners = require("./components/EcosystemPartners.js");

function Landing(Props) {
  return React.createElement("section", {
              className: "blue-dusk-island flex flex-col md:flex-row items-center min-h-screen"
            }, React.createElement("div", {
                  className: "w-full mx-2 block md:relative"
                }, React.createElement("div", {
                      className: "v-align-in-responsive-height min-w-3/4 md:min-w-400"
                    }, React.createElement("div", {
                          className: "block static"
                        }, React.createElement("div", {
                              className: "font-bold leading-none w-full  md:min-w-400 my-2"
                            }, React.createElement("div", {
                                  className: "logo-container mx-auto"
                                }, React.createElement("img", {
                                      className: "h-14 md:h-44 my-5 w-full md:w-auto",
                                      src: "/img/float-capital-logo-sq-center.svg"
                                    })), React.createElement("h1", {
                                  className: "text-lg md:text-2xl font-vt323 font-extrabold text-center"
                                }, "Peer-to-peer synthetic assets")), React.createElement(LandingNav.make, {})))), React.createElement(EcosystemPartners.make, {}));
}

var Link;

var make = Landing;

exports.Link = Link;
exports.make = make;
/* react Not a pure module */
