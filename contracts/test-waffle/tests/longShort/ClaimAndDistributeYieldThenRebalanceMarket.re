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
    let treasuryYieldPercentE18 = Helpers.randomRatio1e18();

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
        (
          ~syntheticToken_amountPaymentToken_backedValueLong,
          ~syntheticToken_amountPaymentToken_backedValueShort,
        ) => {
      let totalValueLockedInMarket =
        syntheticToken_amountPaymentToken_backedValueLong->add(
          syntheticToken_amountPaymentToken_backedValueShort,
        );

      let (yieldDistributedValueLong, yieldDistributedValueShort) =
        if (syntheticToken_amountPaymentToken_backedValueLong->bnGt(
              syntheticToken_amountPaymentToken_backedValueShort,
            )) {
          (
            syntheticToken_amountPaymentToken_backedValueLong,
            syntheticToken_amountPaymentToken_backedValueShort->add(
              marketAmountFromYieldManager,
            ),
          );
        } else {
          (
            syntheticToken_amountPaymentToken_backedValueLong->add(
              marketAmountFromYieldManager,
            ),
            syntheticToken_amountPaymentToken_backedValueShort,
          );
        };

      before_once'(() => {
        let%Await _ =
          contracts.contents.longShort
          ->LongShort.Exposed.setClaimAndDistributeYieldThenRebalanceMarketGlobals(
              ~marketIndex,
              ~syntheticToken_amountPaymentToken_backedValueLong,
              ~syntheticToken_amountPaymentToken_backedValueShort,
              ~yieldManager=contracts.contents.yieldManagerSmocked.address,
            );

        let isLongSideUnderbalanced =
          syntheticToken_amountPaymentToken_backedValueLong->bnLt(
            syntheticToken_amountPaymentToken_backedValueShort,
          );

        LongShortSmocked.InternalMock.mock_getYieldSplitToReturn(
          isLongSideUnderbalanced,
          treasuryYieldPercentE18,
        );

        contracts.contents.yieldManagerSmocked
        ->YieldManagerAaveSmocked.mockClaimYieldAndGetMarketAmountToReturn(
            marketAmountFromYieldManager,
          );
      });

      describe("Function calls", () => {
        before_once'(() => {
          let newAssetPrice =
            Helpers.adjustNumberRandomlyWithinRange(
              ~basisPointsMin=-99999,
              ~basisPointsMax=99999,
              oldAssetPrice,
            );

          setup(~newAssetPrice);
        });
        it("calls _getYieldSplit with correct parameters", () => {
          LongShortSmocked.InternalMock._getYieldSplitCalls()
          ->Chai.recordArrayDeepEqualFlat([|
              {
                marketIndex,
                longValue: syntheticToken_amountPaymentToken_backedValueLong,
                shortValue: syntheticToken_amountPaymentToken_backedValueShort,
                totalValueLockedInMarket,
              },
            |])
        });
        it(
          "gets the treasuryYieldPercent from _getYieldSplit and calls claimYieldAndGetMarketAmount on the yieldManager with correct amount",
          () => {
          contracts.contents.yieldManagerSmocked
          ->YieldManagerAaveSmocked.claimYieldAndGetMarketAmountCalls
          ->Chai.recordArrayDeepEqualFlat([|
              {
                totalValueRealizedForMarket: totalValueLockedInMarket,
                treasuryYieldPercentE18,
              },
            |])
        });
      });

      it(
        "returns the correct updated long and short values when price has remained the same (newAssetPrice == oldAssetPrice)",
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
        "returns the correct updated long and short values when price has decreased (newAssetPrice < oldAssetPrice)",
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
      let syntheticToken_amountPaymentToken_backedValueShort =
        Helpers.randomTokenAmount();
      let syntheticToken_amountPaymentToken_backedValueLong =
        syntheticToken_amountPaymentToken_backedValueShort->add(
          Helpers.randomTokenAmount(),
        );

      runTests(
        ~syntheticToken_amountPaymentToken_backedValueLong,
        ~syntheticToken_amountPaymentToken_backedValueShort,
      );
    });
    describe("Short Side is Overvalued", () => {
      let syntheticToken_amountPaymentToken_backedValueLong =
        Helpers.randomTokenAmount();
      let syntheticToken_amountPaymentToken_backedValueShort =
        syntheticToken_amountPaymentToken_backedValueLong->add(
          Helpers.randomTokenAmount(),
        );

      runTests(
        ~syntheticToken_amountPaymentToken_backedValueLong,
        ~syntheticToken_amountPaymentToken_backedValueShort,
      );
    });
  });
};
