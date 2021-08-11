const { deployProxy } = require("@openzeppelin/truffle-upgrades");
const STAKER = "Staker";
const COLLATERAL_TOKEN = "Dai";
const TREASURY = "Treasury_v0";
const LONGSHORT = "LongShort";
const FLOAT_TOKEN = "FloatToken";
const TOKEN_FACTORY = "TokenFactory";
const FLOAT_CAPITAL = "FloatCapital_v0";

async function main() {
  const Staker = await ethers.getContractFactory(STAKER);
  const Treasury = await ethers.getContractFactory(TREASURY);
  const LongShort = await ethers.getContractFactory(LONGSHORT);
  const DAI = await ethers.getContractFactory(COLLATERAL_TOKEN);
  const FloatToken = await ethers.getContractFactory(FLOAT_TOKEN);
  const TokenFactory = await ethers.getContractFactory(TOKEN_FACTORY);
  const FloatCapital = await ethers.getContractFactory(FLOAT_CAPITAL);

  if (network.name == "matic") {
    throw "Don't save or run this migration if on mainnet (remove when ready)";
  }

  const [deployer, admin] = await ethers.getSigners();

  // No contract migrations for testing.
  if (network.name === "test") {
    return;
  }

  // We use actual bUSD for the BSC testnet instead of fake DAI.
  if (network.name != "mumbai") {
    console.log(network.name);
    let Dai = await DAI.deploy("dai token", "DAI");
    console.log("dai address", Dai.address);
  }

  console.log("Deploying contracts with the account:", deployer.address);
  console.log("Admin Account:", admin.address);
  console.log("Account balance:", (await deployer.getBalance()).toString());
  let floatToken = await FloatToken.deploy();
  await floatToken.deployed();

  const treasury = await upgrades.deployProxy(Treasury, [admin.address]);
  await treasury.deployed();

  const floatCapital = await upgrades.deployProxy(FloatCapital, [
    admin.address,
  ]);
  await floatCapital.deployed();

  const staker = await upgrades.deployProxy(Staker, {
    deployer,
    initializer: false /* This is dangerous since someone else could initialize the staker inbetween us. At least we will know if this happens and the migration will fail.*/,
  });
  await staker.deployed();

  const longShort = await upgrades.deployProxy(LongShort, {
    deployer,
    initializer: false,
  });
  await longShort.deployed();

  let tokenFactory = await TokenFactory.connect(admin).deploy(
    longShort.address
  );
  await tokenFactory.deployed();

  await longShort
    .connect(admin)
    .initialize(
      admin.address,
      treasury.address,
      tokenFactory.address,
      staker.address
    );
  await floatToken
    .connect(admin)
    .initializeFloatToken("Float token", "FLOAT TOKEN", staker.address);

  // Initialize here as there are circular contract dependencies.
  await staker.connect(admin).initialize(
    admin.address,
    longShort.address,
    floatToken.address,
    treasury.address,
    floatCapital.address,
    "250000000000000000" //25%
  );
  console.log("floatToken address:", floatToken.address);
  console.log("treasury address:", treasury.address);
  console.log("floatCapital address:", floatCapital.address);
  console.log("staker address:", staker.address);
  console.log("longShort address:", longShort.address);
  console.log("tokenFactory address:", tokenFactory.address);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
