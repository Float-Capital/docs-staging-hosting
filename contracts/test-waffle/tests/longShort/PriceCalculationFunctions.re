open LetOps;
open Mocha;
open Helpers;

let testUnit =
    (
      ~contracts: ref(Helpers.coreContracts),
      ~accounts as _: ref(array(Ethers.Wallet.t)),
    ) => {
  describe("_getSyntheticTokenPrice", () => {
    it("should test function returns correct price", () => {
      let randomAmountPaymentToken = Helpers.randomTokenAmount();
      let randomAmountSynthToken = Helpers.randomTokenAmount();

      let%Await actualResult =
        contracts^.longShort
        ->LongShort.Exposed._getSyntheticTokenPriceExposed(
            ~amountPaymentTokenBackingSynth=randomAmountPaymentToken,
            ~amountSynthToken=randomAmountSynthToken,
          );

      let expectedResult =
        Contract.LongShortHelpers.calcSyntheticTokenPrice(
          ~amountPaymentToken=randomAmountPaymentToken,
          ~amountSynthToken=randomAmountSynthToken,
        );

      Chai.bnEqual(
        ~message=
          "expected result different to actual result for _getSyntheticTokenPrice call",
        actualResult,
        expectedResult,
      );
    })
  });

  describe("_getAmountPaymentToken", () => {
    it("should test function returns correct amount", () => {
      let randomAmountSynthToken = Helpers.randomTokenAmount();
      let randomTokenPrice = Helpers.randomTokenAmount();

      let%Await actualResult =
        contracts^.longShort
        ->LongShort.Exposed._getAmountPaymentTokenExposed(
            ~amountSynthToken=randomAmountSynthToken,
            ~syntheticTokenPriceInPaymentTokens=randomTokenPrice,
          );

      let expectedResult =
        Contract.LongShortHelpers.calcAmountPaymentToken(
          ~amountSynthToken=randomAmountSynthToken,
          ~price=randomTokenPrice,
        );
      Chai.bnEqual(
        ~message=
          "expected result different to actual result for _getAmountPaymentToken call",
        actualResult,
        expectedResult,
      );
    })
  });

  describe("_getAmountSynthToken", () => {
    it("should test function returns correct amount", () => {
      let randomAmountPaymentToken = Helpers.randomTokenAmount();
      let randomTokenPrice = Helpers.randomTokenAmount();

      let%Await actualResult =
        contracts^.longShort
        ->LongShort.Exposed._getAmountSynthTokenExposed(
            ~amountPaymentTokenBackingSynth=randomAmountPaymentToken,
            ~syntheticTokenPriceInPaymentTokens=randomTokenPrice,
          );

      let expectedResult =
        Contract.LongShortHelpers.calcAmountSynthToken(
          ~amountPaymentToken=randomAmountPaymentToken,
          ~price=randomTokenPrice,
        );

      Chai.bnEqual(
        ~message=
          "expected result different to actual result for _getAmountSynthTokencd call",
        actualResult,
        expectedResult,
      );
    })
  });
};
