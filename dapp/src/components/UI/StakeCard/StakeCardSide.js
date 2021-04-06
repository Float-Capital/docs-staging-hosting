// Generated by ReScript, PLEASE EDIT WITH CARE

import * as React from "react";
import * as MiniLoader from "../MiniLoader.js";

function isHotAPY(apy) {
  return apy > 0.15;
}

function mapVal(apy) {
  return (apy * 100).toFixed(2) + "%" + (
          apy > 0.15 ? "🔥" : ""
        );
}

function StakeCardSide(Props) {
  var marketName = Props.marketName;
  var isLong = Props.isLong;
  var apy = Props.apy;
  var floatApy = Props.floatApy;
  var tmp;
  tmp = typeof apy === "number" ? React.createElement(MiniLoader.make, {}) : (
      apy.TAG === /* Loaded */0 ? React.createElement("div", {
              className: "text-2xl tracking-widest font-alphbeta"
            }, mapVal(apy._0)) : React.createElement(MiniLoader.make, {})
    );
  return React.createElement("div", {
              className: "w-1/4 flex items-center flex-grow text-sm flex-col"
            }, React.createElement("h2", {
                  className: "font-bold text-sm"
                }, marketName, React.createElement("span", {
                      className: "text-xs"
                    }, isLong ? "↗️" : "↘️")), React.createElement("div", {
                  className: "flex flex-col items-center justify-center pt-0 mt-auto"
                }, React.createElement("h3", {
                      className: "text-xs mt-1"
                    }, React.createElement("span", {
                          className: "font-bold"
                        }, isLong ? "LONG" : "SHORT"), " APY"), tmp), React.createElement("div", {
                  className: "flex flex-col items-center justify-center pt-0 mt-auto"
                }, React.createElement("h3", {
                      className: "text-xs mt-1"
                    }, React.createElement("span", {
                          className: "font-bold"
                        }, isLong ? "LONG" : "SHORT"), " FLOAT rewards"), React.createElement("div", {
                      className: "text-2xl tracking-widest font-alphbeta my-3"
                    }, mapVal(floatApy))));
}

var make = StakeCardSide;

export {
  isHotAPY ,
  mapVal ,
  make ,
  
}
/* react Not a pure module */
