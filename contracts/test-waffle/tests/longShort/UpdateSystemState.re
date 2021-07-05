open LetOps;
open Mocha;
open Globals;

let testUnit =
    (
      ~contracts: ref(Helpers.coreContracts),
      ~accounts: ref(array(Ethers.Wallet.t)),
    ) => {
  describe("updateSystemState", () => {
    // TODO
    ()
  });
};

let testIntegration =
    (
      ~contracts: ref(Helpers.coreContracts),
      ~accounts: ref(array(Ethers.Wallet.t)),
    ) => {
  describe("updateSystemState", () => {
    it("distribute yield to markets flow", () => {
      let {longShort, markets} = contracts.contents;
      let {yieldManager, oracleManager, marketIndex} =
        markets->Array.getUnsafe(0);

      // 32.1... DAI - any random amount would do...
      let amountOfYieldToAward = bnFromString("3216543216543216542");

      // get total balance pools etc before (and amount for treasury)
      let%Await longTokenPoolValueBefore =
        longShort->LongShort.syntheticTokenPoolValue(marketIndex, true);
      let%Await shortTokenPoolValueBefore =
        longShort->LongShort.syntheticTokenPoolValue(marketIndex, false);
      let%Await totalDueForTreasuryBefore =
        yieldManager->YieldManagerMock.totalReservedForTreasury;
      let totalValueRelatedToMarketBefore =
        longTokenPoolValueBefore
        ->add(shortTokenPoolValueBefore)
        ->add(totalDueForTreasuryBefore);

      // add some yield
      let _ =
        yieldManager->YieldManagerMock.settleWithYieldAbsolute(
          ~totalYield=amountOfYieldToAward,
        );

      // update oracle price
      let%Await currentOraclePrice =
        oracleManager->OracleManagerMock.getLatestPrice;
      let%Await _ =
        oracleManager->OracleManagerMock.setPrice(
          ~newPrice=currentOraclePrice->add(bnFromInt(1)),
        );

      // run long short update state
      let%Await _ = longShort->LongShort.updateSystemState(~marketIndex);

      // get total balance pools after and amount for treasury
      let%Await longTokenPoolValueAfter =
        longShort->LongShort.syntheticTokenPoolValue(marketIndex, true);
      let%Await shortTokenPoolValueAfter =
        longShort->LongShort.syntheticTokenPoolValue(marketIndex, false);
      let%Await totalDueForTreasuryAfter =
        yieldManager->YieldManagerMock.totalReservedForTreasury;
      let totalValueRelatedToMarketAfter =
        longTokenPoolValueAfter
        ->add(shortTokenPoolValueAfter)
        ->add(totalDueForTreasuryAfter);

      Chai.bnEqual(
        ~message=
          "yield is either being lost or over-allocated - should be exactly the same",
        totalValueRelatedToMarketBefore->add(amountOfYieldToAward),
        totalValueRelatedToMarketAfter,
      );
    });
    it("cannot call updateSystemState on a market that doesn't exist", () => {
      let nonExistantMarketIndex = 321321654;
      Chai.expectRevert(
        ~transaction=
          contracts.contents.longShort
          ->LongShort.updateSystemState(~marketIndex=nonExistantMarketIndex),
        ~reason="market doesn't exist",
      );
    });
  });
};
