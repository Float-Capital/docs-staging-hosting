// Generated by ReScript, PLEASE EDIT WITH CARE
'use strict';

var React = require("react");
var Button = require("../components/UI/Base/Button.js");

function Governance(Props) {
  return React.createElement("section", {
              className: "my-10"
            }, React.createElement("div", {
                  className: "max-w-5xl flex flex-col md:flex-row justify-evenly items-center mx-auto"
                }, React.createElement("div", {
                      className: "w-full md:w-1/2 order-2 md:order-1 p-4 md:p-0"
                    }, React.createElement("h3", {
                          className: "my-2 text-3xl uppercase font-bold"
                        }, "Governance"), React.createElement("p", undefined, "The FLT token governs the float capital protocol. The right governance model will direct and shape the protocol through community lead proposals in a decentralised and fair manor. The future of Float Capital will be dictated by its users. FLT holders govern the Float Capital Treasury."), React.createElement("div", {
                          className: "flex flex-row my-4 items-center justify-evenly md:justify-start  "
                        }, React.createElement("div", {
                              className: "mr-4"
                            }, React.createElement(Button.Small.make, {
                                  children: "Read more"
                                })), React.createElement("div", undefined, React.createElement(Button.Small.make, {
                                  children: "Earn FLT"
                                })))), React.createElement("div", {
                      className: "w-full md:w-1/2 order-1 md:order-2"
                    }, React.createElement("img", {
                          className: "mx-auto w-40",
                          src: "/img/governance.svg"
                        }))));
}

var make = Governance;

exports.make = make;
/* react Not a pure module */
