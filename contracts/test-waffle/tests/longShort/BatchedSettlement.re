open Mocha;
open Globals;
open LetOps;

let testUnit =
    (
      ~contracts: ref(Helpers.coreContracts),
      ~accounts as _: ref(array(Ethers.Wallet.t)),
    ) => {
  describeUnit("Batched Settlement", () => {
    describe("_performOustandingBatchedSettlements", () => {
      let marketIndex = Helpers.randomJsInteger();
      let syntheticTokenPriceLong = Helpers.randomTokenAmount();
      let syntheticTokenPriceShort = Helpers.randomTokenAmount();

      let setup =
          (
            ~amountPaymentTokenDepositPerSide,
            ~amountPaymentTokenRedeemPerSide,
          ) => {
        let {longShort} = contracts.contents;

        let%Await _ =
          longShort->LongShortSmocked.InternalMock.setupFunctionForUnitTesting(
            ~functionName="_performOustandingBatchedSettlements",
          );
        LongShortSmocked.InternalMock.mock_handleBatchedDepositSettlementToReturn(
          amountPaymentTokenDepositPerSide,
        );
        LongShortSmocked.InternalMock.mock_handleBatchedRedeemSettlementToReturn(
          amountPaymentTokenRedeemPerSide,
        );
        let%Await _ =
          longShort->LongShort.Exposed._performOustandingBatchedSettlementsExposed(
            ~marketIndex,
            ~syntheticTokenPriceLong,
            ~syntheticTokenPriceShort,
          );
        ();
      };

      it(
        "Should call `_handleBatchedDepositSettlement` and `_handleBatchedRedeemSettlement` for both long and short",
        () => {
          let amountPaymentTokenDepositPerSide = Helpers.randomTokenAmount();
          let amountPaymentTokenRedeemPerSide = Helpers.randomTokenAmount();

          let%Await _ =
            setup(
              ~amountPaymentTokenDepositPerSide,
              ~amountPaymentTokenRedeemPerSide,
            );
          let batchedDepositSettlementCalls =
            LongShortSmocked.InternalMock._handleBatchedDepositSettlementCalls();
          let batchedRedeemSettlementCalls =
            LongShortSmocked.InternalMock._handleBatchedRedeemSettlementCalls();

          let batchedCallArguments = [|
            {
              "marketIndex": marketIndex,
              "isLong": true,
              "syntheticTokenPrice": syntheticTokenPriceLong,
            },
            {
              "marketIndex": marketIndex,
              "isLong": false,
              "syntheticTokenPrice": syntheticTokenPriceShort,
            },
          |];

          Chai.recordArrayDeepEqualFlat(
            batchedDepositSettlementCalls,
            batchedCallArguments->Obj.magic,
          );
          Chai.recordArrayDeepEqualFlat(
            batchedRedeemSettlementCalls,
            batchedCallArguments->Obj.magic,
          );
        },
      );
      it(
        "Should deposit the correct amount into the yield manager if batchedDeposits > batchedRedeems",
        () => {
          let amountPaymentTokenRedeemPerSide = Helpers.randomTokenAmount();
          let halfCalculatedAmountToDeposit = Helpers.randomTokenAmount();
          let calculatedAmountToDeposit =
            halfCalculatedAmountToDeposit->mul(twoBn);
          let amountPaymentTokenDepositPerSide =
            // Ensure that batchedDeposits > batchedRedeems
            amountPaymentTokenRedeemPerSide
            ->add(halfCalculatedAmountToDeposit)
            ->mul(twoBn);

          let%Await _ =
            setup(
              ~amountPaymentTokenDepositPerSide,
              ~amountPaymentTokenRedeemPerSide,
            );
          let transferFundsToYieldManagerCalls =
            LongShortSmocked.InternalMock._transferFundsToYieldManagerCalls();
          let transferFromYieldManagerCalls =
            LongShortSmocked.InternalMock._transferFromYieldManagerCalls();

          Chai.recordArrayDeepEqualFlat(
            transferFundsToYieldManagerCalls,
            [|{marketIndex, amount: calculatedAmountToDeposit}|],
          );
          Chai.intEqual(transferFromYieldManagerCalls->Array.length, 0);
        },
      );
      it(
        "Should withdraw the correct amount into the yield manager if batchedDeposits < batchedRedeems",
        () => {
          let amountPaymentTokenDepositPerSide = Helpers.randomTokenAmount();
          let amountPaymentTokenRedeemPerSide =
            // Ensure that batchedDeposits < batchedRedeems
            amountPaymentTokenDepositPerSide->add(
              Helpers.randomTokenAmount(),
            );
          let calculatedAmountToWithdraw =
            amountPaymentTokenRedeemPerSide
            ->sub(amountPaymentTokenDepositPerSide)
            ->mul(twoBn);

          let%Await _ =
            setup(
              ~amountPaymentTokenDepositPerSide,
              ~amountPaymentTokenRedeemPerSide,
            );
          let transferFundsToYieldManagerCalls =
            LongShortSmocked.InternalMock._transferFundsToYieldManagerCalls();
          let transferFromYieldManagerCalls =
            LongShortSmocked.InternalMock._transferFromYieldManagerCalls();

          Chai.recordArrayDeepEqualFlat(
            transferFromYieldManagerCalls,
            [|{marketIndex, amount: calculatedAmountToWithdraw}|],
          );
          Chai.intEqual(transferFundsToYieldManagerCalls->Array.length, 0);
        },
      );
    });
    describe("_handleBatchedDepositSettlement", () => {
      // TODO: should repeat these tests for long and short
      it(
        "should do nothing and return zero if amountPaymentTokensToDepositToYieldManager == 0",
        () =>
        Js.log("TODO")
      );
      it(
        "should mint the correct amount of synthetic tokens for itself (call the mint function on the synth token contract)",
        () =>
        Js.log("TODO")
      );
      it(
        "should reset `batchedAmountOfTokensToDeposit` to zero (if not zero already)",
        () =>
        Js.log("TODO")
      );
      it(
        "should increase the `syntheticTokenPoolValue` by the batched deposit amount",
        () =>
        Js.log("TODO")
      );
    });
    describe("_handleBatchedRedeemSettlement", () => {
      // TODO: should repeat these tests for long and short
      it("should do nothing and return zero if amountSynthToRedeem == 0", () =>
        Js.log("TODO")
      );
      it(
        "should redeemBurn the correct amount of synthetic tokens for itself (call the `synthRedeemBurn` function on the synth token contract)",
        () =>
        Js.log("TODO")
      );
      it(
        "should reset `batchedAmountOfSynthTokensToRedeem` to zero (if not zero already)",
        () =>
        Js.log("TODO")
      );
      it(
        "should reduce the `syntheticTokenPoolValue` by the batched redeem amount",
        () =>
        Js.log("TODO")
      );
      it(
        "should revert (without reason - assert) if `syntheticTokenPoolValue` >= `amountOfPaymentTokenToRedeemFromYieldManager`",
        () =>
        Js.log("TODO")
      );
    });
  });
};
