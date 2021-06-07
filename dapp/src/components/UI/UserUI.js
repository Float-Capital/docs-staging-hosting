// Generated by ReScript, PLEASE EDIT WITH CARE
'use strict';

var Misc = require("../../libraries/Misc.js");
var Curry = require("rescript/lib/js/curry.js");
var React = require("react");
var Button = require("./Base/Button.js");
var Config = require("../../config/Config.js");
var Ethers = require("../../ethereum/Ethers.js");
var Loader = require("./Base/Loader.js");
var Ethers$1 = require("ethers");
var Globals = require("../../libraries/Globals.js");
var Js_dict = require("rescript/lib/js/js_dict.js");
var Tooltip = require("./Base/Tooltip.js");
var Belt_Int = require("rescript/lib/js/belt_Int.js");
var Blockies = require("../../bindings/ethereum-blockies-base64/Blockies.js");
var Metamask = require("./Base/Metamask.js");
var CONSTANTS = require("../../CONSTANTS.js");
var DataHooks = require("../../data/DataHooks.js");
var Belt_Array = require("rescript/lib/js/belt_Array.js");
var ClaimFloat = require("../Claim/ClaimFloat.js");
var Pervasives = require("rescript/lib/js/pervasives.js");
var Belt_Option = require("rescript/lib/js/belt_Option.js");
var Caml_option = require("rescript/lib/js/caml_option.js");
var Router = require("next/router");
var RootProvider = require("../../libraries/RootProvider.js");
var Belt_SetString = require("rescript/lib/js/belt_SetString.js");
var InjectedEthereum = require("../../ethereum/InjectedEthereum.js");

function UserUI$UserContainer(Props) {
  var children = Props.children;
  return React.createElement("div", {
              className: "min-w-3/4 mx-auto max-w-7xl flex flex-col items-center"
            }, children);
}

var UserContainer = {
  make: UserUI$UserContainer
};

function UserUI$UserTotalValue(Props) {
  var totalValueNameSup = Props.totalValueNameSup;
  var totalValueNameSub = Props.totalValueNameSub;
  var totalValue = Props.totalValue;
  var isABaller = totalValue.gte(CONSTANTS.oneHundredThousandInWei);
  var isAWhale = totalValue.gte(CONSTANTS.oneMillionInWei);
  return React.createElement("div", {
              className: "p-5 mb-5 flex items-center justify-between bg-white bg-opacity-75 rounded-lg shadow-lg"
            }, React.createElement("div", {
                  className: "flex flex-col"
                }, React.createElement("span", {
                      className: "text-lg font-bold leading-tight"
                    }, totalValueNameSup), React.createElement("span", {
                      className: "text-lg font-bold leading-tight"
                    }, totalValueNameSub)), React.createElement("div", undefined, React.createElement("span", {
                      className: (
                        isABaller ? "text-xl" : "text-2xl"
                      ) + " text-primary"
                    }, "$" + Misc.NumberFormat.formatEther(isAWhale ? 1 : 2, totalValue))));
}

var UserTotalValue = {
  make: UserUI$UserTotalValue
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
                    }, React.createElement(Metamask.AddToken.make, {
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

function directionAndPercentageString(oldPrice, newPrice) {
  var priceDirection = newPrice.eq(oldPrice) ? /* Same */2 : (
      newPrice.gt(oldPrice) ? /* Up */0 : /* Down */1
    );
  var diff;
  switch (priceDirection) {
    case /* Up */0 :
        diff = newPrice.sub(oldPrice);
        break;
    case /* Down */1 :
        diff = oldPrice.sub(newPrice);
        break;
    case /* Same */2 :
        diff = CONSTANTS.zeroBN;
        break;
    
  }
  var initialPercentStr = Globals.percentStr(diff, oldPrice);
  var initialPercentFloat = parseFloat(initialPercentStr);
  var flooredPercentFloat = Math.floor((initialPercentFloat + Pervasives.epsilon_float) * 100) / 100;
  var percentStr = flooredPercentFloat.toFixed(2);
  var percentFloat = parseFloat(percentStr);
  var displayDirection = percentFloat === 0 ? /* Same */2 : priceDirection;
  return [
          displayDirection,
          percentStr
        ];
}

function UserUI$UserPercentageGains(Props) {
  var metadata = Props.metadata;
  var tokenAddress = Props.tokenAddress;
  var isLong = Props.isLong;
  var bothPrices = DataHooks.useSyntheticPrices(metadata, tokenAddress, isLong);
  var tmp;
  if (typeof bothPrices === "number") {
    tmp = React.createElement(Loader.Mini.make, {});
  } else if (bothPrices.TAG === /* GraphError */0) {
    tmp = "";
  } else {
    var match = bothPrices._0;
    var match$1 = directionAndPercentageString(match[0], match[1]);
    var match$2;
    switch (match$1[0]) {
      case /* Up */0 :
          match$2 = [
            "+",
            "text-green-500"
          ];
          break;
      case /* Down */1 :
          match$2 = [
            "-",
            "text-red-500"
          ];
          break;
      case /* Same */2 :
          match$2 = [
            "",
            "text-gray-400"
          ];
          break;
      
    }
    tmp = React.createElement("div", {
          className: match$2[1] + " text-center text-lg"
        }, match$2[0] + match$1[1] + "%");
  }
  return React.createElement("div", {
              className: "flex flex-col items-center justify-center"
            }, tmp);
}

var UserPercentageGains = {
  directionAndPercentageString: directionAndPercentageString,
  make: UserUI$UserPercentageGains
};

function UserUI$UserTokenBox(Props) {
  var name = Props.name;
  var isLong = Props.isLong;
  var tokens = Props.tokens;
  var value = Props.value;
  var tokenAddressOpt = Props.tokenAddress;
  var symbolOpt = Props.symbol;
  var metadata = Props.metadata;
  var children = Props.children;
  var tokenAddress = tokenAddressOpt !== undefined ? Caml_option.valFromOption(tokenAddressOpt) : CONSTANTS.zeroAddress;
  var symbol = symbolOpt !== undefined ? symbolOpt : "";
  return React.createElement("div", {
              className: "flex justify-between w-11/12 mx-auto p-2 mb-2 border-2 border-light-purple rounded-lg z-10 shadow relative"
            }, React.createElement("div", {
                  className: "absolute left-1 top-2"
                }, React.createElement(UserUI$MetamaskMenu, {
                      tokenAddress: Ethers.Utils.ethAdrToStr(tokenAddress),
                      tokenName: (
                        isLong ? "fu" : "fd"
                      ) + symbol
                    })), React.createElement("div", {
                  className: "pl-3 text-sm self-center"
                }, name, React.createElement("br", {
                      className: "mt-1"
                    }), isLong ? "Long↗️" : "Short↘️"), React.createElement("div", {
                  className: "text-sm text-center self-center"
                }, React.createElement("span", {
                      className: "text-sm"
                    }, tokens), React.createElement("span", {
                      className: "text-xs"
                    }, "tkns"), React.createElement("br", {
                      className: "mt-1"
                    }), React.createElement("span", {
                      className: "text-xs"
                    }, "~$".concat(value))), React.createElement("div", {
                  className: "flex flex-col items-center justify-center"
                }, React.createElement("div", {
                      className: "text-xs text-center text-gray-400"
                    }, Globals.formatTimestamp(metadata.timeLastUpdated)), React.createElement(UserUI$UserPercentageGains, {
                      metadata: metadata,
                      tokenAddress: tokenAddress,
                      isLong: isLong
                    })), React.createElement("div", {
                  className: "self-center"
                }, children));
}

var UserTokenBox = {
  make: UserUI$UserTokenBox
};

function UserUI$UserFloatEarnedFromStake(Props) {
  var userId = Props.userId;
  var tokenAddress = Props.tokenAddress;
  var claimableFloat = DataHooks.useTotalClaimableFloatForUser(userId, [Ethers.Utils.ethAdrToLowerStr(tokenAddress)]);
  if (typeof claimableFloat === "number") {
    return React.createElement(Loader.Mini.make, {});
  }
  if (claimableFloat.TAG === /* GraphError */0) {
    return React.createElement(Loader.Mini.make, {});
  }
  var match = claimableFloat._0;
  return React.createElement("div", {
              className: "text-xs flex flex-col items-center justify-center"
            }, React.createElement("div", {
                  className: "text-gray-500"
                }, "Float Accruing"), "~" + Misc.NumberFormat.formatEther(6, match[0].add(match[1])));
}

var UserFloatEarnedFromStake = {
  make: UserUI$UserFloatEarnedFromStake
};

function UserUI$UserStakeBox(Props) {
  var name = Props.name;
  var isLong = Props.isLong;
  var tokens = Props.tokens;
  var value = Props.value;
  var tokenAddressOpt = Props.tokenAddress;
  var metadata = Props.metadata;
  var creationTxHash = Props.creationTxHash;
  var children = Props.children;
  var tokenAddress = tokenAddressOpt !== undefined ? Caml_option.valFromOption(tokenAddressOpt) : CONSTANTS.zeroAddress;
  return React.createElement("div", {
              className: "flex justify-between w-11/12 mx-auto p-2 mb-2 border-2 border-light-purple rounded-lg z-10 shadow relative"
            }, React.createElement("div", {
                  className: "pl-3 text-sm self-center"
                }, name, React.createElement("br", {
                      className: "mt-1"
                    }), isLong ? "Long↗️" : "Short↘️"), React.createElement("div", {
                  className: "text-sm text-center self-center"
                }, React.createElement("span", {
                      className: "text-sm"
                    }, tokens), React.createElement("span", {
                      className: "text-xs"
                    }, "tkns"), React.createElement("br", {
                      className: "mt-1"
                    }), React.createElement("span", {
                      className: "text-xs"
                    }, "~$".concat(value))), React.createElement("div", {
                  className: "flex flex-col items-center justify-center"
                }, React.createElement("a", {
                      className: "text-xs text-center text-gray-400 hover:opacity-75",
                      href: Config.blockExplorer + "/tx/" + creationTxHash,
                      rel: "noopener noreferrer",
                      target: "_"
                    }, Globals.formatTimestamp(metadata.timeLastUpdated)), React.createElement(UserUI$UserPercentageGains, {
                      metadata: metadata,
                      tokenAddress: tokenAddress,
                      isLong: isLong
                    })), React.createElement("div", {
                  className: "self-center"
                }, children));
}

var UserStakeBox = {
  make: UserUI$UserStakeBox
};

function UserUI$UserMarketStakeOrRedeem(Props) {
  var synthAddress = Props.synthAddress;
  var isLong = Props.isLong;
  var marketIdResponse = DataHooks.useTokenMarketId(synthAddress);
  var marketId = Belt_Option.getWithDefault(DataHooks.Util.graphResponseToOption(marketIdResponse), "1");
  var router = Router.useRouter();
  var stake = function (param) {
    router.push("/?marketIndex=" + marketId + "&actionOption=" + (
          isLong ? "long" : "short"
        ) + "&tab=stake");
    
  };
  var redeem = function (param) {
    router.push("/?marketIndex=" + marketId + "&actionOption=" + (
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
  var synthAddressStr = Globals.ethAdrToLowerStr(synthAddress);
  var marketIdResponse = DataHooks.useTokenMarketId(synthAddressStr);
  var marketId = Belt_Option.getWithDefault(DataHooks.Util.graphResponseToOption(marketIdResponse), "1");
  var router = Router.useRouter();
  var unstake = function (param) {
    router.push("/?marketIndex=" + marketId + "&tab=unstake&actionOption=" + (
          isLong ? "long" : "short"
        ));
    
  };
  var optLoggedInUser = RootProvider.useCurrentUser(undefined);
  var isCurrentUser = Belt_Option.mapWithDefault(optLoggedInUser, false, (function (user) {
          return Globals.ethAdrToLowerStr(user) === userId;
        }));
  return React.createElement("div", {
              className: "flex flex-col"
            }, isCurrentUser ? React.createElement(Button.Tiny.make, {
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
  var stakeBoxes = stakes.map(function (stake, i) {
        var key = "user-stakes-" + String(i);
        var syntheticToken = stake.currentStake.syntheticToken;
        var addr = Ethers$1.utils.getAddress(syntheticToken.id);
        var name = syntheticToken.syntheticMarket.name;
        var tokens = Misc.NumberFormat.formatEther(undefined, stake.currentStake.amount);
        var isLong = syntheticToken.tokenType === "Long";
        var price = syntheticToken.latestPrice.price.price;
        var match = syntheticToken.syntheticMarket;
        var match$1 = match.latestSystemState;
        var metadata_timeLastUpdated = stake.currentStake.timestamp;
        var metadata_oracleAddress = match.oracleAddress;
        var metadata_marketIndex = match.marketIndex;
        var metadata_tokenSupply = syntheticToken.tokenSupply;
        var metadata_totalLockedLong = match$1.totalLockedLong;
        var metadata_totalLockedShort = match$1.totalLockedShort;
        var metadata_syntheticPrice = match$1.syntheticPrice;
        var metadata = {
          timeLastUpdated: metadata_timeLastUpdated,
          oracleAddress: metadata_oracleAddress,
          marketIndex: metadata_marketIndex,
          tokenSupply: metadata_tokenSupply,
          totalLockedLong: metadata_totalLockedLong,
          totalLockedShort: metadata_totalLockedShort,
          syntheticPrice: metadata_syntheticPrice
        };
        var value = stake.currentStake.amount.mul(price).div(CONSTANTS.tenToThe18);
        var creationTxHash = stake.currentStake.creationTxHash;
        return React.createElement(UserUI$UserStakeBox, {
                    name: name,
                    isLong: isLong,
                    tokens: tokens,
                    value: Misc.NumberFormat.formatEther(undefined, value),
                    tokenAddress: addr,
                    metadata: metadata,
                    creationTxHash: creationTxHash,
                    children: null,
                    key: key
                  }, React.createElement(UserUI$UserFloatEarnedFromStake, {
                        userId: userId,
                        tokenAddress: addr
                      }), React.createElement(UserUI$UserMarketUnstake, {
                        synthAddress: addr,
                        userId: userId,
                        isLong: isLong
                      }));
      });
  return React.createElement(UserUI$UserColumnCard, {
              children: null
            }, React.createElement(UserUI$UserColumnHeader, {
                  children: "Staked assets 🔐"
                }), stakeBoxes);
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
  var synthTokensMarketIndexes = Belt_Array.map(stakes, (function (stake) {
          return stake.currentStake.syntheticToken.syntheticMarket.id;
        }));
  var uniqueMarketIndexes = Belt_SetString.fromArray(synthTokensMarketIndexes);
  var uniqueMarketIndexesBigInts = Belt_Array.map(Belt_SetString.toArray(uniqueMarketIndexes), (function (item) {
          return Ethers$1.BigNumber.from(Belt_Option.getWithDefault(Belt_Int.fromString(item), 0));
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
    tmp = React.createElement(Loader.Mini.make, {});
  } else if (msg.TAG === /* GraphError */0) {
    tmp = msg._0;
  } else {
    var match = msg._0;
    var match$1 = match[1];
    var floatBalances$1 = match[0];
    var floatBalance = Misc.NumberFormat.formatEther(6, floatBalances$1.floatBalance);
    var floatMinted = Misc.NumberFormat.formatEther(6, floatBalances$1.floatMinted);
    var floatAccrued = Misc.NumberFormat.formatEther(6, match$1[0].add(match$1[1]));
    tmp = React.createElement("div", {
          className: "w-11/12 px-2 mx-auto mb-2 border-2 border-light-purple rounded-lg z-10 shadow"
        }, React.createElement(UserUI$UserColumnTextList, {
              children: null
            }, React.createElement("div", {
                  className: "flex"
                }, React.createElement(UserUI$UserColumnText, {
                      head: "Float accruing",
                      body: floatAccrued
                    }), React.createElement("span", {
                      className: "ml-1"
                    }, React.createElement(Tooltip.make, {
                          tip: "This is an estimate at the current time, the amount issued may differ due to changes in market liquidity and asset prices."
                        }))), React.createElement(UserUI$UserColumnText, {
                  head: "Float balance",
                  body: floatBalance
                }), React.createElement(UserUI$UserColumnText, {
                  head: "Float minted",
                  body: floatMinted
                })), isCurrentUser ? React.createElement("div", {
                className: "flex justify-around flex-row my-1"
              }, "🌊", React.createElement(ClaimFloat.make, {
                    marketIndexes: uniqueMarketIndexesBigInts
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
exports.UserTotalValue = UserTotalValue;
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
exports.UserPercentageGains = UserPercentageGains;
exports.UserTokenBox = UserTokenBox;
exports.UserFloatEarnedFromStake = UserFloatEarnedFromStake;
exports.UserStakeBox = UserStakeBox;
exports.UserMarketStakeOrRedeem = UserMarketStakeOrRedeem;
exports.UserMarketUnstake = UserMarketUnstake;
exports.UserStakesCard = UserStakesCard;
exports.UserFloatCard = UserFloatCard;
/* threeDotsSvg Not a pure module */
