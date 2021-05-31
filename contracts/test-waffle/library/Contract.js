// Generated by ReScript, PLEASE EDIT WITH CARE
'use strict';

var Staker = require("./contracts/Staker.js");

function attachToContract(contractName, contractAddress) {
  return ethers.getContractFactory(contractName).then(function (param) {
              return param.attach(contractAddress);
            });
}

function deployContract0(contractName) {
  return ethers.getContractFactory(contractName).then(function (prim) {
                return prim.deploy();
              }).then(function (prim) {
              return prim.deployed();
            });
}

function deployContract1(contractName, firstParam) {
  return ethers.getContractFactory(contractName).then(function (__x) {
                return __x.deploy(firstParam);
              }).then(function (prim) {
              return prim.deployed();
            });
}

function deployContract2(contractName, firstParam, secondParam) {
  return ethers.getContractFactory(contractName).then(function (__x) {
                return __x.deploy(firstParam, secondParam);
              }).then(function (prim) {
              return prim.deployed();
            });
}

function deployContract3(contractName, firstParam, secondParam, thirdParam) {
  return ethers.getContractFactory(contractName).then(function (__x) {
                return __x.deploy(firstParam, secondParam, thirdParam);
              }).then(function (prim) {
              return prim.deployed();
            });
}

var contractName = "SyntheticToken";

function at(contractAddress) {
  return attachToContract(contractName, contractAddress);
}

var SyntheticToken = {
  contractName: contractName,
  at: at
};

var contractName$1 = "ERC20PresetMinterPauser";

function make(name, symbol) {
  return deployContract2(contractName$1, name, symbol);
}

function at$1(contractAddress) {
  return attachToContract(contractName$1, contractAddress);
}

function grantMintRole(t, user) {
  return t.MINTER_ROLE.call().then(function (minterRole) {
              return t.grantRole(minterRole, user);
            });
}

function mintAndApprove(t, user, amount, spender) {
  return t.mint(user.address, amount).then(function (param) {
              return t.connect(user).approve(spender, amount);
            });
}

var PaymentToken = {
  contractName: contractName$1,
  make: make,
  at: at$1,
  grantMintRole: grantMintRole,
  mintAndApprove: mintAndApprove
};

var contractName$2 = "YieldManagerMock";

function make$1(admin, longShortAddress, fundTokenAddress) {
  return deployContract3(contractName$2, admin, longShortAddress, fundTokenAddress);
}

function at$2(contractAddress) {
  return attachToContract(contractName$2, contractAddress);
}

var YieldManagerMock = {
  contractName: contractName$2,
  make: make$1,
  at: at$2
};

var contractName$3 = "OracleManagerMock";

function make$2(admin) {
  return deployContract1(contractName$3, admin);
}

function at$3(contractAddress) {
  return attachToContract(contractName$3, contractAddress);
}

var OracleManagerMock = {
  contractName: contractName$3,
  make: make$2,
  at: at$3
};

var contractName$4 = "TokenFactory";

function make$3(admin, longShort) {
  return deployContract2(contractName$4, admin, longShort);
}

var TokenFactory = {
  contractName: contractName$4,
  make: make$3
};

var contractName$5 = "FloatToken";

function make$4(param) {
  return deployContract0(contractName$5);
}

var FloatToken = {
  contractName: contractName$5,
  make: make$4
};

var contractName$6 = "FloatCapital_v0";

function make$5(param) {
  return deployContract0(contractName$6);
}

var FloatCapital_v0 = {
  contractName: contractName$6,
  make: make$5
};

var contractName$7 = "Treasury_v0";

function make$6(param) {
  return deployContract0(contractName$7);
}

var Treasury_v0 = {
  contractName: contractName$7,
  make: make$6
};

function marketIndexOfSynth(longShort, syntheticToken) {
  return longShort.staker().then(Staker.at).then(function (__x) {
              return __x.marketIndexOfToken(syntheticToken.address);
            });
}

var DataFetchers = {
  marketIndexOfSynth: marketIndexOfSynth
};

exports.attachToContract = attachToContract;
exports.deployContract0 = deployContract0;
exports.deployContract1 = deployContract1;
exports.deployContract2 = deployContract2;
exports.deployContract3 = deployContract3;
exports.SyntheticToken = SyntheticToken;
exports.PaymentToken = PaymentToken;
exports.YieldManagerMock = YieldManagerMock;
exports.OracleManagerMock = OracleManagerMock;
exports.TokenFactory = TokenFactory;
exports.FloatToken = FloatToken;
exports.FloatCapital_v0 = FloatCapital_v0;
exports.Treasury_v0 = Treasury_v0;
exports.DataFetchers = DataFetchers;
/* No side effect */
