// const { BN } = require("@openzeppelin/test-helpers");
// const { time } = require("@openzeppelin/test-helpers");

const LONGSHORT_CONTRACT_NAME = "LongShort";
const ERC20_CONTRACT_NAME = "ERC20PresetMinterPauserUpgradeSafe";
const PRICE_ORACLE_NAME = "PriceOracle";

const LongShort = artifacts.require(LONGSHORT_CONTRACT_NAME);
const erc20 = artifacts.require(ERC20_CONTRACT_NAME);
const PriceOracle = artifacts.require(PRICE_ORACLE_NAME);

const initialize = async (admin) => {
  const long = await erc20.new({
    from: admin,
  });

  const short = await erc20.new({
    from: admin,
  });

  const dai = await erc20.new({
    from: admin,
  });
  await dai.initialize("short tokens", "SHORT", {
    from: admin,
  });

  const priceOracle = await PriceOracle.new(1, { from: admin });

  // Need to give minting rights to long short contract
  await long.initialize("long tokens", "LONG", {
    from: admin,
  });
  await short.initialize("short tokens", "SHORT", {
    from: admin,
  });

  const longShort = await LongShort.new(
    long.address,
    short.address,
    dai.address,
    dai.address,
    dai.address,
    priceOracle.address,
    {
      from: admin,
    }
  );

  return {
    longShort,
    long,
    short,
    dai,
    priceOracle,
  };
};

const mintAndApprove = async (token, amount, user, approvedAddress) => {
  await token.mint(user, amount);
  await token.approve(approvedAddress, amount, {
    from: user,
  });
};

module.exports = {
  initialize,
  ERC20_CONTRACT_NAME,
  mintAndApprove,
};
