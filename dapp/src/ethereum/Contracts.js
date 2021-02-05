// Generated by ReScript, PLEASE EDIT WITH CARE

import * as Ethers from "./Ethers.js";

var abi = Ethers.makeAbi(["function mint(address,uint256)"]);

function make(address, providerOrSigner) {
  return Ethers.Contract.make(address, abi, providerOrSigner);
}

var TestErc20 = {
  abi: abi,
  make: make
};

var abi$1 = Ethers.makeAbi([
      "function mintLong(uint256 amount)",
      "function mintShort(uint256 amount)",
      "function redeemLong(uint256 tokensToRedeem)",
      "function redeemShort(uint256 tokensToRedeem)",
      "function _updateSystemState()"
    ]);

function make$1(address, providerOrSigner) {
  return Ethers.Contract.make(address, abi$1, providerOrSigner);
}

var LongShort = {
  abi: abi$1,
  make: make$1
};

var abi$2 = Ethers.makeAbi([
      "function approve(address spender, uint256 amount)",
      "function balanceOf(address owner) public view returns (uint256 balance)"
    ]);

function make$2(address, providerOrSigner) {
  return Ethers.Contract.make(address, abi$2, providerOrSigner);
}

var Erc20 = {
  abi: abi$2,
  make: make$2
};

export {
  TestErc20 ,
  LongShort ,
  Erc20 ,
  
}
/* abi Not a pure module */
