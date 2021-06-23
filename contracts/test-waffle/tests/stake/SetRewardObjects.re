open Globals;
open LetOps;
open StakerHelpers;
open Mocha;

let test =
    (
      ~contracts: ref(Helpers.coreContracts),
      ~accounts: ref(array(Ethers.Wallet.t)),
    ) => {
  let stakerRef: ref(Staker.t) = ref(""->Obj.magic);

  let promiseRef: ref(JsPromise.t(ContractHelpers.transaction)) =
    ref(None->Obj.magic);

  let timestampRef: ref(Ethers.BigNumber.t) = ref(CONSTANTS.zeroBn);

  let marketIndex = Helpers.randomJsInteger();

  let (
    longAccum,
    shortAccum,
    latestRewardIndexForMarket,
    longPrice,
    shortPrice,
    longValue,
    shortValue,
  ) =
    Helpers.Tuple.make7(Helpers.randomInteger);

  describe("setRewardObjects", () => {
    before_once'(() => {
      let%AwaitThen _ =
        stakerRef->deployAndSetupStakerToUnitTest(
          ~functionName="setRewardObjects",
          ~contracts,
          ~accounts,
        );
      StakerSmocked.InternalMock.mockCalculateNewCumulativeRateToReturn(
        longAccum,
        shortAccum,
      );

      let%AwaitThen _ =
        (stakerRef^)
        ->Staker.Exposed.setSetRewardObjectsParams(
            ~marketIndex,
            ~latestRewardIndexForMarket,
          );

      let%Await {timestamp} = Helpers.getBlock();

      timestampRef := (timestamp + 1)->Ethers.BigNumber.fromInt; // one second per block

      promiseRef :=
        (stakerRef^)
        ->Staker.Exposed.setRewardObjectsExternal(
            ~marketIndex,
            ~longPrice,
            ~shortPrice,
            ~longValue,
            ~shortValue,
          );

      let%Await _ = promiseRef^;
      ();
    });

    it("calls calculateNewCumulativeRate with correct arguments", () => {
      StakerSmocked.InternalMock.calculateNewCumulativeRateCalls()
      ->Array.getExn(0)
      ->Chai.recordEqualFlat({
          marketIndex,
          longPrice,
          shortPrice,
          longValue,
          shortValue,
        })
    });

    let mutatedIndex =
      latestRewardIndexForMarket->Ethers.BigNumber.add(CONSTANTS.oneBn);

    it("mutates latestRewardIndex", () => {
      let%Await latestRewardIndex =
        (stakerRef^)->Staker.latestRewardIndex(marketIndex);

      latestRewardIndex->Chai.bnEqual(mutatedIndex);
    });

    it("mutates syntheticRewardParams", () => {
      let%Await rewardParams =
        (stakerRef^)->Staker.syntheticRewardParams(marketIndex, mutatedIndex);

      rewardParams->Chai.recordEqualFlat({
        timestamp: timestampRef^,
        accumulativeFloatPerLongToken: longAccum,
        accumulativeFloatPerShortToken: shortAccum,
      });
    });
    it("emits StateAddedEvent", () => {
      Chai.callEmitEvents(
        ~call=promiseRef^,
        ~contract=(stakerRef^)->Obj.magic,
        ~eventName="StateAdded",
      )
      ->Chai.withArgs5(
          marketIndex,
          mutatedIndex,
          timestampRef^,
          longAccum,
          shortAccum,
        )
    });
  });
};
