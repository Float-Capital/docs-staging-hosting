const { runTestTransactions } = require("../DeployTests/RunTestTransactions");
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
  console.log("setup contracts");
  const { deploy, log, get } = deployments;
  const { deployer, admin } = await getNamedAccounts();

  /////////////////////////
  //Retrieve Deployments//
  ////////////////////////
  const PaymentToken = await deployments.get(COLLATERAL_TOKEN);
  const paymentToken = await ethers.getContractAt(
    COLLATERAL_TOKEN,
    PaymentToken.address
  );

  const LongShort = await deployments.get(LONGSHORT);
  const longShort = await ethers.getContractAt(LONGSHORT, LongShort.address);

  const Treasury = await deployments.get(TREASURY);
  const treasury = await ethers.getContractAt(TREASURY, Treasury.address);

  const TokenFactory = await deployments.get(TOKEN_FACTORY);
  const tokenFactory = await ethers.getContractAt(
    TOKEN_FACTORY,
    TokenFactory.address
  );

  const Staker = await deployments.get(STAKER);
  const staker = await ethers.getContractAt(STAKER, Staker.address);

  const FloatToken = await deployments.get(FLOAT_TOKEN);
  const floatToken = await ethers.getContractAt(
    FLOAT_TOKEN,
    FloatToken.address
  );

  const FloatCapital = await deployments.get(FLOAT_CAPITAL);
  const floatCapital = await ethers.getContractAt(
    FLOAT_CAPITAL,
    FloatCapital.address
  );
  ///////////////////////////
  //Initialize the contracts/
  ///////////////////////////
  await longShort.initialize(admin, tokenFactory.address, staker.address);

  await floatToken.initialize("Float", "FLT", staker.address);

  await staker.initialize(
    admin,
    longShort.address,
    floatToken.address,
    treasury.address,
    floatCapital.address,
    "250000000000000000" //25%
  );

  console.log("before test txs");
  if (networkName == "mumbai") {
    console.log("mumbai test transactions");
  } else if (networkName == "hardhat" || networkName == "ganache") {
    console.log("mumbai test transactions");
    await runTestTransactions({
      staker,
      longShort: longShort.connect(admin),
      paymentToken,
      treasury,
    });
  }
  console.log("after test txs");
};
module.exports.tags = ["all", "setup"];
