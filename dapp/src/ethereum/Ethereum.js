// Generated by ReScript, PLEASE EDIT WITH CARE

import * as Belt_Option from "bs-platform/lib/es6/belt_Option.js";

function isMetamask(ethOpt) {
  return Belt_Option.mapWithDefault(ethOpt, false, (function (e) {
                return Belt_Option.getWithDefault(e.isMetaMask, false);
              }));
}

export {
  isMetamask ,
  
}
/* No side effect */
