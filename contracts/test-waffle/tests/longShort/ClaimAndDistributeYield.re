open Mocha;
open Globals;

let testUnit =
    (
      ~contracts as _: ref(Helpers.coreContracts),
      ~accounts as _: ref(array(Ethers.Wallet.t)),
    ) => {
  describeUnit("_claimAndDistributeYield", () => {
    it(
      "gets the yield split from _getYieldSplit (passing it the correct parameters)",
      () =>
      Js.log("TODO")
    );
    it(
      "gets the claims yield the yield manager (claimYieldAndGetMarketAmount) correctly",
      () =>
      Js.log("TODO")
    );
    it(
      "adds the amount due for the market to the `syntheticTokenPoolValue` of the under balanced side (when long is under balanced)",
      () =>
      Js.log("TODO")
    );
    it(
      "adds the amount due for the market to the `syntheticTokenPoolValue` of the under balanced side (when short is under balanced)",
      () =>
      Js.log("TODO")
    );
  });
};
