// Generated by ReScript, PLEASE EDIT WITH CARE

import * as React from "react";

function Button(Props) {
  var onClick = Props.onClick;
  var children = Props.children;
  var variantOpt = Props.variant;
  var disabledOpt = Props.disabled;
  var variant = variantOpt !== undefined ? variantOpt : "small";
  var disabled = disabledOpt !== undefined ? disabledOpt : false;
  var outerContainerClass = "float-button-outer-container " + (
    variant === "tiny" ? "float-button-outer-container-tiny" : ""
  );
  var containerClass = "float-button-container " + (
    variant === "small" ? "float-button-container-small" : ""
  ) + " " + (
    variant === "tiny" ? "float-button-container-tiny" : ""
  );
  var buttonClass = "float-button " + (
    variant === "small" ? "float-button-small" : ""
  ) + " " + (
    variant === "tiny" ? "float-button-tiny" : ""
  );
  return React.createElement("div", {
              className: outerContainerClass
            }, React.createElement("div", {
                  className: containerClass
                }, React.createElement("button", {
                      className: buttonClass + (
                        disabled ? " transform -translate-x-0.5 -translate-y-0.5 bg-gray-300" : ""
                      ),
                      disabled: disabled,
                      onClick: onClick
                    }, children)));
}

var make = Button;

export {
  make ,
  
}
/* react Not a pure module */
