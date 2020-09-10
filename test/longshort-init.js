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

  beforeEach(async () => {
    const result = await initialize(admin);
    longShort = result.longShort;
    long = result.long;
    short = result.short;
    dai = result.dai;
    priceOracle = result.priceOracle;
  });

  it("longshort: contract initialises", async () => {
    assert.equal(0, 0);
  });
});
