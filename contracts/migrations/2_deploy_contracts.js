// Load zos scripts and truffle wrapper function
const { scripts, ConfigManager } = require("@openzeppelin/cli");
const { add, push, create } = scripts;

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

const deployContracts = async (options, accounts, deployer, networkName) => {
  const admin = accounts[0];

  // No contract migrations for testing.
  if (networkName === "test") {
    return;
  }

  // Handles idempotent deployments for upgradeable contracts using zeppelin.
  // The contract name can change, but alias must remain constant across
  // deployments. Use create(...) to deploy a proxy for an alias.
  add({
    contractsData: [
      { name: LONGSHORT, alias: "LongShort" },
      { name: STAKER, alias: "Staker" },
      { name: TREASURY, alias: "Treasury" },
      { name: FLOAT_CAPITAL, alias: "FloatCapital" },
    ],
  });
  await push({ ...options, force: true });

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

  const treasury = await create({
    ...options,
    contractAlias: "Treasury",
    methodName: "initialize",
    methodArgs: [admin],
  });
  const treasuryInstance = await Treasury.at(treasury.address);

  const floatCapital = await create({
    ...options,
    contractAlias: "FloatCapital",
    methodName: "initialize",
    methodArgs: [admin],
  });
  const floatCapitalInstance = await FloatCapital.at(floatCapital.address);

  const staker = await create({
    ...options,
    contractAlias: "Staker",
  });
  const stakerInstance = await Staker.at(staker.address);

  const longShort = await create({
    ...options,
    contractAlias: "LongShort",
    methodName: "setup",
    methodArgs: [admin, treasury.address, tokenFactory.address, staker.address],
  });
  const longShortInstance = await LongShort.at(longShort.address);

  await tokenFactory.setup(admin, longShort.address, {
    from: admin,
  });

  await floatToken.setup("Float token", "FLOAT TOKEN", staker.address, {
    from: admin,
  });

  // Initialize here as there are circular contract dependencies.
  await stakerInstance.initialize(
    admin,
    longShort.address,
    floatToken.address,
    floatCapital.address,
    {
      from: admin,
    }
  );
};

module.exports = async function(deployer, networkName, accounts) {
  if (networkName == "bsc") {
    throw "Don't save or run this migration if on mainnet (remove when ready)";
  }

  deployer.then(async () => {
    // Initialise openzeppelin for upgradeable contracts.
    const options = await ConfigManager.initNetworkConfiguration({
      network: networkName,
      from: accounts[0],
    });

    await deployContracts(options, accounts, deployer, networkName);
  });
};
