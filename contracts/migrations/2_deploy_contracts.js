const { deployProxy } = require("@openzeppelin/truffle-upgrades");
const {
  admin: { getInstance: getAdminInstance },
} = require("@openzeppelin/truffle-upgrades");

const STAKER = "Staker";
const COLLATERAL_TOKEN = "Dai";
const TREASURY = "Treasury_v0";
const LONGSHORT = "LongShort";
const FLOAT_TOKEN = "FloatToken";
const TOKEN_FACTORY = "TokenFactory";
const FLOAT_CAPITAL = "FloatCapital_v0";

const Staker = artifacts.require(STAKER);
const Treasury = artifacts.require(TREASURY);
const LongShort = artifacts.require(LONGSHORT);
const Dai = artifacts.require(COLLATERAL_TOKEN);
const FloatToken = artifacts.require(FLOAT_TOKEN);
const TokenFactory = artifacts.require(TOKEN_FACTORY);
const FloatCapital = artifacts.require(FLOAT_CAPITAL);

module.exports = async function (deployer, networkName, accounts) {
  if (networkName == "matic") {
    throw "Don't save or run this migration if on mainnet (remove when ready)";
  }

  const admin = accounts[0];

  // No contract migrations for testing.
  if (networkName === "test") {
    return;
  }

  // We use actual bUSD for the BSC testnet instead of fake DAI.
  if (networkName != "binanceTest" && networkName != "kovan") {
    await deployer.deploy(Dai, "dai token", "DAI");
  }


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

  const staker = await deployProxy(Staker, {
    deployer,
    initializer: false /* This is dangerous since someone else could initialize the staker inbetween us. At least we will know if this happens and the migration will fail.*/,
  });

  const longShort = await deployProxy(
    LongShort,
    {
      deployer,
      initializer: false
    }
  );
  await deployer.deploy(TokenFactory, admin, longShort.address, {
    from: admin,
  });
  let tokenFactory = await TokenFactory.deployed();

  await longShort.initialize(admin, treasury.address, tokenFactory.address, staker.address, {
    from: admin,
  });


  await floatToken.initialize("Float token", "FLOAT TOKEN", staker.address, {
    from: admin,
  });

  // Initialize here as there are circular contract dependencies.
  await staker.initialize(
    admin,
    longShort.address,
    floatToken.address,
    floatCapital.address,
    {
      from: admin,
    }
  );

  if (networkName == "kovan") {
    const adminInstance = await getAdminInstance();
    console.log(`To verify all these contracts run the following:
    
    \`truffle run verify TokenFactory FloatToken Treasury_v0@${await adminInstance.getProxyImplementation(
      treasury.address
    )} FloatCapital_v0@${await adminInstance.getProxyImplementation(
      floatCapital.address
    )} Staker@${await adminInstance.getProxyImplementation(
      staker.address
    )} LongShort@${await adminInstance.getProxyImplementation(
      longShort.address
    )} --network kovan\``);
  }
};
