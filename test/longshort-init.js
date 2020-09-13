const {
  BN,
  expectRevert,
  ether,
  expectEvent,
  balance,
  time,
} = require("@openzeppelin/test-helpers");

const { initialize, mintAndApprove } = require("./helpers");

contract("LongShort", (accounts) => {
  // Invictus funds
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

  beforeEach(async () => {
    const result = await initialize(admin);
    longShort = result.longShort;
    long = result.long;
    short = result.short;
    dai = result.dai;
    priceOracle = result.priceOracle;
  });

  it("longshort: contract initialises, Long position can be made", async () => {
    await mintAndApprove(dai, defaultMintAmount, user1, longShort.address);

    // Create a long position
    await longShort.mintLong(new BN(defaultMintAmount), { from: user1 });

    const user1LongTokens = await long.balanceOf(user1);
    const user1DaiTokens = await dai.balanceOf(user1);

    assert.equal(
      user1LongTokens,
      100,
      "Correct tokens not minted on initialization"
    );
    assert.equal(user1DaiTokens, 0, "Tokens not taken when minting position");
  });

  it("longshort: contract initialises, short position can be created.", async () => {
    await mintAndApprove(dai, defaultMintAmount, user1, longShort.address);

    // Create a long position
    await longShort.mintShort(new BN(defaultMintAmount), { from: user1 });

    const user1ShortTokens = await short.balanceOf(user1);
    const user1DaiTokens = await dai.balanceOf(user1);

    assert.equal(
      user1ShortTokens,
      100,
      "Correct tokens not minted on initialization"
    );
    assert.equal(user1DaiTokens, 0, "Tokens not taken when minting position");
  });

  it("longshort: contract initialises, short position can be created.", async () => {
    await mintAndApprove(dai, defaultMintAmount, user1, longShort.address);

    // Create a long position
    await longShort.mintShort(new BN(defaultMintAmount), { from: user1 });

    const user1ShortTokens = await short.balanceOf(user1);
    const user1DaiTokens = await dai.balanceOf(user1);

    assert.equal(
      user1ShortTokens,
      100,
      "Correct tokens not minted on initialization"
    );
    assert.equal(user1DaiTokens, 0, "Tokens not taken when minting position");
  });
});
