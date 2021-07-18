open LetOps;
open Mocha;
open Globals;
open Helpers;

let testUnit =
    (
      ~contracts: ref(Helpers.coreContracts),
      ~accounts as _: ref(array(Ethers.Wallet.t)),
    ) => {
  describeUnit("_getYieldSplit", () => {
    it("returns correct treasury yield when longValue > shortValue", () => {
      let syntheticTokenPoolValueShort = Helpers.randomTokenAmount();
      let syntheticTokenPoolValueLong =
        syntheticTokenPoolValueShort->add(Helpers.randomTokenAmount());
      let totalValueLockedInMarket =
        syntheticTokenPoolValueLong->add(syntheticTokenPoolValueShort);
      let imbalance =
        syntheticTokenPoolValueLong->sub(syntheticTokenPoolValueShort);

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
      Chai.bnEqual(expectedResult, actualResult.treasuryPercentE18);
    });
    it("returns correct treasury yield when shortValue > longValue", () => {
      let syntheticTokenPoolValueLong = Helpers.randomTokenAmount();
      let syntheticTokenPoolValueShort =
        syntheticTokenPoolValueLong->add(Helpers.randomTokenAmount());
      let totalValueLockedInMarket =
        syntheticTokenPoolValueLong->add(syntheticTokenPoolValueShort);
      let imbalance =
        syntheticTokenPoolValueShort->sub(syntheticTokenPoolValueLong);

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
      Chai.bnEqual(expectedResult, actualResult.treasuryPercentE18);
    });
    it("returns correct treasury yield when shortValue == longValue", () => {
      let syntheticTokenPoolValueLong = Helpers.randomTokenAmount();
      let syntheticTokenPoolValueShort = syntheticTokenPoolValueLong;
      let totalValueLockedInMarket =
        syntheticTokenPoolValueLong->add(syntheticTokenPoolValueShort);
      let imbalance =
        syntheticTokenPoolValueShort->sub(syntheticTokenPoolValueLong);

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
      ();
      Chai.bnEqual(expectedResult, actualResult.treasuryPercentE18);
    });
  });
};
