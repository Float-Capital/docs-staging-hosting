open Globals;
open LetOps;
open Mocha;

let testUnit =
    (
      ~contracts: ref(Helpers.coreContracts),
      ~accounts: ref(array(Ethers.Wallet.t)),
    ) => {
  describe("_shiftPositionNextPrice", () => {
    let marketIndex = 1;
    let marketUpdateIndex = Helpers.randomInteger();
    let amount = Helpers.randomTokenAmount();
    let smockedSynthToken = ref(SyntheticTokenSmocked.uninitializedValue);

    let setup = (~isShiftFromLong, ~testWallet: Ethers.walletType) => {
      let {longShort, markets} = contracts.contents;
      let {longSynth} = markets->Array.getUnsafe(0);

      let%AwaitThen longSynthSmocked = longSynth->SyntheticTokenSmocked.make;
      longSynthSmocked->SyntheticTokenSmocked.mockTransferFromToReturn(true);
      smockedSynthToken := longSynthSmocked;

      let%AwaitThen _ = longShort->LongShortSmocked.InternalMock.setup;

      let%AwaitThen _ =
        longShort->LongShortSmocked.InternalMock.setupFunctionForUnitTesting(
          ~functionName="_shiftPositionNextPrice",
        );

      let%AwaitThen _ =
        longShort->LongShort.Exposed.setShiftNextPriceGlobals(
          ~marketIndex,
          ~marketUpdateIndex,
          ~syntheticTokenShiftedFrom=longSynthSmocked.address,
          ~isShiftFromLong,
        );

      let longShort = longShort->ContractHelpers.connect(~address=testWallet);

      longShort->LongShort.Exposed._shiftPositionNextPriceExposed(
        ~marketIndex,
        ~synthTokensToShift=amount,
        ~isShiftFromLong,
      );
    };

    let testMarketSide = (~isShiftFromLong) => {
      it("calls the executeOutstandingNextPriceSettlements modifier", () => {
        let testWallet = accounts.contents->Array.getUnsafe(1);

        let%Await _ = setup(~isShiftFromLong, ~testWallet);

        let executeOutstandingNextPriceSettlementsCalls =
          LongShortSmocked.InternalMock._executeOutstandingNextPriceSettlementsCalls();

        executeOutstandingNextPriceSettlementsCalls->Chai.recordArrayDeepEqualFlat([|
          {user: testWallet.address, marketIndex},
        |]);
      });

      it("emits the NextPriceSyntheticPositionShift event", () => {
        let testWallet = accounts.contents->Array.getUnsafe(1);

        Chai.callEmitEvents(
          ~call=setup(~isShiftFromLong, ~testWallet),
          ~eventName="NextPriceSyntheticPositionShift",
          ~contract=contracts.contents.longShort->Obj.magic,
        )
        ->Chai.withArgs5(
            marketIndex,
            isShiftFromLong,
            amount,
            testWallet.address,
            marketUpdateIndex->add(oneBn),
          );
      });

      it(
        "transfers synthetic tokens (calls transferFrom with the correct parameters)",
        () => {
        let testWallet = accounts.contents->Array.getUnsafe(1);

        let%Await _ = setup(~isShiftFromLong, ~testWallet);

        let transferFrom =
          smockedSynthToken.contents->SyntheticTokenSmocked.transferFromCalls;

        transferFrom->Chai.recordArrayDeepEqualFlat([|
          {
            sender: testWallet.address,
            recipient: contracts.contents.longShort.address,
            amount,
          },
        |]);
      });

      it("updates the correct state variables with correct values", () => {
        let testWallet = accounts.contents->Array.getUnsafe(1);

        let%AwaitThen _ = setup(~isShiftFromLong, ~testWallet);

        let%AwaitThen updatedBatchedAmountOfSynthTokensToShiftMarketSide =
          contracts.contents.longShort
          ->LongShort.batchedAmountOfSynthTokensToShiftMarketSide(
              marketIndex,
              isShiftFromLong,
            );

        let%AwaitThen updatedUserNextPrice_amountSynthToShiftFromMarketSide =
          contracts.contents.longShort
          ->LongShort.userNextPrice_amountSynthToShiftFromMarketSide(
              marketIndex,
              isShiftFromLong,
              testWallet.address,
            );

        let%Await updatedUserCurrentNextPriceUpdateIndex =
          contracts.contents.longShort
          ->LongShort.userCurrentNextPriceUpdateIndex(
              marketIndex,
              testWallet.address,
            );

        Chai.bnEqual(
          ~message=
            "batchedAmountOfSynthTokensToShiftMarketSide not updated correctly",
          updatedBatchedAmountOfSynthTokensToShiftMarketSide,
          amount,
        );

        Chai.bnEqual(
          ~message=
            "userNextPrice_amountSynthToShiftFromMarketSide not updated correctly",
          updatedUserNextPrice_amountSynthToShiftFromMarketSide,
          amount,
        );

        Chai.bnEqual(
          ~message="userCurrentNextPriceUpdateIndex not updated correctly",
          updatedUserCurrentNextPriceUpdateIndex,
          marketUpdateIndex->add(oneBn),
        );
      });
    };

    describe("long", () => {
      testMarketSide(~isShiftFromLong=true)
    });
    describe("short", () => {
      testMarketSide(~isShiftFromLong=false)
    });
  });
};
