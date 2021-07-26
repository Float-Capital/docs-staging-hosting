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
            ~batchedAmountOfPaymentTokenToDepositLong,
            ~batchedAmountOfPaymentTokenToDepositShort,
            ~batchedAmountOfSynthTokensToRedeemLong,
            ~batchedAmountOfSynthTokensToRedeemShort,
            ~batchedAmountOfSynthTokensToShiftFromLong,
            ~batchedAmountOfSynthTokensToShiftFromShort,
          ) => {
        let {longShort} = contracts.contents;
        let%AwaitThen _ =
          longShort->LongShortSmocked.InternalMock.setupFunctionForUnitTesting(
            ~functionName="_performOustandingBatchedSettlements",
          );

        LongShortSmocked.InternalMock.mock_handleTotalValueChangeForMarketWithYieldManagerToReturn();
        LongShortSmocked.InternalMock.mock_handleChangeInSynthTokensTotalSupplyToReturn();

        let%AwaitThen _ =
          longShort->LongShort.Exposed.setPerformOustandingBatchedSettlementsGlobals(
            ~marketIndex,
            ~batchedAmountOfPaymentTokenToDepositLong,
            ~batchedAmountOfPaymentTokenToDepositShort,
            ~batchedAmountOfSynthTokensToRedeemLong,
            ~batchedAmountOfSynthTokensToRedeemShort,
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
            ~batchedAmountOfPaymentTokenToDepositLong,
            ~batchedAmountOfPaymentTokenToDepositShort,
            ~batchedAmountOfSynthTokensToRedeemLong,
            ~batchedAmountOfSynthTokensToRedeemShort,
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
              ~batchedAmountOfPaymentTokenToDepositLong,
              ~batchedAmountOfPaymentTokenToDepositShort,
              ~batchedAmountOfSynthTokensToRedeemLong,
              ~batchedAmountOfSynthTokensToRedeemShort,
              ~batchedAmountOfSynthTokensToShiftFromLong,
              ~batchedAmountOfSynthTokensToShiftFromShort,
            );

          batchedAmountOfSynthTokensToMintLong :=
            Contract.LongShortHelpers.calcAmountSynthToken(
              ~amountPaymentToken=batchedAmountOfPaymentTokenToDepositLong,
              ~price=syntheticTokenPriceLong,
            );
          batchedAmountOfSynthTokensToMintShort :=
            Contract.LongShortHelpers.calcAmountSynthToken(
              ~amountPaymentToken=batchedAmountOfPaymentTokenToDepositShort,
              ~price=syntheticTokenPriceShort,
            );
          batchedAmountOfPaymentTokensToBurnLong :=
            Contract.LongShortHelpers.calcAmountPaymentToken(
              ~amountSynthToken=batchedAmountOfSynthTokensToRedeemLong,
              ~price=syntheticTokenPriceLong,
            );
          batchedAmountOfPaymentTokensToBurnShort :=
            Contract.LongShortHelpers.calcAmountPaymentToken(
              ~amountSynthToken=batchedAmountOfSynthTokensToRedeemShort,
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

          batchedAmountOfSynthTokensToShiftToLong :=
            Contract.LongShortHelpers.calcAmountSynthToken(
              ~amountPaymentToken=
                batchedAmountOfPaymentTokensToShiftToLong.contents,
              ~price=syntheticTokenPriceLong,
            );
          batchedAmountOfSynthTokensToShiftToShort :=
            Contract.LongShortHelpers.calcAmountSynthToken(
              ~amountPaymentToken=
                batchedAmountOfPaymentTokensToShiftToShort.contents,
              ~price=syntheticTokenPriceShort,
            );

          calculatedValueChangeForLong :=
            batchedAmountOfPaymentTokenToDepositLong
            ->sub(batchedAmountOfPaymentTokensToBurnLong.contents)
            ->add(batchedAmountOfPaymentTokensToShiftToLong.contents)
            ->sub(batchedAmountOfPaymentTokensToShiftToShort.contents);
          calculatedValueChangeForShort :=
            batchedAmountOfPaymentTokenToDepositShort
            ->sub(batchedAmountOfPaymentTokensToBurnShort.contents)
            ->add(batchedAmountOfPaymentTokensToShiftToShort.contents)
            ->sub(batchedAmountOfPaymentTokensToShiftToLong.contents);

          calculatedValueChangeInSynthSupplyLong :=
            batchedAmountOfSynthTokensToMintLong.contents
            ->sub(batchedAmountOfSynthTokensToRedeemLong)
            ->add(batchedAmountOfSynthTokensToShiftToLong.contents)
            ->sub(batchedAmountOfSynthTokensToShiftFromLong);
          calculatedValueChangeInSynthSupplyShort :=
            batchedAmountOfSynthTokensToMintShort.contents
            ->sub(batchedAmountOfSynthTokensToRedeemShort)
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
          // Chai.recordArrayDeepEqualFlat(
          //   handleChangeInSynthTokensTotalSupplyCalls,
          //   [|
          //     {
          //       marketIndex,
          //       isLong: true,
          //       changeInSynthTokensTotalSupply:
          //         calculatedValueChangeInSynthSupplyLong.contents,
          //     },
          //     {
          //       marketIndex,
          //       isLong: false,
          //       changeInSynthTokensTotalSupply:
          //         calculatedValueChangeInSynthSupplyShort.contents,
          //     },
          //   |],
          // );

          Chai.intEqual(
            handleChangeInSynthTokensTotalSupplyCalls->Array.length,
            2,
          );
          let longCall =
            handleChangeInSynthTokensTotalSupplyCalls->Array.getUnsafe(0);
          let shortCall =
            handleChangeInSynthTokensTotalSupplyCalls->Array.getUnsafe(1);

          Chai.bnWithin(
            longCall.changeInSynthTokensTotalSupply,
            ~min=calculatedValueChangeInSynthSupplyLong.contents,
            ~max=calculatedValueChangeInSynthSupplyLong.contents->add(oneBn),
          );
          Chai.bnWithin(
            shortCall.changeInSynthTokensTotalSupply,
            ~min=calculatedValueChangeInSynthSupplyShort.contents,
            ~max=calculatedValueChangeInSynthSupplyShort.contents->add(oneBn),
          );
        });
        it(
          "call handleTotalValueChangeForMarketWithYieldManager with the correct parameters",
          () => {
            let handleTotalValueChangeForMarketWithYieldManagerCalls =
              LongShortSmocked.InternalMock._handleTotalValueChangeForMarketWithYieldManagerCalls();

            let totalValueChangeForMarket =
              calculatedValueChangeForLong.contents
              ->add(calculatedValueChangeForShort.contents);
            Chai.recordArrayDeepEqualFlat(
              handleTotalValueChangeForMarketWithYieldManagerCalls,
              [|{marketIndex, totalValueChangeForMarket}|],
            );
          },
        );
        it("should return the correct values", () => {
          Chai.recordEqualDeep(
            returnOfPerformOustandingBatchedSettlements.contents,
            {
              valueChangeForLong: calculatedValueChangeForLong.contents,
              valueChangeForShort: calculatedValueChangeForShort.contents,
            },
          )
        });
      };

      describe("there are no actions in the batch", () => {
        runTest(
          ~batchedAmountOfPaymentTokenToDepositLong=zeroBn,
          ~batchedAmountOfPaymentTokenToDepositShort=zeroBn,
          ~batchedAmountOfSynthTokensToRedeemLong=zeroBn,
          ~batchedAmountOfSynthTokensToRedeemShort=zeroBn,
          ~batchedAmountOfSynthTokensToShiftFromLong=zeroBn,
          ~batchedAmountOfSynthTokensToShiftFromShort=zeroBn,
        )
      });
      describe("there is 1 deposit long", () => {
        runTest(
          ~batchedAmountOfPaymentTokenToDepositLong=
            Helpers.randomTokenAmount(),
          ~batchedAmountOfPaymentTokenToDepositShort=zeroBn,
          ~batchedAmountOfSynthTokensToRedeemLong=zeroBn,
          ~batchedAmountOfSynthTokensToRedeemShort=zeroBn,
          ~batchedAmountOfSynthTokensToShiftFromLong=zeroBn,
          ~batchedAmountOfSynthTokensToShiftFromShort=zeroBn,
        )
      });
      describe("there is 1 deposit short", () => {
        runTest(
          ~batchedAmountOfPaymentTokenToDepositLong=zeroBn,
          ~batchedAmountOfPaymentTokenToDepositShort=
            Helpers.randomTokenAmount(),
          ~batchedAmountOfSynthTokensToRedeemLong=zeroBn,
          ~batchedAmountOfSynthTokensToRedeemShort=zeroBn,
          ~batchedAmountOfSynthTokensToShiftFromLong=zeroBn,
          ~batchedAmountOfSynthTokensToShiftFromShort=zeroBn,
        )
      });
      describe("there is 1 withdraw long", () => {
        runTest(
          ~batchedAmountOfPaymentTokenToDepositLong=zeroBn,
          ~batchedAmountOfPaymentTokenToDepositShort=zeroBn,
          ~batchedAmountOfSynthTokensToRedeemLong=Helpers.randomTokenAmount(),
          ~batchedAmountOfSynthTokensToRedeemShort=zeroBn,
          ~batchedAmountOfSynthTokensToShiftFromLong=zeroBn,
          ~batchedAmountOfSynthTokensToShiftFromShort=zeroBn,
        )
      });
      describe("there is 1 withdraw short", () => {
        runTest(
          ~batchedAmountOfPaymentTokenToDepositLong=zeroBn,
          ~batchedAmountOfPaymentTokenToDepositShort=zeroBn,
          ~batchedAmountOfSynthTokensToRedeemLong=zeroBn,
          ~batchedAmountOfSynthTokensToRedeemShort=Helpers.randomTokenAmount(),
          ~batchedAmountOfSynthTokensToShiftFromLong=zeroBn,
          ~batchedAmountOfSynthTokensToShiftFromShort=zeroBn,
        )
      });
      describe("there is 1 shift from long to short", () => {
        runTest(
          ~batchedAmountOfPaymentTokenToDepositLong=zeroBn,
          ~batchedAmountOfPaymentTokenToDepositShort=zeroBn,
          ~batchedAmountOfSynthTokensToRedeemLong=zeroBn,
          ~batchedAmountOfSynthTokensToRedeemShort=zeroBn,
          ~batchedAmountOfSynthTokensToShiftFromLong=
            Helpers.randomTokenAmount(),
          ~batchedAmountOfSynthTokensToShiftFromShort=zeroBn,
        )
      });
      describe("there is 1 shift from short to long", () => {
        runTest(
          ~batchedAmountOfPaymentTokenToDepositLong=zeroBn,
          ~batchedAmountOfPaymentTokenToDepositShort=zeroBn,
          ~batchedAmountOfSynthTokensToRedeemLong=zeroBn,
          ~batchedAmountOfSynthTokensToRedeemShort=zeroBn,
          ~batchedAmountOfSynthTokensToShiftFromLong=zeroBn,
          ~batchedAmountOfSynthTokensToShiftFromShort=
            Helpers.randomTokenAmount(),
        )
      });
      describe(
        "[FLAKY - sometimes off by one!]there random deposits and withdrawals (we could be more specific with this test possibly?)",
        () => {
        runTest(
          ~batchedAmountOfPaymentTokenToDepositLong=
            Helpers.randomTokenAmount(),
          ~batchedAmountOfPaymentTokenToDepositShort=
            Helpers.randomTokenAmount(),
          ~batchedAmountOfSynthTokensToRedeemLong=Helpers.randomTokenAmount(),
          ~batchedAmountOfSynthTokensToRedeemShort=Helpers.randomTokenAmount(),
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
    describe("_handleTotalValueChangeForMarketWithYieldManager", () => {
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
      describe("totalValueChangeForMarket > 0", () => {
        let totalValueChangeForMarket = Helpers.randomTokenAmount();
        before_each(() => {
          let {longShort} = contracts.contents;

          longShort->LongShort.Exposed._handleTotalValueChangeForMarketWithYieldManagerExposed(
            ~marketIndex,
            ~totalValueChangeForMarket,
          );
        });
        it(
          "should call the depositPaymentToken function on the correct synthetic token with correct arguments.",
          () => {
            let mintCalls =
              yieldManagerRef.contents
              ->YieldManagerMockSmocked.depositPaymentTokenCalls;
            Chai.recordArrayDeepEqualFlat(
              mintCalls,
              [|{amount: totalValueChangeForMarket}|],
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
      describe("totalValueChangeForMarket < 0", () => {
        let totalValueChangeForMarket =
          zeroBn->sub(Helpers.randomTokenAmount());
        before_each(() => {
          let {longShort} = contracts.contents;

          longShort->LongShort.Exposed._handleTotalValueChangeForMarketWithYieldManagerExposed(
            ~marketIndex,
            ~totalValueChangeForMarket,
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
              [|{amount: zeroBn->sub(totalValueChangeForMarket)}|],
            );
          },
        );
      });
      describe("totalValueChangeForMarket == 0", () => {
        it(
          "should call NEITHER the depositPaymentToken NOR withdrawPaymentToken function.",
          () => {
          let totalValueChangeForMarket = zeroBn;
          let {longShort} = contracts.contents;

          let%Await _ =
            longShort->LongShort.Exposed._handleTotalValueChangeForMarketWithYieldManagerExposed(
              ~marketIndex,
              ~totalValueChangeForMarket,
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
