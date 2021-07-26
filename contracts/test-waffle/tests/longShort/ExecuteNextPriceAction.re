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

      let setup =
          (
            ~isLong,
            ~userNextPriceRedemptionAmount,
            ~userCurrentNextPriceUpdateIndex,
            ~syntheticTokenPriceSnapshot,
          ) => {
        let {longShort, markets} = contracts.contents;
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

    describe("_executeOutstandingNextPriceTokenShifts", () => {
      let longSynthSmocked = ref(SyntheticTokenSmocked.uninitializedValue);
      let shortSynthSmocked = ref(SyntheticTokenSmocked.uninitializedValue);

      let setup =
          (
            ~isShiftFromLong,
            ~userNextPrice_amountSynthToShiftFromMarketSide,
            ~userCurrentNextPriceUpdateIndex,
            ~syntheticTokenPriceSnapshotShiftedFrom,
            ~syntheticTokenPriceSnapshotShiftedTo,
          ) => {
        let {longShort, markets} = contracts.contents;
        let {longSynth, shortSynth} = markets->Array.getUnsafe(0);

        let%Await smockedLongSynth = SyntheticTokenSmocked.make(longSynth);
        let%Await smockedShortSynth = SyntheticTokenSmocked.make(shortSynth);

        smockedLongSynth->SyntheticTokenSmocked.mockTransferToReturn(true);
        smockedShortSynth->SyntheticTokenSmocked.mockTransferToReturn(true);

        longSynthSmocked := smockedLongSynth;
        shortSynthSmocked := smockedShortSynth;

        longShort->LongShort.Exposed.setExecuteOutstandingNextPriceTokenShiftsGlobals(
          ~marketIndex,
          ~user,
          ~isShiftFromLong,
          ~syntheticTokenShiftedTo=
            (isShiftFromLong ? smockedShortSynth : smockedLongSynth).address,
          ~userNextPrice_amountSynthToShiftFromMarketSide,
          ~userCurrentNextPriceUpdateIndex,
          ~syntheticTokenPriceSnapshotShiftedFrom,
          ~syntheticTokenPriceSnapshotShiftedTo,
        );
      };
      let testExecuteOutstandingNextPriceRedeems = (~isShiftFromLong) => {
        describe("synthTokensShiftedAwayFromMarketSide == 0", () => {
          let executeOutstandingNextPriceRedeemsTx =
            ref("Undefined"->Obj.magic);

          before_each(() => {
            let%Await _ =
              setup(
                ~isShiftFromLong,
                ~userNextPrice_amountSynthToShiftFromMarketSide=zeroBn,
                ~userCurrentNextPriceUpdateIndex=Helpers.randomInteger(),
                ~syntheticTokenPriceSnapshotShiftedFrom=
                  Helpers.randomTokenAmount(),
                ~syntheticTokenPriceSnapshotShiftedTo=
                  Helpers.randomTokenAmount(),
              );

            executeOutstandingNextPriceRedeemsTx :=
              contracts.contents.longShort
              ->LongShort.Exposed._executeOutstandingNextPriceTokenShiftsExposed(
                  ~marketIndex,
                  ~user,
                  ~isShiftFromLong,
                );
          });
          it("should not call any functions or change any state", () => {
            let%Await _ = executeOutstandingNextPriceRedeemsTx.contents;

            let transferCalls =
              (isShiftFromLong ? shortSynthSmocked : longSynthSmocked).contents
              ->SyntheticTokenSmocked.transferCalls;

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
          let userNextPrice_amountSynthToShiftFromMarketSide =
            Helpers.randomTokenAmount();
          let syntheticTokenPriceSnapshotShiftedFrom =
            Helpers.randomTokenAmount();
          let syntheticTokenPriceSnapshotShiftedTo =
            Helpers.randomTokenAmount();

          before_each(() => {
            let%Await _ =
              setup(
                ~isShiftFromLong,
                ~userNextPrice_amountSynthToShiftFromMarketSide,
                ~userCurrentNextPriceUpdateIndex=Helpers.randomInteger(),
                ~syntheticTokenPriceSnapshotShiftedFrom,
                ~syntheticTokenPriceSnapshotShiftedTo,
              );

            executeOutstandingNextPriceRedeemsTx :=
              contracts.contents.longShort
              ->LongShort.Exposed._executeOutstandingNextPriceTokenShiftsExposed(
                  ~marketIndex,
                  ~user,
                  ~isShiftFromLong,
                );
          });

          it(
            "should call transfer on the correct amount of Syntetic Tokens to the user",
            () => {
            let%Await _ = executeOutstandingNextPriceRedeemsTx.contents;
            let transferCalls =
              (isShiftFromLong ? shortSynthSmocked : longSynthSmocked).contents
              ->SyntheticTokenSmocked.transferCalls;

            let expectedAmountOfPaymentTokenToRecieve =
              Contract.LongShortHelpers.calcAmountPaymentToken(
                ~amountSynthToken=userNextPrice_amountSynthToShiftFromMarketSide,
                ~price=syntheticTokenPriceSnapshotShiftedFrom,
              );

            let expectedAmountOfOtherSynthTokenToRecieve =
              Contract.LongShortHelpers.calcAmountSynthToken(
                ~amountPaymentToken=expectedAmountOfPaymentTokenToRecieve,
                ~price=syntheticTokenPriceSnapshotShiftedTo,
              );
            Chai.recordArrayDeepEqualFlat(
              transferCalls,
              [|
                {
                  recipient: user,
                  amount: expectedAmountOfOtherSynthTokenToRecieve,
                },
              |],
            );
          });

          it(
            "should emit the ExecuteNextPriceRedeemSettlementUser event with the correct arguments",
            () => {
              let expectedAmountOfPaymentTokenToRecieve =
                Contract.LongShortHelpers.calcAmountPaymentToken(
                  ~amountSynthToken=userNextPrice_amountSynthToShiftFromMarketSide,
                  ~price=syntheticTokenPriceSnapshotShiftedFrom,
                );
              let expectedAmountOfOtherSynthTokenToRecieve =
                Contract.LongShortHelpers.calcAmountSynthToken(
                  ~amountPaymentToken=expectedAmountOfPaymentTokenToRecieve,
                  ~price=syntheticTokenPriceSnapshotShiftedTo,
                );

              Chai.callEmitEvents(
                ~call=executeOutstandingNextPriceRedeemsTx.contents,
                ~contract=contracts.contents.longShort->Obj.magic,
                ~eventName="ExecuteNextPriceMarketSideShiftSettlementUser",
              )
              ->Chai.withArgs4(
                  user,
                  marketIndex,
                  isShiftFromLong,
                  expectedAmountOfOtherSynthTokenToRecieve,
                );
            },
          );
          it(
            "should reset userNextPrice_amountSynthToShiftFromMarketSide to zero",
            () => {
            let%Await userNextPrice_amountSynthToShiftFromMarketSide =
              contracts.contents.longShort
              ->LongShort.userNextPrice_amountSynthToShiftFromMarketSide(
                  marketIndex,
                  isShiftFromLong,
                  user,
                );
            Chai.bnEqual(
              zeroBn,
              userNextPrice_amountSynthToShiftFromMarketSide,
            );
          });
        });
      };
      describe("Long Side", () =>
        testExecuteOutstandingNextPriceRedeems(~isShiftFromLong=true)
      );
      describe("Short Side", () =>
        testExecuteOutstandingNextPriceRedeems(~isShiftFromLong=false)
      );
    });
  });
};
