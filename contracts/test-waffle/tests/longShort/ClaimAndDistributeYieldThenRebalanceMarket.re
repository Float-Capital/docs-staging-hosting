open LetOps;
open Mocha;
open Globals;
open Helpers;

let testUnit =
    (
      ~contracts: ref(Helpers.longShortUnitTestContracts),
      ~accounts as _: ref(array(Ethers.Wallet.t)),
    ) => {
  describeUnit("_claimAndDistributeYieldThenRebalanceMarket", () => {
    let marketIndex = 1;
    let oldAssetPrice = Helpers.randomTokenAmount();
    let newAssetPrice = Helpers.randomTokenAmount();
      // Helpers.increaseOrDecreaseByRandomPercentageLessThan100Percent(
      //   oldAssetPrice,
      // );

    let marketAmountFromYieldManager = Helpers.randomTokenAmount();

    let syntheticTokenPoolValueLong = Helpers.randomTokenAmount();
    let syntheticTokenPoolValueShort = Helpers.randomTokenAmount();
    let totalValueLockedInMarket =
      syntheticTokenPoolValueLong->add(syntheticTokenPoolValueShort);

    before_once'(() => {
      contracts.contents.longShort
      ->LongShortSmocked.InternalMock.setupFunctionForUnitTesting(
          ~functionName="_claimAndDistributeYieldThenRebalanceMarket",
        )
    });

    it(
      "gets the treasuryYieldPercent from _getYieldSplit and calls claimYieldAndGetMarketAmount on the yieldManager with correct amount",
      () => {
        let {longShort, yieldManagerSmocked} = contracts.contents;

        let%Await _ =
          longShort->LongShort.Exposed.setClaimAndDistributeYieldThenRebalanceMarketGlobals(
            ~marketIndex,
            ~syntheticTokenPoolValueLong,
            ~syntheticTokenPoolValueShort,
            ~yieldManager=yieldManagerSmocked.address,
          );

        Js.log({"yieldmanager": yieldManagerSmocked.address});

        yieldManagerSmocked->YieldManagerAaveSmocked.mockClaimYieldAndGetMarketAmountToReturn(
          marketAmountFromYieldManager,
        );

        let%Await {treasuryPercentE18} =
          longShort->LongShort.Exposed._getYieldSplitExposed(
            ~longValue=syntheticTokenPoolValueLong,
            ~shortValue=syntheticTokenPoolValueShort,
            ~totalValueLockedInMarket,
          );

        let%Await _ =
          longShort->LongShort.Exposed._claimAndDistributeYieldThenRebalanceMarketExposed(
            ~marketIndex,
            ~newAssetPrice,
            ~oldAssetPrice,
          );

        yieldManagerSmocked
        ->YieldManagerAaveSmocked.claimYieldAndGetMarketAmountCalls
        ->Chai.recordArrayDeepEqualFlat([|
            {
              totalValueRealizedForMarket: totalValueLockedInMarket,
              treasuryPercentE18,
            },
          |]);
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

    it_only(
      "should return the correct long and short values when price has increased (newAssetPrice > oldAssetPrice)",
      () => {
        let {longShort, yieldManagerSmocked} = contracts.contents;

        // 1. set the globals
        let%Await _ =
          longShort->LongShort.Exposed.setClaimAndDistributeYieldThenRebalanceMarketGlobals(
            ~marketIndex,
            ~syntheticTokenPoolValueLong,
            ~syntheticTokenPoolValueShort,
            ~yieldManager=yieldManagerSmocked.address,
          );

        // obtain actualResult via calling the fn with globals set
        let%Await actualResult =
          contracts.contents.longShort
          ->LongShort.Exposed._claimAndDistributeYieldThenRebalanceMarketExposedCall(
              ~marketIndex,
              ~newAssetPrice,
              ~oldAssetPrice,
            );

        // obtain expectedResult by implementing the math from the smart contract here in reason using the mocked values from the
        // two functions mock yieldManager to return that randomTokenAmount from the lets above
        yieldManagerSmocked->YieldManagerAaveSmocked.mockClaimYieldAndGetMarketAmountToReturn(
          marketAmountFromYieldManager,
        );

        // get these two values just by calling the fn.. do I HAVE to mock these values rather?
        // ya, try - should be easy given the above precedent
        let%Await {isLongSideUnderbalanced, treasuryPercentE18} =
          longShort->LongShort.Exposed._getYieldSplitExposed(
            ~longValue=syntheticTokenPoolValueLong,
            ~shortValue=syntheticTokenPoolValueShort,
            ~totalValueLockedInMarket,
          );

        // come back and make this more elegant
        let syntheticTokenPoolValueLong =
          isLongSideUnderbalanced
          && marketAmountFromYieldManager->bnGt(zeroBn)
            ? syntheticTokenPoolValueLong->add(marketAmountFromYieldManager)
            : syntheticTokenPoolValueLong;

        let syntheticTokenPoolValueShort =
          isLongSideUnderbalanced
          && marketAmountFromYieldManager->bnGt(zeroBn)
            ? syntheticTokenPoolValueShort
            : syntheticTokenPoolValueShort->add(marketAmountFromYieldManager);

        let unbalancedSidePoolValue =
          min(syntheticTokenPoolValueLong, syntheticTokenPoolValueShort);

        let percentageChangeE18 =
          newAssetPrice
          ->sub(oldAssetPrice)
          ->mul(CONSTANTS.tenToThe18)
          ->div(oldAssetPrice);

        let valueChange =
          percentageChangeE18
          ->mul(unbalancedSidePoolValue)
          ->div(CONSTANTS.tenToThe18);

        let expectedLongValue =
          valueChange->bnGt(zeroBn)
            ? syntheticTokenPoolValueLong->add(valueChange)
            : syntheticTokenPoolValueLong->sub(
                valueChange->mul(bnFromInt(-1)),
              );

        let expectedShortValue =
          valueChange->bnGt(zeroBn)
            ? syntheticTokenPoolValueShort->sub(valueChange)
            : syntheticTokenPoolValueLong->add(
                valueChange->mul(bnFromInt(-1)),
              );

        // logging for sanity - to take out 
        Js.log(Ethers.BigNumber.toString(expectedLongValue));
        Js.log(Ethers.BigNumber.toString(expectedShortValue));
        Js.log(Ethers.BigNumber.toString(actualResult.longValue));
        Js.log(Ethers.BigNumber.toString(actualResult.shortValue));
        Js.log(Ethers.BigNumber.toString(bnFromInt(-1))); 
        
        // test whether they're the same
        Chai.bnEqual(
          ~message=
            "expected longValue was different to result for _claimAndDistributeYieldThenRebalanceMarket call",
          expectedLongValue,
          actualResult.longValue,
        );
        Chai.bnEqual(
          ~message=
            "expected shortValue was different to result for _claimAndDistributeYieldThenRebalanceMarket call",
          expectedShortValue,
          actualResult.shortValue,
        );
      },
    );

    // it_only(
    //   "should return the correct long and short values when price has decreased (newAssetPrice < oldAssetPrice)",
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
