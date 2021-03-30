// Generated by ReScript, PLEASE EDIT WITH CARE

import * as React from "react";

function MarketBar(Props) {
  var percentStrLong = Props.percentStrLong;
  var percentStrShort = Props.percentStrShort;
  return React.createElement("div", {
              className: "relative w-full h-6 my-1"
            }, React.createElement("div", {
                  className: "w-full flex h-8 justify-between items-center absolute bottom-0 z-10"
                }, React.createElement("div", {
                      className: "font-bold text-xs ml-2 text-gray-100"
                    }, percentStrLong + "%", React.createElement("span", {
                          className: "text-lg"
                        }, " 🐮")), React.createElement("div", {
                      className: "font-bold text-xs mr-2 text-gray-100"
                    }, React.createElement("span", {
                          className: "text-lg"
                        }, "🐻 "), percentStrShort + "% ")), React.createElement("div", {
                  className: "w-full flex h-8 absolute bottom-0 z-0"
                }, React.createElement("div", {
                      className: "h-8 bg-blue-400",
                      style: {
                        width: percentStrLong + "%"
                      }
                    }), React.createElement("div", {
                      className: "h-8 bg-blue-300",
                      style: {
                        width: percentStrShort + "%"
                      }
                    })));
}

var make = MarketBar;

export {
  make ,
  
}
/* react Not a pure module */
