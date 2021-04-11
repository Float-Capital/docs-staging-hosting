// Generated by ReScript, PLEASE EDIT WITH CARE

import * as Modal from "../UI/Modal.js";
import * as React from "react";
import * as Config from "../../Config.js";
import * as MiniLoader from "../UI/MiniLoader.js";

function ClaimTxStatusModal(Props) {
  var txState = Props.txState;
  if (typeof txState === "number") {
    switch (txState) {
      case /* UnInitialised */0 :
          return null;
      case /* Created */1 :
          return React.createElement(Modal.make, {
                      id: 1,
                      children: React.createElement("div", {
                            className: "text-center m-3"
                          }, React.createElement("h1", undefined, "Confirm the transaction to claim Float"))
                    });
      case /* Failed */2 :
          return React.createElement(Modal.make, {
                      id: 5,
                      children: React.createElement("div", {
                            className: "text-center m-3"
                          }, React.createElement("h1", undefined, "The transaction failed."), React.createElement("p", undefined, React.createElement("a", {
                                    href: Config.discordInviteLink,
                                    rel: "noopenner noreferer",
                                    target: "_"
                                  }, "Connect with us on discord, if you would like some assistance")))
                    });
      
    }
  } else {
    switch (txState.TAG | 0) {
      case /* SignedAndSubmitted */0 :
          return React.createElement(Modal.make, {
                      id: 2,
                      children: React.createElement("div", {
                            className: "text-center m-3"
                          }, React.createElement(MiniLoader.make, {}), React.createElement("p", undefined, "Claiming transaction pending... "), React.createElement("a", {
                                className: "hover:underline",
                                href: Config.blockExplorer + "tx/" + txState._0,
                                rel: "noopenner noreferer",
                                target: "_"
                              }, React.createElement("p", undefined, "view tx on " + Config.blockExplorerName)))
                    });
      case /* Declined */1 :
          return React.createElement(Modal.make, {
                      id: 4,
                      children: React.createElement("div", {
                            className: "text-center m-3"
                          }, React.createElement("p", undefined, "The transaction was rejected by your wallet"), React.createElement("a", {
                                href: Config.discordInviteLink,
                                rel: "noopenner noreferer",
                                target: "_"
                              }, "Connect with us on discord, if you would like some assistance"))
                    });
      case /* Complete */2 :
          return React.createElement(Modal.make, {
                      id: 3,
                      children: React.createElement("div", {
                            className: "text-center m-3"
                          }, React.createElement("p", undefined, "Transaction complete 🎉"))
                    });
      
    }
  }
}

var make = ClaimTxStatusModal;

export {
  make ,
  
}
/* Modal Not a pure module */
