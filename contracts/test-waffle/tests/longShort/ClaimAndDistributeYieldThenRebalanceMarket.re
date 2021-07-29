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
    let marketIndex = Helpers.randomJsInteger();
    let oldAssetPrice = Helpers.randomTokenAmount();

    let marketAmountFromYieldManager = Helpers.randomTokenAmount();

    before_once'(() => {
      contracts.contents.longShort
      ->LongShortSmocked.InternalMock.setupFunctionForUnitTesting(
          ~functionName="_claimAndDistributeYieldThenRebalanceMarket",
        )
    });

    let setup = (~newAssetPrice) => {
      contracts.contents.longShort
      ->LongShort.Exposed._claimAndDistributeYieldThenRebalanceMarketExposedCall(
          ~marketIndex,
          ~newAssetPrice,
          ~oldAssetPrice,
        );
    };

    let runTests =
        (~syntheticTokenPoolValueLong, ~syntheticTokenPoolValueShort) => {
      let totalValueLockedInMarket =
        syntheticTokenPoolValueLong->add(syntheticTokenPoolValueShort);

      let (yieldDistributedValueLong, yieldDistributedValueShort) =
        if (syntheticTokenPoolValueLong->bnGt(syntheticTokenPoolValueShort)) {
          (
            syntheticTokenPoolValueLong,
            syntheticTokenPoolValueShort->add(marketAmountFromYieldManager),
          );
        } else {
          (
            syntheticTokenPoolValueLong->add(marketAmountFromYieldManager),
            syntheticTokenPoolValueShort,
          );
        };

      before_once'(() => {
        let%Await _ =
          contracts.contents.longShort
          ->LongShort.Exposed.setClaimAndDistributeYieldThenRebalanceMarketGlobals(
              ~marketIndex,
              ~syntheticTokenPoolValueLong,
              ~syntheticTokenPoolValueShort,
              ~yieldManager=contracts.contents.yieldManagerSmocked.address,
            );

        contracts.contents.yieldManagerSmocked
        ->YieldManagerAaveSmocked.mockClaimYieldAndGetMarketAmountToReturn(
            marketAmountFromYieldManager,
          );
      });

      it(
        "gets the treasuryYieldPercent from _getYieldSplit and calls claimYieldAndGetMarketAmount on the yieldManager with correct amount",
        () => {
          let newAssetPrice =
            Helpers.adjustNumberRandomlyWithinRange(
              ~basisPointsMin=-99999,
              ~basisPointsMax=99999,
              oldAssetPrice,
            );
          let%AwaitThen {treasuryPercentE18} =
            contracts.contents.longShort
            ->LongShort.Exposed._getYieldSplitExposed(
                ~longValue=syntheticTokenPoolValueLong,
                ~shortValue=syntheticTokenPoolValueShort,
                ~totalValueLockedInMarket,
              );

          let%Await _ = setup(~newAssetPrice);

          contracts.contents.yieldManagerSmocked
          ->YieldManagerAaveSmocked.claimYieldAndGetMarketAmountCalls
          ->Chai.recordArrayDeepEqualFlat([|
              {
                totalValueRealizedForMarket: totalValueLockedInMarket,
                treasuryPercentE18,
              },
            |]);
        },
      );

      it(
        "returns the correct updated long and short values when price has increased (newAssetPrice == oldAssetPrice)",
        () => {
          let newAssetPrice = oldAssetPrice;
          let%Await {longValue, shortValue} = setup(~newAssetPrice);

          Chai.bnEqual(yieldDistributedValueLong, longValue);
          Chai.bnEqual(yieldDistributedValueShort, shortValue);
        },
      );

      it(
        "returns the correct updated long and short values when price has increased (newAssetPrice > oldAssetPrice)",
        () => {
          // make the price increase
          let newAssetPrice =
            Helpers.adjustNumberRandomlyWithinRange(
              ~basisPointsMin=0,
              ~basisPointsMax=99999,
              oldAssetPrice,
            );

          let%Await {longValue, shortValue} = setup(~newAssetPrice);

          let unbalancedSidePoolValue =
            bnMin(yieldDistributedValueLong, yieldDistributedValueShort);

          let valueChange =
            newAssetPrice
            ->sub(oldAssetPrice)
            ->mul(unbalancedSidePoolValue)
            ->div(oldAssetPrice);

          Chai.bnEqual(
            yieldDistributedValueLong->add(valueChange),
            longValue,
          );
          Chai.bnEqual(
            yieldDistributedValueShort->sub(valueChange),
            shortValue,
          );
        },
      );

      it(
        "returns the correct updated long and short values when price has increased (newAssetPrice < oldAssetPrice)",
        () => {
          // make the price decrease
          let newAssetPrice =
            Helpers.adjustNumberRandomlyWithinRange(
              ~basisPointsMin=-99999,
              ~basisPointsMax=0,
              oldAssetPrice,
            );

          let%Await {longValue, shortValue} = setup(~newAssetPrice);

          let unbalancedSidePoolValue =
            bnMin(yieldDistributedValueLong, yieldDistributedValueShort);

          let valueChange =
            newAssetPrice
            ->sub(oldAssetPrice)
            ->mul(unbalancedSidePoolValue)
            ->div(oldAssetPrice);

          Chai.bnEqual(
            yieldDistributedValueLong->add(valueChange),
            longValue,
          );
          Chai.bnEqual(
            yieldDistributedValueShort->sub(valueChange),
            shortValue,
          );
        },
      );
    };
    ();

    describe("Long Side is Overvalued", () => {
      let syntheticTokenPoolValueShort = Helpers.randomTokenAmount();
      let syntheticTokenPoolValueLong =
        syntheticTokenPoolValueShort->add(Helpers.randomTokenAmount());

      runTests(~syntheticTokenPoolValueLong, ~syntheticTokenPoolValueShort);
    });
    describe("Short Side is Overvalued", () => {
      let syntheticTokenPoolValueLong = Helpers.randomTokenAmount();
      let syntheticTokenPoolValueShort =
        syntheticTokenPoolValueLong->add(Helpers.randomTokenAmount());

      runTests(~syntheticTokenPoolValueLong, ~syntheticTokenPoolValueShort);
    });
  });
};
