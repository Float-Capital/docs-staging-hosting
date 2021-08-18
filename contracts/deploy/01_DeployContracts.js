const { ethers, getNamedAccounts } = require("hardhat");
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

  const treasury = await deploy(TREASURY, {
    from: deployer,
    proxy: {
      execute: {
        methodName: "initialize",
        args: [admin],
      },
    },
    log: true,
  });

  const floatCapital = await deploy(FLOAT_CAPITAL, {
    from: deployer,
    proxy: {
      execute: {
        methodName: "initialize",
        args: [admin],
      },
    },
    log: true,
  });

  const staker = await deploy(STAKER, {
    from: deployer,
    log: true,
    proxy: {
      initializer: false,
    },
  });

  const longShort = await deploy(LONGSHORT, {
    from: deployer,
    log: true,
    proxy: {
      initializer: false,
    },
  });

  let tokenFactory = await deploy(TOKEN_FACTORY, {
    from: admin,
    log: true,
    args: [longShort.address],
  });

  let floatToken = await deploy(FLOAT_TOKEN, {
    from: deployer,
    log: true,
  });
};
module.exports.tags = ["all", "contracts"];
