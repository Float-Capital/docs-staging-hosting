// Generated by ReScript, PLEASE EDIT WITH CARE

import * as React from "react";
import * as Button from "./components/UI/Button.js";
import * as Config from "./Config.js";
import * as Ethers from "./ethereum/Ethers.js";
import * as Loader from "./components/UI/Loader.js";
import * as UserUI from "./components/UI/UserUI.js";
import * as Js_dict from "bs-platform/lib/es6/js_dict.js";
import * as Masonry from "./components/UI/Masonry.js";
import * as CONSTANTS from "./CONSTANTS.js";
import * as DataHooks from "./data/DataHooks.js";
import Link from "next/link";
import * as Belt_Array from "bs-platform/lib/es6/belt_Array.js";
import * as MiniLoader from "./components/UI/MiniLoader.js";
import * as Caml_option from "bs-platform/lib/es6/caml_option.js";
import * as FormatMoney from "./components/UI/FormatMoney.js";
import * as Router from "next/router";
import * as RootProvider from "./libraries/RootProvider.js";
import * as DisplayAddress from "./components/UI/DisplayAddress.js";
import Format from "date-fns/format";

function User$UserBalancesCard(Props) {
  var userId = Props.userId;
  var usersTokensQuery = DataHooks.useUsersBalances(userId);
  var tmp;
  if (typeof usersTokensQuery === "number") {
    tmp = React.createElement("div", {
          className: "m-auto"
        }, React.createElement(MiniLoader.make, {}));
  } else if (usersTokensQuery.TAG === /* GraphError */0) {
    tmp = usersTokensQuery._0;
  } else {
    var match = usersTokensQuery._0;
    tmp = React.createElement(React.Fragment, undefined, React.createElement(UserUI.UserColumnTextCenter.make, {
              children: React.createElement(UserUI.UserColumnText.make, {
                    head: "💰 Synth value",
                    body: "$" + FormatMoney.formatEther(undefined, match.totalBalance)
                  })
            }), React.createElement("br", undefined), Belt_Array.map(Belt_Array.keep(match.balances, (function (param) {
                    return !param.tokenBalance.eq(CONSTANTS.zeroBN);
                  })), (function (param) {
                var isLong = param.isLong;
                var name = param.name;
                return React.createElement(UserUI.UserMarketBox.make, {
                            name: name,
                            isLong: isLong,
                            tokens: FormatMoney.formatEther(undefined, param.tokenBalance),
                            value: FormatMoney.formatEther(undefined, param.tokensValue),
                            children: React.createElement(UserUI.UserMarketStakeOrRedeem.make, {
                                  synthAddress: param.addr
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
                }, "Synthetic Assets", React.createElement("img", {
                      className: "inline h-5 ml-2",
                      src: "/img/coin.png"
                    })), tmp);
}

var UserBalancesCard = {
  make: User$UserBalancesCard
};

function User$UserProfileCard(Props) {
  var userInfo = Props.userInfo;
  var addressStr = DisplayAddress.ellipsifyMiddle(userInfo.id, 8, 3);
  var joinedStr = Format(userInfo.joinedAt, "do MMM yyyy");
  var txStr = userInfo.transactionCount.toString();
  var gasStr = FormatMoney.formatInt(userInfo.gasUsed.toString());
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
                        children: React.createElement(User$UserProfileCard, {
                              userInfo: data.userInfo
                            })
                      }), React.createElement(Masonry.Divider.make, {
                        children: React.createElement(User$UserBalancesCard, {
                              userId: data.user
                            })
                      }), React.createElement(Masonry.Divider.make, {
                        children: null
                      }, React.createElement(UserUI.UserFloatCard.make, {
                            userId: data.user,
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
                      href: Config.defaultBlockExplorer + "address/" + user,
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
                                        children: "MINT"
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

export {
  UserBalancesCard ,
  UserProfileCard ,
  User ,
  $$default ,
  $$default as default,
  
}
/* react Not a pure module */
