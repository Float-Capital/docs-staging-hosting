const {
  BN,
  expectRevert,
  ether,
  expectEvent,
  balance,
  time,
} = require("@openzeppelin/test-helpers");

const {
  initialize,
  mintAndApprove,
  SIMULATED_INSTANT_APY,
  simulateInterestEarned,
  tokenPriceCalculator,
  simulateTotalValueWithInterest,
  feeCalculation,
} = require("./helpers");

contract("LongShort", (accounts) => {
  let longShort;
  let long;
  let short;
  let dai;
  let priceOracle;
  let aaveLendingPool;

  // Default test values
  const admin = accounts[0];
  const user1 = accounts[1];
  const user2 = accounts[2];
  const user3 = accounts[3];

  const defaultMintAmount = "100000000000000000000"; // 100 dai etc.
  //const defaultMintAmount = "8923490023525451345"; // 100 dai etc.
  const oneUnitInWei = "1000000000000000000";

  beforeEach(async () => {
    const result = await initialize(admin);
    longShort = result.longShort;
    long = result.long;
    short = result.short;
    dai = result.dai;
    priceOracle = result.priceOracle;
    aaveLendingPool = result.aaveLendingPool;

    xyz = async (_amount, _longValue, _shortValue, isLongDeposit) => {
      // check if imbalance or not
      const baseFee = await longShort.baseFee.call();
      const feeMultiplier = await longShort.feeMultiplier.call();
      const minThreshold = await longShort.contractValueWhenScalingFeesKicksIn.call();
      const feeUnitsOfPrecision = await longShort.feeUnitsOfPrecision.call();
      return feeCalculation(
        _amount,
        _longValue,
        _shortValue,
        baseFee,
        feeMultiplier,
        minThreshold,
        feeUnitsOfPrecision,
        isLongDeposit
      );
    };
  });

  it("longshort: No entry fees while one side has no capital (long)", async () => {
    await mintAndApprove(dai, defaultMintAmount, user1, longShort.address);
    await longShort.mintLong(new BN(defaultMintAmount), { from: user1 });

    await mintAndApprove(dai, defaultMintAmount, user2, longShort.address);
    await longShort.mintLong(new BN(defaultMintAmount), { from: user2 });

    await mintAndApprove(dai, defaultMintAmount, user1, longShort.address);
    await longShort.mintLong(new BN(defaultMintAmount), { from: user1 });

    await mintAndApprove(dai, defaultMintAmount, user1, longShort.address);
    await longShort.mintLong(new BN(defaultMintAmount), { from: user1 });

    // Short value should remain zero. No fees being paid. Even though order book imbalance getting larger.
    // The system should refresh and update after minting long tokens and reflect the interest earned by the short side
    const shortValueLocked = await longShort.shortValue.call();
    const shortValueExpected = 0;
    assert.equal(
      shortValueLocked.toString(),
      shortValueExpected.toString(),
      "Short value not correctly shown"
    );
  });

  it("longshort: No entry fees while one side has no capital (short)", async () => {
    await mintAndApprove(dai, defaultMintAmount, user1, longShort.address);
    await longShort.mintShort(new BN(defaultMintAmount), { from: user1 });

    await mintAndApprove(dai, defaultMintAmount, user2, longShort.address);
    await longShort.mintShort(new BN(defaultMintAmount), { from: user2 });

    await mintAndApprove(dai, defaultMintAmount, user1, longShort.address);
    await longShort.mintShort(new BN(defaultMintAmount), { from: user1 });

    await mintAndApprove(dai, defaultMintAmount, user1, longShort.address);
    await longShort.mintShort(new BN(defaultMintAmount), { from: user1 });

    const longValueLocked = await longShort.longValue.call();
    const longValueExpected = 0;
    assert.equal(
      longValueLocked.toString(),
      longValueExpected.toString(),
      "long value not correctly shown"
    );
  });

  // Other Fee cases to consider.
  // (1) 100 initial long. Next a 110 short position comes in.
  // (2) equal order book, full fee should be paid.
  // (3) Imbalance order book, further skewing, full fee should be paid.
  // (4) Imbalance order book, tipping case, partial fee to be paid.

  it("longshort: fees case 2", async () => {
    // Consider APY=0% for initial simplicity.
    await aaveLendingPool.setSimulatedInstantAPY(0, { from: admin });

    await mintAndApprove(dai, defaultMintAmount, user1, longShort.address);
    await longShort.mintShort(new BN(defaultMintAmount), { from: user1 });

    await mintAndApprove(dai, defaultMintAmount, user2, longShort.address);
    await longShort.mintLong(new BN(defaultMintAmount), { from: user2 });

    // Short value before fee
    const shortValBefore = await longShort.shortValue.call();

    // 0.5% fee on this [Fee's don't scale till contract value > $100]
    await mintAndApprove(dai, defaultMintAmount, user3, longShort.address);
    await longShort.mintLong(new BN(defaultMintAmount), { from: user3 });

    const longVal = await longShort.longValue.call();
    const shortVal = await longShort.shortValue.call();
    //console.log(longVal.toString());
    //console.log(shortVal.toString());

    // Something wrong with my zeros
    const expectedFeesForAction = await xyz(
      defaultMintAmount,
      longVal,
      shortVal,
      true
    );
    //console.log(expectedFeesForAction.toString());

    assert.equal(
      shortVal.sub(shortValBefore).toString(),
      expectedFeesForAction.toString(),
      "Fee not correct"
    );
  });
});
