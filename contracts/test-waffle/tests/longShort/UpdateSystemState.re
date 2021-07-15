open LetOps;
open Mocha;
open Globals;

let testUnit =
    (
      ~contracts as _: ref(Helpers.coreContracts),
      ~accounts as _: ref(array(Ethers.Wallet.t)),
    ) => {
  describeUnit("updateSystemState", () => {
    describe("_updateSystemStateInternal", () => {
      it("calls for the latest price from the oracle", () =>
        Js.log("TODO")
      );
      it(
        "it shouldn't modify state or call other functions IF the `msg.sender` isn't the staker AND the price didn't change",
        () =>
        Js.log("TODO")
      );

      it(
        "it should call the addNewStateForFloatRewards on the staker function if the `msg.sender` is the staker (with NO price change)",
        () =>
        Js.log("TODO")
      );

      describe("There is a price change", () => {
        // TODO: there could also be a test to ensure that _claimAndDistributeYield happens before _adjustMarketBasedOnNewAssetPrice
        it(
          "it should call the addNewStateForFloatRewards on the staker function if the `msg.sender` is the staker (WITH a price change)",
          () =>
          Js.log("TODO")
        );

        it(
          "it should call `_claimAndDistributeYield` with correct arguments",
          () =>
          Js.log("TODO")
        );
        it(
          "it should call `_adjustMarketBasedOnNewAssetPrice` with correct arguments",
          () =>
          Js.log("TODO")
        );
        it(
          "it should call `_recalculateSyntheticTokenPrice` twice (one for long, other for short) with correct arguments",
          () =>
          Js.log("TODO")
        );
        it(
          "it should call `_saveSyntheticTokenPriceSnapshots` with correct arguments (",
          () =>
          Js.log("TODO")
        );
        it(
          "it should call `_performOustandingSettlements` with correct arguments",
          () =>
          Js.log("TODO")
        );
        it(
          "it should update the (underlying) asset price with correct arguments",
          () =>
          Js.log("TODO")
        );
        it("it should increment the marketUpdateIndex by 1", () =>
          Js.log("TODO")
        );
        it(
          "it should emit the SystemStateUpdated event with the correct arguments",
          () =>
          Js.log("TODO")
        );
      });
    });

    describe("updateSystemStateMulti", () => {
      it(
        "should call `_updateSystemStateInternal` for each market in the array",
        () =>
        Js.log("TODO")
      )
    });
    describe("updateSystemState", () => {
      it(
        "should call to `_updateSystemStateInternal` with the correct market as an argument",
        () =>
        Js.log("TODO")
      )
    });
  });
};

let testIntegration =
    (
      ~contracts: ref(Helpers.coreContracts),
      ~accounts as _: ref(array(Ethers.Wallet.t)),
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
