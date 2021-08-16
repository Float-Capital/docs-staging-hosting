open LetOps;
open Mocha;

let testUnit =
    (
      ~contracts: ref(Helpers.coreContracts),
      ~accounts as _: ref(array(Ethers.Wallet.t)),
    ) => {
  describe("executeOutstandingNextPriceSettlementsUserMulti", () => {
    it(
      "calls _executeOutstandingNextPriceSettlements with correct arguments for given array of market indexes",
      () => {
        let user = Helpers.randomAddress();
        let marketIndexes = [|1, 2, 3, 4|];

        let%Await _ =
          contracts.contents.longShort
          ->LongShortSmocked.InternalMock.setupFunctionForUnitTesting(
              ~functionName="executeOutstandingNextPriceSettlementsUserMulti",
            );

        let%Await _ =
          contracts.contents.longShort
          ->LongShort.Exposed.executeOutstandingNextPriceSettlementsUserMulti(
              ~user,
              ~marketIndexes,
            );

        LongShortSmocked.InternalMock._executeOutstandingNextPriceSettlementsCalls()
        ->Chai.recordArrayDeepEqualFlat([|
            {user, marketIndex: 1},
            {user, marketIndex: 2},
            {user, marketIndex: 3},
            {user, marketIndex: 4},
          |]);
      },
    )
  });
};
