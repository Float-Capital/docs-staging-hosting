// Generated by ReScript, PLEASE EDIT WITH CARE
'use strict';

var Curry = require("rescript/lib/js/curry.js");
var React = require("react");

var activeSelectionStyle = "bg-primary text-white  shadow-lg";

function inactiveSelectionStyle(disabled) {
  return "bg-white text-primary shadow-inner " + (
          disabled ? "" : "hover:bg-primary hover:bg-opacity-75 hover:text-white hover:shadow-md"
        ) + " ";
}

var transitionStyling = "transition-all duration-500 ";

function onBlurStyling(disabled) {
  if (disabled) {
    return "cursor-not-allowed";
  } else {
    return "";
  }
}

function LongOrShortSelect(Props) {
  var isLong = Props.isLong;
  var selectPosition = Props.selectPosition;
  var disabled = Props.disabled;
  return React.createElement("div", {
              className: "flex flex-row justify-between w-full border-2  border-primary uppercase rounded-full bg-white text-center"
            }, React.createElement("div", {
                  className: "cursor-pointer w-full py-2 rounded-l-full " + (
                    isLong ? activeSelectionStyle : inactiveSelectionStyle(disabled)
                  ) + " " + transitionStyling + " " + (
                    disabled ? "cursor-not-allowed" : ""
                  ),
                  onClick: (function (param) {
                      if (!disabled) {
                        return Curry._1(selectPosition, "long");
                      }
                      
                    })
                }, "Long 🐮"), React.createElement("div", {
                  className: "cursor-pointer w-full border-l-2 rounded-r-full border-primary hover:border-white py-2 " + (
                    isLong ? inactiveSelectionStyle(disabled) : activeSelectionStyle
                  ) + " " + transitionStyling + " " + (
                    disabled ? "cursor-not-allowed" : ""
                  ),
                  onClick: (function (param) {
                      if (!disabled) {
                        return Curry._1(selectPosition, "short");
                      }
                      
                    })
                }, "Short 🐻"));
}

var make = LongOrShortSelect;

exports.activeSelectionStyle = activeSelectionStyle;
exports.inactiveSelectionStyle = inactiveSelectionStyle;
exports.transitionStyling = transitionStyling;
exports.onBlurStyling = onBlurStyling;
exports.make = make;
/* react Not a pure module */
