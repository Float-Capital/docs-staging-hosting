open LetOps;
open Mocha;
open Globals;
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
            ~amountPaymentToken=randomAmountPaymentToken,
            ~amountSynthToken=randomAmountSynthToken,
          );

      let expectedResult =
        randomAmountPaymentToken
        ->mul(CONSTANTS.tenToThe18)
        ->div(randomAmountSynthToken);
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
            ~price=randomTokenPrice,
          );

      let expectedResult =
        randomAmountSynthToken
        ->mul(randomTokenPrice)
        ->div(CONSTANTS.tenToThe18);
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
            ~amountPaymentToken=randomAmountPaymentToken,
            ~price=randomTokenPrice,
          );

      let expectedResult =
        randomAmountPaymentToken
        ->mul(CONSTANTS.tenToThe18)
        ->div(randomTokenPrice);
      Chai.bnEqual(
        ~message=
          "expected result different to actual result for _getAmountSynthTokencd call",
        actualResult,
        expectedResult,
      );
    })
  });
};
