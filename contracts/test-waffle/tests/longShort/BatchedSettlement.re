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
    describe_only("_performOustandingBatchedSettlements", () => {
      let syntheticTokenPriceLong = Helpers.randomTokenAmount();
      let syntheticTokenPriceShort = Helpers.randomTokenAmount();

      let setup =
          (
            ~batched_amountOfPaymentTokenToDepositLong,
            ~batched_amountOfPaymentTokenToDepositShort,
            ~batched_amountOfSynthTokensToRedeemLong,
            ~batched_amountOfSynthTokensToRedeemShort,
            ~batchedAmountOfSynthTokensToShiftFromLong,
            ~batchedAmountOfSynthTokensToShiftFromShort,
          ) => {
        let {longShort} = contracts.contents;
        let%AwaitThen _ =
          longShort->LongShortSmocked.InternalMock.setupFunctionForUnitTesting(
            ~functionName="_performOustandingBatchedSettlements",
          );

        LongShortSmocked.InternalMock.mock_handleTotalPaymentTokenValueChangeForMarketWithYieldManagerToReturn();
        LongShortSmocked.InternalMock.mock_handleChangeInSynthTokensTotalSupplyToReturn();

        let%AwaitThen _ =
          longShort->LongShort.Exposed.setPerformOustandingBatchedSettlementsGlobals(
            ~marketIndex,
            ~batched_amountOfPaymentTokenToDepositLong,
            ~batched_amountOfPaymentTokenToDepositShort,
            ~batched_amountOfSynthTokensToRedeemLong,
            ~batched_amountOfSynthTokensToRedeemShort,
            ~batchedAmountOfSynthTokensToShiftFromLong,
            ~batchedAmountOfSynthTokensToShiftFromShort,
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
            ~batched_amountOfSynthTokensToRedeemLong,
            ~batched_amountOfSynthTokensToRedeemShort,
            ~batchedAmountOfSynthTokensToShiftFromLong,
            ~batchedAmountOfSynthTokensToShiftFromShort,
          ) => {
        let batchedAmountOfSynthTokensToMintLong = ref(None->Obj.magic);
        let batchedAmountOfSynthTokensToMintShort = ref(None->Obj.magic);
        let batchedAmountOfPaymentTokensToBurnLong = ref(None->Obj.magic);
        let batchedAmountOfPaymentTokensToBurnShort = ref(None->Obj.magic);
        let batchedAmountOfPaymentTokensToShiftToLong = ref(None->Obj.magic);
        let batchedAmountOfPaymentTokensToShiftToShort = ref(None->Obj.magic);
        let batchedAmountOfSynthTokensToShiftToLong = ref(None->Obj.magic);
        let batchedAmountOfSynthTokensToShiftToShort = ref(None->Obj.magic);
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
              ~batched_amountOfSynthTokensToRedeemLong,
              ~batched_amountOfSynthTokensToRedeemShort,
              ~batchedAmountOfSynthTokensToShiftFromLong,
              ~batchedAmountOfSynthTokensToShiftFromShort,
            );

          batchedAmountOfSynthTokensToMintLong :=
            Contract.LongShortHelpers.calcAmountSynthToken(
              ~amountPaymentToken=batched_amountOfPaymentTokenToDepositLong,
              ~price=syntheticTokenPriceLong,
            );
          batchedAmountOfSynthTokensToMintShort :=
            Contract.LongShortHelpers.calcAmountSynthToken(
              ~amountPaymentToken=batched_amountOfPaymentTokenToDepositShort,
              ~price=syntheticTokenPriceShort,
            );
          batchedAmountOfPaymentTokensToBurnLong :=
            Contract.LongShortHelpers.calcAmountPaymentToken(
              ~amountSynthToken=batched_amountOfSynthTokensToRedeemLong,
              ~price=syntheticTokenPriceLong,
            );
          batchedAmountOfPaymentTokensToBurnShort :=
            Contract.LongShortHelpers.calcAmountPaymentToken(
              ~amountSynthToken=batched_amountOfSynthTokensToRedeemShort,
              ~price=syntheticTokenPriceShort,
            );

          batchedAmountOfPaymentTokensToShiftToLong :=
            Contract.LongShortHelpers.calcAmountPaymentToken(
              ~amountSynthToken=batchedAmountOfSynthTokensToShiftFromShort,
              ~price=syntheticTokenPriceShort,
            );
          batchedAmountOfPaymentTokensToShiftToShort :=
            Contract.LongShortHelpers.calcAmountPaymentToken(
              ~amountSynthToken=batchedAmountOfSynthTokensToShiftFromLong,
              ~price=syntheticTokenPriceLong,
            );

          batchedAmountOfSynthTokensToShiftToShort :=
            Contract.LongShortHelpers.calcEquivalentAmountSynthTokensOnTargetSide(
              ~amountSynthTokenOriginSide=batchedAmountOfSynthTokensToShiftFromLong,
              ~priceOriginSide=syntheticTokenPriceLong,
              ~priceTargetSide=syntheticTokenPriceShort,
            );
          batchedAmountOfSynthTokensToShiftToLong :=
            Contract.LongShortHelpers.calcEquivalentAmountSynthTokensOnTargetSide(
              ~amountSynthTokenOriginSide=batchedAmountOfSynthTokensToShiftFromShort,
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
            batchedAmountOfSynthTokensToMintLong.contents
            ->sub(batched_amountOfSynthTokensToRedeemLong)
            ->add(batchedAmountOfSynthTokensToShiftToLong.contents)
            ->sub(batchedAmountOfSynthTokensToShiftFromLong);
          calculatedValueChangeInSynthSupplyShort :=
            batchedAmountOfSynthTokensToMintShort.contents
            ->sub(batched_amountOfSynthTokensToRedeemShort)
            ->add(batchedAmountOfSynthTokensToShiftToShort.contents)
            ->sub(batchedAmountOfSynthTokensToShiftFromShort);
          returnOfPerformOustandingBatchedSettlements := functionCallReturn;
        });
        it(
          "call handleChangeInSynthTokensTotalSupply with the correct parameters",
          () => {
          let handleChangeInSynthTokensTotalSupplyCalls =
            LongShortSmocked.InternalMock._handleChangeInSynthTokensTotalSupplyCalls();

          // NOTE: due to the small optimization in the implementation (and ovoiding stack too deep errors) it is possible that the algorithm over issues float by a unit.
          //       This is probably not an issue since it overshoots rather than undershoots. However, this should be monitored or changed.
          Chai.recordArrayDeepEqualFlat(
            handleChangeInSynthTokensTotalSupplyCalls,
            [|
              {
                marketIndex,
                isLong: true,
                changeInSynthTokensTotalSupply:
                  calculatedValueChangeInSynthSupplyLong.contents,
              },
              {
                marketIndex,
                isLong: false,
                changeInSynthTokensTotalSupply:
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
          ~batched_amountOfSynthTokensToRedeemLong=zeroBn,
          ~batched_amountOfSynthTokensToRedeemShort=zeroBn,
          ~batchedAmountOfSynthTokensToShiftFromLong=zeroBn,
          ~batchedAmountOfSynthTokensToShiftFromShort=zeroBn,
        )
      });
      describe("there is 1 deposit long", () => {
        runTest(
          ~batched_amountOfPaymentTokenToDepositLong=
            Helpers.randomTokenAmount(),
          ~batched_amountOfPaymentTokenToDepositShort=zeroBn,
          ~batched_amountOfSynthTokensToRedeemLong=zeroBn,
          ~batched_amountOfSynthTokensToRedeemShort=zeroBn,
          ~batchedAmountOfSynthTokensToShiftFromLong=zeroBn,
          ~batchedAmountOfSynthTokensToShiftFromShort=zeroBn,
        )
      });
      describe("there is 1 deposit short", () => {
        runTest(
          ~batched_amountOfPaymentTokenToDepositLong=zeroBn,
          ~batched_amountOfPaymentTokenToDepositShort=
            Helpers.randomTokenAmount(),
          ~batched_amountOfSynthTokensToRedeemLong=zeroBn,
          ~batched_amountOfSynthTokensToRedeemShort=zeroBn,
          ~batchedAmountOfSynthTokensToShiftFromLong=zeroBn,
          ~batchedAmountOfSynthTokensToShiftFromShort=zeroBn,
        )
      });
      describe("there is 1 withdraw long", () => {
        runTest(
          ~batched_amountOfPaymentTokenToDepositLong=zeroBn,
          ~batched_amountOfPaymentTokenToDepositShort=zeroBn,
          ~batched_amountOfSynthTokensToRedeemLong=Helpers.randomTokenAmount(),
          ~batched_amountOfSynthTokensToRedeemShort=zeroBn,
          ~batchedAmountOfSynthTokensToShiftFromLong=zeroBn,
          ~batchedAmountOfSynthTokensToShiftFromShort=zeroBn,
        )
      });
      describe("there is 1 withdraw short", () => {
        runTest(
          ~batched_amountOfPaymentTokenToDepositLong=zeroBn,
          ~batched_amountOfPaymentTokenToDepositShort=zeroBn,
          ~batched_amountOfSynthTokensToRedeemLong=zeroBn,
          ~batched_amountOfSynthTokensToRedeemShort=
            Helpers.randomTokenAmount(),
          ~batchedAmountOfSynthTokensToShiftFromLong=zeroBn,
          ~batchedAmountOfSynthTokensToShiftFromShort=zeroBn,
        )
      });
      describe("there is 1 shift from long to short", () => {
        runTest(
          ~batched_amountOfPaymentTokenToDepositLong=zeroBn,
          ~batched_amountOfPaymentTokenToDepositShort=zeroBn,
          ~batched_amountOfSynthTokensToRedeemLong=zeroBn,
          ~batched_amountOfSynthTokensToRedeemShort=zeroBn,
          ~batchedAmountOfSynthTokensToShiftFromLong=
            Helpers.randomTokenAmount(),
          ~batchedAmountOfSynthTokensToShiftFromShort=zeroBn,
        )
      });
      describe("there is 1 shift from short to long", () => {
        runTest(
          ~batched_amountOfPaymentTokenToDepositLong=zeroBn,
          ~batched_amountOfPaymentTokenToDepositShort=zeroBn,
          ~batched_amountOfSynthTokensToRedeemLong=zeroBn,
          ~batched_amountOfSynthTokensToRedeemShort=zeroBn,
          ~batchedAmountOfSynthTokensToShiftFromLong=zeroBn,
          ~batchedAmountOfSynthTokensToShiftFromShort=
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
          ~batched_amountOfSynthTokensToRedeemLong=Helpers.randomTokenAmount(),
          ~batched_amountOfSynthTokensToRedeemShort=
            Helpers.randomTokenAmount(),
          ~batchedAmountOfSynthTokensToShiftFromLong=
            Helpers.randomTokenAmount(),
          ~batchedAmountOfSynthTokensToShiftFromShort=
            Helpers.randomTokenAmount(),
        )
      });
    });
    describe("_handleChangeInSynthTokensTotalSupply", () => {
      let longSynthToken = ref("Not Set Yet"->Obj.magic);
      let shortSynthToken = ref("Not Set Yet"->Obj.magic);

      before_each(() => {
        let {longShort, markets} = contracts.contents;
        let {longSynth, shortSynth} = markets->Array.getUnsafe(0);

        let%Await smockedSynthLong = SyntheticTokenSmocked.make(longSynth);
        let%Await smockedSynthShort = SyntheticTokenSmocked.make(shortSynth);

        longSynthToken := smockedSynthLong;
        shortSynthToken := smockedSynthShort;

        let _ = smockedSynthLong->SyntheticTokenSmocked.mockMintToReturn;
        let _ = smockedSynthLong->SyntheticTokenSmocked.mockBurnToReturn;
        let _ = smockedSynthShort->SyntheticTokenSmocked.mockMintToReturn;
        let _ = smockedSynthShort->SyntheticTokenSmocked.mockBurnToReturn;

        longShort->LongShort.Exposed.setHandleChangeInSynthTokensTotalSupplyGlobals(
          ~marketIndex,
          ~longSynthToken=smockedSynthLong.address,
          ~shortSynthToken=smockedSynthShort.address,
        );
      });
      let testHandleChangeInSynthTokensTotalSupply = (~isLong, ~synthTokenRef) => {
        describe("changeInSynthTokensTotalSupply > 0", () => {
          let changeInSynthTokensTotalSupply = Helpers.randomTokenAmount();
          before_each(() => {
            let {longShort} = contracts.contents;

            longShort->LongShort.Exposed._handleChangeInSynthTokensTotalSupplyExposed(
              ~marketIndex,
              ~isLong,
              ~changeInSynthTokensTotalSupply,
            );
          });
          it(
            "should call the mint function on the correct synthetic token with correct arguments.",
            () => {
              let mintCalls =
                synthTokenRef.contents->SyntheticTokenSmocked.mintCalls;
              Chai.recordArrayDeepEqualFlat(
                mintCalls,
                [|
                  {
                    _to: contracts.contents.longShort.address,
                    amount: changeInSynthTokensTotalSupply,
                  },
                |],
              );
            },
          );
          it("should NOT call the burn function.", () => {
            let burnCalls =
              synthTokenRef.contents->SyntheticTokenSmocked.burnCalls;
            Chai.recordArrayDeepEqualFlat(burnCalls, [||]);
          });
        });
        describe("changeInSynthTokensTotalSupply < 0", () => {
          let changeInSynthTokensTotalSupply =
            zeroBn->sub(Helpers.randomTokenAmount());
          before_each(() => {
            let {longShort} = contracts.contents;

            longShort->LongShort.Exposed._handleChangeInSynthTokensTotalSupplyExposed(
              ~marketIndex,
              ~isLong,
              ~changeInSynthTokensTotalSupply,
            );
          });
          it(
            "should NOT call the mint function on the correct synthetic token.",
            () => {
            let mintCalls =
              synthTokenRef.contents->SyntheticTokenSmocked.mintCalls;
            Chai.recordArrayDeepEqualFlat(mintCalls, [||]);
          });
          it(
            "should call the burn function on the correct synthetic token with correct arguments.",
            () => {
              let burnCalls =
                synthTokenRef.contents->SyntheticTokenSmocked.burnCalls;
              Chai.recordArrayDeepEqualFlat(
                burnCalls,
                [|{amount: zeroBn->sub(changeInSynthTokensTotalSupply)}|],
              );
            },
          );
        });
        describe("changeInSynthTokensTotalSupply == 0", () => {
          it("should call NEITHER the mint NOR burn function.", () => {
            let changeInSynthTokensTotalSupply = zeroBn;
            let {longShort} = contracts.contents;

            let%Await _ =
              longShort->LongShort.Exposed._handleChangeInSynthTokensTotalSupplyExposed(
                ~marketIndex,
                ~isLong,
                ~changeInSynthTokensTotalSupply,
              );
            let mintCalls =
              synthTokenRef.contents->SyntheticTokenSmocked.mintCalls;
            let burnCalls =
              synthTokenRef.contents->SyntheticTokenSmocked.burnCalls;
            Chai.recordArrayDeepEqualFlat(mintCalls, [||]);
            Chai.recordArrayDeepEqualFlat(burnCalls, [||]);
          })
        });
      };
      describe("LongSide", () => {
        testHandleChangeInSynthTokensTotalSupply(
          ~isLong=true,
          ~synthTokenRef=longSynthToken,
        );
        testHandleChangeInSynthTokensTotalSupply(
          ~isLong=false,
          ~synthTokenRef=shortSynthToken,
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
