const { runTestTransactions } = require("../deployTests/RunTestTransactions");
const {
  runMumbaiTransactions,
} = require("../deployTests/RunMumbaiTransactions");
const { ethers } = require("hardhat");

const {
  STAKER,
  COLLATERAL_TOKEN,
  TREASURY,
  LONGSHORT,
  FLOAT_TOKEN,
  TOKEN_FACTORY,
  FLOAT_CAPITAL,
  isAlphaLaunch,
  FLOAT_TOKEN_ALPHA,
  TREASURY_ALPHA
} = require("../helper-hardhat-config");

module.exports = async (hardhatDeployArguments) => {
  console.log("setup contracts");
  const { getNamedAccounts, deployments } = hardhatDeployArguments;
  const { deployer, admin } = await getNamedAccounts();


  ////////////////////////
  //Retrieve Deployments//
  ////////////////////////
  console.log("1");
  let paymentTokenAddress;
  if (network.name == "mumbai") {
    paymentTokenAddress = "0x001B3B4d0F3714Ca98ba10F6042DaEbF0B1B7b6F";
  } else if (network.name == "hardhat" || network.name == "ganache") {
    paymentTokenAddress = (await deployments.get(COLLATERAL_TOKEN)).address;
  }
  const paymentToken = await ethers.getContractAt(
    COLLATERAL_TOKEN,
    paymentTokenAddress
  );


  console.log("2");
  const LongShort = await deployments.get(LONGSHORT);
  const longShort = await ethers.getContractAt(LONGSHORT, LongShort.address);

  let treasuryToUse = isAlphaLaunch ? TREASURY_ALPHA : TREASURY;
  const Treasury = await deployments.get(treasuryToUse);
  const treasury = await ethers.getContractAt(treasuryToUse, Treasury.address);

  const TokenFactory = await deployments.get(TOKEN_FACTORY);
  const tokenFactory = await ethers.getContractAt(
    TOKEN_FACTORY,
    TokenFactory.address
  );

  const Staker = await deployments.get(STAKER);
  const staker = await ethers.getContractAt(STAKER, Staker.address);
  console.log("3", longShort.address, staker.address);

  const floatTokenToUse = isAlphaLaunch ? FLOAT_TOKEN_ALPHA : FLOAT_TOKEN;
  const FloatToken = await deployments.get(floatTokenToUse);
  const floatToken = await ethers.getContractAt(
    floatTokenToUse,
    FloatToken.address
  );
  console.log("4");

  const FloatCapital = await deployments.get(FLOAT_CAPITAL);
  const floatCapital = await ethers.getContractAt(
    FLOAT_CAPITAL,
    FloatCapital.address
  );
  // ///////////////////////////
  // //Initialize the contracts/
  // ///////////////////////////
  // await longShort.initialize(admin, tokenFactory.address, staker.address);
  // console.log({ admin })
  // console.log("5 - deployer is admin", await longShort.isAdmin(deployer));
  // console.log("5 - is admin", await longShort.isAdmin(admin));
  // console.log("5 - is default admin", await longShort.isDefaultAdmin(admin));

  // if (isAlphaLaunch) {
  //   await floatToken.initialize("Alpha Float", "alphaFLT", staker.address, treasury.address);
  // } else {
  //   await floatToken.initialize("Float", "FLT", staker.address);
  // }
  // await staker.initialize(
  //   admin,
  //   longShort.address,
  //   floatToken.address,
  //   treasury.address,
  //   floatCapital.address,
  //   "100000000000000", // mint an additional 0.01% for the treasury - just for testing purposes
  // );

  console.log("before test txs");
  // throw "dont deploy"
  if (network.name == "mumbai") {
    console.log("mumbai test transactions");
    await runMumbaiTransactions({
      staker,
      longShort: longShort.connect(admin),
      paymentToken,
      treasury,
    }, hardhatDeployArguments);
  } else if (network.name == "hardhat" || network.name == "ganache") {
    console.log("mumbai test transactions");
    await runTestTransactions({
      staker,
      longShort: longShort.connect(admin),
      paymentToken,
      treasury,
    }, hardhatDeployArguments);
  }
  console.log("after test txs");
};
module.exports.tags = ["all", "setup"];


/*
(0) 0x738edd7F6a625C02030DbFca84885b4De5252903 (100 ETH)
(1) 0x2740EA9F72B23372621D8D718F52609b80c24E61 (100 ETH)
(2) 0xB33f20b5579f263831451401951B426ffE32Db2d (100 ETH)
(3) 0x24B1eb0aE57C93EF71B2428661F45f3F6296E95E (100 ETH)
(4) 0xD7aa05D92Aff145536Dc0de089852B81ad5e369C (100 ETH)
(5) 0x7ff0C9501BBB856d7814594A770Bd2f07C428235 (100 ETH)

*/
