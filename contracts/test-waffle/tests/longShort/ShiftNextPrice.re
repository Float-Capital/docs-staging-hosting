open Globals;
open LetOps;
open Mocha;

let testUnit =
    (
      ~contracts: ref(Helpers.coreContracts),
      ~accounts: ref(array(Ethers.Wallet.t)),
    ) => {
  describe("shiftNextPrice external functions", () => {
    let marketIndex = 1;
    let synthTokensToShift = Helpers.randomTokenAmount();

    let setup = () => {
      contracts.contents.longShort->LongShortSmocked.InternalMock.setup;
    };

    describe("shiftPositionFromLongNextPrice", () => {
      it("calls _shiftPositionNextPrice with isShiftFromLong==true", () => {
        let%Await _ = setup();

        let%Await _ =
          contracts.contents.longShort
          ->LongShortSmocked.InternalMock.setupFunctionForUnitTesting(
              ~functionName="shiftPositionFromLongNextPrice",
            );

        let%Await _ =
          contracts.contents.longShort
          ->LongShort.shiftPositionFromLongNextPrice(~marketIndex, ~synthTokensToShift);

        let shiftPositionNextPriceCalls =
          LongShortSmocked.InternalMock._shiftPositionNextPriceCalls();

        shiftPositionNextPriceCalls->Chai.recordArrayDeepEqualFlat([|
          {marketIndex, synthTokensToShift, isShiftFromLong: true},
        |]);
      })
    });

    describe("shiftPositionFromShortNextPrice", () => {
      it("calls _shiftPositionNextPrice with isShiftFromLong==false", () => {
        let%Await _ = setup();

        let%Await _ =
          contracts.contents.longShort
          ->LongShortSmocked.InternalMock.setupFunctionForUnitTesting(
              ~functionName="shiftPositionFromShortNextPrice",
            );

        let%Await _ =
          contracts.contents.longShort
          ->LongShort.shiftPositionFromShortNextPrice(~marketIndex, ~synthTokensToShift);

        let shiftPositionNextPriceCalls =
          LongShortSmocked.InternalMock._shiftPositionNextPriceCalls();

        shiftPositionNextPriceCalls->Chai.recordArrayDeepEqualFlat([|
          {marketIndex, synthTokensToShift, isShiftFromLong: false},
        |]);
      })
    });
  });

  describe("_shiftPositionNextPrice internal function", () => {
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

        let%AwaitThen updateduserNextPriceAmountSynthToShiftFromMarketSide =
          contracts.contents.longShort
          ->LongShort.userNextPriceAmountSynthToShiftFromMarketSide(
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
            "userNextPriceAmountSynthToShiftFromMarketSide not updated correctly",
          updateduserNextPriceAmountSynthToShiftFromMarketSide,
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
