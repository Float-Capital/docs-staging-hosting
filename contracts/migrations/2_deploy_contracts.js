const { deployProxy } = require("@openzeppelin/truffle-upgrades");

const STAKER = "Staker";
const SYNTHETIC_TOKEN = "Dai";
const TREASURY = "Treasury_v0";
const LONGSHORT = "LongShort";
const FLOAT_TOKEN = "FloatToken";
const TOKEN_FACTORY = "TokenFactory";
const FLOAT_CAPITAL = "FloatCapital_v0";

const Staker = artifacts.require(STAKER);
const Treasury = artifacts.require(TREASURY);
const LongShort = artifacts.require(LONGSHORT);
const Dai = artifacts.require(SYNTHETIC_TOKEN);
const FloatToken = artifacts.require(FLOAT_TOKEN);
const TokenFactory = artifacts.require(TOKEN_FACTORY);
const FloatCapital = artifacts.require(FLOAT_CAPITAL);

module.exports = async function(deployer, networkName, accounts) {
  if (networkName == "bsc") {
    throw "Don't save or run this migration if on mainnet (remove when ready)";
  }

  const admin = accounts[0];

  // No contract migrations for testing.
  if (networkName === "test") {
    return;
  }

  // We use actual bUSD for the BSC testnet instead of fake DAI.
  if (networkName != "binanceTest") {
    await deployer.deploy(Dai);
    let dai = await Dai.deployed();
    await dai.initialize("dai token", "DAI");
  }

  await deployer.deploy(TokenFactory);
  let tokenFactory = await TokenFactory.deployed();

  await deployer.deploy(FloatToken);
  let floatToken = await FloatToken.deployed();

  const treasury = await deployProxy(Treasury, [admin], {
    deployer,
    initializer: "initialize",
  });

  const floatCapital = await deployProxy(FloatCapital, [admin], {
    deployer,
    initializer: "initialize",
  });

  const staker = await deployProxy(EmptyPlaceholderContract, {
    deployer,
    initializer: false,
  });

  const longShort = await deployProxy(
    LongShort,
    [admin, treasury.address, tokenFactory.address, staker.address],
    {
      deployer,
      initializer: "setup",
    }
  );

  await tokenFactory.setup(admin, longShort.address, {
    from: admin,
  });

  await floatToken.setup("Float token", "FLOAT TOKEN", staker.address, {
    from: admin,
  });

  // Initialize here as there are circular contract dependencies.
  await upgradeProxy(staker.address, BoxV2, [
  	admin,
    longShort.address,
    floatToken.address,
    floatCapital.address,
], Staker, { deployer });
    floatCapital.address,
    {
      from: admin,
    }
  );
};
