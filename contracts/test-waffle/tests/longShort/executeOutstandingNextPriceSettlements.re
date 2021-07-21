open LetOps;
open Mocha;
open Globals;

let testUnit =
    (
      ~contracts: ref(Helpers.coreContracts),
      ~accounts as _: ref(array(Ethers.Wallet.t)),
    ) => {
  describe("executeOutstandingNextPriceSettlements", () => {
    let marketIndex = 1;
    let user = Helpers.randomAddress();
    let defaultUserCurrentNextPriceUpdateIndex = bnFromInt(22);
    let defaultMarketUpdateIndex =
      defaultUserCurrentNextPriceUpdateIndex->add(oneBn);

    let setup = (~userCurrentNextPriceUpdateIndex, ~marketUpdateIndex) => {
      let%AwaitThen _ =
        contracts.contents.longShort->LongShortSmocked.InternalMock.setup;

      let%AwaitThen _ =
        contracts.contents.longShort
        ->LongShortSmocked.InternalMock.setupFunctionForUnitTesting(
            ~functionName="_executeOutstandingNextPriceSettlements",
          );

      let%AwaitThen _ =
        contracts.contents.longShort
        ->LongShort.Exposed.setExecuteOutstandingNextPriceSettlementsGlobals(
            ~marketIndex,
            ~user,
            ~userCurrentNextPriceUpdateIndex,
            ~marketUpdateIndex,
          );

      contracts.contents.longShort
      ->LongShort.Exposed._executeOutstandingNextPriceSettlementsExposed(
          ~user,
          ~marketIndex,
        );
    };

    it(
      "emits ExecuteNextPriceSettlementsUser event with correct parameters", () => {
      Chai.callEmitEvents(
        ~call=
          setup(
            ~userCurrentNextPriceUpdateIndex=defaultUserCurrentNextPriceUpdateIndex,
            ~marketUpdateIndex=defaultMarketUpdateIndex,
          ),
        ~eventName="ExecuteNextPriceSettlementsUser",
        ~contract=contracts.contents.longShort->Obj.magic,
      )
      ->Chai.withArgs2(user, marketIndex)
    });

    it(
      "calls nextPriceMint/nextPriceRedeem functions with correct arguments",
      () => {
      let%Await _ =
        setup(
          ~userCurrentNextPriceUpdateIndex=defaultUserCurrentNextPriceUpdateIndex,
          ~marketUpdateIndex=defaultMarketUpdateIndex,
        );

      let executeOutstandingNextPriceMintsCalls =
        LongShortSmocked.InternalMock._executeOutstandingNextPriceMintsCalls();
      let executeOutstandingNextPriceRedeemCalls =
        LongShortSmocked.InternalMock._executeOutstandingNextPriceRedeemsCalls();

      Chai.intEqual(executeOutstandingNextPriceMintsCalls->Array.length, 2);
      Chai.intEqual(executeOutstandingNextPriceRedeemCalls->Array.length, 2);

      executeOutstandingNextPriceMintsCalls->Chai.recordArrayDeepEqualFlat([|
        {marketIndex, user, isLong: true},
        {marketIndex, user, isLong: false},
      |]);

      executeOutstandingNextPriceRedeemCalls->Chai.recordArrayDeepEqualFlat([|
        {marketIndex, user, isLong: true},
        {marketIndex, user, isLong: false},
      |]);
    });

    it("sets userCurrentNextPriceUpdateIndex[marketIndex][user] to 0", () => {
      let%AwaitThen _ =
        setup(
          ~userCurrentNextPriceUpdateIndex=defaultUserCurrentNextPriceUpdateIndex,
          ~marketUpdateIndex=defaultMarketUpdateIndex,
        );

      let%Await updatedUserCurrentNextPriceUpdateIndex =
        contracts^.longShort
        ->LongShort.userCurrentNextPriceUpdateIndex(marketIndex, user);

      Chai.bnEqual(updatedUserCurrentNextPriceUpdateIndex, oneBn);
    });

    it(
      "doesn't emit ExecuteNextPriceSettlementsUser event if userCurrentNextPriceUpdateIndex[marketIndex][user] = 0",
      () => {
      Chai.callEmitEvents(
        ~call=
          setup(
            ~userCurrentNextPriceUpdateIndex=bnFromInt(0),
            ~marketUpdateIndex=defaultMarketUpdateIndex,
          ),
        ~eventName="ExecuteNextPriceSettlementsUser",
        ~contract=contracts.contents.longShort->Obj.magic,
      )
      ->Chai.expectToNotEmit
    });

    it(
      "doesn't call nextPriceMint/nextPriceRedeem functions if userCurrentNextPriceUpdateIndex[marketIndex][user] = 0",
      () => {
        let%Await _ =
          setup(
            ~userCurrentNextPriceUpdateIndex=bnFromInt(0),
            ~marketUpdateIndex=defaultMarketUpdateIndex,
          );

        let executeOutstandingNextPriceMintsCalls =
          LongShortSmocked.InternalMock._executeOutstandingNextPriceMintsCalls();
        let executeOutstandingNextPriceRedeemCalls =
          LongShortSmocked.InternalMock._executeOutstandingNextPriceRedeemsCalls();

        Chai.intEqual(executeOutstandingNextPriceMintsCalls->Array.length, 0);
        Chai.intEqual(
          executeOutstandingNextPriceRedeemCalls->Array.length,
          0,
        );
      },
    );

    it(
      "doesn't emit ExecuteNextPriceSettlementsUser event if userCurrentNextPriceUpdateIndex[marketIndex][user] > marketUpdateIndex[marketIndex]",
      () => {
      Chai.callEmitEvents(
        ~call=
          setup(
            ~userCurrentNextPriceUpdateIndex=defaultUserCurrentNextPriceUpdateIndex,
            ~marketUpdateIndex=
              defaultUserCurrentNextPriceUpdateIndex->sub(oneBn),
          ),
        ~eventName="ExecuteNextPriceSettlementsUser",
        ~contract=contracts.contents.longShort->Obj.magic,
      )
      ->Chai.expectToNotEmit
    });

    it(
      "doesn't call nextPriceMint/nextPriceRedeem functions if userCurrentNextPriceUpdateIndex[marketIndex][user] > marketUpdateIndex[marketIndex]",
      () => {
        let%Await _ =
          setup(
            ~userCurrentNextPriceUpdateIndex=defaultUserCurrentNextPriceUpdateIndex,
            ~marketUpdateIndex=
              defaultUserCurrentNextPriceUpdateIndex->sub(oneBn),
          );

        let executeOutstandingNextPriceMintsCalls =
          LongShortSmocked.InternalMock._executeOutstandingNextPriceMintsCalls();
        let executeOutstandingNextPriceRedeemCalls =
          LongShortSmocked.InternalMock._executeOutstandingNextPriceRedeemsCalls();

        Chai.intEqual(executeOutstandingNextPriceMintsCalls->Array.length, 0);
        Chai.intEqual(
          executeOutstandingNextPriceRedeemCalls->Array.length,
          0,
        );
      },
    );
  });
};
