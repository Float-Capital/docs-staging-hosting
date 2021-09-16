// Generated by ReScript, PLEASE EDIT WITH CARE
'use strict';

var Ethers = require("./Ethers.js");

var abi = Ethers.makeAbi([
      "function mintLongNextPrice(uint32 marketIndex,uint256 amount) @300000",
      "function mintShortNextPrice(uint32 marketIndex,uint256 amount) @300000",
      "function redeemLongNextPrice(uint32 marketIndex,uint256 tokensToRedeem) @300000",
      "function redeemShortNextPrice(uint32 marketIndex,uint256 tokensToRedeem) @300000",
      "function executeOutstandingNextPriceSettlementsUser(address user,uint32 marketIndex) @300000",
      "function updateSystemState()",
      "function updateSystemStateMulti(uint32[] marketIndexes)"
    ]);

function make(address, providerOrSigner) {
  return Ethers.Contract.make(address, abi, providerOrSigner);
}

var LongShort = {
  abi: abi,
  make: make
};

var abi$1 = Ethers.makeAbi([
      "function stake(address tokenAddress, uint256 amount) @6000000",
      "function withdraw(uint32, bool, uint256 amount) @6000000",
      "function claimFloatCustom(uint32[] calldata marketIndexes) @6000000"
    ]);

function make$1(address, providerOrSigner) {
  return Ethers.Contract.make(address, abi$1, providerOrSigner);
}

var Staker = {
  abi: abi$1,
  make: make$1
};

var abi$2 = Ethers.makeAbi([
      "function approve(address spender, uint256 amount) @52000",
      "function balanceOf(address owner) public view returns (uint256 balance)",
      "function allowance(address owner, address spender) public view returns (uint256 remaining)",
      "function mint(uint256 value) public virtual returns (bool)"
    ]);

function make$2(address, providerOrSigner) {
  return Ethers.Contract.make(address, abi$2, providerOrSigner);
}

var Erc20 = {
  abi: abi$2,
  make: make$2
};

var abi$3 = Ethers.makeAbi([
      "function approve(address spender, uint256 amount) @52000",
      "function balanceOf(address owner) public view returns (uint256 balance)",
      "function allowance(address owner, address spender) public view returns (uint256 remaining)",
      "function stake(uint256 amount) external @500000"
    ]);

function make$3(address, providerOrSigner) {
  return Ethers.Contract.make(address, abi$3, providerOrSigner);
}

var Synth = {
  abi: abi$3,
  make: make$3
};

exports.LongShort = LongShort;
exports.Staker = Staker;
exports.Erc20 = Erc20;
exports.Synth = Synth;
/* abi Not a pure module */
