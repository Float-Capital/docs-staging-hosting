const { BN } = require("@openzeppelin/test-helpers");
const { assertion } = require("@openzeppelin/test-helpers/src/expectRevert");

const ChainlinkOracle = artifacts.require("OracleManagerChainlink");
const AggregatorV3 = artifacts.require("AggregatorV3Mock");

contract("OracleManager (ChainLink)", (accounts) => {
  // Test users.
  const admin = accounts[0];
  const user = accounts[1];

  const twoBN = new BN(2);
  const tenBN = new BN(10);

  // Utility bignum.js constants.
  const one = new BN("1000000000000000000");
  const two = one.mul(twoBN);
  const oneTenth = one.div(tenBN);

  const tenToThe8 = new BN("100000000");
  const twoTenToThe8 = tenToThe8.mul(twoBN);
  const tenToThe8Over10 = tenToThe8.div(tenBN);

  const tenToThe20 = new BN("100000000000000000000");
  const twoTenToThe20 = tenToThe20.mul(twoBN);
  const tenToThe20Over10 = tenToThe20.div(tenBN);

  let oracleTest = ({
    aggregatorDecimals,
    initialAggregatorPrice,
    initialOraclePrice,
    finalOraclePrice,
    aggregatorPriceToChangeTo,
  }) => {
    return async () => {
      let aggregator = await AggregatorV3.new({ from: admin });
      await aggregator.setup(admin, initialAggregatorPrice, aggregatorDecimals);
      let oracle = await ChainlinkOracle.new(admin, aggregator.address);

      let initialPrice = await oracle.getLatestPrice.call();
      assert.equal(
        initialOraclePrice.toString(),
        initialPrice.toString(),
        "initial oracle price wrong"
      );

      // Set the band oracle to our given rates.
      await aggregator.setPrice(aggregatorPriceToChangeTo);

      let newPrice = await oracle.updatePrice.call();
      assert.equal(
        newPrice.toString(),
        finalOraclePrice.toString(),
        "final price of oracle was wrong"
      );
    };
  };

  it(
    "if prices don't change, neither should the oracle",
    oracleTest({
      aggregatorDecimals: 18,
      initialAggregatorPrice: one,
      initialOraclePrice: one,
      aggregatorPriceToChangeTo: one,
      finalOraclePrice: one,
    })
  );

  it(
    "if aggregate price increases, so does oracle price",
    oracleTest({
      aggregatorDecimals: 18,
      initialAggregatorPrice: one,
      initialOraclePrice: one,
      aggregatorPriceToChangeTo: two,
      finalOraclePrice: two,
    })
  );

  it(
    "if aggregate price decreases, so does oracle price",
    oracleTest({
      aggregatorDecimals: 18,
      initialAggregatorPrice: one,
      initialOraclePrice: one,
      aggregatorPriceToChangeTo: oneTenth,
      finalOraclePrice: oneTenth,
    })
  );

  it("prices are normalized to 18 decimals (case less decimals)", async () => {
    await oracleTest({
      aggregatorDecimals: 8,
      initialAggregatorPrice: tenToThe8,
      initialOraclePrice: one,
      aggregatorPriceToChangeTo: tenToThe8,
      finalOraclePrice: one,
    })();

    await oracleTest({
      aggregatorDecimals: 8,
      initialAggregatorPrice: tenToThe8,
      initialOraclePrice: one,
      aggregatorPriceToChangeTo: twoTenToThe8,
      finalOraclePrice: two,
    })();

    await oracleTest({
      aggregatorDecimals: 8,
      initialAggregatorPrice: tenToThe8,
      initialOraclePrice: one,
      aggregatorPriceToChangeTo: tenToThe8Over10,
      finalOraclePrice: oneTenth,
    })();
  });

  it("prices are normalized to 18 decimals (case more decimals)", async () => {
    await oracleTest({
      aggregatorDecimals: 20,
      initialAggregatorPrice: tenToThe20,
      initialOraclePrice: one,
      aggregatorPriceToChangeTo: tenToThe20,
      finalOraclePrice: one,
    })();

    await oracleTest({
      aggregatorDecimals: 20,
      initialAggregatorPrice: tenToThe20,
      initialOraclePrice: one,
      aggregatorPriceToChangeTo: twoTenToThe20,
      finalOraclePrice: two,
    })();

    await oracleTest({
      aggregatorDecimals: 20,
      initialAggregatorPrice: tenToThe20,
      initialOraclePrice: one,
      aggregatorPriceToChangeTo: tenToThe20Over10,
      finalOraclePrice: oneTenth,
    })();
  });
});
