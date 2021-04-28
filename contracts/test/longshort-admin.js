const {
  BN,
  expectRevert,
  ether,
  expectEvent,
  balance,
  time,
} = require("@openzeppelin/test-helpers");

const { initialize, createSynthetic } = require("./helpers");

contract("LongShort (admin)", (accounts) => {
  let longShort;  
  let marketIndex;  

  const syntheticName = "FTSE100";
  const syntheticSymbol = "FTSE";

  // Fees
  const _baseEntryFee = 0;
  const _badLiquidityEntryFee = 0;
  const _baseExitFee = 50;
  const _badLiquidityExitFee = 50;

  // Default test values
  const admin = accounts[0];
  const user1 = accounts[1];

  const zeroAddressStr = "0x0000000000000000000000000000000000000000";

  beforeEach(async () => {
    const result = await initialize(admin);

    longShort = result.longShort;

    const synthResult = await createSynthetic(
      admin,
      longShort,
      syntheticName,
      syntheticSymbol,
      _baseEntryFee,
      _badLiquidityEntryFee,
      _baseExitFee,
      _badLiquidityExitFee
    );
    
    marketIndex = synthResult.currentMarketIndex;

  });


  it("shouldn't allow non admin to update the oracle", async () => {

    const newOracleAddress = zeroAddressStr

    await expectRevert(longShort.updateMarketOracle(marketIndex, newOracleAddress, {from: user1} ), "only admin");

    await longShort.updateMarketOracle(marketIndex, newOracleAddress, {from: admin} ) 
    
    const contactAdmin = await longShort.admin.call();
    
    assert.equal(admin, contactAdmin, "is admin");

    const updatedOracleAddress = await longShort.oracleManagers.call(marketIndex);

    assert.equal(newOracleAddress, updatedOracleAddress, "Oracle has been updated")
  
  });


});
