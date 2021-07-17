open LetOps;
open Mocha;
open Globals;
open Helpers;

let testUnit =
    (
      ~contracts: ref(Helpers.coreContracts),
      ~accounts as _: ref(array(Ethers.Wallet.t)),
    ) => {
  describeUnit("_claimAndDistributeYield", () => {
    let marketIndex = 1;
    let targetMarketAmount = Helpers.randomTokenAmount();
    let syntheticTokenPoolValueLong = Helpers.randomTokenAmount();
    let syntheticTokenPoolValueShort = Helpers.randomTokenAmount();
    let mockedYieldManager = ref(None->Obj.magic);

    let setup = (~syntheticTokenPoolValueLong, ~syntheticTokenPoolValueShort) => {
      let {markets, longShort} = contracts.contents;
      let {yieldManager} = markets->Array.getUnsafe(marketIndex);
      let%Await mockYieldManager = yieldManager->YieldManagerMockSmocked.make;

      mockedYieldManager := mockYieldManager;

      let%Await _ =
        longShort->LongShort.Exposed.setClaimAndDistributeYieldGlobals(
          ~marketIndex,
          ~yieldManager=mockYieldManager.address,
          ~syntheticTokenPoolValueLong,
          ~syntheticTokenPoolValueShort,
        );

      let%Await _ = longShort->LongShortSmocked.InternalMock.setup;
      let%Await _ =
        longShort->LongShortSmocked.InternalMock.setupFunctionForUnitTesting(
          ~functionName="_claimAndDistributeYield",
        );

      mockYieldManager->YieldManagerMockSmocked.mockClaimYieldAndGetMarketAmountToReturn(
        targetMarketAmount,
      );
    };
    it_only(
      "gets the yield split from _getYieldSplit (passing it the correct parameters)",
      () => {
        let%Await _ =
          setup(~syntheticTokenPoolValueLong, ~syntheticTokenPoolValueShort);
        let longShort = contracts.contents.longShort;
        let totalValueRealizedForMarket =
          syntheticTokenPoolValueLong->add(syntheticTokenPoolValueShort);

        let%Await _ =
          longShort->LongShort.Exposed._getYieldSplitExposed(
            ~longValue=syntheticTokenPoolValueLong,
            ~shortValue=syntheticTokenPoolValueShort,
            ~totalValueLockedInMarket=totalValueRealizedForMarket,
          );
        ();
      },
    );
    it_only(
      "gets the yield accrued for the market from yield manager by calling `claimYieldAndGetMarketAmount` with the correct arguments",
      () => {
        let%Await _ =
          setup(~syntheticTokenPoolValueLong, ~syntheticTokenPoolValueShort);
        let longShort = contracts.contents.longShort;
        let totalValueRealizedForMarket =
          syntheticTokenPoolValueLong->add(syntheticTokenPoolValueShort);
        let%Await {treasuryPercentE18} =
          longShort->LongShort.Exposed._getYieldSplitExposed(
            ~longValue=syntheticTokenPoolValueLong,
            ~shortValue=syntheticTokenPoolValueShort,
            ~totalValueLockedInMarket=totalValueRealizedForMarket,
          );
        let%Await _ =
          longShort->LongShort.Exposed._claimAndDistributeYieldExposed(
            ~marketIndex,
          );
        let claimYieldAndGetMarketAmountCalls =
          mockedYieldManager.contents
          ->YieldManagerMockSmocked.claimYieldAndGetMarketAmountCalls;
        Chai.recordArrayDeepEqualFlat(
          claimYieldAndGetMarketAmountCalls,
          [|{totalValueRealizedForMarket, treasuryPercentE18}|],
        );
      },
    );

    let testPoolValueUpdatesCorrectly =
        (~syntheticTokenPoolValueLong, ~syntheticTokenPoolValueShort) => {
      let longShort = contracts.contents.longShort;

      let isLongSideUnderbalanced =
        syntheticTokenPoolValueLong->bnLt(syntheticTokenPoolValueShort);

      let expectedResult =
        isLongSideUnderbalanced
          ? syntheticTokenPoolValueLong->add(targetMarketAmount)
          : syntheticTokenPoolValueShort->add(targetMarketAmount);

      let%Await _ =
        setup(~syntheticTokenPoolValueLong, ~syntheticTokenPoolValueShort);

      let%Await _ =
        longShort->LongShort.Exposed._claimAndDistributeYieldExposed(
          ~marketIndex,
        );

      let%Await marketAmountAfterCall =
        longShort->LongShort.syntheticTokenPoolValue(
          marketIndex,
          isLongSideUnderbalanced,
        );

      Chai.bnEqual(
        ~message=
          "expectedResult and result after `_claimAndDistributeYield` not the same",
        expectedResult,
        marketAmountAfterCall,
      );
    };

    it_only(
      "adds the amount due for the market to the `syntheticTokenPoolValue` of the underbalanced side (when long is underbalanced)",
      () => {
        let syntheticTokenPoolValueLong = Helpers.randomTokenAmount();
        let syntheticTokenPoolValueShort =
          syntheticTokenPoolValueLong->add(Helpers.randomTokenAmount());

        testPoolValueUpdatesCorrectly(
          ~syntheticTokenPoolValueLong,
          ~syntheticTokenPoolValueShort,
        );
      },
    );

    it_only(
      "adds the amount due for the market to the `syntheticTokenPoolValue` of the underbalanced side (when short is underbalanced)",
      () => {
        let syntheticTokenPoolValueShort = Helpers.randomTokenAmount();
        let syntheticTokenPoolValueLong =
          syntheticTokenPoolValueShort->add(
            Helpers.randomTokenAmount()->add(Helpers.randomTokenAmount()),
          );

        testPoolValueUpdatesCorrectly(
          ~syntheticTokenPoolValueLong,
          ~syntheticTokenPoolValueShort,
        );
      },
    );
    ();
  });
};
