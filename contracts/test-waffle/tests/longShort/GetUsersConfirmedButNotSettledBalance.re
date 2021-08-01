open LetOps;
open Mocha;
open Globals;

let testUnit =
    (
      ~contracts: ref(Helpers.coreContracts),
      ~accounts as _: ref(array(Ethers.Wallet.t)),
    ) => {
  describe("getUsersConfirmedButNotSettledSynthBalance", () => {
    let user = Helpers.randomAddress();
    let isLong =
      switch (Js.Math.random_int(0, 2)) {
      | 0 => false
      | _ => true
      };
    let marketIndex = 1;

    before_once'(() => {
      contracts.contents.longShort
      ->LongShortSmocked.InternalMock.setupFunctionForUnitTesting(
          ~functionName="getUsersConfirmedButNotSettledSynthBalance",
        )
    });

    describe(
      {j|[happy case] [isLong: $isLong] userNextPrice_currentUpdateIndex within bounds|j},
      () => {
        let userNextPrice_currentUpdateIndex = oneBn;
        let marketUpdateIndex = twoBn;

        describe(
          "userNextPriceDepositAmount non-zero and userNextPrice_amountSynthToShiftFromMarketSide zero",
          () => {
            let userNextPrice_depositAmount_isLong =
              Helpers.randomTokenAmount();
            let syntheticTokenPriceSnapshot_isLong =
              Helpers.randomTokenAmount();
            let syntheticTokenPriceSnapshot_notIsLong =
              Helpers.randomTokenAmount();
            let userNextPrice_amountSynthToShiftFromMarketSide_notIsLong = zeroBn;

            it("should return correct result", () => {
              let%Await _ =
                contracts.contents.longShort
                ->LongShort.Exposed.setGetUsersConfirmedButNotSettledBalanceGlobals(
                    ~marketIndex,
                    ~user,
                    ~isLong,
                    ~userNextPrice_currentUpdateIndex,
                    ~marketUpdateIndex,
                    ~userNextPrice_depositAmount_isLong,
                    ~syntheticTokenPriceSnapshot_isLong,
                    ~syntheticTokenPriceSnapshot_notIsLong,
                    ~userNextPrice_amountSynthToShiftFromMarketSide_notIsLong,
                  );

              let expectedResult =
                userNextPrice_depositAmount_isLong
                ->mul(tenToThe18)
                ->div(syntheticTokenPriceSnapshot_isLong);
              let%Await actualResult =
                contracts.contents.longShort
                ->LongShort.getUsersConfirmedButNotSettledSynthBalance(
                    ~user,
                    ~marketIndex,
                    ~isLong,
                  );
              Chai.bnEqual(expectedResult, actualResult);
            });
          },
        );

        describe(
          "userNextPriceDepositAmount zero and userNextPrice_amountSynthToShiftFromMarketSide non-zero",
          () => {
            let userNextPrice_depositAmount_isLong = zeroBn;
            let syntheticTokenPriceSnapshot_isLong =
              Helpers.randomTokenAmount();
            let syntheticTokenPriceSnapshot_notIsLong =
              Helpers.randomTokenAmount();
            let userNextPrice_amountSynthToShiftFromMarketSide_notIsLong =
              Helpers.randomTokenAmount();

            it("should return correct result", () => {
              let%Await _ =
                contracts.contents.longShort
                ->LongShort.Exposed.setGetUsersConfirmedButNotSettledBalanceGlobals(
                    ~marketIndex,
                    ~user,
                    ~isLong,
                    ~userNextPrice_currentUpdateIndex,
                    ~marketUpdateIndex,
                    ~userNextPrice_depositAmount_isLong,
                    ~syntheticTokenPriceSnapshot_isLong,
                    ~syntheticTokenPriceSnapshot_notIsLong,
                    ~userNextPrice_amountSynthToShiftFromMarketSide_notIsLong,
                  );

              let expectedResult =
                userNextPrice_amountSynthToShiftFromMarketSide_notIsLong
                ->mul(syntheticTokenPriceSnapshot_notIsLong)
                ->div(syntheticTokenPriceSnapshot_isLong);
              let%Await actualResult =
                contracts.contents.longShort
                ->LongShort.getUsersConfirmedButNotSettledSynthBalance(
                    ~user,
                    ~marketIndex,
                    ~isLong,
                  );
              Chai.bnEqual(expectedResult, actualResult);
            });
          },
        );
        describe(
          "userNextPriceDepositAmount non-zero and userNextPrice_amountSynthToShiftFromMarketSide non-zero",
          () => {
            let userNextPrice_depositAmount_isLong =
              Helpers.randomTokenAmount();
            let syntheticTokenPriceSnapshot_isLong =
              Helpers.randomTokenAmount();
            let syntheticTokenPriceSnapshot_notIsLong =
              Helpers.randomTokenAmount();
            let userNextPrice_amountSynthToShiftFromMarketSide_notIsLong =
              Helpers.randomTokenAmount();

            it("should return correct result", () => {
              let%Await _ =
                contracts.contents.longShort
                ->LongShort.Exposed.setGetUsersConfirmedButNotSettledBalanceGlobals(
                    ~marketIndex,
                    ~user,
                    ~isLong,
                    ~userNextPrice_currentUpdateIndex,
                    ~marketUpdateIndex,
                    ~userNextPrice_depositAmount_isLong,
                    ~syntheticTokenPriceSnapshot_isLong,
                    ~syntheticTokenPriceSnapshot_notIsLong,
                    ~userNextPrice_amountSynthToShiftFromMarketSide_notIsLong,
                  );

              let expectedResult =
                userNextPrice_amountSynthToShiftFromMarketSide_notIsLong
                ->mul(syntheticTokenPriceSnapshot_notIsLong)
                ->div(syntheticTokenPriceSnapshot_isLong)
                ->add(
                    userNextPrice_depositAmount_isLong
                    ->mul(tenToThe18)
                    ->div(syntheticTokenPriceSnapshot_isLong),
                  );
              let%Await actualResult =
                contracts.contents.longShort
                ->LongShort.getUsersConfirmedButNotSettledSynthBalance(
                    ~user,
                    ~marketIndex,
                    ~isLong,
                  );
              Chai.bnEqual(expectedResult, actualResult);
            });
          },
        );
      },
    );
    describe(
      {j|[sad case] [isLong: $isLong] userNextPrice_currentUpdateIndex out of bounds|j},
      () => {
        let userNextPrice_depositAmount_isLong = Helpers.randomTokenAmount();
        let syntheticTokenPriceSnapshot_isLong = Helpers.randomTokenAmount();
        let syntheticTokenPriceSnapshot_notIsLong =
          Helpers.randomTokenAmount();
        let userNextPrice_amountSynthToShiftFromMarketSide_notIsLong =
          Helpers.randomTokenAmount();

        let setup = (~userNextPrice_currentUpdateIndex, ~marketUpdateIndex) => {
          contracts.contents.longShort
          ->LongShort.Exposed.setGetUsersConfirmedButNotSettledBalanceGlobals(
              ~marketIndex,
              ~user,
              ~isLong,
              ~userNextPrice_currentUpdateIndex,
              ~marketUpdateIndex,
              ~userNextPrice_depositAmount_isLong,
              ~syntheticTokenPriceSnapshot_isLong,
              ~syntheticTokenPriceSnapshot_notIsLong,
              ~userNextPrice_amountSynthToShiftFromMarketSide_notIsLong,
            );
        };

        it("returns 0 if userNextPrice_currentUpdateIndex == 0", () => {
          let userNextPrice_currentUpdateIndex = zeroBn;
          let marketUpdateIndex = oneBn;

          let%Await _ =
            setup(~userNextPrice_currentUpdateIndex, ~marketUpdateIndex);

          let%Await result =
            contracts^.longShort
            ->LongShort.getUsersConfirmedButNotSettledSynthBalance(
                ~user,
                ~marketIndex,
                ~isLong,
              );

          Chai.bnEqual(zeroBn, result);
        });
        it(
          "returns 0 if userNextPrice_currentUpdateIndex > currentMarketUpdateIndex",
          () => {
          let userNextPrice_currentUpdateIndex = twoBn;
          let marketUpdateIndex = oneBn;

          let%Await _ =
            setup(~userNextPrice_currentUpdateIndex, ~marketUpdateIndex);

          let%Await result =
            contracts^.longShort
            ->LongShort.getUsersConfirmedButNotSettledSynthBalance(
                ~user,
                ~marketIndex,
                ~isLong,
              );

          Chai.bnEqual(zeroBn, result);
        });
      },
    );
  });
};
