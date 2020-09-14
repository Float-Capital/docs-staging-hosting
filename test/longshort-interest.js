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
} = require("./helpers");

contract("LongShort", (accounts) => {
  let longShort;
  let long;
  let short;
  let dai;
  let priceOracle;

  // Default test values
  const admin = accounts[0];
  const user1 = accounts[1];
  const user2 = accounts[2];

  const defaultMintAmount = "100000000000000000000"; // 100 dai etc.
  const oneUnitInWei = "1000000000000000000";

  beforeEach(async () => {
    const result = await initialize(admin);
    longShort = result.longShort;
    long = result.long;
    short = result.short;
    dai = result.dai;
    priceOracle = result.priceOracle;
  });

  it("longshort: Interest accrues correctly initially to short side if minted first.", async () => {
    await mintAndApprove(dai, defaultMintAmount, user1, longShort.address);

    // Create a short position
    await longShort.mintShort(new BN(defaultMintAmount), { from: user1 });

    // Now long position comes in.
    await mintAndApprove(dai, defaultMintAmount, user2, longShort.address);
    await longShort.mintLong(new BN(defaultMintAmount), { from: user2 });

    // The system should refresh and update after minting long tokens and reflect the interest earned by the short side
    const shortValueLocked = await longShort.shortValue.call();
    const shortValueExpected = simulateInterestEarned(
      defaultMintAmount,
      SIMULATED_INSTANT_APY
    );
    assert.equal(
      shortValueLocked.toString(),
      shortValueExpected.toString(),
      "Short value not correctly shown"
    );

    const shortTokenSupply = await short.totalSupply();
    // Check token prices are reflected correctly...
    const shortValueTokenPrice = await longShort.shortTokenPrice.call();
    const expectedShortValueTokenPrice = tokenPriceCalculator(
      shortValueExpected,
      shortTokenSupply
    );
    assert.equal(
      shortValueTokenPrice.toString(),
      expectedShortValueTokenPrice.toString(),
      "Token price not correct"
    );
    // right now a 1 short or long token costs 10*18
    // Think I might be getting it wrong and and 1 wei costs 10**18 ??

    const totalValueLocked = await longShort.totalValueLocked.call();
    const longValueExpected = simulateInterestEarned(defaultMintAmount, 0);
    assert.equal(
      totalValueLocked.toString(),
      shortValueExpected.add(longValueExpected).toString(),
      "Total value not correctly shown"
    );
  });

  it("longshort: Interest accrues correctly initially to long side if minted first.", async () => {
    await mintAndApprove(dai, defaultMintAmount, user1, longShort.address);

    // Create a short position
    await longShort.mintLong(new BN(defaultMintAmount), { from: user1 });

    // Now long position comes in.
    await mintAndApprove(dai, defaultMintAmount, user2, longShort.address);
    await longShort.mintShort(new BN(defaultMintAmount), { from: user2 });

    // The system should refresh and update after minting long tokens and reflect the interest earned by the short side
    const longValueLocked = await longShort.longValue.call();
    const longValueExpected = simulateInterestEarned(
      defaultMintAmount,
      SIMULATED_INSTANT_APY
    );
    assert.equal(
      longValueLocked.toString(),
      longValueExpected.toString(),
      "Long value not correctly shown"
    );

    const longTokenSupply = await long.totalSupply();
    // Check token prices are reflected correctly...
    const longValueTokenPrice = await longShort.longTokenPrice.call();
    const expectedLongValueTokenPrice = tokenPriceCalculator(
      longValueExpected,
      longTokenSupply
    );
    assert.equal(
      longValueTokenPrice.toString(),
      expectedLongValueTokenPrice.toString(),
      "Token price not correct"
    );
    // right now a 1 short or long token costs 10*18
    // Think I might be getting it wrong and and 1 wei costs 10**18 ??

    const totalValueLocked = await longShort.totalValueLocked.call();
    const shortValueExpected = simulateInterestEarned(defaultMintAmount, 0);
    assert.equal(
      totalValueLocked.toString(),
      shortValueExpected.add(longValueExpected).toString(),
      "Total value not correctly shown"
    );
  });
});
