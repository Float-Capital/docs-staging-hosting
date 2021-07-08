// Generated by ReScript, PLEASE EDIT WITH CARE
'use strict';

var React = require("react");
var Config = require("../config/Config.js");
var Link = require("next/link").default;

function Footer(Props) {
  return React.createElement("section", {
              className: "text-right md:text-center text:2xl md:text-xs my-2 flex flex-col md:flex-row"
            }, React.createElement(Link, {
                  href: "/markets",
                  children: React.createElement("a", {
                        className: "px-3 hover:bg-white"
                      }, "app")
                }), React.createElement(Link, {
                  href: "/stats",
                  children: React.createElement("a", {
                        className: "px-3 hover:bg-white"
                      }, "stats")
                }), React.createElement("a", {
                  className: "px-3 hover:bg-white",
                  href: "https://www.cryptovoxels.com/play?coords=N@459W,127S",
                  rel: "noopenner noreferer",
                  target: "_"
                }, "headquarters"), React.createElement("a", {
                  className: "px-3 hover:bg-white",
                  href: Config.discordInviteLink,
                  rel: "noopenner noreferer",
                  target: "_"
                }, "discord"), React.createElement("a", {
                  className: "px-3 hover:bg-white",
                  href: "https://twitter.com/float_capital",
                  rel: "noopenner noreferer",
                  target: "_"
                }, "twitter"), React.createElement("a", {
                  className: "px-3 hover:bg-white",
                  href: "https://docs.float.capital",
                  rel: "noopenner noreferer",
                  target: "_"
                }, "docs"));
}

var make = Footer;

exports.make = make;
/* react Not a pure module */
