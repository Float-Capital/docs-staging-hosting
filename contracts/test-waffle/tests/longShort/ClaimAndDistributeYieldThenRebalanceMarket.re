open LetOps;
open Mocha;
open Globals;
open Helpers;

let testUnit =
    (
      ~contracts: ref(Helpers.coreContracts),
      ~accounts as _: ref(array(Ethers.Wallet.t)),
    ) => {
  describeUnit("_claimAndDistributeYieldThenRebalanceMarket", () => {
    let marketIndex = 1;

    // let mockedYieldManager = ref(None->Obj.magic);

    it_only(
      "gets the treasuryYieldPercent from _getYieldSplit (passing it the correct parameters)",
      () => {
        let longShort = contracts.contents.longShort;

        let longValue = Helpers.randomTokenAmount();
        let shortValue = Helpers.randomTokenAmount();
        let totalValueLockedInMarket = longValue->add(shortValue);

        let%Await _ =
          longShort->LongShort.Exposed._getYieldSplitExposed(
            ~longValue,
            ~shortValue,
            ~totalValueLockedInMarket,
          );
        ();
      },
    );

    // it_only(
    //   "gets marketAmount from yield manager by calling `claimYieldAndGetMarketAmount` with the correct arguments",
    //   () => {

    //     let longShort = contracts.contents.longShort;

    //         // set the globals that this test fn uses
    //     let%Await _ =
    //       contracts^.longShort
    //       ->LongShort.Exposed.setClaimAndDistributeYieldThenRebalanceMarketGlobals(
    //           ~marketIndex,
    //           ~syntheticTokenPoolValueLong,
    //           ~syntheticTokenPoolValueShort,
    //         );

    //     let%Await {treasuryPercentE18} =
    //       longShort->LongShort.Exposed._getYieldSplitExposed(
    //         ~longValue=syntheticTokenPoolValueLong,
    //         ~shortValue=syntheticTokenPoolValueShort,
    //         ~totalValueLockedInMarket=totalValueRealizedForMarket,
    //       );

    //     let%Await _ =
    //       longShort->LongShort.Exposed._claimYieldAndGetMarketAmountExposed(
    //         ~totalValueLockedInMarket=totalValueRealizedForMarket,
    //         ~treasuryYieldPercentE18=treasuryPercentR18,
    //       );

    //     // fetch the values it was called with
    //     let claimYieldAndGetMarketAmountCalls =
    //       mockedYieldManager.contents
    //       ->YieldManagerMockSmocked.claimYieldAndGetMarketAmountCalls;

    //     // checks that the fn was called with the correct values
    //     Chai.recordArrayDeepEqualFlat(
    //       claimYieldAndGetMarketAmountCalls,
    //       [|{totalValueRealizedForMarket, treasuryPercentE18}|],
    //     );
    //   },
    // );

    // it_only(
    //   "returns the correct updated long and short values when price has increased (newAssetPrice > oldAssetPrice)",
    //   () => {
    //     let {longShort, markets} = contracts.contents;
    //     let {yieldManager} = markets->Array.getUnsafe(0);

    //     // hardcode the asset prices so that price has increased
    //     let oldAssetPrice = Helpers.randomTokenAmount();
    //     let newAssetPrice = oldAssetPrice->add(Helpers.randomTokenAmount());
    //     let syntheticTokenPoolValueLong = Helpers.randomTokenAmount();
    //     let syntheticTokenPoolValueShort = Helpers.randomTokenAmount();
    //     let totalValueRealizedForMarket =
    //       syntheticTokenPoolValueLong->add(syntheticTokenPoolValueShort);
        
    //     // mock longshort so that we can set the return values from _getYieldSplit 
    //     let%Await LongShortSmocked =
    //     longShort->LongShortSmocked.make;
    //     yieldManagerSmocked->LongShortSmocked.mockGetYieldSplitToReturn(
    //       false,
    //       treasuryPercentE18,
    //     );

    //     // mock yieldManager so that we can set the return values for claimYieldAndGetMarketAmount
    //     let%Await yieldManagerSmocked =
    //     yieldManager->YieldManagerSmocked.make;
    //     yieldManagerSmocked->YieldManagerSmocked.mockClaimYieldAndGetMarketAmountToReturn(
    //       false,
    //       treasuryPercentE18,
    //     );

    //     // obtain expectedResult by implementing the math from the smart contract here in reason
    //     // using the mocked return values

    //     // set the globals that this test fn uses
    //     let%Await _ =
    //       contracts^.longShort
    //       ->LongShort.Exposed.setClaimAndDistributeYieldThenRebalanceMarketGlobals(
    //           ~marketIndex,
    //           ~syntheticTokenPoolValueLong,
    //           ~syntheticTokenPoolValueShort,
    //         );

    //     // obtain actualResult via calling the fn with globals set
    //     let%Await actualResult =
    //       contracts.contents.longShort
    //       ->LongShort.Exposed._claimAndDistributeYieldThenRebalanceMarketExposed(
    //           ~marketIndex,
    //           ~newAssetPrice,
    //           ~oldAssetPrice,
    //         );
    //     ();
    //     // test whether they're the same
    //     Chai.recordArrayDeepEqualFlat(
    //       [|{expectedLongValue, expectedShortValue}|],
    //       [|{actualLongValue, actualShortValue}|],
    //     );
    //   },
    // );

    // it_only(
    //   "returns the correct updated long and short values when price has decreased (newAssetPrice < oldAssetPrice)",
    //   () => {
    //     // hardcode the asset prices
    //     let newAssetPrice = Helpers.randomTokenAmount();
    //     let oldAssetPrice = newAssetPrice->add(Helpers.randomTokenAmount());
    //     ();
    //   },
    // );

    ();
  });
};
