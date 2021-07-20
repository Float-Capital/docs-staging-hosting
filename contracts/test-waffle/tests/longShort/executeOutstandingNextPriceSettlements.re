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
    let userCurrentNextPriceUpdateIndex = bnFromInt(22);
    let marketUpdateIndex = userCurrentNextPriceUpdateIndex->add(oneBn);

    let setup = (~userCurrentNextPriceUpdateIndex) => {
      let%AwaitThen _ =
        contracts.contents.longShort->LongShortSmocked.InternalMock.setup;

      let%AwaitThen _ =
        contracts.contents.longShort
        ->LongShortSmocked.InternalMock.setupFunctionForUnitTesting(
            ~functionName="_executeOutstandingNextPriceSettlements",
          );

      LongShortSmocked.InternalMock.mock_executeOutstandingNextPriceMintsToReturn();
      LongShortSmocked.InternalMock.mock_executeOutstandingNextPriceRedeemsToReturn();

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
        ~call=setup(~userCurrentNextPriceUpdateIndex),
        ~eventName="ExecuteNextPriceSettlementsUser",
        ~contract=contracts.contents.longShort->Obj.magic,
      )
      ->Chai.withArgs2(user, marketIndex)
    });

    it(
      "calls nextPriceMint/nextPriceRedeem functions with correct arguments",
      () => {
      let%Await _ = setup(~userCurrentNextPriceUpdateIndex);

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
      let%AwaitThen _ = setup(~userCurrentNextPriceUpdateIndex);

      let%Await updatedUserCurrentNextPriceUpdateIndex =
        contracts^.longShort
        ->LongShort.userCurrentNextPriceUpdateIndex(marketIndex, user);

      Chai.bnEqual(updatedUserCurrentNextPriceUpdateIndex, bnFromInt(0));
    });

    it(
      "doesn't emit ExecuteNextPriceSettlementsUser event if userCurrentNextPriceUpdateIndex[marketIndex][user] = 0",
      () => {
      Chai.callEmitEvents(
        ~call=setup(~userCurrentNextPriceUpdateIndex=bnFromInt(0)),
        ~eventName="ExecuteNextPriceSettlementsUser",
        ~contract=contracts.contents.longShort->Obj.magic,
      )
      ->Chai.expectToNotEmit
    });

    it(
      "doesn't call nextPriceMint/nextPriceRedeem functions if userCurrentNextPriceUpdateIndex[marketIndex][user] = 0",
      () => {
        let%Await _ = setup(~userCurrentNextPriceUpdateIndex=bnFromInt(0));

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
