const { BN } = require("@openzeppelin/test-helpers");
// const { time } = require("@openzeppelin/test-helpers");

const LONGSHORT_CONTRACT_NAME = "LongShort";
const ERC20_CONTRACT_NAME = "ERC20PresetMinterPauserUpgradeSafe";
const PRICE_ORACLE_NAME = "PriceOracle";
const LONG_COINS = "LongCoins";
const AAVE_LENDING_POOL = "AaveLendingPool";
const LENDING_POOL_ADDRESS_PROVIDER = "LendingPoolAddressesProvider";
const ADAI = "ADai";
const SIMULATED_INSTANT_APY = 10;

const LongShort = artifacts.require(LONGSHORT_CONTRACT_NAME);
const erc20 = artifacts.require(LONG_COINS);
const PriceOracle = artifacts.require(PRICE_ORACLE_NAME);
const AaveLendingPool = artifacts.require(AAVE_LENDING_POOL);
const LendingPoolAddressProvider = artifacts.require(
  LENDING_POOL_ADDRESS_PROVIDER
);
const ADai = artifacts.require(ADAI);

const initialize = async (admin) => {
  // Long and short coins.
  const long = await erc20.new({
    from: admin,
  });
  const short = await erc20.new({
    from: admin,
  });

  // Dai
  const dai = await erc20.new({
    from: admin,
  });
  await dai.initialize("short tokens", "SHORT", {
    from: admin,
  });

  // aDai
  aDai = await ADai.new(dai.address, {
    from: admin,
  });

  // aave lending pool
  aaveLendingPool = await AaveLendingPool.new(
    aDai.address,
    dai.address,
    SIMULATED_INSTANT_APY,
    {
      from: admin,
    }
  );

  lendingPoolAddressProvider = await LendingPoolAddressProvider.new(
    aaveLendingPool.address,
    {
      from: admin,
    }
  );

  const priceOracle = await PriceOracle.new(1, { from: admin });

  const longShort = await LongShort.new(
    long.address,
    short.address,
    dai.address,
    aDai.address,
    lendingPoolAddressProvider.address,
    priceOracle.address,
    {
      from: admin,
    }
  );

  await long.setup("long tokens", "LONG", longShort.address, {
    from: admin,
  });
  await short.setup("short tokens", "SHORT", longShort.address, {
    from: admin,
  });

  return {
    longShort,
    long,
    short,
    dai,
    aDai,
    priceOracle,
    aaveLendingPool,
  };
};

const mintAndApprove = async (token, amount, user, approvedAddress) => {
  let bnAmount = new BN(amount);
  await token.mint(user, bnAmount);
  await token.approve(approvedAddress, bnAmount, {
    from: user,
  });
};

const simulateTotalValueWithInterest = (amount, apy) => {
  let bnAmount = new BN(amount);
  return bnAmount.add(bnAmount.mul(new BN(apy)).div(new BN(100)));
};

const simulateInterestEarned = (amount, apy) => {
  let bnAmount = new BN(amount);
  return bnAmount.mul(new BN(apy)).div(new BN(100));
};

const tokenPriceCalculator = (value, supply) => {
  return new BN(value).mul(new BN("1000000000000000000")).div(new BN(supply));
};

module.exports = {
  initialize,
  ERC20_CONTRACT_NAME,
  mintAndApprove,
  SIMULATED_INSTANT_APY,
  simulateInterestEarned,
  tokenPriceCalculator,
  simulateTotalValueWithInterest,
};
