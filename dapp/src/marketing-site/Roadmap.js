// Generated by ReScript, PLEASE EDIT WITH CARE
'use strict';

var React = require("react");
var Timeline = require("./Timeline.js");

function Roadmap(Props) {
  return React.createElement("section", {
              className: "min-h-screen w-screen flex flex-col items-center justify-center bg-pastel-pink"
            }, React.createElement("h3", {
                  className: "my-2 text-5xl uppercase  font-arimo font-extrabold "
                }, "ROADMAP"), React.createElement(Timeline.make, {}));
}

var make = Roadmap;

exports.make = make;
/* react Not a pure module */
