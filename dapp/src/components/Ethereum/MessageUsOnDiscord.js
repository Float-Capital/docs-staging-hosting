// Generated by ReScript, PLEASE EDIT WITH CARE
'use strict';

var React = require("react");
var Config = require("../../config/Config.js");

function MessageUsOnDiscord(Props) {
  return React.createElement("p", {
              className: "text-xs hover:underline"
            }, React.createElement("a", {
                  href: Config.discordInviteLink,
                  rel: "noopenner noreferer",
                  target: "_"
                }, "Message us on discord for assistance"));
}

var make = MessageUsOnDiscord;

exports.make = make;
/* react Not a pure module */
