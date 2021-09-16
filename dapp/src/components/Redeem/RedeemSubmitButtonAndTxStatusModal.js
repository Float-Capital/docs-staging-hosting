// Generated by ReScript, PLEASE EDIT WITH CARE
'use strict';

var Misc = require("../../libraries/Misc.js");
var Tick = require("../UI/Base/Tick.js");
var Curry = require("rescript/lib/js/curry.js");
var React = require("react");
var Button = require("../UI/Base/Button.js");
var Config = require("../../config/Config.js");
var Ethers = require("../../ethereum/Ethers.js");
var Loader = require("../UI/Base/Loader.js");
var Withdraw = require("../Withdraw/Withdraw.js");
var DataHooks = require("../../data/DataHooks.js");
var PendingBar = require("../UI/Base/PendingBar.js");
var Refetchers = require("../../libraries/Refetchers.js");
var RootProvider = require("../../libraries/RootProvider.js");
var ModalProvider = require("../../libraries/ModalProvider.js");
var ViewProfileButton = require("../UI/ViewProfileButton.js");
var MessageUsOnDiscord = require("../Ethereum/MessageUsOnDiscord.js");
var ViewOnBlockExplorer = require("../Ethereum/ViewOnBlockExplorer.js");

function RedeemSubmitButtonAndTxStatusModal$ConfirmedTransactionModal(Props) {
  var marketIndex = Props.marketIndex;
  var txStateWithdraw = Props.txStateWithdraw;
  var contractExecutionHandlerWithdraw = Props.contractExecutionHandlerWithdraw;
  var user = RootProvider.useCurrentUserExn(undefined);
  var userId = Ethers.Utils.ethAdrToLowerStr(user);
  var usersPendingRedeemsQuery = DataHooks.useUsersPendingRedeems(userId);
  var match = React.useState(function () {
        return 0;
      });
  var refetchAttempt = match[0];
  Refetchers.useRefetchPendingRedeems(userId, refetchAttempt);
  Refetchers.useRefetchConfirmedRedeems(userId, refetchAttempt);
  var tmp;
  tmp = typeof usersPendingRedeemsQuery === "number" ? React.createElement(Loader.Tiny.make, {}) : (
      usersPendingRedeemsQuery.TAG === /* GraphError */0 ? React.createElement("p", undefined, usersPendingRedeemsQuery._0) : (
          usersPendingRedeemsQuery._0.length === 0 ? React.createElement(Withdraw.make, {
                  marketIndex: marketIndex,
                  txState: txStateWithdraw,
                  contractExecutionHandler: contractExecutionHandlerWithdraw
                }) : React.createElement(PendingBar.make, {
                  marketIndex: marketIndex,
                  refetchCallback: match[1],
                  showBlurb: false
                })
        )
    );
  return React.createElement("div", {
              className: "text-center m-3"
            }, React.createElement(Tick.make, {}), React.createElement("p", undefined, "Transaction complete 🎉"), React.createElement("p", {
                  className: "text-xxs text-gray-700"
                }, "You can withdraw your " + Config.paymentTokenName + " on the next oracle price update"), tmp, React.createElement(ViewProfileButton.make, {}));
}

var ConfirmedTransactionModal = {
  make: RedeemSubmitButtonAndTxStatusModal$ConfirmedTransactionModal
};

function useRedeemModal(txStateRedeem, marketIndex, txStateWithdraw, contractExecutionHandlerWithdraw) {
  var match = ModalProvider.useModalDisplay(undefined);
  var hideModal = match.hideModal;
  var showModal = match.showModal;
  React.useEffect((function () {
          if (typeof txStateRedeem === "number") {
            if (txStateRedeem === /* UnInitialised */0) {
              Curry._1(hideModal, undefined);
            } else {
              Curry._1(showModal, React.createElement("div", {
                        className: "text-center m-3"
                      }, React.createElement(Loader.Ellipses.make, {}), React.createElement("h1", undefined, "Confirm the transaction to redeem " + Config.paymentTokenName)));
            }
          } else {
            switch (txStateRedeem.TAG | 0) {
              case /* SignedAndSubmitted */0 :
                  Curry._1(showModal, React.createElement("div", {
                            className: "text-center m-3"
                          }, React.createElement("div", {
                                className: "m-2"
                              }, React.createElement(Loader.Mini.make, {})), React.createElement("p", undefined, "Redeem transaction pending... "), React.createElement("p", {
                                className: "text-xxs text-yellow-600"
                              }, "⚡ Redeeming your position requires a second withdraw transaction once the oracle price has updated ⚡"), React.createElement(ViewOnBlockExplorer.make, {
                                txHash: txStateRedeem._0
                              })));
                  break;
              case /* Declined */1 :
                  Curry._1(showModal, React.createElement("div", {
                            className: "text-center m-3"
                          }, React.createElement("p", undefined, "The transaction was rejected by your wallet"), React.createElement(MessageUsOnDiscord.make, {})));
                  break;
              case /* Complete */2 :
                  Curry._1(showModal, React.createElement("div", undefined, React.createElement(Misc.Time.DelayedDisplay.make, {
                                delay: 500,
                                children: React.createElement(RedeemSubmitButtonAndTxStatusModal$ConfirmedTransactionModal, {
                                      marketIndex: marketIndex,
                                      txStateWithdraw: txStateWithdraw,
                                      contractExecutionHandlerWithdraw: contractExecutionHandlerWithdraw
                                    })
                              })));
                  break;
              case /* Failed */3 :
                  Curry._1(showModal, React.createElement("div", {
                            className: "text-center m-3"
                          }, React.createElement("h1", undefined, "The transaction failed."), React.createElement(ViewOnBlockExplorer.make, {
                                txHash: txStateRedeem._0
                              }), React.createElement(MessageUsOnDiscord.make, {})));
                  break;
              
            }
          }
          
        }), [txStateRedeem]);
  
}

function RedeemSubmitButtonAndTxStatusModal(Props) {
  var txStateRedeem = Props.txStateRedeem;
  var resetFormButton = Props.resetFormButton;
  var buttonText = Props.buttonText;
  var buttonDisabled = Props.buttonDisabled;
  if (typeof txStateRedeem !== "number") {
    switch (txStateRedeem.TAG | 0) {
      case /* Declined */1 :
      case /* Complete */2 :
      case /* Failed */3 :
          return Curry._1(resetFormButton, undefined);
      default:
        
    }
  }
  return React.createElement(Button.make, {
              onClick: (function (param) {
                  
                }),
              children: buttonText,
              disabled: buttonDisabled
            });
}

var make = RedeemSubmitButtonAndTxStatusModal;

exports.ConfirmedTransactionModal = ConfirmedTransactionModal;
exports.useRedeemModal = useRedeemModal;
exports.make = make;
/* Misc Not a pure module */
