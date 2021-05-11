// Generated by ReScript, PLEASE EDIT WITH CARE
'use strict';


function deployContract(contractName) {
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

var contractName = "LongShort";

function make(param) {
  return deployContract(contractName);
}

var LongShort = {
  contractName: contractName,
  make: make
};

var contractName$1 = "YieldManagerMock";

function make$1(admin, longShortAddress, fundTokenAddress) {
  return deployContract3(contractName$1, admin, longShortAddress, fundTokenAddress);
}

var YieldManagerMock = {
  contractName: contractName$1,
  make: make$1
};

var contractName$2 = "OracleManagerMock";

function make$2(admin) {
  return deployContract1(contractName$2, admin);
}

var OracleManagerMock = {
  contractName: contractName$2,
  make: make$2
};

var contractName$3 = "ERC20PresetMinterPauserUpgradeable";

function make$3(param) {
  return deployContract(contractName$3);
}

var GenericErc20 = {
  contractName: contractName$3,
  make: make$3
};

var contractName$4 = "SyntheticToken";

function make$4(param) {
  return deployContract(contractName$4);
}

var SyntheticToken = {
  contractName: contractName$4,
  make: make$4
};

var contractName$5 = "TokenFactory";

function make$5(admin, longShort) {
  return deployContract2(contractName$5, admin, longShort);
}

var TokenFactory = {
  contractName: contractName$5,
  make: make$5
};

var contractName$6 = "Staker";

function make$6(param) {
  return deployContract(contractName$6);
}

var Staker = {
  contractName: contractName$6,
  make: make$6
};

var contractName$7 = "FloatToken";

function make$7(param) {
  return deployContract(contractName$7);
}

var FloatToken = {
  contractName: contractName$7,
  make: make$7
};

var contractName$8 = "ERC20PresetMinterPauser";

function make$8(name, symbol) {
  return deployContract2(contractName$8, name, symbol);
}

function grantMintRole(t, user) {
  return t.MINTER_ROLE.call().then(function (minterRole) {
              return t.grantRole(minterRole, user);
            });
}

function mintAndApprove(t, user, amount, spender) {
  return t.mint(user, amount).then(function (param) {
              return t.attach(user).approve(spender, amount);
            });
}

var PaymentToken = {
  contractName: contractName$8,
  make: make$8,
  grantMintRole: grantMintRole,
  mintAndApprove: mintAndApprove
};

var contractName$9 = "FloatCapital_v0";

function make$9(param) {
  return deployContract(contractName$9);
}

var FloatCapital_v0 = {
  contractName: contractName$9,
  make: make$9
};

var contractName$10 = "Treasury_v0";

function make$10(param) {
  return deployContract(contractName$10);
}

var Treasury_v0 = {
  contractName: contractName$10,
  make: make$10
};

exports.deployContract = deployContract;
exports.deployContract1 = deployContract1;
exports.deployContract2 = deployContract2;
exports.deployContract3 = deployContract3;
exports.LongShort = LongShort;
exports.YieldManagerMock = YieldManagerMock;
exports.OracleManagerMock = OracleManagerMock;
exports.GenericErc20 = GenericErc20;
exports.SyntheticToken = SyntheticToken;
exports.TokenFactory = TokenFactory;
exports.Staker = Staker;
exports.FloatToken = FloatToken;
exports.PaymentToken = PaymentToken;
exports.FloatCapital_v0 = FloatCapital_v0;
exports.Treasury_v0 = Treasury_v0;
/* No side effect */
