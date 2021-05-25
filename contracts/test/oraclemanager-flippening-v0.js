const { BN, time } = require("@openzeppelin/test-helpers");
const { assert } = require("chai");

const AggregatorV3 = artifacts.require("AggregatorV3Mock");

const Flippening = artifacts.require("OracleManagerFlippening_V0");

let bn = (a) => new BN(a);

let oneBN = bn(1);
let zeroBN = bn(0);
let twoBN = bn(2);

const tenToThe18 = bn("1000000000000000000");
const oneEth = tenToThe18;

const tenToThe8 = bn("100000000");
const oneBTC = tenToThe8;
const oneDollar = tenToThe8;

let with18Decimals = (int) => bn(int).mul(tenToThe18);
let with8Decimals = (int) => bn(int).mul(tenToThe8);

let asBTC = with8Decimals;
let asETH = with18Decimals;

let asDollars = with8Decimals;

contract("OracleManager (Flippening V0)", (accounts) => {
  // Test users.
  const admin = accounts[0];
  const user = accounts[1];

  let flippening;
  let btcOracle;
  let ethOracle;

  let setupChainlinkOracle = async (decimals, initialPrice) => {
    let oracle = await AggregatorV3.new({ from: admin });
    await oracle.setup(admin, initialPrice, decimals);
    return oracle;
  };

  let setup = async ({
    btcSupply,
    ethSupply,
    btcBlocksPerDay,
    ethBlocksPerDay,
    ethUnclesPerDay,
    btcBlockReward,
    ethBlockReward,
    ethUncleReward,
    ethNephewReward,
    btcPrice,
    ethPrice,
  }) => {
    let defaultOne = (x) => x ?? oneBN;
    btcOracle = await setupChainlinkOracle(8, defaultOne(btcPrice));
    ethOracle = await setupChainlinkOracle(18, defaultOne(ethPrice));

    flippening = await Flippening.new(
      admin,
      btcOracle.address,
      ethOracle.address,
      defaultOne(ethSupply),
      defaultOne(btcSupply),
      defaultOne(btcBlocksPerDay),
      defaultOne(ethBlocksPerDay),
      defaultOne(ethUnclesPerDay),
      defaultOne(btcBlockReward),
      defaultOne(ethBlockReward),
      defaultOne(ethUncleReward),
      defaultOne(ethNephewReward),
      { from: admin }
    );
  };

  let testDominanceDynamic = async ({
    timeIncrease,
    expectedEthSupply,
    expectedBtcSupply,
    ethPriceNew,
    btcPriceNew,
    expectedDominance,
  }) => {
    await btcOracle.setPrice(btcPriceNew);
    await ethOracle.setPrice(ethPriceNew);

    await time.increase(timeIncrease - time.duration.seconds(2)); // one second per tx

    await flippening.updatePrice();

    testEthSupplyStatic(expectedEthSupply);
    testBtcSupplyStatic(expectedBtcSupply);

    let price = await flippening.getLatesPrice.call();

    assert.equal(price.toString(), expectedDominance.toString());
  };

  describe("dominance calc", () => {
    let testDominanceStatic = ({
      btcSupply,
      ethSupply,
      btcPrice,
      ethPrice,
      expectedDominance,
    }) => async () => {
      await setup({ btcSupply, ethSupply, btcPrice, ethPrice });

      // initial dominance determined by set supply and oracle prices
      let price = await flippening.getLatestPrice.call();
      assert.equal(price.toString(), expectedDominance.toString());
    };

    it(
      "identical prices and supplies lead to 50% dominance ratio",
      testDominanceStatic({
        btcSupply: oneBTC,
        ethSupply: oneEth, // one ETH
        btcPrice: oneDollar, // $1
        ethPrice: oneDollar, // $1
        expectedDominance: with18Decimals(50),
      })
    );

    it(
      "btc price increases btc dominance increases",
      testDominanceStatic({
        btcSupply: oneBTC,
        ethSupply: oneEth,
        btcPrice: asDollars(4),
        ethPrice: oneDollar,
        expectedDominance: with18Decimals(80),
      })
    );

    it(
      "eth price increases btc dominance decreases",
      testDominanceStatic({
        btcSupply: oneBTC,
        ethSupply: oneEth,
        btcPrice: oneDollar,
        ethPrice: asDollars(4),
        expectedDominance: with18Decimals(20),
      })
    );

    it(
      "btc supply increases btc dominance increases",
      testDominanceStatic({
        btcSupply: asBTC(4),
        ethSupply: oneEth,
        btcPrice: oneDollar,
        ethPrice: oneDollar,
        expectedDominance: with18Decimals(80),
      })
    );

    it(
      "eth supply increases btc dominance decreases",
      testDominanceStatic({
        btcSupply: oneBTC,
        ethSupply: asETH(4),
        btcPrice: oneDollar,
        ethPrice: oneDollar,
        expectedDominance: with18Decimals(20),
      })
    );
  });

  let testSupplyStatic = async (expectedSupply, supplyFuncCall) => {
    let supply = await supplyFuncCall();
    assert.equal(supply.toString(), expectedSupply.toString());
  };

  describe("btc supply gain", () => {
    let testBtcSupplyStatic = async (expectedSupply) =>
      await testSupplyStatic(expectedSupply, flippening.btcSupply);

    let testBtcSupplyGain = ({
      btcBlocksPerDay,
      btcBlockReward,
      timeIncrease,
      expectedSupplyIncrease,
    }) => async () => {
      await setup({ btcBlocksPerDay, btcBlockReward, btcSupply: zeroBN });
      await time.increase(timeIncrease - time.duration.seconds(1));
      await flippening.updatePrice(); // each tx increments seconds by 1
      await testBtcSupplyStatic(expectedSupplyIncrease);
    };

    describe("increases by blockReward * blocksPerDay per day", () => {
      let twelvePointFiveBTC = tenToThe8.mul(bn(25)).div(twoBN);

      let sixPointTwoFiveBTC = twelvePointFiveBTC.div(twoBN);
      it(
        "sanity check",
        testBtcSupplyGain({
          btcBlocksPerDay: oneBN,
          btcBlockReward: twelvePointFiveBTC,
          timeIncrease: time.duration.days(1),
          expectedSupplyIncrease: twelvePointFiveBTC,
        })
      );

      it(
        "block reward decreases, supply change decreases",
        testBtcSupplyGain({
          btcBlocksPerDay: oneBN,
          btcBlockReward: sixPointTwoFiveBTC,
          timeIncrease: time.duration.days(1),
          expectedSupplyIncrease: sixPointTwoFiveBTC,
        })
      );

      it(
        "blocks per day increase, supply change increases",
        testBtcSupplyGain({
          btcBlocksPerDay: twoBN,
          btcBlockReward: twelvePointFiveBTC,
          timeIncrease: time.duration.days(1),
          expectedSupplyIncrease: asBTC(25),
        })
      );
    });

    describe("increases linearly over time", async () => {
      it(
        "case less than a day",
        testBtcSupplyGain({
          btcBlocksPerDay: twoBN,
          btcBlockReward: asBTC(8),
          timeIncrease: time.duration.hours(12),
          expectedSupplyIncrease: asBTC(8),
        })
      );

      it(
        "case more than a day",
        testBtcSupplyGain({
          btcBlocksPerDay: twoBN,
          btcBlockReward: asBTC(8),
          timeIncrease: time.duration.hours(36),
          expectedSupplyIncrease: asBTC(24),
        })
      );
    });
  });

  describe("eth supply gain", () => {
    let testEthSupplyStatic = async (expectedSupply) =>
      await testSupplyStatic(expectedSupply, flippening.ethSupply);

    let testEthSupplyGain = ({
      ethBlocksPerDay,
      ethBlockReward,
      ethNephewReward,
      ethUncleReward,
      ethUnclesPerDay,
      timeIncrease,
      expectedSupplyIncrease,
    }) => async () => {
      await setup({
        ethBlocksPerDay,
        ethBlockReward,
        ethNephewReward,
        ethUncleReward,
        ethUnclesPerDay,
        ethSupply: zeroBN,
      });
      await time.increase(timeIncrease - time.duration.seconds(1));
      await flippening.updatePrice(); // each tx increments seconds by 1
      await testEthSupplyStatic(expectedSupplyIncrease);
    };

    describe("increases by blockReward * blocksPerDay + (uncleReward + nephewReward) * unclesPerDay per day", () => {
      let defaultUncleReward = oneEth.mul(bn(3)).div(bn(4)); // 0.75 ETH
      let halfUncleReward = defaultUncleReward.div(twoBN);
      let defaultNephewReward = oneEth.div(bn(32));
      let pointFiveEth = oneEth.div(twoBN);
      it(
        "sanity check",
        testEthSupplyGain({
          ethBlocksPerDay: oneBN,
          ethUnclesPerDay: oneBN,
          ethBlockReward: oneEth, // 1 ETH
          ethUncleReward: defaultUncleReward,
          ethNephewReward: defaultNephewReward,
          timeIncrease: time.duration.days(1),
          expectedSupplyIncrease: oneEth
            .add(defaultUncleReward)
            .add(defaultNephewReward),
        })
      );

      it(
        "block reward decreases, supply change decreases",
        testEthSupplyGain({
          ethBlocksPerDay: oneBN,
          ethUnclesPerDay: oneBN,
          ethBlockReward: pointFiveEth, // 0.5 ETH
          ethUncleReward: defaultUncleReward, // 0.75 ETH
          ethNephewReward: defaultNephewReward, // 1/32 ETH,
          timeIncrease: time.duration.days(1),
          expectedSupplyIncrease: pointFiveEth
            .add(defaultUncleReward)
            .add(defaultNephewReward),
        })
      );

      it(
        "blocks per day increase, supply change increases",
        testEthSupplyGain({
          ethBlocksPerDay: twoBN,
          ethUnclesPerDay: oneBN,
          ethBlockReward: pointFiveEth,
          ethUncleReward: defaultUncleReward, // 0.75 ETH
          ethNephewReward: defaultNephewReward, // 1/32 ETH,
          timeIncrease: time.duration.days(1),
          expectedSupplyIncrease: oneEth
            .add(defaultUncleReward)
            .add(defaultNephewReward),
        })
      );

      it(
        "uncles per day increases, supply change increases",
        testEthSupplyGain({
          ethBlocksPerDay: oneBN,
          ethUnclesPerDay: twoBN,
          ethBlockReward: oneEth,
          ethUncleReward: defaultUncleReward, // 0.75 ETH
          ethNephewReward: defaultNephewReward, // 1/32 ETH,
          timeIncrease: time.duration.days(1),
          expectedSupplyIncrease: oneEth.add(
            twoBN.mul(defaultUncleReward.add(defaultNephewReward))
          ),
        })
      );

      it(
        "uncle reward decreases, supply change decreases",
        testEthSupplyGain({
          ethBlocksPerDay: oneBN,
          ethUnclesPerDay: oneBN,
          ethBlockReward: oneEth,
          ethUncleReward: halfUncleReward, // 0.75 ETH
          ethNephewReward: defaultNephewReward, // 1/32 ETH,
          timeIncrease: time.duration.days(1),
          expectedSupplyIncrease: oneEth
            .add(halfUncleReward)
            .add(defaultNephewReward),
        })
      );

      // TO DO: NEPHEW TEST + OTHER. FINAL INTEGRATION TEST WOULD BE NICE

      // it(
      //   "blocks increase, supply increases",
      //   testBtcSupplyGain({
      //     btcBlocksPerDay: twoBN,
      //     btcBlockReward: asBTC(2),
      //     timeIncrease: time.duration.days(1),
      //     expectedSupplyIncrease: asBTC(4),
      //   })
      // );
    });
  });
});
