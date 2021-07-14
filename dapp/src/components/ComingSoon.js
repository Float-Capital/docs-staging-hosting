// Generated by ReScript, PLEASE EDIT WITH CARE
'use strict';

var React = require("react");
var Config = require("../config/Config.js");

function ComingSoon(Props) {
  return React.createElement("div", {
              className: "absolute bg-primary p-1 mb-2 h-10 flex items-center w-full font-default"
            }, React.createElement("div", {
                  className: "text-center text-xxs md:text-sm text-white mx-12 w-full"
                }, "🏗 The protocol is under active development, join our ", React.createElement("a", {
                      className: "bg-white hover:bg-primary-light text-primary hover:text-white py-1 font-bold",
                      href: Config.discordInviteLink,
                      rel: "noopener noreferrer",
                      target: "_blank"
                    }, "discord"), " to get the latest updates  🏗"));
}

var make = ComingSoon;

exports.make = make;
/* react Not a pure module */
