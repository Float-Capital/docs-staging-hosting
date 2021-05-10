const {
  admin: { getInstance: getAdminInstance },
} = require("@openzeppelin/truffle-upgrades");

const hardhat = require("hardhat")

const STAKER = "Staker";
const TREASURY = "Treasury_v0";
const LONGSHORT = "LongShort";
const FLOAT_TOKEN = "FloatToken";
const TOKEN_FACTORY = "TokenFactory";
const FLOAT_CAPITAL = "FloatCapital_v0";

const Staker = artifacts.require(STAKER);
const Treasury = artifacts.require(TREASURY);
const LongShort = artifacts.require(LONGSHORT);
const FloatToken = artifacts.require(FLOAT_TOKEN);
const TokenFactory = artifacts.require(TOKEN_FACTORY);
const FloatCapital = artifacts.require(FLOAT_CAPITAL);

module.exports = async function (deployer, networkName, accounts) {
  const adminInstance = await getAdminInstance();

  if (networkName == "mumbai") {
    const adminInstance = await getAdminInstance();
    console.log(`To verify all these contracts run the following:

    hardhat [GLOBAL OPTIONS] tenderly:verify ...contracts
    
    \`hardhat --network ${networkName} tenderly:verify TokenFactory=${(await TokenFactory.deployed()).address} FloatToken=${(await FloatToken.deployed()).address} Treasury_v0=${await adminInstance.getProxyImplementation(
      (await Treasury.deployed()).address
    )} LongShort=${await adminInstance.getProxyImplementation(
      (await LongShort.deployed()).address
    )} FloatCapital_v0=${await adminInstance.getProxyImplementation(
      (await FloatCapital.deployed()).address
    )} Staker=${await adminInstance.getProxyImplementation(
      (await Staker.deployed()).address
    )}\``);
  }

  /* KEPT ONLY AS REFERENCE - Since we will be moving to hardhat in the future.
  await hardhat.tenderly.verify(...contracts)
  */

  throw Error("running migrations")
};
