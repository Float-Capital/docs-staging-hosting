open LetOps;
open Mocha;
open Globals;
open SmockGeneral;

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
            ~userNextPrice_syntheticToken_redeemAmount,
            ~userNextPrice_currentUpdateIndex,
            ~syntheticToken_priceSnapshot,
          ) => {
        let {longShort} = contracts.contents;
        longShortRef := longShort;
        let%Await smockedLongSynth = SyntheticTokenSmocked.make();
        let%Await smockedShortSynth = SyntheticTokenSmocked.make();

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
          ~userNextPrice_syntheticToken_redeemAmount,
          ~userNextPrice_currentUpdateIndex,
          ~syntheticToken_priceSnapshot,
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
                ~userNextPrice_syntheticToken_redeemAmount=zeroBn,
                ~userNextPrice_currentUpdateIndex=Helpers.randomInteger(),
                ~syntheticToken_priceSnapshot=Helpers.randomTokenAmount(),
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
            ();

            expect(
              (isLong ? longSynthSmocked : shortSynthSmocked).contents
              ->SyntheticTokenSmocked.transferFunction,
            )
            ->toHaveCallCount(0);
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
          let userNextPrice_syntheticToken_redeemAmount =
            Helpers.randomTokenAmount();
          let syntheticToken_priceSnapshot = Helpers.randomTokenAmount();

          before_each(() => {
            let%Await _ =
              setup(
                ~isLong,
                ~userNextPrice_syntheticToken_redeemAmount,
                ~userNextPrice_currentUpdateIndex=Helpers.randomInteger(),
                ~syntheticToken_priceSnapshot,
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
            let expectedAmountOfSynthToRecieve =
              Contract.LongShortHelpers.calcAmountSyntheticToken(
                ~amountPaymentToken=userNextPrice_syntheticToken_redeemAmount,
                ~price=syntheticToken_priceSnapshot,
              );
            (isLong ? longSynthSmocked : shortSynthSmocked).contents
            ->SyntheticTokenSmocked.transferCallCheck({
                recipient: user,
                amount: expectedAmountOfSynthToRecieve,
              });
          });

          it("should reset userNextPriceDepositAmount to zero", () => {
            let%Await userNextPriceDepositAmount =
              contracts.contents.longShort
              ->LongShort.userNextPrice_paymentToken_depositAmount(
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
      let yieldManagerSmocked =
        ref(YieldManagerMockSmocked.uninitializedValue);

      let setup =
          (
            ~isLong,
            ~userNextPrice_syntheticToken_redeemAmount,
            ~userNextPrice_currentUpdateIndex,
            ~syntheticToken_priceSnapshot,
          ) => {
        let {longShort} = contracts^;

        let%Await smockedYieldManeger = YieldManagerMockSmocked.make();

        yieldManagerSmocked := smockedYieldManeger;

        longShort->LongShort.Exposed.setExecuteOutstandingNextPriceRedeemsGlobals(
          ~marketIndex,
          ~user,
          ~isLong,
          ~yieldManager=smockedYieldManeger.address,
          ~userNextPrice_syntheticToken_redeemAmount,
          ~userNextPrice_currentUpdateIndex,
          ~syntheticToken_priceSnapshot,
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
                ~userNextPrice_syntheticToken_redeemAmount=zeroBn,
                ~userNextPrice_currentUpdateIndex=Helpers.randomInteger(),
                ~syntheticToken_priceSnapshot=Helpers.randomTokenAmount(),
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
            expect(
              yieldManagerSmocked.contents
              ->YieldManagerMockSmocked.transferPaymentTokensToUserFunction,
            )
            ->toHaveCallCount(0);
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
          let userNextPrice_syntheticToken_redeemAmount =
            Helpers.randomTokenAmount();
          let syntheticToken_priceSnapshot = Helpers.randomTokenAmount();

          before_each(() => {
            let%Await _ =
              setup(
                ~isLong,
                ~userNextPrice_syntheticToken_redeemAmount,
                ~userNextPrice_currentUpdateIndex=Helpers.randomInteger(),
                ~syntheticToken_priceSnapshot,
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
            let expectedAmountOfPaymentTokenToRecieve =
              Contract.LongShortHelpers.calcAmountPaymentToken(
                ~amountSyntheticToken=userNextPrice_syntheticToken_redeemAmount,
                ~price=syntheticToken_priceSnapshot,
              );
            yieldManagerSmocked.contents
            ->YieldManagerMockSmocked.transferPaymentTokensToUserCallCheck({
                user,
                amount: expectedAmountOfPaymentTokenToRecieve,
              });
          });

          it("should reset userNextPriceDepositAmount to zero", () => {
            let%Await userNextPriceDepositAmount =
              contracts.contents.longShort
              ->LongShort.userNextPrice_paymentToken_depositAmount(
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
            ~userNextPrice_syntheticToken_toShiftAwayFrom_marketSide,
            ~userNextPrice_currentUpdateIndex,
            ~syntheticToken_priceSnapshotShiftedFrom,
            ~syntheticToken_priceSnapshotShiftedTo,
          ) => {
        let {longShort} = contracts.contents;

        let%Await smockedLongSynth = SyntheticTokenSmocked.make();
        let%Await smockedShortSynth = SyntheticTokenSmocked.make();

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
          ~userNextPrice_syntheticToken_toShiftAwayFrom_marketSide,
          ~userNextPrice_currentUpdateIndex,
          ~syntheticToken_priceSnapshotShiftedFrom,
          ~syntheticToken_priceSnapshotShiftedTo,
        );
      };
      let testExecuteOutstandingNextPriceRedeems = (~isShiftFromLong) => {
        describe("syntheticToken_toShiftAwayFrom_marketSide == 0", () => {
          let executeOutstandingNextPriceRedeemsTx =
            ref("Undefined"->Obj.magic);

          before_each(() => {
            let%Await _ =
              setup(
                ~isShiftFromLong,
                ~userNextPrice_syntheticToken_toShiftAwayFrom_marketSide=zeroBn,
                ~userNextPrice_currentUpdateIndex=Helpers.randomInteger(),
                ~syntheticToken_priceSnapshotShiftedFrom=
                  Helpers.randomTokenAmount(),
                ~syntheticToken_priceSnapshotShiftedTo=
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

            expect(
              (isShiftFromLong ? shortSynthSmocked : longSynthSmocked).contents
              ->SyntheticTokenSmocked.transferFunction,
            )
            ->toHaveCallCount(0);
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
          let userNextPrice_syntheticToken_toShiftAwayFrom_marketSide =
            Helpers.randomTokenAmount();
          let syntheticToken_priceSnapshotShiftedFrom =
            Helpers.randomTokenAmount();
          let syntheticToken_priceSnapshotShiftedTo =
            Helpers.randomTokenAmount();

          before_each(() => {
            let%Await _ =
              setup(
                ~isShiftFromLong,
                ~userNextPrice_syntheticToken_toShiftAwayFrom_marketSide,
                ~userNextPrice_currentUpdateIndex=Helpers.randomInteger(),
                ~syntheticToken_priceSnapshotShiftedFrom,
                ~syntheticToken_priceSnapshotShiftedTo,
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

            let expectedAmountOfPaymentTokenToRecieve =
              Contract.LongShortHelpers.calcAmountPaymentToken(
                ~amountSyntheticToken=userNextPrice_syntheticToken_toShiftAwayFrom_marketSide,
                ~price=syntheticToken_priceSnapshotShiftedFrom,
              );

            let expectedAmountOfOtherSyntheticTokenToRecieve =
              Contract.LongShortHelpers.calcAmountSyntheticToken(
                ~amountPaymentToken=expectedAmountOfPaymentTokenToRecieve,
                ~price=syntheticToken_priceSnapshotShiftedTo,
              );
            (isShiftFromLong ? shortSynthSmocked : longSynthSmocked).contents
            ->SyntheticTokenSmocked.transferCallCheck({
                recipient: user,
                amount: expectedAmountOfOtherSyntheticTokenToRecieve,
              });
          });

          it(
            "should reset userNextPrice_syntheticToken_toShiftAwayFrom_marketSide to zero",
            () => {
            let%Await userNextPrice_syntheticToken_toShiftAwayFrom_marketSide =
              contracts.contents.longShort
              ->LongShort.userNextPrice_syntheticToken_toShiftAwayFrom_marketSide(
                  marketIndex,
                  isShiftFromLong,
                  user,
                );
            Chai.bnEqual(
              zeroBn,
              userNextPrice_syntheticToken_toShiftAwayFrom_marketSide,
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
