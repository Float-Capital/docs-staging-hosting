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
      it("works as expected if longValue > shortValue", () =>
        Js.log("TODO")
      );
      it("works as expected if shortValue > longValue", () =>
        Js.log("TODO")
      );
      it("works as expected if shortValue == longValue", () =>
        Js.log("TODO")
      );
    });
  });
};
