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
      "function mintLong(uint256 marketIndex,uint256 amount)",
      "function mintShort(uint256 marketIndex,uint256 amount)",
      "function redeemLong(uint256 marketIndex,uint256 tokensToRedeem)",
      "function redeemShort(uint256 marketIndex,uint256 tokensToRedeem)",
      "function mintLongAndStake(uint256 marketIndex, uint256 amount) @1000000",
      "function mintShortAndStake(uint256 marketIndex, uint256 amount) @1000000",
      "function _updateSystemState()",
      "function longValue(uint256 marketIndex) public view returns (uint256)",
      "function shortValue(uint256 marketIndex) public view returns (uint256)"
    ]);

function make$1(address, providerOrSigner) {
  return Ethers.Contract.make(address, abi$1, providerOrSigner);
}

var LongShort = {
  abi: abi$1,
  make: make$1
};

var abi$2 = Ethers.makeAbi([
      "function stake(address tokenAddress, uint256 amount)",
      "function stakeAndEarnImmediately(address tokenAddress, uint256 amount)  @1200000",
      "function withdraw(address tokenAddress, uint256 amount)",
      "function claimFloat(address[] memory tokenAddresses)",
      "function claimFloatImmediately(address tokenAddress) @1200000"
    ]);

function make$2(address, providerOrSigner) {
  return Ethers.Contract.make(address, abi$2, providerOrSigner);
}

var Staker = {
  abi: abi$2,
  make: make$2
};

var abi$3 = Ethers.makeAbi([
      "function approve(address spender, uint256 amount) @100000",
      "function balanceOf(address owner) public view returns (uint256 balance)",
      "function allowance(address owner, address spender) public view returns (uint256 remaining)"
    ]);

function make$3(address, providerOrSigner) {
  return Ethers.Contract.make(address, abi$3, providerOrSigner);
}

var Erc20 = {
  abi: abi$3,
  make: make$3
};

export {
  TestErc20 ,
  LongShort ,
  Staker ,
  Erc20 ,
  
}
/* abi Not a pure module */
