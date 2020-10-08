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
  let baseFee;

  // Default test values
  const admin = accounts[0];
  const user1 = accounts[1];
  const user2 = accounts[2];
  const user3 = accounts[3];

  const tenToThe18 = "000000000000000000";
  const tenMintAmount = "1" + tenToThe18; // 100 dai etc.
  const oneHundredMintAmount = "100" + tenToThe18; // 100 dai etc.
  const defaultMintAmount = oneHundredMintAmount;
  const tenThousandMintAmount = "10000" + tenToThe18; // 100 dai etc.
  const fiftyThousandMintAmount = "50000" + tenToThe18; // 100 dai etc.
  const oneHundredThousandMintAmount = "100000" + tenToThe18; // 100 dai etc.
  //const defaultMintAmount = "8923490023525451345"; // 100 dai etc.
  const oneUnitInWei = "1" + tenToThe18;

  beforeEach(async () => {
    const result = await initialize(admin);
    longShort = result.longShort;
    long = result.long;
    short = result.short;
    dai = result.dai;
    priceOracle = result.priceOracle;
    aaveLendingPool = result.aaveLendingPool;
    baseFee = await longShort.baseFee.call();
    getShortBeta = async () => await longShort.getShortBeta.call();
    getLongBeta = async () => await longShort.getLongBeta.call();

    feeCalc = async (
      _amount,
      _longValue,
      _shortValue,
      isLongDeposit,
      thinBeta = 1
    ) => {
      // check if imbalance or not
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
        isLongDeposit,
        thinBeta
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

  it("longshort: Tipping the order book first entry, partial fee on imbalance amount", async () => {
    // Consider APY=0% for initial simplicity.
    await aaveLendingPool.setSimulatedInstantAPY(0, { from: admin });

    await mintAndApprove(dai, defaultMintAmount, user1, longShort.address);
    await longShort.mintLong(new BN(defaultMintAmount), { from: user1 });

    const longVal = await longShort.longValue.call();
    const shortVal = await longShort.shortValue.call();

    const additionalMintAmount = new BN(defaultMintAmount).add(
      new BN(tenMintAmount)
    ); // 110

    await mintAndApprove(dai, additionalMintAmount, user2, longShort.address);

    await longShort.mintShort(new BN(additionalMintAmount), { from: user2 });

    const newShortVal = await longShort.shortValue.call();

    const shortValueExpected = additionalMintAmount.sub(newShortVal);

    const expectedFeesForAction = await feeCalc(
      additionalMintAmount,
      longVal,
      shortVal,
      false
    );

    assert.equal(
      shortValueExpected.toString(),
      expectedFeesForAction.toString(),
      "Fee not correct"
    );
  });

  it("longshort: Equalize the order book, full fee should be paid.", async () => {
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

    // Something wrong with my zeros
    const expectedFeesForAction = await feeCalc(
      defaultMintAmount,
      longVal,
      shortVal,
      true
    );

    assert.equal(
      shortVal.sub(shortValBefore).toString(),
      expectedFeesForAction.toString(),
      "Fee not correct"
    );
  });

  it("longshort: Imbalance order book, further skewing, full fee should be paid", async () => {
    // Consider APY=0% for initial simplicity.
    await aaveLendingPool.setSimulatedInstantAPY(0, { from: admin });

    await mintAndApprove(dai, defaultMintAmount, user1, longShort.address);
    await longShort.mintLong(new BN(defaultMintAmount), { from: user1 });

    const additionalMintAmount = new BN(defaultMintAmount).add(
      new BN(tenMintAmount)
    ); // 110

    await mintAndApprove(
      dai,
      additionalMintAmount.mul(new BN(2)), // extra minted for user 2
      user2,
      longShort.address
    );

    await longShort.mintShort(new BN(additionalMintAmount), { from: user2 });

    const longVal = await longShort.longValue.call();
    const shortVal = await longShort.shortValue.call();

    // Imbalanced orderbook to the short side, (100 + imbalance fee) - (110 - imbalance fee)

    await longShort.mintShort(new BN(defaultMintAmount), { from: user2 });

    // further skewed orderbook to thin side

    const newShortVal = await longShort.shortValue.call();

    const shortValueExpected = new BN(defaultMintAmount).sub(
      newShortVal.sub(shortVal)
    );

    const expectedFeesForAction = await feeCalc(
      defaultMintAmount,
      longVal,
      shortVal,
      false
    );

    assert.equal(
      shortValueExpected.toString(),
      expectedFeesForAction.toString(),
      "Fee not correct"
    );
  });

  it("longshort: Tipping the order book back, partial fee on imbalance amount", async () => {
    // Consider APY=0% for initial simplicity.
    await aaveLendingPool.setSimulatedInstantAPY(0, { from: admin });

    const additionalMintAmount = new BN(defaultMintAmount).add(
      new BN(tenMintAmount)
    ); // 110

    await mintAndApprove(
      dai,
      additionalMintAmount.mul(new BN(2)), // extra minted for user 1
      user1,
      longShort.address
    );
    await longShort.mintLong(new BN(defaultMintAmount), { from: user1 });

    await mintAndApprove(dai, additionalMintAmount, user2, longShort.address);
    await longShort.mintShort(new BN(additionalMintAmount), { from: user2 });

    // Imbalanced orderbook to the short side, (100 + imbalance fee) - (110 - imbalance fee)

    const longVal = await longShort.longValue.call();
    const shortVal = await longShort.shortValue.call();

    const furtherImbalanceMintAmount = new BN(tenMintAmount).add(
      new BN(tenMintAmount)
    ); // 20

    await longShort.mintLong(new BN(furtherImbalanceMintAmount), {
      from: user1,
    });

    // Imbalanced orderbook back to the long side (tipped)

    const newLongVal = await longShort.longValue.call();

    const longValueFeesFromContract = new BN(furtherImbalanceMintAmount).sub(
      newLongVal.sub(longVal)
    );

    const expectedFeesForAction = await feeCalc(
      furtherImbalanceMintAmount,
      longVal,
      shortVal,
      true
    );

    assert.equal(
      longValueFeesFromContract.toString(),
      expectedFeesForAction.toString(),
      "Fee not correct"
    );
  });

  it("longshort: Total value on both sides is equal to total deposits after fee mechanism adjustments (tipping)", async () => {
    // Consider APY=0% for initial simplicity.
    await aaveLendingPool.setSimulatedInstantAPY(0, { from: admin });

    await mintAndApprove(dai, defaultMintAmount, user1, longShort.address);
    await longShort.mintLong(new BN(defaultMintAmount), { from: user1 });

    const additionalMintAmount = new BN(defaultMintAmount).add(
      new BN(tenMintAmount)
    ); // 110

    await mintAndApprove(dai, additionalMintAmount, user2, longShort.address);

    await longShort.mintShort(new BN(additionalMintAmount), { from: user2 });

    const longVal = await longShort.longValue.call();
    const shortVal = await longShort.shortValue.call();

    const totalValue = longVal.add(shortVal);
    const totalDeposited = additionalMintAmount.add(new BN(defaultMintAmount));

    assert.equal(
      totalValue.toString(),
      totalDeposited.toString(),
      "Fee not correct"
    );
  });

  it("longshort: Total value on both sides is equal to total deposits after fee mechanism adjustments (equalizing)", async () => {
    // Consider APY=0% for initial simplicity.
    await aaveLendingPool.setSimulatedInstantAPY(0, { from: admin });

    await mintAndApprove(dai, defaultMintAmount, user1, longShort.address);
    await longShort.mintLong(new BN(defaultMintAmount), { from: user1 });

    await mintAndApprove(dai, defaultMintAmount, user2, longShort.address);
    await longShort.mintShort(new BN(defaultMintAmount), { from: user2 });

    const longVal = await longShort.longValue.call();
    const shortVal = await longShort.shortValue.call();

    const totalValue = longVal.add(shortVal);
    const totalDeposited = new BN(defaultMintAmount).add(
      new BN(defaultMintAmount)
    );

    assert.equal(
      totalValue.toString(),
      totalDeposited.toString(),
      "Fee not correct"
    );
  });

  it("longshort: Tipping the order book first entry above threshold, partial fee on imbalance amount", async () => {
    // Consider APY=0% for initial simplicity.
    await aaveLendingPool.setSimulatedInstantAPY(0, { from: admin });

    await mintAndApprove(
      dai,
      fiftyThousandMintAmount,
      user1,
      longShort.address
    );
    await longShort.mintLong(new BN(fiftyThousandMintAmount), {
      from: user1,
    });

    const longVal = await longShort.longValue.call();
    const shortVal = await longShort.shortValue.call();

    const additionalMintAmount = new BN(fiftyThousandMintAmount).add(
      new BN(tenThousandMintAmount)
    ); // 60000

    await mintAndApprove(dai, additionalMintAmount, user2, longShort.address);

    await longShort.mintShort(new BN(additionalMintAmount), { from: user2 });

    const newShortVal = await longShort.shortValue.call();
    // console.log("newShortVal", newShortVal.toString());

    const shortDepositFeesFromContract = additionalMintAmount.sub(newShortVal);
    // console.log(
    //   "shortDepositFeesFromContract",
    //   shortDepositFeesFromContract.toString()
    // );

    console.log(
      new BN(additionalMintAmount).mul(new BN(tenToThe18)).toString()
    );
    console.log(new BN(fiftyThousandMintAmount).toString());

    let bn50 = new BN(fiftyThousandMintAmount);
    console.log("bn50: ", bn50.toString());
    let bn6 = new BN(6);
    console.log("bn6: ", bn6.toString());
    const shortBeta = bn50.div(bn6).div(new BN("10000"));
    // shortBeta = shortBeta.div(new BN("10000"));

    const shortBetaFromContract = await getShortBeta();

    console.log("shortbeta", shortBeta.toString());
    console.log("shortBetaFromContract", shortBetaFromContract.toString());

    const expectedFeesForAction = await feeCalc(
      additionalMintAmount,
      longVal,
      shortVal,
      false,
      shortBeta
    );

    assert.equal(
      shortDepositFeesFromContract.toString(), // actual
      expectedFeesForAction.toString(), // expected
      "Fee not correct"
    );
  });

  // Fee calcs when scaling kicks in fee tests
  // (1)
});
