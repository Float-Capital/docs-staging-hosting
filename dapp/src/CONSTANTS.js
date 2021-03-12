// Generated by ReScript, PLEASE EDIT WITH CARE

import * as Ethers from "ethers";

var zeroAddressStr = "0x0000000000000000000000000000000000000000";

var zeroAddress = Ethers.utils.getAddress(zeroAddressStr);

var zeroBN = Ethers.BigNumber.from(0);

var tenToThe6 = Ethers.BigNumber.from("1000000");

var tenToThe18 = Ethers.BigNumber.from("1000000000000000000");

var tenToThe42 = tenToThe6.mul(tenToThe18).mul(tenToThe18);

var oneHundredEth = Ethers.BigNumber.from("100000000000000000000");

export {
  zeroAddressStr ,
  zeroAddress ,
  zeroBN ,
  tenToThe6 ,
  tenToThe18 ,
  tenToThe42 ,
  oneHundredEth ,
  
}
/* zeroAddress Not a pure module */
