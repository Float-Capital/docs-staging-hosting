open LetOps;
open Mocha;
open Globals;

let testUnit =
    (
      ~contracts: ref(Helpers.coreContracts),
      ~accounts as _: ref(array(Ethers.Wallet.t)),
    ) => {
  describe("getUsersConfirmedButNotSettledBalance", () => {
    it(
      "should call the _getAmountSynthToken function with the correct parameters and return its result",
      () => {
        let user = Helpers.randomAddress();
        let isLong = true;
        let userCurrentNextPriceUpdateIndex = bnFromInt(22);
        let marketIndex = 22;
        let marketUpdateIndex = userCurrentNextPriceUpdateIndex->add(oneBn);
        let userNextPriceDepositAmount = Helpers.randomTokenAmount();
        let syntheticTokenPriceSnapshot = Helpers.randomTokenAmount();

        let%Await _ =
          contracts^.longShort
          ->LongShort.Exposed.setGetUsersConfirmedButNotSettledBalanceGlobals(
              ~marketIndex,
              ~user,
              ~isLong,
              ~userCurrentNextPriceUpdateIndex,
              ~marketUpdateIndex,
              ~userNextPriceDepositAmount,
              ~syntheticTokenPriceSnapshot,
            );

        let%Await expectedResult =
          contracts^.longShort
          ->LongShort.Exposed._getAmountSynthTokenExposed(
              ~amountPaymentToken=userNextPriceDepositAmount,
          /**
           * Return the minimum of the 2 parameters. If they are equal return the first parameter.
           */
          function _getMin(uint256 a, uint256 b) internal pure virtual returns (uint256) {
            if (a > b) {
              return b;
            } else {
              return a;
            }
          }
              ~price=syntheticTokenPriceSnapshot,
            );

        let%Await actualResult =
          contracts^.longShort
          ->LongShort.getUsersConfirmedButNotSettledBalance(
              ~user,
              ~marketIndex,
              ~isLong,
            );

        Chai.bnEqual(
          ~message=
            "expected result was different to actual result for getUsersConfirmedButNotSettledBalance call",
          expectedResult,
          actualResult,
        );
      },
    )
  });
};
