// Generated by ReScript, PLEASE EDIT WITH CARE

import * as React from "react";
import * as Button from "./Button.js";
import * as Ethers from "../../ethereum/Ethers.js";
import * as Ethers$1 from "ethers";
import * as CONSTANTS from "../../CONSTANTS.js";
import * as DataHooks from "../../data/DataHooks.js";
import * as Belt_Array from "bs-platform/lib/es6/belt_Array.js";
import * as MiniLoader from "./MiniLoader.js";
import * as FormatMoney from "./FormatMoney.js";
import * as Router from "next/router";

function UserUI$UserContainer(Props) {
  var children = Props.children;
  return React.createElement("div", {
              className: "min-w-3/4 flex flex-col items-center"
            }, children);
}

var UserContainer = {
  make: UserUI$UserContainer
};

function UserUI$UserBanner(Props) {
  return React.createElement("div", {
              className: "p-5 mt-7 flex bg-white bg-opacity-75 rounded-lg shadow-lg"
            }, React.createElement("span", {
                  className: "text-sm"
                }, "💲 BUSD Balance: $1234.todo"), React.createElement("span", {
                  className: "text-sm ml-20"
                }, "🏦 Total Value in Float: $1234.todo"));
}

var UserBanner = {
  make: UserUI$UserBanner
};

function UserUI$UserColumnContainer(Props) {
  var children = Props.children;
  return React.createElement("div", {
              className: "w-full flex mt-1"
            }, children);
}

var UserColumnContainer = {
  make: UserUI$UserColumnContainer
};

function UserUI$UserColumn(Props) {
  var children = Props.children;
  return React.createElement("div", {
              className: "m-4 w-1/3"
            }, children);
}

var UserColumn = {
  make: UserUI$UserColumn
};

function UserUI$UserColumnCard(Props) {
  var children = Props.children;
  return React.createElement("div", {
              className: "bg-white w-full bg-opacity-75 rounded-lg shadow-lg p-4"
            }, children);
}

var UserColumnCard = {
  make: UserUI$UserColumnCard
};

function UserUI$UserColumnHeader(Props) {
  var children = Props.children;
  var subheaderOpt = Props.subheader;
  var subheader = subheaderOpt !== undefined ? subheaderOpt : false;
  return React.createElement("h1", {
              className: "text-center " + (
                subheader ? "text-base" : "text-lg"
              ) + " font-alphbeta mb-4 mt-2"
            }, children);
}

var UserColumnHeader = {
  make: UserUI$UserColumnHeader
};

function UserUI$UserProfileHeader(Props) {
  var level = Ethers$1.BigNumber.from(1);
  return React.createElement("div", {
              className: "w-full flex flex-row justify-around"
            }, React.createElement("div", {
                  className: "w-24 h-24 rounded-full border-2 border-light-purple flex items-center justify-center"
                }, React.createElement("img", {
                      className: "inline h-10",
                      src: "/img/mario.png"
                    })), React.createElement("div", {
                  className: "flex flex-col text-center justify-center"
                }, React.createElement("div", undefined, "moose-code"), React.createElement("div", undefined, "Lvl. " + level.toString())));
}

var UserProfileHeader = {
  make: UserUI$UserProfileHeader
};

function UserUI$UserColumnTextList(Props) {
  var children = Props.children;
  return React.createElement("div", {
              className: "flex flex-col mt-3"
            }, children);
}

var UserColumnTextList = {
  make: UserUI$UserColumnTextList
};

function UserUI$UserColumnTextCenter(Props) {
  var children = Props.children;
  return React.createElement("div", {
              className: "flex flex-col items-center"
            }, children);
}

var UserColumnTextCenter = {
  make: UserUI$UserColumnTextCenter
};

function UserUI$UserColumnText(Props) {
  var icon = Props.icon;
  var head = Props.head;
  var bodyOpt = Props.body;
  var body = bodyOpt !== undefined ? bodyOpt : "";
  return React.createElement("div", {
              className: "ml-4 mb-1"
            }, icon !== undefined ? React.createElement("img", {
                    className: "inline mr-1 h-5",
                    src: icon
                  }) : "", React.createElement("span", {
                  className: "text-sm"
                }, head + ": "), body);
}

var UserColumnText = {
  make: UserUI$UserColumnText
};

function UserUI$UserMarketBox(Props) {
  var name = Props.name;
  var isLong = Props.isLong;
  var tokens = Props.tokens;
  var value = Props.value;
  var children = Props.children;
  return React.createElement("div", {
              className: "flex w-11/12 mx-auto p-2 mb-2 border-2 border-light-purple rounded-lg z-10 shadow"
            }, React.createElement("div", {
                  className: "w-1/3 text-sm self-center"
                }, name, React.createElement("br", {
                      className: "mt-1"
                    }), isLong ? "Long ↗️" : "Short ↘️"), React.createElement("div", {
                  className: "w-1/3 text-sm mx-2 text-center self-center"
                }, React.createElement("span", {
                      className: "text-sm"
                    }, tokens), React.createElement("span", {
                      className: "text-xs"
                    }, "tkns"), React.createElement("br", {
                      className: "mt-1"
                    }), React.createElement("span", {
                      className: "text-xs"
                    }, "~$".concat(value))), React.createElement("div", {
                  className: "w-1/3 self-center"
                }, children));
}

var UserMarketBox = {
  make: UserUI$UserMarketBox
};

function UserUI$UserMarketStakeOrRedeem(Props) {
  var synthAddress = Props.synthAddress;
  var router = Router.useRouter();
  var stake = function (param) {
    router.push("/stake?tokenAddress=" + Ethers.Utils.ethAdrToLowerStr(synthAddress));
    
  };
  var redeem = function (param) {
    router.push("/redeem?tokenAddress=" + Ethers.Utils.ethAdrToLowerStr(synthAddress));
    
  };
  return React.createElement("div", {
              className: "flex flex-col"
            }, React.createElement(Button.make, {
                  onClick: stake,
                  children: "stake",
                  variant: "tiny"
                }), React.createElement(Button.make, {
                  onClick: redeem,
                  children: "redeem",
                  variant: "tiny"
                }));
}

var UserMarketStakeOrRedeem = {
  make: UserUI$UserMarketStakeOrRedeem
};

function UserUI$UserMarketUnstake(Props) {
  var synthAddress = Props.synthAddress;
  var router = Router.useRouter();
  var unstake = function (param) {
    router.push("/stake?tokenAddress=" + Ethers.Utils.ethAdrToLowerStr(synthAddress));
    
  };
  return React.createElement("div", {
              className: "flex flex-col"
            }, React.createElement("span", {
                  className: "text-xxs self-center"
                }, React.createElement("i", undefined, "4 days ago")), React.createElement(Button.make, {
                  onClick: unstake,
                  children: "unstake",
                  variant: "tiny"
                }));
}

var UserMarketUnstake = {
  make: UserUI$UserMarketUnstake
};

function UserUI$UserStakesCard(Props) {
  var stakes = Props.stakes;
  var totalValue = {
    contents: CONSTANTS.zeroBN
  };
  var stakeBoxes = stakes.map(function (stake, i) {
        var key = "user-stakes-" + String(i);
        var syntheticToken = stake.currentStake.syntheticToken;
        var addr = Ethers$1.utils.getAddress(syntheticToken.id);
        var name = syntheticToken.syntheticMarket.symbol;
        var tokens = FormatMoney.formatEther(undefined, syntheticToken.totalStaked);
        var isLong = syntheticToken.tokenType === "Long";
        var price = syntheticToken.latestPrice.price.price;
        var value = stake.currentStake.syntheticToken.totalStaked.mul(price).div(CONSTANTS.tenToThe18);
        totalValue.contents = totalValue.contents.add(value);
        return React.createElement(UserUI$UserMarketBox, {
                    name: name,
                    isLong: isLong,
                    tokens: tokens,
                    value: FormatMoney.formatEther(undefined, value),
                    children: React.createElement(UserUI$UserMarketUnstake, {
                          synthAddress: addr
                        }),
                    key: key
                  });
      });
  return React.createElement(UserUI$UserColumnCard, {
              children: null
            }, React.createElement(UserUI$UserColumnHeader, {
                  children: "Staking"
                }), React.createElement(UserUI$UserColumnTextCenter, {
                  children: React.createElement(UserUI$UserColumnText, {
                        head: "💰 Staked value",
                        body: "$" + FormatMoney.formatEther(undefined, totalValue.contents)
                      })
                }), React.createElement("br", undefined), stakeBoxes);
}

var UserStakesCard = {
  make: UserUI$UserStakesCard
};

function UserUI$UserFloatCard(Props) {
  var userId = Props.userId;
  var stakes = Props.stakes;
  var synthTokens = Belt_Array.map(stakes, (function (stake) {
          return stake.currentStake.syntheticToken.id;
        }));
  var router = Router.useRouter();
  var claimFloat = function (param) {
    router.push("/stake");
    
  };
  var floatBalances = DataHooks.useFloatBalancesForUser(userId);
  var claimableFloat = DataHooks.useTotalClaimableFloatForUser(userId, synthTokens);
  var msg = DataHooks.liftGraphResponse2(floatBalances, claimableFloat);
  var tmp;
  if (typeof msg === "number") {
    tmp = React.createElement(MiniLoader.make, {});
  } else if (msg.TAG === /* GraphError */0) {
    tmp = msg._0;
  } else {
    var match = msg._0;
    var match$1 = match[1];
    var floatBalances$1 = match[0];
    var floatBalance = FormatMoney.formatEther(6, floatBalances$1.floatBalance);
    var floatMinted = FormatMoney.formatEther(6, floatBalances$1.floatMinted);
    var floatAccrued = FormatMoney.formatEther(6, match$1[0].add(match$1[1]));
    tmp = React.createElement("div", {
          className: "w-11/12 mx-auto mb-2 border-2 border-light-purple rounded-lg z-10 shadow"
        }, React.createElement(UserUI$UserColumnTextList, {
              children: null
            }, React.createElement(UserUI$UserColumnText, {
                  head: "float accruing",
                  body: floatAccrued
                }), React.createElement(UserUI$UserColumnText, {
                  head: "float balance",
                  body: floatBalance
                }), React.createElement(UserUI$UserColumnText, {
                  head: "float minted",
                  body: floatMinted
                })), React.createElement("div", {
              className: "flex justify-around flex-row my-1"
            }, "🌊", React.createElement(Button.make, {
                  onClick: claimFloat,
                  children: "claim float",
                  variant: "tiny"
                }), "🌊"));
  }
  return React.createElement(UserUI$UserColumnCard, {
              children: null
            }, React.createElement(UserUI$UserColumnHeader, {
                  children: "Float rewards 🔥"
                }), tmp);
}

var UserFloatCard = {
  make: UserUI$UserFloatCard
};

export {
  UserContainer ,
  UserBanner ,
  UserColumnContainer ,
  UserColumn ,
  UserColumnCard ,
  UserColumnHeader ,
  UserProfileHeader ,
  UserColumnTextList ,
  UserColumnTextCenter ,
  UserColumnText ,
  UserMarketBox ,
  UserMarketStakeOrRedeem ,
  UserMarketUnstake ,
  UserStakesCard ,
  UserFloatCard ,
  
}
/* react Not a pure module */
