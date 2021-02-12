// Generated by ReScript, PLEASE EDIT WITH CARE

import * as Ethers from "./ethereum/Ethers.js";
import * as Ethers$1 from "ethers";
import * as Js_dict from "bs-platform/lib/es6/js_dict.js";
import * as Constants from "./Constants.js";
import * as Belt_Option from "bs-platform/lib/es6/belt_Option.js";
import * as RootProvider from "./libraries/RootProvider.js";

var longshortContractAbi = Ethers.makeAbi([""]);

var allContracts = (require('./contractAddresses.json'));

function getContractAddressString(netIdStr, closure) {
  return Ethers.Utils.toString(Belt_Option.mapWithDefault(Js_dict.get(allContracts, netIdStr), Constants.zeroAddress, closure));
}

function longShortContractAddress(netIdStr) {
  return Belt_Option.mapWithDefault(Js_dict.get(allContracts, netIdStr), Constants.zeroAddress, (function (contracts) {
                return contracts.LongShort;
              }));
}

function useLongShortAddress(param) {
  return longShortContractAddress(Belt_Option.mapWithDefault(RootProvider.useChainId(undefined), "5", (function (prim) {
                    return String(prim);
                  })));
}

function daiContractAddress(netIdStr) {
  console.log(netIdStr);
  return Ethers$1.utils.getAddress("0x096c8301e153037df723c23e2de113941cb973ef");
}

function useDaiAddress(param) {
  return daiContractAddress(Belt_Option.mapWithDefault(RootProvider.useChainId(undefined), "5", (function (prim) {
                    return String(prim);
                  })));
}

export {
  longshortContractAbi ,
  allContracts ,
  getContractAddressString ,
  longShortContractAddress ,
  useLongShortAddress ,
  daiContractAddress ,
  useDaiAddress ,
  
}
/* longshortContractAbi Not a pure module */
