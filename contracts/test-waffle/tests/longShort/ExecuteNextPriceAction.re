open LetOps;
open Mocha;
open Globals;

let testUnit =
    (
      ~contracts: ref(Helpers.coreContracts),
      ~accounts as _: ref(array(Ethers.Wallet.t)),
    ) => {
  describeUnit("Execute next price action", () => {
    let marketIndex = Helpers.randomJsInteger();
    let user = Helpers.randomAddress();

    describe("_executeOutstandingNextPriceMints", () => {
      let longSynthSmocked = ref(SyntheticTokenSmocked.uninitializedValue);
      let shortSynthSmocked = ref(SyntheticTokenSmocked.uninitializedValue);
      let longShortRef: ref(LongShort.t) = ref(""->Obj.magic);

      let sampleAddress = Ethers.Wallet.createRandom().address;

      let setup =
          (
            ~isLong,
            ~userNextPriceRedemptionAmount,
            ~userCurrentNextPriceUpdateIndex,
            ~syntheticTokenPriceSnapshot,
          ) => {
        let {longShort, markets} = contracts^;
        let {longSynth, shortSynth} = markets->Array.getUnsafe(0);
        longShortRef := longShort;
        let%Await smockedLongSynth = SyntheticTokenSmocked.make(longSynth);
        let%Await smockedShortSynth = SyntheticTokenSmocked.make(shortSynth);

        smockedLongSynth->SyntheticTokenSmocked.mockTransferToReturn(true);
        smockedShortSynth->SyntheticTokenSmocked.mockTransferToReturn(true);

        longSynthSmocked := smockedLongSynth;
        shortSynthSmocked := smockedShortSynth;

        longShort->LongShort.Exposed.setExecuteOutstandingNextPriceMintsGlobals(
          ~marketIndex,
          ~user,
          ~isLong,
          ~syntheticToken=
            (isLong ? smockedLongSynth : smockedShortSynth).address,
          ~userNextPriceRedemptionAmount,
          ~userCurrentNextPriceUpdateIndex,
          ~syntheticTokenPriceSnapshot,
        );
      };
      let testExecuteOutstandingNextPriceMints = (~isLong) => {
        describe("userNextPriceDepositAmount == 0", () => {
          let executeOutstandingNextPriceMintsTx =
            ref("Undefined"->Obj.magic);

          before_each(() => {
            let%Await _ =
              setup(
                ~isLong,
                ~userNextPriceRedemptionAmount=zeroBn,
                ~userCurrentNextPriceUpdateIndex=Helpers.randomInteger(),
                ~syntheticTokenPriceSnapshot=Helpers.randomTokenAmount(),
              );

            executeOutstandingNextPriceMintsTx :=
              contracts.contents.longShort
              ->LongShort.Exposed._executeOutstandingNextPriceMintsExposed(
                  ~marketIndex,
                  ~user,
                  ~isLong,
                );
          });
          it("should not call any functions or change any state", () => {
            let%Await _ = executeOutstandingNextPriceMintsTx.contents;

            let transferCalls =
              (isLong ? longSynthSmocked : shortSynthSmocked).contents
              ->SyntheticTokenSmocked.transferCalls;

            Chai.recordArrayDeepEqualFlat(transferCalls, [||]);
          });

          it(
            "should not emit the ExecuteNextPriceMintSettlementUser event", () => {
            Chai.callEmitEvents(
              ~call=executeOutstandingNextPriceMintsTx.contents,
              ~contract=contracts.contents.longShort->Obj.magic,
              ~eventName="ExecuteNextPriceMintSettlementUser",
            )
            ->Chai.expectToNotEmit
          });
        });
        describe("userNextPriceDepositAmount > 0", () => {
          let executeOutstandingNextPriceMintsTx =
            ref("Undefined"->Obj.magic);
          let userNextPriceRedemptionAmount = Helpers.randomTokenAmount();
          let syntheticTokenPriceSnapshot = Helpers.randomTokenAmount();

          before_each(() => {
            let%Await _ =
              setup(
                ~isLong,
                ~userNextPriceRedemptionAmount,
                ~userCurrentNextPriceUpdateIndex=Helpers.randomInteger(),
                ~syntheticTokenPriceSnapshot,
              );

            executeOutstandingNextPriceMintsTx :=
              contracts.contents.longShort
              ->LongShort.Exposed._executeOutstandingNextPriceMintsExposed(
                  ~marketIndex,
                  ~user,
                  ~isLong,
                );
          });

          it(
            "should call transfer on the correct amount of synthetic tokens to the user",
            () => {
            let%Await _ = executeOutstandingNextPriceMintsTx.contents;
            let transferCalls =
              (isLong ? longSynthSmocked : shortSynthSmocked).contents
              ->SyntheticTokenSmocked.transferCalls;
            let expectedAmountOfSynthToRecieve =
              Contract.LongShortHelpers.calcAmountSynthToken(
                ~amountPaymentToken=userNextPriceRedemptionAmount,
                ~price=syntheticTokenPriceSnapshot,
              );
            Chai.recordArrayDeepEqualFlat(
              transferCalls,
              [|{recipient: user, amount: expectedAmountOfSynthToRecieve}|],
            );
          });

          it(
            "should emit the ExecuteNextPriceMintSettlementUser event with the correct arguments",
            () => {
              let expectedAmountOfSynthToRecieve =
                Contract.LongShortHelpers.calcAmountSynthToken(
                  ~amountPaymentToken=userNextPriceRedemptionAmount,
                  ~price=syntheticTokenPriceSnapshot,
                );

              Chai.callEmitEvents(
                ~call=executeOutstandingNextPriceMintsTx.contents,
                ~contract=contracts.contents.longShort->Obj.magic,
                ~eventName="ExecuteNextPriceMintSettlementUser",
              )
              ->Chai.withArgs4(
                  user,
                  marketIndex,
                  isLong,
                  expectedAmountOfSynthToRecieve,
                );
            },
          );
          it("should reset userNextPriceDepositAmount to zero", () => {
            let%Await userNextPriceDepositAmount =
              contracts.contents.longShort
              ->LongShort.userNextPriceDepositAmount(
                  marketIndex,
                  isLong,
                  user,
                );
            Chai.bnEqual(zeroBn, userNextPriceDepositAmount);
          });
        });
      };
      describe("Long Side", () =>
        testExecuteOutstandingNextPriceMints(~isLong=true)
      );
      describe("Short Side", () =>
        testExecuteOutstandingNextPriceMints(~isLong=false)
      );
    });

    describe("_executeOutstandingNextPriceRedeems", () => {
      let paymentTokenSmocked = ref(ERC20MockSmocked.uninitializedValue);

      let setup =
          (
            ~isLong,
            ~userNextPriceRedemptionAmount,
            ~userCurrentNextPriceUpdateIndex,
            ~syntheticTokenPriceSnapshot,
          ) => {
        let {longShort, markets} = contracts^;
        let {paymentToken} = markets->Array.getUnsafe(0);

        let%Await smockedPaymentToken = ERC20MockSmocked.make(paymentToken);

        smockedPaymentToken->ERC20MockSmocked.mockTransferToReturn(true);

        paymentTokenSmocked := smockedPaymentToken;

        longShort->LongShort.Exposed.setExecuteOutstandingNextPriceRedeemsGlobals(
          ~marketIndex,
          ~user,
          ~isLong,
          ~paymentToken=smockedPaymentToken.address,
          ~userNextPriceRedemptionAmount,
          ~userCurrentNextPriceUpdateIndex,
          ~syntheticTokenPriceSnapshot,
        );
      };
      let testExecuteOutstandingNextPriceRedeems = (~isLong) => {
        describe("userNextPriceDepositAmount == 0", () => {
          let executeOutstandingNextPriceRedeemsTx =
            ref("Undefined"->Obj.magic);

          before_each(() => {
            let%Await _ =
              setup(
                ~isLong,
                ~userNextPriceRedemptionAmount=zeroBn,
                ~userCurrentNextPriceUpdateIndex=Helpers.randomInteger(),
                ~syntheticTokenPriceSnapshot=Helpers.randomTokenAmount(),
              );

            executeOutstandingNextPriceRedeemsTx :=
              contracts.contents.longShort
              ->LongShort.Exposed._executeOutstandingNextPriceRedeemsExposed(
                  ~marketIndex,
                  ~user,
                  ~isLong,
                );
          });
          it("should not call any functions or change any state", () => {
            let%Await _ = executeOutstandingNextPriceRedeemsTx.contents;

            let transferCalls =
              paymentTokenSmocked.contents->ERC20MockSmocked.transferCalls;

            Chai.recordArrayDeepEqualFlat(transferCalls, [||]);
          });

          it(
            "should not emit the ExecuteNextPriceRedeemSettlementUser event",
            () => {
            Chai.callEmitEvents(
              ~call=executeOutstandingNextPriceRedeemsTx.contents,
              ~contract=contracts.contents.longShort->Obj.magic,
              ~eventName="ExecuteNextPriceRedeemSettlementUser",
            )
            ->Chai.expectToNotEmit
          });
        });
        describe("userNextPriceDepositAmount > 0", () => {
          let executeOutstandingNextPriceRedeemsTx =
            ref("Undefined"->Obj.magic);
          let userNextPriceRedemptionAmount = Helpers.randomTokenAmount();
          let syntheticTokenPriceSnapshot = Helpers.randomTokenAmount();

          let isLong = true;

          before_each(() => {
            let%Await _ =
              setup(
                ~isLong,
                ~userNextPriceRedemptionAmount,
                ~userCurrentNextPriceUpdateIndex=Helpers.randomInteger(),
                ~syntheticTokenPriceSnapshot,
              );

            executeOutstandingNextPriceRedeemsTx :=
              contracts.contents.longShort
              ->LongShort.Exposed._executeOutstandingNextPriceRedeemsExposed(
                  ~marketIndex,
                  ~user,
                  ~isLong,
                );
          });

          it(
            "should call transfer on the correct amount of Payment Tokens to the user",
            () => {
            let%Await _ = executeOutstandingNextPriceRedeemsTx.contents;
            let transferCalls =
              paymentTokenSmocked.contents->ERC20MockSmocked.transferCalls;
            let expectedAmountOfPaymentTokenToRecieve =
              Contract.LongShortHelpers.calcAmountPaymentToken(
                ~amountSynthToken=userNextPriceRedemptionAmount,
                ~price=syntheticTokenPriceSnapshot,
              );
            Chai.recordArrayDeepEqualFlat(
              transferCalls,
              [|
                {
                  recipient: user,
                  amount: expectedAmountOfPaymentTokenToRecieve,
                },
              |],
            );
          });

          it(
            "should emit the ExecuteNextPriceRedeemSettlementUser event with the correct arguments",
            () => {
              let expectedAmountOfPaymentTokenToRecieve =
                Contract.LongShortHelpers.calcAmountPaymentToken(
                  ~amountSynthToken=userNextPriceRedemptionAmount,
                  ~price=syntheticTokenPriceSnapshot,
                );

              Chai.callEmitEvents(
                ~call=executeOutstandingNextPriceRedeemsTx.contents,
                ~contract=contracts.contents.longShort->Obj.magic,
                ~eventName="ExecuteNextPriceRedeemSettlementUser",
              )
              ->Chai.withArgs4(
                  user,
                  marketIndex,
                  isLong,
                  expectedAmountOfPaymentTokenToRecieve,
                );
            },
          );
          it("should reset userNextPriceDepositAmount to zero", () => {
            let%Await userNextPriceDepositAmount =
              contracts.contents.longShort
              ->LongShort.userNextPriceDepositAmount(
                  marketIndex,
                  isLong,
                  user,
                );
            Chai.bnEqual(zeroBn, userNextPriceDepositAmount);
          });
        });
      };
      describe("Long Side", () =>
        testExecuteOutstandingNextPriceRedeems(~isLong=true)
      );
      describe("Short Side", () =>
        testExecuteOutstandingNextPriceRedeems(~isLong=false)
      );
    });
  });
};
