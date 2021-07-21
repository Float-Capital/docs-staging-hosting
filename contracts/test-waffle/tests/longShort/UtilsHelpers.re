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
      let test = (~syntheticTokenPoolValueLong, ~syntheticTokenPoolValueShort) => {
        let totalValueLockedInMarket =
          syntheticTokenPoolValueLong->add(syntheticTokenPoolValueShort);

        let isLongSideUnderbalanced =
          syntheticTokenPoolValueShort->bnGte(syntheticTokenPoolValueLong);

        let imbalance =
          isLongSideUnderbalanced
            ? syntheticTokenPoolValueShort->sub(syntheticTokenPoolValueLong)
            : syntheticTokenPoolValueLong->sub(syntheticTokenPoolValueShort);

        let marketTreasurySplitGradientE18 = CONSTANTS.tenToThe18;
        let marketPercentCalculatedE18 =
          imbalance
          ->mul(marketTreasurySplitGradientE18)
          ->div(totalValueLockedInMarket);
        let marketPercentE18 =
          min(marketPercentCalculatedE18, CONSTANTS.tenToThe18);
        let treasuryPercentE18 = CONSTANTS.tenToThe18->sub(marketPercentE18);
        let expectedResult = treasuryPercentE18;

        let%Await actualResult =
          contracts.contents.longShort
          ->LongShort.Exposed._getYieldSplitExposed(
              ~longValue=syntheticTokenPoolValueLong,
              ~shortValue=syntheticTokenPoolValueShort,
              ~totalValueLockedInMarket,
            );
        Chai.bnEqual(
          ~message=
            "expectedResult and result after `_getYieldSplit` not the same",
          expectedResult,
          actualResult.treasuryPercentE18,
        );
      };

      it("works as expected if longValue > shortValue", () => {
        let syntheticTokenPoolValueShort = Helpers.randomTokenAmount();
        let syntheticTokenPoolValueLong =
          syntheticTokenPoolValueShort->add(Helpers.randomTokenAmount());

        test(~syntheticTokenPoolValueLong, ~syntheticTokenPoolValueShort);
      });
      it("works as expected if shortValue > longValue", () => {
        let syntheticTokenPoolValueLong = Helpers.randomTokenAmount();
        let syntheticTokenPoolValueShort =
          syntheticTokenPoolValueLong->add(Helpers.randomTokenAmount());

        test(~syntheticTokenPoolValueLong, ~syntheticTokenPoolValueShort);
      });
      it("works as expected if shortValue == longValue", () => {
        let syntheticTokenPoolValueLong = Helpers.randomTokenAmount();
        let syntheticTokenPoolValueShort = syntheticTokenPoolValueLong;

        test(~syntheticTokenPoolValueLong, ~syntheticTokenPoolValueShort);
      });
    });
  });
};
