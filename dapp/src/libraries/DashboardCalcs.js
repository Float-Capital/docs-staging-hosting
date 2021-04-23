// Generated by ReScript, PLEASE EDIT WITH CARE

import * as Ethers from "../ethereum/Ethers.js";
import * as CONSTANTS from "../CONSTANTS.js";
import * as StakeCard from "../components/Stake/StakeCard.js";
import * as Belt_Array from "rescript/lib/es6/belt_Array.js";
import * as Belt_SortArray from "rescript/lib/es6/belt_SortArray.js";

function trendingStakes(syntheticMarkets, apy) {
  return Belt_Array.slice(Belt_SortArray.stableSortBy(Belt_Array.reduce(syntheticMarkets, [], (function (previous, param) {
                        var match = param.latestSystemState;
                        var totalLockedShort = match.totalLockedShort;
                        var totalLockedLong = match.totalLockedLong;
                        var currentTimestamp = match.timestamp;
                        var timestampCreated = param.timestampCreated;
                        var marketName = param.name;
                        var longApy = StakeCard.basicApyCalc(apy, Number(Ethers.Utils.formatEther(totalLockedLong)), Number(Ethers.Utils.formatEther(totalLockedShort)), "long");
                        var shortApy = StakeCard.basicApyCalc(apy, Number(Ethers.Utils.formatEther(totalLockedLong)), Number(Ethers.Utils.formatEther(totalLockedShort)), "short");
                        var longFloatApy = StakeCard.myfloatCalc(totalLockedLong, totalLockedShort, StakeCard.kperiodHardcode, StakeCard.kmultiplierHardcode, timestampCreated, currentTimestamp, "long");
                        var shortFloatApy = StakeCard.myfloatCalc(totalLockedLong, totalLockedShort, StakeCard.kperiodHardcode, StakeCard.kmultiplierHardcode, timestampCreated, currentTimestamp, "short");
                        return Belt_Array.concat(previous, [
                                    {
                                      marketName: marketName,
                                      isLong: true,
                                      apy: longApy,
                                      floatApy: Number(Ethers.Utils.formatEther(longFloatApy))
                                    },
                                    {
                                      marketName: marketName,
                                      isLong: false,
                                      apy: shortApy,
                                      floatApy: Number(Ethers.Utils.formatEther(shortFloatApy))
                                    }
                                  ]);
                      })), (function (token1, token2) {
                    var match = token1.apy + token1.floatApy;
                    var match$1 = token2.apy + token2.floatApy;
                    if (match < match$1) {
                      return 1;
                    } else if (match$1 > match) {
                      return -1;
                    } else {
                      return 0;
                    }
                  })), 0, 3);
}

function tokenSupplyToTokenValue(tokenPrice, tokenSupply) {
  return tokenSupply.mul(tokenPrice).div(CONSTANTS.tenToThe18);
}

function getTotalSynthValue(totalValueLocked, totalValueStaked) {
  return totalValueLocked.sub(totalValueStaked);
}

function getTotalValueLockedAndTotalStaked(syntheticMarkets) {
  return Belt_Array.reduce(syntheticMarkets, {
              totalValueLocked: CONSTANTS.zeroBN,
              totalValueStaked: CONSTANTS.zeroBN
            }, (function (previous, param) {
                var match = param.latestSystemState;
                return {
                        totalValueLocked: previous.totalValueLocked.add(match.totalValueLocked),
                        totalValueStaked: previous.totalValueStaked.add(tokenSupplyToTokenValue(match.longTokenPrice.price.price, param.syntheticLong.totalStaked)).add(tokenSupplyToTokenValue(match.shortTokenPrice.price.price, param.syntheticShort.totalStaked))
                      };
              }));
}

export {
  trendingStakes ,
  tokenSupplyToTokenValue ,
  getTotalSynthValue ,
  getTotalValueLockedAndTotalStaked ,
  
}
/* Ethers Not a pure module */
