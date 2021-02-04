// Generated by ReScript, PLEASE EDIT WITH CARE

import * as Ethers from "./ethereum/Ethers.js";
import * as Ethers$1 from "ethers";
import * as Js_dict from "bs-platform/lib/es6/js_dict.js";
import * as Belt_Option from "bs-platform/lib/es6/belt_Option.js";

var longshortContractAbi = Ethers.makeAbi([""]);

var allContracts = (require('./contractAddresses.json'));

function getContractAddressString(netIdStr, closure) {
  return Ethers.Utils.toString(Belt_Option.mapWithDefault(Js_dict.get(allContracts, netIdStr), Ethers$1.utils.getAddress("0x0000000000000000000000000000000000000000"), closure));
}

function longShortContractAddress(netIdStr) {
  return Belt_Option.mapWithDefault(Js_dict.get(allContracts, netIdStr), Ethers$1.utils.getAddress("0x0000000000000000000000000000000000000000"), (function (contracts) {
                return contracts.LongShort;
              }));
}

function daiContractAddress(netIdStr) {
  return Belt_Option.mapWithDefault(Js_dict.get(allContracts, netIdStr), Ethers$1.utils.getAddress("0x0000000000000000000000000000000000000000"), (function (contracts) {
                return contracts.Dai;
              }));
}

function longTokenContractAddress(netIdStr) {
  return Belt_Option.mapWithDefault(Js_dict.get(allContracts, netIdStr), Ethers$1.utils.getAddress("0x0000000000000000000000000000000000000000"), (function (contracts) {
                return contracts.LongCoins;
              }));
}

function shortTokenContractAddress(netIdStr) {
  return Belt_Option.mapWithDefault(Js_dict.get(allContracts, netIdStr), Ethers$1.utils.getAddress("0x0000000000000000000000000000000000000000"), (function (contracts) {
                return contracts.ShortCoins;
              }));
}

export {
  longshortContractAbi ,
  allContracts ,
  getContractAddressString ,
  longShortContractAddress ,
  daiContractAddress ,
  longTokenContractAddress ,
  shortTokenContractAddress ,
  
}
/* longshortContractAbi Not a pure module */
