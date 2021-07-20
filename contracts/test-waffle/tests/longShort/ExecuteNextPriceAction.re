open LetOps;
open Mocha;
open Globals;

let testUnit =
    (
      ~contracts: ref(Helpers.coreContracts),
      ~accounts: ref(array(Ethers.Wallet.t)),
    ) => {
  describe("Execute next price action", () => {
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
              longSynthSmocked.contents->SyntheticTokenSmocked.transferCalls;

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

          let isLong = true;

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
              longSynthSmocked.contents->SyntheticTokenSmocked.transferCalls;
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
  });
};
