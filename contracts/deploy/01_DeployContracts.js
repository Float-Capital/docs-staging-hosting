const { network } = require("hardhat");
const {
  STAKER,
  COLLATERAL_TOKEN,
  TREASURY,
  TREASURY_ALPHA,
  LONGSHORT,
  FLOAT_TOKEN,
  FLOAT_TOKEN_ALPHA,
  TOKEN_FACTORY,
  FLOAT_CAPITAL,
  isAlphaLaunch
} = require("../helper-hardhat-config");
const mumbaiDaiAddress = "0x001B3B4d0F3714Ca98ba10F6042DaEbF0B1B7b6F";

module.exports = async ({ getNamedAccounts, deployments }) => {
  const { deploy } = deployments;
  // const { deployer, admin } = await getNamedAccounts();
  const accounts = await ethers.getSigners();
  const deployer = accounts[0].address;
  const admin = accounts[1].address;

  let paymentTokenAddress;

  if (network.name != "mumbai") {
    console.log(network.name);
    paymentToken = await deploy(COLLATERAL_TOKEN, {
      from: deployer,
      log: true,
      args: ["dai token", "DAI"],
    });
    console.log("dai address", paymentToken.address);
    paymentTokenAddress = paymentToken.address;
  } else if (network.name === "mumbai") {
    paymentTokenAddress = mumbaiDaiAddress;
  } else {
    throw new Error(`network ${network.name} un-accounted for`)
  }

  console.log("Deploying contracts with the account:", deployer);
  console.log("Admin Account:", admin);

  const floatTokenToUse = isAlphaLaunch ? FLOAT_TOKEN_ALPHA : FLOAT_TOKEN;
  let floatToken = await deploy(floatTokenToUse, {
    from: deployer,
    log: true,
    proxy: {
      proxyContract: "UUPSProxy",
      initializer: false,
    },
  });

  let treasuryToUse = isAlphaLaunch ? TREASURY_ALPHA : TREASURY;
  await deploy(treasuryToUse, {
    from: deployer,
    proxy: {
      proxyContract: "UUPSProxy",
      execute: {
        methodName: "initialize",
        args: [admin, paymentTokenAddress, floatToken.address],
      },
    },
    log: true,
  });

  await deploy(FLOAT_CAPITAL, {
    from: deployer,
    proxy: {
      proxyContract: "UUPSProxy",
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
      proxyContract: "UUPSProxy",
      initializer: false,
    },
  });

  const longShort = await deploy(LONGSHORT, {
    from: deployer,
    log: true,
    proxy: {
      proxyContract: "UUPSProxy",
      initializer: false,
    },
  });
  console.log("StakerDeployed", staker.address)
  console.log("LongShortDeployed", longShort.address)

  await deploy(TOKEN_FACTORY, {
    from: admin,
    log: true,
    args: [longShort.address],
  });
};
module.exports.tags = ["all", "contracts"];
