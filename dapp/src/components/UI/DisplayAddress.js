// Generated by ReScript, PLEASE EDIT WITH CARE

import * as React from "react";

function DisplayAddress(Props) {
  var address = Props.address;
  return React.createElement(React.Fragment, undefined, address.slice(0, 5) + ".." + address.slice(address.length - 3 | 0, address.length));
}

var make = DisplayAddress;

export {
  make ,
  
}
/* react Not a pure module */
