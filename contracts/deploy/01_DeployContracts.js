const { ethers, upgrades, getNamedAccounts } = require("hardhat");
const {
  STAKER,
  COLLATERAL_TOKEN,
  TREASURY,
  LONGSHORT,
  FLOAT_TOKEN,
  TOKEN_FACTORY,
  FLOAT_CAPITAL,
} = require("../helper-hardhat-config");

module.exports = async ({ getNamedAccounts, deployments }) => {
  const { deploy, log } = deployments;
  const { deployer, admin } = await getNamedAccounts();

  let paymentToken;

  if (network.name != "mumbai") {
    console.log(network.name);
    paymentToken = await deploy(COLLATERAL_TOKEN, {
      from: deployer,
      log: true,
      args: ["dai token", "DAI"],
    });
    console.log("dai address", paymentToken.address);
  }

  console.log("Deploying contracts with the account:", deployer);
  console.log("Admin Account:", admin);

  const Treasury = await ethers.getContractFactory(TREASURY);

  const treasury = await upgrades.deployProxy(Treasury, [admin], {
    kind: "uups",
    initializer: "initialize",
  });

  const FloatCapital = await ethers.getContractFactory(FLOAT_CAPITAL);
  const floatCapital = await upgrades.deployProxy(FloatCapital, [admin], {
    kind: "uups",
    initializer: "initialize",
  });

  const Staker = await ethers.getContractFactory(STAKER);

  const staker = await upgrades.deployProxy(Staker, [], {
    kind: "uups",
    initializer: false,
  });

  const LongShort = await ethers.getContractFactory(LONGSHORT);
  const longShort = await upgrades.deployProxy(LongShort, [], {
    kind: "uups",
    initializer: false,
  });

  let tokenFactory = await deploy(TOKEN_FACTORY, {
    from: admin,
    log: true,
    args: [longShort.address],
  });

  let FloatToken = await ethers.getContractFactory(FLOAT_TOKEN);
  let floatToken = await upgrades.deployProxy(FloatToken, [], {
    kind: "uups",
    initializer: false,
  });
};
module.exports.tags = ["all", "contracts"];
