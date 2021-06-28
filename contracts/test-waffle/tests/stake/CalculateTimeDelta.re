open LetOps;
open Mocha;

let test = (~contracts: ref(Helpers.coreContracts)) => {
  let stakerRef: ref(Staker.t) = ref(""->Obj.magic);

  let marketIndex = Helpers.randomJsInteger();
  let latestMarketIndex = Helpers.randomInteger();

  describe("calculateTimeDelta", () => {
    it(
      "returns the time difference since the last reward state for a market",
      () => {
      let {staker} = contracts^;
      stakerRef := staker;
      let%Await pastTimestamp = Helpers.getRandomTimestampInPast();

      let%AwaitThen _ =
        (stakerRef^)
        ->Staker.Exposed.setCalculateTimeDeltaParams(
            ~marketIndex,
            ~latestRewardIndexForMarket=latestMarketIndex,
            ~timestamp=pastTimestamp,
          );

      let%AwaitThen {timestamp: nowTimestampInt} = Helpers.getBlock();

      let expectedDelta =
        nowTimestampInt
        ->Ethers.BigNumber.fromInt
        ->Ethers.BigNumber.sub(pastTimestamp);

      let%Await delta =
        (stakerRef^)->Staker.Exposed.calculateTimeDeltaExposed(~marketIndex);

      delta->Chai.bnEqual(expectedDelta);
    })
  });
};
