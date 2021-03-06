// Generated by ReScript, PLEASE EDIT WITH CARE

import * as React from "react";
import * as Ethers from "ethers";
import * as Belt_Option from "bs-platform/lib/es6/belt_Option.js";
import * as RedeemSynth from "../Testing/Admin/RedeemSynth.js";
import * as ContractHooks from "../Testing/Admin/ContractHooks.js";

function RedeemForm(Props) {
  var market = Props.market;
  console.log([
        "Market",
        market
      ]);
  var match = ContractHooks.useErc20BalanceRefresh(market.syntheticShort.tokenAddress);
  var match$1 = ContractHooks.useErc20BalanceRefresh(market.syntheticLong.tokenAddress);
  var hasShortBalance = Belt_Option.mapWithDefault(match.data, false, (function (balance) {
          return balance.gt(Ethers.BigNumber.from(0));
        }));
  var hasLongBalance = Belt_Option.mapWithDefault(match$1.data, false, (function (balance) {
          return balance.gt(Ethers.BigNumber.from(0));
        }));
  if (hasShortBalance) {
    if (hasLongBalance) {
      return React.createElement(React.Fragment, undefined, React.createElement(RedeemSynth.make, {
                      isLong: true,
                      marketIndex: market.marketIndex
                    }), React.createElement(RedeemSynth.make, {
                      isLong: false,
                      marketIndex: market.marketIndex
                    }));
    } else {
      return React.createElement(RedeemSynth.make, {
                  isLong: false,
                  marketIndex: market.marketIndex
                });
    }
  } else if (hasLongBalance) {
    return React.createElement(RedeemSynth.make, {
                isLong: true,
                marketIndex: market.marketIndex
              });
  } else {
    return "You don't have any tokens to redeem";
  }
}

var make = RedeemForm;

export {
  make ,
  
}
/* react Not a pure module */
