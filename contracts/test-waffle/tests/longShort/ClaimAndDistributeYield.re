open Mocha;
open Globals;
open LetOps;

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
    before_each(() => {
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
    });
    it(
      "gets the yield split from _getYieldSplit (passing it the correct parameters)",
      () =>
      Js.log("TODO")
    );
    it(
      "gets the yield accreud for the market the yield manager by calling `claimYieldAndGetMarketAmount` with the correct arguments",
      () => {
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
    it(
      "adds the amount due for the market to the `syntheticTokenPoolValue` of the under balanced side (when long is under balanced)",
      () =>
      Js.log("TODO")
    );
    it(
      "adds the amount due for the market to the `syntheticTokenPoolValue` of the under balanced side (when short is under balanced)",
      () =>
      Js.log("TODO")
    );
  });
};
