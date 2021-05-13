// Generated by ReScript, PLEASE EDIT WITH CARE
'use strict';

var React = require("react");
var CONSTANTS = require("../../../CONSTANTS.js");
var MiniLoader = require("../MiniLoader.js");

function isHotAPY(apy) {
  return apy > CONSTANTS.hotAPYThreshold;
}

function mapVal(apy) {
  return (apy * 100).toFixed(2) + "%" + (
          apy > CONSTANTS.hotAPYThreshold ? "🔥" : ""
        );
}

function StakeCardSide(Props) {
  var orderPostion = Props.orderPostion;
  var orderPostionMobile = Props.orderPostionMobile;
  var marketName = Props.marketName;
  var isLong = Props.isLong;
  var apy = Props.apy;
  var floatApy = Props.floatApy;
  var tmp;
  tmp = typeof apy === "number" ? React.createElement(MiniLoader.make, {}) : (
      apy.TAG === /* Loaded */0 ? React.createElement("p", {
              className: "text-xl tracking-widest font-alphbeta"
            }, mapVal(apy._0)) : React.createElement(MiniLoader.make, {})
    );
  return React.createElement("div", {
              className: "order-" + String(orderPostionMobile) + " md:order-" + String(orderPostion) + " w-1/2 md:w-1/4 flex items-center flex grow flex-wrap flex-col"
            }, React.createElement("h2", {
                  className: "font-bold text-sm"
                }, marketName, React.createElement("span", {
                      className: "text-xs"
                    }, isLong ? "↗️" : "↘️")), React.createElement("div", {
                  className: "flex flex-col items-center justify-center pt-0 mt-auto"
                }, React.createElement("h3", {
                      className: "text-xs mt-2"
                    }, React.createElement("span", {
                          className: "font-bold"
                        }, isLong ? "LONG" : "SHORT"), " FLOAT rewards"), React.createElement("p", {
                      className: "text-2xl md:text-4xl tracking-widest font-alphbeta"
                    }, mapVal(floatApy))), React.createElement("div", {
                  className: "flex flex-col items-center justify-center pt-0 mt-auto text-gray-600"
                }, React.createElement("h3", {
                      className: "text-xxs mt-1"
                    }, React.createElement("span", {
                          className: "font-bold"
                        }, isLong ? "LONG" : "SHORT"), " APY"), tmp));
}

var make = StakeCardSide;

exports.isHotAPY = isHotAPY;
exports.mapVal = mapVal;
exports.make = make;
/* react Not a pure module */
