// Generated by ReScript, PLEASE EDIT WITH CARE
'use strict';

var Curry = require("rescript/lib/js/curry.js");
var React = require("react");
var Button = require("./Button.js");
var Ethers = require("../../ethereum/Ethers.js");
var Ethers$1 = require("ethers");
var Globals = require("../../libraries/Globals.js");
var Js_dict = require("rescript/lib/js/js_dict.js");
var Blockies = require("../../bindings/ethereum-blockies-base64/Blockies.js");
var CONSTANTS = require("../../CONSTANTS.js");
var DataHooks = require("../../data/DataHooks.js");
var Belt_Array = require("rescript/lib/js/belt_Array.js");
var ClaimFloat = require("../Claim/ClaimFloat.js");
var MiniLoader = require("./MiniLoader.js");
var Belt_Option = require("rescript/lib/js/belt_Option.js");
var Caml_option = require("rescript/lib/js/caml_option.js");
var FormatMoney = require("./FormatMoney.js");
var Router = require("next/router");
var RootProvider = require("../../libraries/RootProvider.js");
var AddToMetamask = require("./AddToMetamask.js");
var InjectedEthereum = require("../../ethereum/InjectedEthereum.js");
var FromUnixTime = require("date-fns/fromUnixTime").default;
var FormatDistanceToNow = require("date-fns/formatDistanceToNow").default;

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
              className: "bg-white w-full bg-opacity-75 rounded-lg shadow-lg p-2 mb-2 md:mb-4"
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
  var address = Props.address;
  return React.createElement("div", {
              className: "w-full flex flex-row justify-around"
            }, React.createElement("div", {
                  className: "w-24 h-24 rounded-full border-2 border-light-purple flex items-center justify-center"
                }, React.createElement("img", {
                      className: "inline h-10 rounded",
                      src: Blockies.makeBlockie(address)
                    })));
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
              className: "mb-1"
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

var threeDotsSvg = React.createElement("svg", {
      viewBox: "0 0 24 24",
      xmlns: "http://www.w3.org/2000/svg"
    }, React.createElement("path", {
          d: "M12 7a2 2 0 1 1 0-4 2 2 0 0 1 0 4zm0 7a2 2 0 1 1 0-4 2 2 0 0 1 0 4zm0 7a2 2 0 1 1 0-4 2 2 0 0 1 0 4z",
          fillRule: "evenodd"
        }));

function addClickListener(param) {
  document.addEventListener("mousedown", param);
  
}

function removeClickListener(param) {
  document.removeEventListener("mousedown", param);
  
}

function UserUI$MetamaskMenu(Props) {
  var tokenAddress = Props.tokenAddress;
  var tokenName = Props.tokenName;
  var match = React.useState(function () {
        return false;
      });
  var setShow = match[1];
  var router = Router.useRouter();
  var addr = Js_dict.get(router.query, "minted");
  var initialShowPing = addr !== undefined ? addr === tokenAddress : false;
  var match$1 = React.useState(function () {
        return false;
      });
  var setShowPing = match$1[1];
  React.useEffect((function () {
          if (initialShowPing) {
            Curry._1(setShowPing, (function (param) {
                    return true;
                  }));
            setTimeout((function (param) {
                    return Curry._1(setShowPing, (function (param) {
                                  return false;
                                }));
                  }), 6000);
            return ;
          }
          
        }), [initialShowPing]);
  var wrapper = React.useRef(null);
  var dots = React.useRef(null);
  React.useEffect((function () {
          var handleMousedown = function (param) {
            var target = param.target;
            Belt_Option.mapWithDefault(Caml_option.nullable_to_opt(wrapper.current), undefined, (function (element) {
                    Belt_Option.mapWithDefault(Caml_option.nullable_to_opt(dots.current), undefined, (function (dotsElement) {
                            if (!element.contains(target) && !dotsElement.contains(target)) {
                              return Curry._1(setShow, (function (param) {
                                            return false;
                                          }));
                            }
                            
                          }));
                    
                  }));
            
          };
          document.addEventListener("mousedown", handleMousedown);
          return (function (param) {
                    document.removeEventListener("mousedown", handleMousedown);
                    
                  });
        }), [wrapper]);
  if (InjectedEthereum.isMetamask(undefined)) {
    return React.createElement("div", {
                className: "relative"
              }, React.createElement("div", {
                    ref: dots,
                    className: "absolute top-1 w-4 h-4 cursor-pointer z-20",
                    onClick: (function (param) {
                        Curry._1(setShow, (function (show) {
                                return !show;
                              }));
                        return Curry._1(setShowPing, (function (param) {
                                      return false;
                                    }));
                      })
                  }, threeDotsSvg), match[0] ? React.createElement("div", {
                      ref: wrapper,
                      className: "absolute bottom-full left-1 rounded-lg z-30 text-xs py-1 px-1 w-20 bg-white shadow-lg flex justify-center cursor-pointer"
                    }, React.createElement(AddToMetamask.make, {
                          tokenAddress: tokenAddress,
                          tokenSymbol: tokenName,
                          callback: (function (param) {
                              return Curry._1(setShow, (function (param) {
                                            return false;
                                          }));
                            }),
                          children: null
                        }, "Add to ", React.createElement("img", {
                              className: "h-5 ml-1",
                              src: "/icons/metamask.svg"
                            }))) : null, match$1[0] ? React.createElement("div", {
                      className: "absolute left-1 top-1 z-0 animate-ping inline-flex h-3 w-3 mr-4 rounded-full bg-green-500 opacity-90"
                    }) : null);
  } else {
    return null;
  }
}

var MetamaskMenu = {
  addClickListener: addClickListener,
  removeClickListener: removeClickListener,
  make: UserUI$MetamaskMenu
};

function UserUI$UserMarketBox(Props) {
  var name = Props.name;
  var isLong = Props.isLong;
  var tokens = Props.tokens;
  var value = Props.value;
  var tokenAddressOpt = Props.tokenAddress;
  var metamaskMenuOpt = Props.metamaskMenu;
  var symbolOpt = Props.symbol;
  var children = Props.children;
  var tokenAddress = tokenAddressOpt !== undefined ? Caml_option.valFromOption(tokenAddressOpt) : CONSTANTS.zeroAddress;
  var metamaskMenu = metamaskMenuOpt !== undefined ? metamaskMenuOpt : false;
  var symbol = symbolOpt !== undefined ? symbolOpt : "";
  return React.createElement("div", {
              className: "flex w-11/12 mx-auto p-2 mb-2 border-2 border-light-purple rounded-lg z-10 shadow relative"
            }, metamaskMenu ? React.createElement("div", {
                    className: "absolute left-1 top-2"
                  }, React.createElement(UserUI$MetamaskMenu, {
                        tokenAddress: Ethers.Utils.ethAdrToStr(tokenAddress),
                        tokenName: (
                          isLong ? "fu" : "fd"
                        ) + symbol
                      })) : null, React.createElement("div", {
                  className: "pl-3 w-1/3 text-sm self-center"
                }, name, React.createElement("br", {
                      className: "mt-1"
                    }), isLong ? "Long↗️" : "Short↘️"), React.createElement("div", {
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
  var isLong = Props.isLong;
  var marketIdResponse = DataHooks.useTokenMarketId(synthAddress);
  var marketId = Belt_Option.getWithDefault(DataHooks.Util.graphResponseToOption(marketIdResponse), "1");
  var router = Router.useRouter();
  var stake = function (param) {
    router.push("/markets?marketIndex=" + marketId + "&actionOption=" + (
          isLong ? "long" : "short"
        ) + "&tab=stake");
    
  };
  var redeem = function (param) {
    router.push("/markets?marketIndex=" + marketId + "&actionOption=" + (
          isLong ? "long" : "short"
        ) + "&tab=redeem");
    
  };
  return React.createElement("div", {
              className: "flex flex-col"
            }, React.createElement(Button.Tiny.make, {
                  onClick: stake,
                  children: "stake"
                }), React.createElement(Button.Tiny.make, {
                  onClick: redeem,
                  children: "redeem"
                }));
}

var UserMarketStakeOrRedeem = {
  make: UserUI$UserMarketStakeOrRedeem
};

function UserUI$UserMarketUnstake(Props) {
  var synthAddress = Props.synthAddress;
  var userId = Props.userId;
  var isLong = Props.isLong;
  var whenStrOpt = Props.whenStr;
  var whenStr = whenStrOpt !== undefined ? whenStrOpt : "";
  var synthAddressStr = Globals.ethAdrToLowerStr(synthAddress);
  var marketIdResponse = DataHooks.useTokenMarketId(synthAddressStr);
  var marketId = Belt_Option.getWithDefault(DataHooks.Util.graphResponseToOption(marketIdResponse), "1");
  var router = Router.useRouter();
  var unstake = function (param) {
    router.push("/markets?marketIndex=" + marketId + "&tab=unstake&actionOption=" + (
          isLong ? "long" : "short"
        ));
    
  };
  var optLoggedInUser = RootProvider.useCurrentUser(undefined);
  var isCurrentUser = Belt_Option.mapWithDefault(optLoggedInUser, false, (function (user) {
          return Globals.ethAdrToLowerStr(user) === userId;
        }));
  return React.createElement("div", {
              className: "flex flex-col"
            }, React.createElement("span", {
                  className: "text-xxs self-center"
                }, React.createElement("i", undefined, whenStr + " ago")), isCurrentUser ? React.createElement(Button.Tiny.make, {
                    onClick: unstake,
                    children: "unstake"
                  }) : null);
}

var UserMarketUnstake = {
  make: UserUI$UserMarketUnstake
};

function UserUI$UserStakesCard(Props) {
  var stakes = Props.stakes;
  var userId = Props.userId;
  var totalValue = {
    contents: CONSTANTS.zeroBN
  };
  var stakeBoxes = stakes.map(function (stake, i) {
        var key = "user-stakes-" + String(i);
        var syntheticToken = stake.currentStake.syntheticToken;
        var addr = Ethers$1.utils.getAddress(syntheticToken.id);
        var name = syntheticToken.syntheticMarket.symbol;
        var tokens = FormatMoney.formatEther(undefined, stake.currentStake.amount);
        var isLong = syntheticToken.tokenType === "Long";
        var price = syntheticToken.latestPrice.price.price;
        var whenStr = FormatDistanceToNow(FromUnixTime(stake.currentStake.timestamp.toNumber()));
        var value = stake.currentStake.amount.mul(price).div(CONSTANTS.tenToThe18);
        totalValue.contents = totalValue.contents.add(value);
        return React.createElement(UserUI$UserMarketBox, {
                    name: name,
                    isLong: isLong,
                    tokens: tokens,
                    value: FormatMoney.formatEther(undefined, value),
                    children: React.createElement(UserUI$UserMarketUnstake, {
                          synthAddress: addr,
                          userId: userId,
                          isLong: isLong,
                          whenStr: whenStr
                        }),
                    key: key
                  });
      });
  return React.createElement(UserUI$UserColumnCard, {
              children: null
            }, React.createElement(UserUI$UserColumnHeader, {
                  children: "Staked assets 🔐"
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
  var floatBalances = DataHooks.useFloatBalancesForUser(userId);
  var claimableFloat = DataHooks.useTotalClaimableFloatForUser(userId, synthTokens);
  var optLoggedInUser = RootProvider.useCurrentUser(undefined);
  var isCurrentUser = Belt_Option.mapWithDefault(optLoggedInUser, false, (function (user) {
          return Globals.ethAdrToLowerStr(user) === userId;
        }));
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
          className: "w-11/12 px-2 mx-auto mb-2 border-2 border-light-purple rounded-lg z-10 shadow"
        }, React.createElement(UserUI$UserColumnTextList, {
              children: null
            }, React.createElement(UserUI$UserColumnText, {
                  head: "Float accruing",
                  body: floatAccrued
                }), React.createElement(UserUI$UserColumnText, {
                  head: "Float balance",
                  body: floatBalance
                }), React.createElement(UserUI$UserColumnText, {
                  head: "Float minted",
                  body: floatMinted
                })), isCurrentUser ? React.createElement("div", {
                className: "flex justify-around flex-row my-1"
              }, "🌊", React.createElement(ClaimFloat.make, {
                    tokenAddresses: synthTokens
                  }), "🌊") : null);
  }
  return React.createElement(UserUI$UserColumnCard, {
              children: null
            }, React.createElement(UserUI$UserColumnHeader, {
                  children: React.createElement("div", {
                        className: "flex flex-row items-center justify-center"
                      }, React.createElement("h3", undefined, "Float rewards"), React.createElement("img", {
                            className: "ml-2 h-5",
                            src: "/img/float-token-coin-v3.svg"
                          }))
                }), tmp);
}

var UserFloatCard = {
  make: UserUI$UserFloatCard
};

exports.UserContainer = UserContainer;
exports.UserBanner = UserBanner;
exports.UserColumnContainer = UserColumnContainer;
exports.UserColumn = UserColumn;
exports.UserColumnCard = UserColumnCard;
exports.UserColumnHeader = UserColumnHeader;
exports.UserProfileHeader = UserProfileHeader;
exports.UserColumnTextList = UserColumnTextList;
exports.UserColumnTextCenter = UserColumnTextCenter;
exports.UserColumnText = UserColumnText;
exports.threeDotsSvg = threeDotsSvg;
exports.MetamaskMenu = MetamaskMenu;
exports.UserMarketBox = UserMarketBox;
exports.UserMarketStakeOrRedeem = UserMarketStakeOrRedeem;
exports.UserMarketUnstake = UserMarketUnstake;
exports.UserStakesCard = UserStakesCard;
exports.UserFloatCard = UserFloatCard;
/* threeDotsSvg Not a pure module */
