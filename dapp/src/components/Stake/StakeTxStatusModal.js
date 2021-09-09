// Generated by ReScript, PLEASE EDIT WITH CARE
'use strict';

var Tick = require("../UI/Base/Tick.js");
var Curry = require("rescript/lib/js/curry.js");
var React = require("react");
var Loader = require("../UI/Base/Loader.js");
var Js_math = require("rescript/lib/js/js_math.js");
var TweetButton = require("../UI/TweetButton.js");
var ModalProvider = require("../../libraries/ModalProvider.js");
var ViewProfileButton = require("../UI/ViewProfileButton.js");
var MessageUsOnDiscord = require("../Ethereum/MessageUsOnDiscord.js");
var ViewOnBlockExplorer = require("../Ethereum/ViewOnBlockExplorer.js");

function useStakeTxModal(txStateStake, tokenToStake) {
  var stakeTweetMessages = [
    "Hey Siri, play “Celebrate” by Kool and The Gang 🥳, because I just staked my @float_capital synthetic assets to earn FLOAT tokens! 🌊",
    "Stake that @float_capital! 🌊 I just staked my synthetic assets to earn FLOAT tokens! 🥳",
    "Make it rain @float_capital! 💸 I just staked my synthetic assets to earn FLOAT tokens! 🥳",
    "Stake that, all on the floor! Stake that, give me some more! 🎶 I just staked my synthetic assets to earn FLOAT tokens! @float_capital 🌊",
    "Float like a butterfly, stake like a bee!🐝 I just staked to earn FLOAT tokens @float_capital 🌊"
  ];
  var match = ModalProvider.useModalDisplay(undefined);
  var hideModal = match.hideModal;
  var showModal = match.showModal;
  var randomStakeTweetMessage = stakeTweetMessages[Js_math.random_int(0, stakeTweetMessages.length)];
  React.useEffect((function () {
          if (typeof txStateStake === "number") {
            if (txStateStake === /* UnInitialised */0) {
              Curry._1(hideModal, undefined);
            } else {
              Curry._1(showModal, React.createElement("div", {
                        className: "text-center m-3"
                      }, React.createElement(Loader.Ellipses.make, {}), React.createElement("h1", undefined, "Confirm the transaction to stake " + tokenToStake)));
            }
          } else {
            switch (txStateStake.TAG | 0) {
              case /* SignedAndSubmitted */0 :
                  Curry._1(showModal, React.createElement("div", {
                            className: "text-center m-3"
                          }, React.createElement("div", {
                                className: "m-2"
                              }, React.createElement(Loader.Mini.make, {})), React.createElement("p", undefined, "Staking transaction pending... "), React.createElement(ViewOnBlockExplorer.make, {
                                txHash: txStateStake._0
                              })));
                  break;
              case /* Declined */1 :
                  Curry._1(showModal, React.createElement("div", {
                            className: "text-center m-3"
                          }, React.createElement("p", undefined, "The transaction was rejected by your wallet"), React.createElement(MessageUsOnDiscord.make, {})));
                  break;
              case /* Complete */2 :
                  Curry._1(showModal, React.createElement(React.Fragment, undefined, React.createElement("div", {
                                className: "text-center m-3"
                              }, React.createElement(Tick.make, {}), React.createElement("p", undefined, "Transaction complete 🎉"), React.createElement(TweetButton.make, {
                                    message: randomStakeTweetMessage
                                  }), React.createElement(ViewProfileButton.make, {}))));
                  break;
              case /* Failed */3 :
                  Curry._1(showModal, React.createElement("div", {
                            className: "text-center m-3"
                          }, React.createElement("h1", undefined, "The transaction failed."), React.createElement(ViewOnBlockExplorer.make, {
                                txHash: txStateStake._0
                              }), React.createElement(MessageUsOnDiscord.make, {})));
                  break;
              
            }
          }
          
        }), [txStateStake]);
  
}

exports.useStakeTxModal = useStakeTxModal;
/* Tick Not a pure module */
