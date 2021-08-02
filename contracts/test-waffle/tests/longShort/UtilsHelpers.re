open Mocha;
open Globals;
open LetOps;

let testUnit =
    (
      ~contracts: ref(Helpers.coreContracts),
      ~accounts as _: ref(array(Ethers.Wallet.t)),
    ) => {
  describeUnit("Long Short Utilities and helpers", () => {
    describe("_getMin(a,b)", () => {
      it("returns `a` when `a < b`", () => {
        let a = Js.Math.random_int(0, Js.Int.max - 1);
        let b = Js.Math.random_int(a + 1, Js.Int.max);

        let expectedResult = bnFromInt(a);

        let%Await actualResult =
          contracts.contents.longShort
          ->LongShort.Exposed._getMinExposed(
              ~a=bnFromInt(a),
              ~b=bnFromInt(b),
            );

        Chai.bnEqual(
          ~message={j|incorrect number returned from _getMin (a=$a ; b=$b)|j},
          actualResult,
          expectedResult,
        );
      });

      it("returns `b` when `b < a`", () => {
        let b = Js.Math.random_int(0, Js.Int.max - 1);
        let a = Js.Math.random_int(b + 1, Js.Int.max);

        let expectedResult = bnFromInt(b);

        let%Await actualResult =
          contracts.contents.longShort
          ->LongShort.Exposed._getMinExposed(
              ~a=bnFromInt(a),
              ~b=bnFromInt(b),
            );

        Chai.bnEqual(
          ~message={j|incorrect number returned from _getMin (a=$a ; b=$b)|j},
          actualResult,
          expectedResult,
        );
      });

      it("returns `a` when `a == b`", () => {
        let a = Js.Math.random_int(0, Js.Int.max);
        let b = a;

        let expectedResult = bnFromInt(a);

        let%Await actualResult =
          contracts.contents.longShort
          ->LongShort.Exposed._getMinExposed(
              ~a=bnFromInt(a),
              ~b=bnFromInt(b),
            );

        Chai.bnEqual(
          ~message={j|incorrect number returned from _getMin (a=$a ; b=$b)|j},
          actualResult,
          expectedResult,
        );
      });
    });

    describe("_getYieldSplit", () => {
      let marketIndex = 1;

      let test =
          (
            ~syntheticToken_amountPaymentToken_backedValueLong,
            ~syntheticToken_amountPaymentToken_backedValueShort,
          ) => {
        let totalValueLockedInMarket =
          syntheticToken_amountPaymentToken_backedValueLong->add(
            syntheticToken_amountPaymentToken_backedValueShort,
          );

        let isLongSideUnderbalanced =
          syntheticToken_amountPaymentToken_backedValueShort->bnGte(
            syntheticToken_amountPaymentToken_backedValueLong,
          );

        let imbalance =
          isLongSideUnderbalanced
            ? syntheticToken_amountPaymentToken_backedValueShort->sub(
                syntheticToken_amountPaymentToken_backedValueLong,
              )
            : syntheticToken_amountPaymentToken_backedValueLong->sub(
                syntheticToken_amountPaymentToken_backedValueShort,
              );

        let%AwaitThen marketTreasurySplitGradientE18 =
          contracts.contents.longShort
          ->LongShort.marketTreasurySplit_gradients_e18(marketIndex);

        let marketPercentCalculatedE18 =
          imbalance
          ->mul(marketTreasurySplitGradientE18)
          ->div(totalValueLockedInMarket);
        let marketPercentE18 =
          bnMin(marketPercentCalculatedE18, CONSTANTS.tenToThe18);

        let treasuryPercentE18 = CONSTANTS.tenToThe18->sub(marketPercentE18);

        let expectedResult = treasuryPercentE18;

        let%Await actualResult =
          contracts.contents.longShort
          ->LongShort.Exposed._getYieldSplitExposed(
              ~marketIndex,
              ~longValue=syntheticToken_amountPaymentToken_backedValueLong,
              ~shortValue=syntheticToken_amountPaymentToken_backedValueShort,
              ~totalValueLockedInMarket,
            );
        Chai.bnEqual(
          ~message=
            "expectedResult and result after `_getYieldSplit` not the same",
          expectedResult,
          actualResult.treasuryYieldPercentE18,
        );
      };

      it("works as expected if longValue > shortValue", () => {
        let syntheticToken_amountPaymentToken_backedValueShort =
          Helpers.randomTokenAmount();
        let syntheticToken_amountPaymentToken_backedValueLong =
          syntheticToken_amountPaymentToken_backedValueShort->add(
            Helpers.randomTokenAmount(),
          );

        test(
          ~syntheticToken_amountPaymentToken_backedValueLong,
          ~syntheticToken_amountPaymentToken_backedValueShort,
        );
      });
      it("works as expected if shortValue > longValue", () => {
        let syntheticToken_amountPaymentToken_backedValueLong =
          Helpers.randomTokenAmount();
        let syntheticToken_amountPaymentToken_backedValueShort =
          syntheticToken_amountPaymentToken_backedValueLong->add(
            Helpers.randomTokenAmount(),
          );

        test(
          ~syntheticToken_amountPaymentToken_backedValueLong,
          ~syntheticToken_amountPaymentToken_backedValueShort,
        );
      });
      it("works as expected if shortValue == longValue", () => {
        let syntheticToken_amountPaymentToken_backedValueLong =
          Helpers.randomTokenAmount();
        let syntheticToken_amountPaymentToken_backedValueShort = syntheticToken_amountPaymentToken_backedValueLong;

        test(
          ~syntheticToken_amountPaymentToken_backedValueLong,
          ~syntheticToken_amountPaymentToken_backedValueShort,
        );
      });
    });
  });
};
