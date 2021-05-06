// Generated by ReScript, PLEASE EDIT WITH CARE
'use strict';

var Tick = require("../UI/Tick.js");
var Curry = require("rescript/lib/js/curry.js");
var Modal = require("../UI/Modal.js");
var React = require("react");
var MiniLoader = require("../UI/MiniLoader.js");
var EllipsesLoader = require("../UI/EllipsesLoader.js");
var MessageUsOnDiscord = require("../Ethereum/MessageUsOnDiscord.js");
var ViewOnBlockExplorer = require("../Ethereum/ViewOnBlockExplorer.js");

function StakeTxStatusModal(Props) {
  var txStateStake = Props.txStateStake;
  var resetFormButton = Props.resetFormButton;
  var tokenToStake = Props.tokenToStake;
  if (typeof txStateStake === "number") {
    if (txStateStake === /* UnInitialised */0) {
      return null;
    } else {
      return React.createElement(Modal.make, {
                  id: "stake-1",
                  children: React.createElement("div", {
                        className: "text-center m-3"
                      }, React.createElement(EllipsesLoader.make, {}), React.createElement("h1", undefined, "Confirm the transaction to stake " + tokenToStake))
                });
    }
  }
  switch (txStateStake.TAG | 0) {
    case /* SignedAndSubmitted */0 :
        return React.createElement(Modal.make, {
                    id: "stake-3",
                    children: React.createElement("div", {
                          className: "text-center m-3"
                        }, React.createElement("div", {
                              className: "m-2"
                            }, React.createElement(MiniLoader.make, {})), React.createElement("p", undefined, "Staking transaction pending... "), React.createElement(ViewOnBlockExplorer.make, {
                              txHash: txStateStake._0
                            }))
                  });
    case /* Declined */1 :
        return React.createElement(Modal.make, {
                    id: "stake-5",
                    children: React.createElement("div", {
                          className: "text-center m-3"
                        }, React.createElement("p", undefined, "The transaction was rejected by your wallet"), React.createElement(MessageUsOnDiscord.make, {}), Curry._1(resetFormButton, undefined))
                  });
    case /* Complete */2 :
        return React.createElement(React.Fragment, undefined, React.createElement(Modal.make, {
                        id: "stake-4",
                        children: null
                      }, React.createElement("div", {
                            className: "text-center m-3"
                          }, React.createElement(Tick.make, {}), React.createElement("p", undefined, "Transaction complete 🎉")), Curry._1(resetFormButton, undefined)));
    case /* Failed */3 :
        return React.createElement(Modal.make, {
                    id: "stake-6",
                    children: React.createElement("div", {
                          className: "text-center m-3"
                        }, React.createElement("h1", undefined, "The transaction failed."), React.createElement(ViewOnBlockExplorer.make, {
                              txHash: txStateStake._0
                            }), React.createElement(MessageUsOnDiscord.make, {}), Curry._1(resetFormButton, undefined))
                  });
    
  }
}

var make = StakeTxStatusModal;

exports.make = make;
/* Tick Not a pure module */
