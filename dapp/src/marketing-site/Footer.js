// Generated by ReScript, PLEASE EDIT WITH CARE
'use strict';

var React = require("react");
var Config = require("../config/Config.js");
var Link = require("next/link").default;

function Footer(Props) {
  return React.createElement("section", {
              className: "py-5 my-0 text:2xl md:text-lg flex flex-col md:flex-row items-end md:items-center md:justify-center bg-primary text-white"
            }, React.createElement(Link, {
                  href: "/markets",
                  children: React.createElement("a", {
                        className: "px-3 hover:bg-white hover:text-black"
                      }, "app")
                }), React.createElement(Link, {
                  href: "/stats",
                  children: React.createElement("a", {
                        className: "px-3 hover:bg-white hover:text-black"
                      }, "stats")
                }), React.createElement("a", {
                  className: "px-3 hover:bg-white hover:text-black",
                  href: "https://www.cryptovoxels.com/play?coords=N@459W,127S",
                  rel: "noopenner noreferer",
                  target: "_"
                }, "headquarters"), React.createElement("a", {
                  className: "px-3 hover:bg-white hover:text-black",
                  href: Config.discordInviteLink,
                  rel: "noopenner noreferer",
                  target: "_"
                }, "discord"), React.createElement("a", {
                  className: "px-3 hover:bg-white hover:text-black",
                  href: "https://twitter.com/float_capital",
                  rel: "noopenner noreferer",
                  target: "_"
                }, "twitter"), React.createElement("a", {
                  className: "px-3 hover:bg-white hover:text-black",
                  href: "https://docs.float.capital",
                  rel: "noopenner noreferer",
                  target: "_"
                }, "docs"));
}

var make = Footer;

exports.make = make;
/* react Not a pure module */
