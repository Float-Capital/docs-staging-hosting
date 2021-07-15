open Mocha;
open Globals;

let testUnit =
    (
      ~contracts as _: ref(Helpers.coreContracts),
      ~accounts as _: ref(array(Ethers.Wallet.t)),
    ) => {
  describeUnit("Long Short Utilities and helpers", () => {
    describe("floor", () => {
      it("works as expected", ()
        // A dead simple test that generates two numbers and returns the smaller one
        =>
          Js.log("TODO")
        )
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
    describe("_saveSyntheticTokenPriceSnapshots", () => {
      it("saves and overwrites the correct values", () =>
        Js.log("TODO")
      )
    });
  });
};
