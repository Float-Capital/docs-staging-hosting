open Mocha;
open Globals;
open LetOps;

let testUnit =
    (
      ~contracts: ref(Helpers.coreContracts),
      ~accounts as _: ref(array(Ethers.Wallet.t)),
    ) => {
  describeUnit("Batched Settlement", () => {
    let marketIndex = Helpers.randomJsInteger();
    describe("_performOustandingBatchedSettlements", () => {
      let syntheticTokenPriceLong = Helpers.randomTokenAmount();
      let syntheticTokenPriceShort = Helpers.randomTokenAmount();

      let setup =
          (
            ~batched_amountOfPaymentTokenToDepositLong,
            ~batched_amountOfPaymentTokenToDepositShort,
            ~batched_amountOfSyntheticTokensToRedeemLong,
            ~batched_amountOfSyntheticTokensToRedeemShort,
            ~batchedAmountOfSyntheticTokensToShiftFromLong,
            ~batchedAmountOfSyntheticTokensToShiftFromShort,
          ) => {
        let {longShort} = contracts.contents;
        let%AwaitThen _ =
          longShort->LongShortSmocked.InternalMock.setupFunctionForUnitTesting(
            ~functionName="_performOustandingBatchedSettlements",
          );

        LongShortSmocked.InternalMock.mock_handleTotalPaymentTokenValueChangeForMarketWithYieldManagerToReturn();
        LongShortSmocked.InternalMock.mock_handleChangeInSyntheticTokensTotalSupplyToReturn();

        let%AwaitThen _ =
          longShort->LongShort.Exposed.setPerformOustandingBatchedSettlementsGlobals(
            ~marketIndex,
            ~batched_amountOfPaymentTokenToDepositLong,
            ~batched_amountOfPaymentTokenToDepositShort,
            ~batched_amountOfSyntheticTokensToRedeemLong,
            ~batched_amountOfSyntheticTokensToRedeemShort,
            ~batchedAmountOfSyntheticTokensToShiftFromLong,
            ~batchedAmountOfSyntheticTokensToShiftFromShort,
          );

        longShort->LongShort.Exposed._performOustandingBatchedSettlementsExposedCall(
          ~marketIndex,
          ~syntheticTokenPriceLong,
          ~syntheticTokenPriceShort,
        );
      };

      let runTest =
          (
            ~batched_amountOfPaymentTokenToDepositLong,
            ~batched_amountOfPaymentTokenToDepositShort,
            ~batched_amountOfSyntheticTokensToRedeemLong,
            ~batched_amountOfSyntheticTokensToRedeemShort,
            ~batchedAmountOfSyntheticTokensToShiftFromLong,
            ~batchedAmountOfSyntheticTokensToShiftFromShort,
          ) => {
        let batchedAmountOfSyntheticTokensToMintLong = ref(None->Obj.magic);
        let batchedAmountOfSyntheticTokensToMintShort = ref(None->Obj.magic);
        let batchedAmountOfPaymentTokensToBurnLong = ref(None->Obj.magic);
        let batchedAmountOfPaymentTokensToBurnShort = ref(None->Obj.magic);
        let batchedAmountOfPaymentTokensToShiftToLong = ref(None->Obj.magic);
        let batchedAmountOfPaymentTokensToShiftToShort = ref(None->Obj.magic);
        let batchedAmountOfSyntheticTokensToShiftToLong =
          ref(None->Obj.magic);
        let batchedAmountOfSyntheticTokensToShiftToShort =
          ref(None->Obj.magic);
        let calculatedValueChangeForLong = ref(None->Obj.magic);
        let calculatedValueChangeForShort = ref(None->Obj.magic);
        let calculatedValueChangeInSynthSupplyLong = ref(None->Obj.magic);
        let calculatedValueChangeInSynthSupplyShort = ref(None->Obj.magic);
        let returnOfPerformOustandingBatchedSettlements =
          ref(None->Obj.magic);

        before_each(() => {
          let%Await functionCallReturn =
            setup(
              ~batched_amountOfPaymentTokenToDepositLong,
              ~batched_amountOfPaymentTokenToDepositShort,
              ~batched_amountOfSyntheticTokensToRedeemLong,
              ~batched_amountOfSyntheticTokensToRedeemShort,
              ~batchedAmountOfSyntheticTokensToShiftFromLong,
              ~batchedAmountOfSyntheticTokensToShiftFromShort,
            );

          batchedAmountOfSyntheticTokensToMintLong :=
            Contract.LongShortHelpers.calcAmountSyntheticToken(
              ~amountPaymentToken=batched_amountOfPaymentTokenToDepositLong,
              ~price=syntheticTokenPriceLong,
            );
          batchedAmountOfSyntheticTokensToMintShort :=
            Contract.LongShortHelpers.calcAmountSyntheticToken(
              ~amountPaymentToken=batched_amountOfPaymentTokenToDepositShort,
              ~price=syntheticTokenPriceShort,
            );
          batchedAmountOfPaymentTokensToBurnLong :=
            Contract.LongShortHelpers.calcAmountPaymentToken(
              ~amountSyntheticToken=batched_amountOfSyntheticTokensToRedeemLong,
              ~price=syntheticTokenPriceLong,
            );
          batchedAmountOfPaymentTokensToBurnShort :=
            Contract.LongShortHelpers.calcAmountPaymentToken(
              ~amountSyntheticToken=batched_amountOfSyntheticTokensToRedeemShort,
              ~price=syntheticTokenPriceShort,
            );

          batchedAmountOfPaymentTokensToShiftToLong :=
            Contract.LongShortHelpers.calcAmountPaymentToken(
              ~amountSyntheticToken=batchedAmountOfSyntheticTokensToShiftFromShort,
              ~price=syntheticTokenPriceShort,
            );
          batchedAmountOfPaymentTokensToShiftToShort :=
            Contract.LongShortHelpers.calcAmountPaymentToken(
              ~amountSyntheticToken=batchedAmountOfSyntheticTokensToShiftFromLong,
              ~price=syntheticTokenPriceLong,
            );

          batchedAmountOfSyntheticTokensToShiftToShort :=
            Contract.LongShortHelpers.calcEquivalentAmountSyntheticTokensOnTargetSide(
              ~amountSyntheticTokenOriginSide=batchedAmountOfSyntheticTokensToShiftFromLong,
              ~priceOriginSide=syntheticTokenPriceLong,
              ~priceTargetSide=syntheticTokenPriceShort,
            );
          batchedAmountOfSyntheticTokensToShiftToLong :=
            Contract.LongShortHelpers.calcEquivalentAmountSyntheticTokensOnTargetSide(
              ~amountSyntheticTokenOriginSide=batchedAmountOfSyntheticTokensToShiftFromShort,
              ~priceOriginSide=syntheticTokenPriceShort,
              ~priceTargetSide=syntheticTokenPriceLong,
            );

          calculatedValueChangeForLong :=
            batched_amountOfPaymentTokenToDepositLong
            ->sub(batchedAmountOfPaymentTokensToBurnLong.contents)
            ->add(batchedAmountOfPaymentTokensToShiftToLong.contents)
            ->sub(batchedAmountOfPaymentTokensToShiftToShort.contents);
          calculatedValueChangeForShort :=
            batched_amountOfPaymentTokenToDepositShort
            ->sub(batchedAmountOfPaymentTokensToBurnShort.contents)
            ->add(batchedAmountOfPaymentTokensToShiftToShort.contents)
            ->sub(batchedAmountOfPaymentTokensToShiftToLong.contents);

          calculatedValueChangeInSynthSupplyLong :=
            batchedAmountOfSyntheticTokensToMintLong.contents
            ->sub(batched_amountOfSyntheticTokensToRedeemLong)
            ->add(batchedAmountOfSyntheticTokensToShiftToLong.contents)
            ->sub(batchedAmountOfSyntheticTokensToShiftFromLong);
          calculatedValueChangeInSynthSupplyShort :=
            batchedAmountOfSyntheticTokensToMintShort.contents
            ->sub(batched_amountOfSyntheticTokensToRedeemShort)
            ->add(batchedAmountOfSyntheticTokensToShiftToShort.contents)
            ->sub(batchedAmountOfSyntheticTokensToShiftFromShort);
          returnOfPerformOustandingBatchedSettlements := functionCallReturn;
        });
        it(
          "call handleChangeInSyntheticTokensTotalSupply with the correct parameters",
          () => {
          let handleChangeInSyntheticTokensTotalSupplyCalls =
            LongShortSmocked.InternalMock._handleChangeInSyntheticTokensTotalSupplyCalls();

          // NOTE: due to the small optimization in the implementation (and ovoiding stack too deep errors) it is possible that the algorithm over issues float by a unit.
          //       This is probably not an issue since it overshoots rather than undershoots. However, this should be monitored or changed.
          Chai.recordArrayDeepEqualFlat(
            handleChangeInSyntheticTokensTotalSupplyCalls,
            [|
              {
                marketIndex,
                isLong: true,
                changeInSyntheticTokensTotalSupply:
                  calculatedValueChangeInSynthSupplyLong.contents,
              },
              {
                marketIndex,
                isLong: false,
                changeInSyntheticTokensTotalSupply:
                  calculatedValueChangeInSynthSupplyShort.contents,
              },
            |],
          );
        });
        it(
          "call handleTotalValueChangeForMarketWithYieldManager with the correct parameters",
          () => {
            let handleTotalValueChangeForMarketWithYieldManagerCalls =
              LongShortSmocked.InternalMock._handleTotalPaymentTokenValueChangeForMarketWithYieldManagerCalls();

            let totalPaymentTokenValueChangeForMarket =
              calculatedValueChangeForLong.contents
              ->add(calculatedValueChangeForShort.contents);
            Chai.recordArrayDeepEqualFlat(
              handleTotalValueChangeForMarketWithYieldManagerCalls,
              [|{marketIndex, totalPaymentTokenValueChangeForMarket}|],
            );
          },
        );
        it("should return the correct values", () => {
          Chai.recordEqualDeep(
            returnOfPerformOustandingBatchedSettlements.contents,
            {
              paymentTokenValueChangeForLong:
                calculatedValueChangeForLong.contents,
              paymentTokenValueChangeForShort:
                calculatedValueChangeForShort.contents,
            },
          )
        });
      };

      describe("there are no actions in the batch", () => {
        runTest(
          ~batched_amountOfPaymentTokenToDepositLong=zeroBn,
          ~batched_amountOfPaymentTokenToDepositShort=zeroBn,
          ~batched_amountOfSyntheticTokensToRedeemLong=zeroBn,
          ~batched_amountOfSyntheticTokensToRedeemShort=zeroBn,
          ~batchedAmountOfSyntheticTokensToShiftFromLong=zeroBn,
          ~batchedAmountOfSyntheticTokensToShiftFromShort=zeroBn,
        )
      });
      describe("there is 1 deposit long", () => {
        runTest(
          ~batched_amountOfPaymentTokenToDepositLong=
            Helpers.randomTokenAmount(),
          ~batched_amountOfPaymentTokenToDepositShort=zeroBn,
          ~batched_amountOfSyntheticTokensToRedeemLong=zeroBn,
          ~batched_amountOfSyntheticTokensToRedeemShort=zeroBn,
          ~batchedAmountOfSyntheticTokensToShiftFromLong=zeroBn,
          ~batchedAmountOfSyntheticTokensToShiftFromShort=zeroBn,
        )
      });
      describe("there is 1 deposit short", () => {
        runTest(
          ~batched_amountOfPaymentTokenToDepositLong=zeroBn,
          ~batched_amountOfPaymentTokenToDepositShort=
            Helpers.randomTokenAmount(),
          ~batched_amountOfSyntheticTokensToRedeemLong=zeroBn,
          ~batched_amountOfSyntheticTokensToRedeemShort=zeroBn,
          ~batchedAmountOfSyntheticTokensToShiftFromLong=zeroBn,
          ~batchedAmountOfSyntheticTokensToShiftFromShort=zeroBn,
        )
      });
      describe("there is 1 withdraw long", () => {
        runTest(
          ~batched_amountOfPaymentTokenToDepositLong=zeroBn,
          ~batched_amountOfPaymentTokenToDepositShort=zeroBn,
          ~batched_amountOfSyntheticTokensToRedeemLong=
            Helpers.randomTokenAmount(),
          ~batched_amountOfSyntheticTokensToRedeemShort=zeroBn,
          ~batchedAmountOfSyntheticTokensToShiftFromLong=zeroBn,
          ~batchedAmountOfSyntheticTokensToShiftFromShort=zeroBn,
        )
      });
      describe("there is 1 withdraw short", () => {
        runTest(
          ~batched_amountOfPaymentTokenToDepositLong=zeroBn,
          ~batched_amountOfPaymentTokenToDepositShort=zeroBn,
          ~batched_amountOfSyntheticTokensToRedeemLong=zeroBn,
          ~batched_amountOfSyntheticTokensToRedeemShort=
            Helpers.randomTokenAmount(),
          ~batchedAmountOfSyntheticTokensToShiftFromLong=zeroBn,
          ~batchedAmountOfSyntheticTokensToShiftFromShort=zeroBn,
        )
      });
      describe("there is 1 shift from long to short", () => {
        runTest(
          ~batched_amountOfPaymentTokenToDepositLong=zeroBn,
          ~batched_amountOfPaymentTokenToDepositShort=zeroBn,
          ~batched_amountOfSyntheticTokensToRedeemLong=zeroBn,
          ~batched_amountOfSyntheticTokensToRedeemShort=zeroBn,
          ~batchedAmountOfSyntheticTokensToShiftFromLong=
            Helpers.randomTokenAmount(),
          ~batchedAmountOfSyntheticTokensToShiftFromShort=zeroBn,
        )
      });
      describe("there is 1 shift from short to long", () => {
        runTest(
          ~batched_amountOfPaymentTokenToDepositLong=zeroBn,
          ~batched_amountOfPaymentTokenToDepositShort=zeroBn,
          ~batched_amountOfSyntheticTokensToRedeemLong=zeroBn,
          ~batched_amountOfSyntheticTokensToRedeemShort=zeroBn,
          ~batchedAmountOfSyntheticTokensToShiftFromLong=zeroBn,
          ~batchedAmountOfSyntheticTokensToShiftFromShort=
            Helpers.randomTokenAmount(),
        )
      });
      describe(
        "there random deposits and withdrawals (we could be more specific with this test possibly?)",
        () => {
        runTest(
          ~batched_amountOfPaymentTokenToDepositLong=
            Helpers.randomTokenAmount(),
          ~batched_amountOfPaymentTokenToDepositShort=
            Helpers.randomTokenAmount(),
          ~batched_amountOfSyntheticTokensToRedeemLong=
            Helpers.randomTokenAmount(),
          ~batched_amountOfSyntheticTokensToRedeemShort=
            Helpers.randomTokenAmount(),
          ~batchedAmountOfSyntheticTokensToShiftFromLong=
            Helpers.randomTokenAmount(),
          ~batchedAmountOfSyntheticTokensToShiftFromShort=
            Helpers.randomTokenAmount(),
        )
      });
    });
    describe("_handleChangeInSyntheticTokensTotalSupply", () => {
      let longSyntheticToken = ref("Not Set Yet"->Obj.magic);
      let shortSyntheticToken = ref("Not Set Yet"->Obj.magic);

      before_each(() => {
        let {longShort, markets} = contracts.contents;
        let {longSynth, shortSynth} = markets->Array.getUnsafe(0);

        let%Await smockedSynthLong = SyntheticTokenSmocked.make(longSynth);
        let%Await smockedSynthShort = SyntheticTokenSmocked.make(shortSynth);

        longSyntheticToken := smockedSynthLong;
        shortSyntheticToken := smockedSynthShort;

        let _ = smockedSynthLong->SyntheticTokenSmocked.mockMintToReturn;
        let _ = smockedSynthLong->SyntheticTokenSmocked.mockBurnToReturn;
        let _ = smockedSynthShort->SyntheticTokenSmocked.mockMintToReturn;
        let _ = smockedSynthShort->SyntheticTokenSmocked.mockBurnToReturn;

        longShort->LongShort.Exposed.setHandleChangeInSyntheticTokensTotalSupplyGlobals(
          ~marketIndex,
          ~longSyntheticToken=smockedSynthLong.address,
          ~shortSyntheticToken=smockedSynthShort.address,
        );
      });
      let testHandleChangeInSyntheticTokensTotalSupply =
          (~isLong, ~syntheticTokenRef) => {
        describe("changeInSyntheticTokensTotalSupply > 0", () => {
          let changeInSyntheticTokensTotalSupply = Helpers.randomTokenAmount();
          before_each(() => {
            let {longShort} = contracts.contents;

            longShort->LongShort.Exposed._handleChangeInSyntheticTokensTotalSupplyExposed(
              ~marketIndex,
              ~isLong,
              ~changeInSyntheticTokensTotalSupply,
            );
          });
          it(
            "should call the mint function on the correct synthetic token with correct arguments.",
            () => {
              let mintCalls =
                syntheticTokenRef.contents->SyntheticTokenSmocked.mintCalls;
              Chai.recordArrayDeepEqualFlat(
                mintCalls,
                [|
                  {
                    _to: contracts.contents.longShort.address,
                    amount: changeInSyntheticTokensTotalSupply,
                  },
                |],
              );
            },
          );
          it("should NOT call the burn function.", () => {
            let burnCalls =
              syntheticTokenRef.contents->SyntheticTokenSmocked.burnCalls;
            Chai.recordArrayDeepEqualFlat(burnCalls, [||]);
          });
        });
        describe("changeInSyntheticTokensTotalSupply < 0", () => {
          let changeInSyntheticTokensTotalSupply =
            zeroBn->sub(Helpers.randomTokenAmount());
          before_each(() => {
            let {longShort} = contracts.contents;

            longShort->LongShort.Exposed._handleChangeInSyntheticTokensTotalSupplyExposed(
              ~marketIndex,
              ~isLong,
              ~changeInSyntheticTokensTotalSupply,
            );
          });
          it(
            "should NOT call the mint function on the correct synthetic token.",
            () => {
            let mintCalls =
              syntheticTokenRef.contents->SyntheticTokenSmocked.mintCalls;
            Chai.recordArrayDeepEqualFlat(mintCalls, [||]);
          });
          it(
            "should call the burn function on the correct synthetic token with correct arguments.",
            () => {
              let burnCalls =
                syntheticTokenRef.contents->SyntheticTokenSmocked.burnCalls;
              Chai.recordArrayDeepEqualFlat(
                burnCalls,
                [|
                  {amount: zeroBn->sub(changeInSyntheticTokensTotalSupply)},
                |],
              );
            },
          );
        });
        describe("changeInSyntheticTokensTotalSupply == 0", () => {
          it("should call NEITHER the mint NOR burn function.", () => {
            let changeInSyntheticTokensTotalSupply = zeroBn;
            let {longShort} = contracts.contents;

            let%Await _ =
              longShort->LongShort.Exposed._handleChangeInSyntheticTokensTotalSupplyExposed(
                ~marketIndex,
                ~isLong,
                ~changeInSyntheticTokensTotalSupply,
              );
            let mintCalls =
              syntheticTokenRef.contents->SyntheticTokenSmocked.mintCalls;
            let burnCalls =
              syntheticTokenRef.contents->SyntheticTokenSmocked.burnCalls;
            Chai.recordArrayDeepEqualFlat(mintCalls, [||]);
            Chai.recordArrayDeepEqualFlat(burnCalls, [||]);
          })
        });
      };
      describe("LongSide", () => {
        testHandleChangeInSyntheticTokensTotalSupply(
          ~isLong=true,
          ~syntheticTokenRef=longSyntheticToken,
        );
        testHandleChangeInSyntheticTokensTotalSupply(
          ~isLong=false,
          ~syntheticTokenRef=shortSyntheticToken,
        );
      });
    });
    describe(
      "_handleTotalPaymentTokenValueChangeForMarketWithYieldManager", () => {
      let yieldManagerRef = ref("Not Set Yet"->Obj.magic);

      before_each(() => {
        let {longShort, markets} = contracts.contents;
        let {yieldManager} = markets->Array.getUnsafe(0);

        let%Await smockedYieldManager =
          YieldManagerMockSmocked.make(yieldManager);

        yieldManagerRef := smockedYieldManager;

        let _ =
          smockedYieldManager->YieldManagerMockSmocked.mockDepositPaymentTokenToReturn;
        let _ =
          smockedYieldManager->YieldManagerMockSmocked.mockWithdrawPaymentTokenToReturn;

        longShort->LongShort.Exposed.setHandleTotalValueChangeForMarketWithYieldManagerGlobals(
          ~marketIndex,
          ~yieldManager=smockedYieldManager.address,
        );
      });
      describe("totalPaymentTokenValueChangeForMarket > 0", () => {
        let totalPaymentTokenValueChangeForMarket =
          Helpers.randomTokenAmount();
        before_each(() => {
          let {longShort} = contracts.contents;

          longShort->LongShort.Exposed._handleTotalPaymentTokenValueChangeForMarketWithYieldManagerExposed(
            ~marketIndex,
            ~totalPaymentTokenValueChangeForMarket,
          );
        });
        it(
          "should call the depositPaymentToken function on the correct synthetic token with correct arguments.",
          () => {
            let depositPaymentTokenCalls =
              yieldManagerRef.contents
              ->YieldManagerMockSmocked.depositPaymentTokenCalls;
            Chai.recordArrayDeepEqualFlat(
              depositPaymentTokenCalls,
              [|{amount: totalPaymentTokenValueChangeForMarket}|],
            );
          },
        );
        it("should NOT call the withdrawPaymentToken function.", () => {
          let burnCalls =
            yieldManagerRef.contents
            ->YieldManagerMockSmocked.withdrawPaymentTokenCalls;
          Chai.recordArrayDeepEqualFlat(burnCalls, [||]);
        });
      });
      describe("totalPaymentTokenValueChangeForMarket < 0", () => {
        let totalPaymentTokenValueChangeForMarket =
          zeroBn->sub(Helpers.randomTokenAmount());
        before_each(() => {
          let {longShort} = contracts.contents;

          longShort->LongShort.Exposed._handleTotalPaymentTokenValueChangeForMarketWithYieldManagerExposed(
            ~marketIndex,
            ~totalPaymentTokenValueChangeForMarket,
          );
        });
        it(
          "should NOT call the depositPaymentToken function on the correct synthetic token.",
          () => {
            let mintCalls =
              yieldManagerRef.contents
              ->YieldManagerMockSmocked.depositPaymentTokenCalls;
            Chai.recordArrayDeepEqualFlat(mintCalls, [||]);
          },
        );
        it(
          "should call the withdrawPaymentToken function on the correct synthetic token with correct arguments.",
          () => {
            let burnCalls =
              yieldManagerRef.contents
              ->YieldManagerMockSmocked.withdrawPaymentTokenCalls;
            Chai.recordArrayDeepEqualFlat(
              burnCalls,
              [|
                {amount: zeroBn->sub(totalPaymentTokenValueChangeForMarket)},
              |],
            );
          },
        );
      });
      describe("totalPaymentTokenValueChangeForMarket == 0", () => {
        it(
          "should call NEITHER the depositPaymentToken NOR withdrawPaymentToken function.",
          () => {
          let totalPaymentTokenValueChangeForMarket = zeroBn;
          let {longShort} = contracts.contents;

          let%Await _ =
            longShort->LongShort.Exposed._handleTotalPaymentTokenValueChangeForMarketWithYieldManagerExposed(
              ~marketIndex,
              ~totalPaymentTokenValueChangeForMarket,
            );
          let mintCalls =
            yieldManagerRef.contents
            ->YieldManagerMockSmocked.depositPaymentTokenCalls;
          let burnCalls =
            yieldManagerRef.contents
            ->YieldManagerMockSmocked.withdrawPaymentTokenCalls;
          Chai.recordArrayDeepEqualFlat(mintCalls, [||]);
          Chai.recordArrayDeepEqualFlat(burnCalls, [||]);
        })
      });
    });
  });
};
