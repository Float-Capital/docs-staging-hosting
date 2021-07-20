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
        let a = Js.Math.random_int(1, Js.Int.max);
        let b = Js.Math.random_int(1, Js.Int.max);

        let expectedResult = Js.Math.min_int(a, b)->Ethers.BigNumber.fromInt;

        let%Await actualResult =
          contracts.contents.longShort
          ->LongShort.Exposed._getMinExposed(
              ~a=Ethers.BigNumber.fromInt(a),
              ~b=Ethers.BigNumber.fromInt(b),
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
