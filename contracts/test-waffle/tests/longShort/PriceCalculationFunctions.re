open LetOps;
open Mocha;
open Globals;

open Ethers;

open Helpers;

let testUnit =
    (
      ~contracts: ref(Helpers.coreContracts),
      ~accounts as _: ref(array(Ethers.Wallet.t)),
    ) => {
  describe_only("_getSyntheticTokenPrice", () => {
    it("should test function returns correct price", () => { 

      let randomTokenAmount1 = Helpers.randomTokenAmount();
      let randomTokenAmount2 = Helpers.randomTokenAmount();

      let%Await actualResult =
      contracts^.longShort
      ->LongShort.Exposed._getSyntheticTokenPriceExposed(
          ~amountPaymentToken=randomTokenAmount1,
          ~amountSynthToken=randomTokenAmount2,
        );

      let expectedResult = randomTokenAmount1->mul(CONSTANTS.tenToThe18)->div(randomTokenAmount2);
      Chai.bnEqual(~message="expected result different to actual result for _getSyntheticTokenPrice call", actualResult, expectedResult); 
      
    }) 
  });

  // describe.skip("_getAmountPaymentToken", () => {
  //   it("", () => {
  //     //helpers.randomInteger
  //     LongShort.Exposed._getAmountPaymentTokenExposed()
  //   })
      
    
  // });

  // describe("_getAmountSynthToken", () => {
  //   it("", () => {
  //     //helpers.randomInteger
  //     LongShort.Exposed._getAmountSynthTokenExposed()
  //   })
  // });
};
