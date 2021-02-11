// Generated by ReScript, PLEASE EDIT WITH CARE

import * as Curry from "bs-platform/lib/es6/curry.js";
import * as React from "react";
import * as Ethers from "ethers";
import * as MintLong from "./components/Admin/MintLong.js";
import * as MintShort from "./components/Admin/MintShort.js";
import * as ApproveDai from "./components/Admin/ApproveDai.js";
import * as RedeemLong from "./components/Admin/RedeemLong.js";
import * as RedeemShort from "./components/Admin/RedeemShort.js";
import * as Router from "next/router";
import * as AccessControl from "./components/AccessControl.js";
import * as UpdateSystemState from "./components/Admin/UpdateSystemState.js";

var shortTokenAddress = Ethers.utils.getAddress("0x096c8301e153037df723c23e2de113941cb973ef");

var longTokenAddress = Ethers.utils.getAddress("0x096c8301e153037df723c23e2de113941cb973ef");

function Dapp$Dapp(Props) {
  var router = Router.useRouter();
  var match = React.useState(function () {
        return true;
      });
  var setIsMint = match[1];
  var isMint = match[0];
  return React.createElement(AccessControl.make, {
              children: null,
              alternateComponent: React.createElement("h1", {
                    onClick: (function (param) {
                        router.push("/login?nextPath=/dashboard");
                        
                      })
                  }, "login to view this")
            }, React.createElement("section", undefined, React.createElement("div", undefined, React.createElement("div", {
                          className: "trade-form"
                        }, React.createElement("h2", undefined, "FTSE 100"), React.createElement("select", {
                              className: "trade-select",
                              name: "longshort"
                            }, React.createElement("option", {
                                  value: "long"
                                }, "Long 🐮"), React.createElement("option", {
                                  value: "short"
                                }, "Short 🐻")), isMint ? React.createElement("input", {
                                className: "trade-input",
                                placeholder: "mint"
                              }) : React.createElement("input", {
                                className: "trade-input",
                                placeholder: "redeem"
                              }), React.createElement("div", {
                              className: "trade-switch",
                              onClick: (function (param) {
                                  return Curry._1(setIsMint, (function (param) {
                                                return !isMint;
                                              }));
                                })
                            }, "↑↓"), isMint ? React.createElement("input", {
                                className: "trade-input",
                                placeholder: "redeem"
                              }) : React.createElement("input", {
                                className: "trade-input",
                                placeholder: "mint"
                              }), React.createElement("button", {
                              className: "trade-action"
                            }, "OPEN POSITION"))), React.createElement("br", undefined), React.createElement("br", undefined), React.createElement("br", undefined), React.createElement("br", undefined), React.createElement("br", undefined), React.createElement("br", undefined), React.createElement("br", undefined), React.createElement("br", undefined), React.createElement("h1", undefined, "Dapp"), React.createElement(ApproveDai.make, {}), React.createElement("hr", undefined), React.createElement(MintLong.make, {}), React.createElement("hr", undefined), React.createElement(RedeemLong.make, {
                      longTokenAddress: longTokenAddress
                    }), React.createElement("hr", undefined), React.createElement(MintShort.make, {
                      shortTokenAddress: shortTokenAddress
                    }), React.createElement("hr", undefined), React.createElement(RedeemShort.make, {
                      shortTokenAddress: shortTokenAddress
                    }), React.createElement("hr", undefined)), React.createElement(UpdateSystemState.make, {}));
}

var Dapp = {
  make: Dapp$Dapp
};

function $$default(param) {
  return React.createElement(Dapp$Dapp, {});
}

export {
  shortTokenAddress ,
  longTokenAddress ,
  Dapp ,
  $$default ,
  $$default as default,
  
}
/* shortTokenAddress Not a pure module */
