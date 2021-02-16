// Generated by ReScript, PLEASE EDIT WITH CARE

import * as React from "react";

function Button(Props) {
  var onClick = Props.onClick;
  var text = Props.text;
  var variant = Props.variant;
  return React.createElement("div", {
              className: "float-button-outer-container"
            }, React.createElement("div", {
                  className: "float-button-container " + (
                    variant === "small" ? "float-button-container-small" : ""
                  )
                }, React.createElement("button", {
                      className: "float-button " + (
                        variant === "small" ? "float-button-small" : ""
                      ),
                      onClick: onClick
                    }, text)));
}

var make = Button;

export {
  make ,
  
}
/* react Not a pure module */
