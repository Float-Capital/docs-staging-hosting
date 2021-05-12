// Generated by ReScript, PLEASE EDIT WITH CARE
'use strict';

var Misc = require("./libraries/Misc.js");
var React = require("react");
var Button = require("./components/UI/Base/Button.js");
var Config = require("./Config.js");
var Ethers = require("./ethereum/Ethers.js");
var Loader = require("./components/UI/Base/Loader.js");
var UserUI = require("./components/UI/UserUI.js");
var Js_dict = require("rescript/lib/js/js_dict.js");
var Masonry = require("./components/UI/Masonry.js");
var CONSTANTS = require("./CONSTANTS.js");
var DataHooks = require("./data/DataHooks.js");
var Link = require("next/link").default;
var Belt_Array = require("rescript/lib/js/belt_Array.js");
var Caml_option = require("rescript/lib/js/caml_option.js");
var Router = require("next/router");
var RootProvider = require("./libraries/RootProvider.js");
var DisplayAddress = require("./components/UI/Base/DisplayAddress.js");
var Format = require("date-fns/format").default;

function User$UserBalancesCard(Props) {
  var userId = Props.userId;
  var usersTokensQuery = DataHooks.useUsersBalances(userId);
  var tmp;
  if (typeof usersTokensQuery === "number") {
    tmp = React.createElement("div", {
          className: "m-auto"
        }, React.createElement(Loader.Mini.make, {}));
  } else if (usersTokensQuery.TAG === /* GraphError */0) {
    tmp = usersTokensQuery._0;
  } else {
    var match = usersTokensQuery._0;
    tmp = React.createElement(React.Fragment, undefined, React.createElement(UserUI.UserColumnTextCenter.make, {
              children: React.createElement(UserUI.UserColumnText.make, {
                    head: "💰 Synth value",
                    body: "$" + Misc.NumberFormat.formatEther(undefined, match.totalBalance)
                  })
            }), React.createElement("br", undefined), Belt_Array.map(Belt_Array.keep(match.balances, (function (param) {
                    return !param.tokenBalance.eq(CONSTANTS.zeroBN);
                  })), (function (param) {
                var isLong = param.isLong;
                var name = param.name;
                var addr = param.addr;
                return React.createElement(UserUI.UserMarketBox.make, {
                            name: name,
                            isLong: isLong,
                            tokens: Misc.NumberFormat.formatEther(undefined, param.tokenBalance),
                            value: Misc.NumberFormat.formatEther(undefined, param.tokensValue),
                            tokenAddress: addr,
                            metamaskMenu: true,
                            symbol: param.symbol,
                            metadata: param.metadata,
                            children: React.createElement(UserUI.UserMarketStakeOrRedeem.make, {
                                  synthAddress: Ethers.Utils.ethAdrToLowerStr(addr),
                                  isLong: isLong
                                }),
                            key: name + "-" + (
                              isLong ? "long" : "short"
                            )
                          });
              })));
  }
  return React.createElement(UserUI.UserColumnCard.make, {
              children: null
            }, React.createElement(UserUI.UserColumnHeader.make, {
                  children: null
                }, "Synthetic assets", React.createElement("img", {
                      className: "inline h-5 ml-2",
                      src: "/img/coin.png"
                    })), tmp);
}

var UserBalancesCard = {
  make: User$UserBalancesCard
};

function getUsersTotalStakeValue(stakes) {
  var totalStakedValue = {
    contents: CONSTANTS.zeroBN
  };
  Belt_Array.forEach(stakes, (function (stake) {
          var syntheticToken = stake.currentStake.syntheticToken;
          var price = syntheticToken.latestPrice.price.price;
          var value = stake.currentStake.amount.mul(price).div(CONSTANTS.tenToThe18);
          totalStakedValue.contents = totalStakedValue.contents.add(value);
          
        }));
  return totalStakedValue;
}

function User$UserTotalInvestedCard(Props) {
  var stakes = Props.stakes;
  var userId = Props.userId;
  var usersTokensQuery = DataHooks.useUsersBalances(userId);
  var totalStakedValue = getUsersTotalStakeValue(stakes);
  var tmp;
  tmp = typeof usersTokensQuery === "number" ? React.createElement("div", {
          className: "m-auto"
        }, React.createElement(Loader.Mini.make, {})) : (
      usersTokensQuery.TAG === /* GraphError */0 ? usersTokensQuery._0 : React.createElement(UserUI.UserTotalValue.make, {
              totalValueNameSup: "Portfolio",
              totalValueNameSub: "Value",
              totalValue: usersTokensQuery._0.totalBalance.add(totalStakedValue.contents)
            })
    );
  return React.createElement(React.Fragment, undefined, tmp);
}

var UserTotalInvestedCard = {
  make: User$UserTotalInvestedCard
};

function User$UserTotalStakedCard(Props) {
  var stakes = Props.stakes;
  var totalStakedValue = getUsersTotalStakeValue(stakes);
  return React.createElement(UserUI.UserTotalValue.make, {
              totalValueNameSup: "Staked",
              totalValueNameSub: "Value",
              totalValue: totalStakedValue.contents
            });
}

var UserTotalStakedCard = {
  make: User$UserTotalStakedCard
};

function User$UserProfileCard(Props) {
  var userInfo = Props.userInfo;
  var addressStr = DisplayAddress.ellipsifyMiddle(userInfo.id, 8, 3);
  var joinedStr = Format(userInfo.joinedAt, "do MMM ''yy");
  var txStr = userInfo.transactionCount.toString();
  var gasStr = Misc.NumberFormat.formatInt(userInfo.gasUsed.toString());
  return React.createElement(UserUI.UserColumnCard.make, {
              children: null
            }, React.createElement(UserUI.UserProfileHeader.make, {
                  address: addressStr
                }), React.createElement(UserUI.UserColumnTextList.make, {
                  children: React.createElement("div", {
                        className: "p-4"
                      }, React.createElement(UserUI.UserColumnText.make, {
                            head: "📮 Address",
                            body: addressStr
                          }), React.createElement(UserUI.UserColumnText.make, {
                            head: "🎉 Joined",
                            body: joinedStr
                          }), React.createElement(UserUI.UserColumnText.make, {
                            head: "⛽ Gas used",
                            body: gasStr
                          }), React.createElement(UserUI.UserColumnText.make, {
                            head: "🏃 No. txs",
                            body: txStr
                          }))
                }));
}

var UserProfileCard = {
  make: User$UserProfileCard
};

function onQueryError(msg) {
  return React.createElement(UserUI.UserContainer.make, {
              children: "Error: " + msg
            });
}

function onQuerySuccess(data) {
  return React.createElement(UserUI.UserContainer.make, {
              children: React.createElement(Masonry.Container.make, {
                    children: null
                  }, React.createElement(Masonry.Divider.make, {
                        children: null
                      }, React.createElement(User$UserProfileCard, {
                            userInfo: data.userInfo
                          }), React.createElement(UserUI.UserFloatCard.make, {
                            userId: data.user,
                            stakes: data.stakes
                          })), React.createElement(Masonry.Divider.make, {
                        children: null
                      }, React.createElement(User$UserTotalInvestedCard, {
                            stakes: data.stakes,
                            userId: data.user
                          }), React.createElement(User$UserBalancesCard, {
                            userId: data.user
                          })), React.createElement(Masonry.Divider.make, {
                        children: null
                      }, React.createElement(User$UserTotalStakedCard, {
                            stakes: data.stakes
                          }), React.createElement(UserUI.UserStakesCard.make, {
                            stakes: data.stakes,
                            userId: data.user
                          })))
            });
}

function User$User(Props) {
  var optCurrentUser = RootProvider.useCurrentUser(undefined);
  var router = Router.useRouter();
  var userStr = Js_dict.get(router.query, "user");
  var user = userStr !== undefined ? userStr.toLowerCase() : "no user provided";
  var stakesQuery = DataHooks.useStakesForUser(user);
  var userInfoQuery = DataHooks.useBasicUserInfo(user);
  var notCurrentUserMessage = function (param) {
    return React.createElement(UserUI.UserColumnTextCenter.make, {
                children: React.createElement("a", {
                      className: "mt-4 hover:text-gray-600",
                      href: Config.blockExplorer + "address/" + user,
                      rel: "noopener noreferrer",
                      target: "_"
                    }, React.createElement("h1", undefined, "This user has not interacted with float.capital yet"))
              });
  };
  var msg = DataHooks.liftGraphResponse2(stakesQuery, userInfoQuery);
  if (typeof msg === "number") {
    return React.createElement(Loader.make, {});
  }
  if (msg.TAG === /* GraphError */0) {
    return onQueryError(msg._0);
  }
  var match = msg._0;
  var userInfo = match[1];
  if (userInfo) {
    return onQuerySuccess({
                user: user,
                userInfo: userInfo._0,
                stakes: match[0]
              });
  } else {
    return React.createElement(React.Fragment, undefined, React.createElement(UserUI.UserColumnCard.make, {
                    children: null
                  }, React.createElement(UserUI.UserProfileHeader.make, {
                        address: user
                      }), optCurrentUser !== undefined && Ethers.Utils.ethAdrToLowerStr(Caml_option.valFromOption(optCurrentUser)) === user ? React.createElement(React.Fragment, undefined, React.createElement(UserUI.UserColumnTextCenter.make, {
                              children: React.createElement("p", {
                                    className: "my-2"
                                  }, "Mint a position to see data on your profile")
                            }), React.createElement("div", {
                              className: "w-40 mx-auto"
                            }, React.createElement(Link, {
                                  href: "/markets",
                                  children: React.createElement(Button.Small.make, {
                                        children: "MARKETS"
                                      })
                                }))) : notCurrentUserMessage(undefined)));
  }
}

var User = {
  onQueryError: onQueryError,
  onQuerySuccess: onQuerySuccess,
  make: User$User
};

function $$default(param) {
  return React.createElement(User$User, {});
}

exports.UserBalancesCard = UserBalancesCard;
exports.getUsersTotalStakeValue = getUsersTotalStakeValue;
exports.UserTotalInvestedCard = UserTotalInvestedCard;
exports.UserTotalStakedCard = UserTotalStakedCard;
exports.UserProfileCard = UserProfileCard;
exports.User = User;
exports.$$default = $$default;
exports.default = $$default;
exports.__esModule = true;
/* Misc Not a pure module */
