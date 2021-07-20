open Mocha;
open Globals;
open LetOps;

let testUnit =
    (
      ~contracts: ref(Helpers.coreContracts),
      ~accounts as _: ref(array(Ethers.Wallet.t)),
    ) => {
  describeUnit("Long Short Utilities and helpers", () => {
    describe("_getMin", () => {
      it("returns smaller number when numbers are not equal", () => {
        let a = Helpers.randomJsInteger();
        let b = Helpers.randomJsInteger();

        let expectedResult = Js.Math.min_int(a, b)->bnFromInt;

        let%Await actualResult =
          contracts.contents.longShort
          ->LongShort.Exposed._getMinExposed(
              ~a=bnFromInt(a),
              ~b=bnFromInt(b),
            );

        Chai.bnEqual(
          ~message="incorrect number returned from _getMin",
          actualResult,
          expectedResult,
        );
      })
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
