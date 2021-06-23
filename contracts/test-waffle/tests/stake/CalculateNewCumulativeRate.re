open LetOps;
open StakerHelpers;
open Mocha;

open Globals;

let test =
    (
      ~contracts: ref(Helpers.coreContracts),
      ~accounts: ref(array(Ethers.Wallet.t)),
    ) => {
  let stakerRef: ref(Staker.t) = ref(""->Obj.magic);
  let marketIndex = Helpers.randomJsInteger();

  let (
    longFloatPerSecond,
    shortFloatPerSecond,
    latestRewardIndexForMarket,
    accumFloatLong,
    accumFloatShort,
    timeDelta,
  ) =
    Helpers.Tuple.make6(Helpers.randomInteger);

  let (longValue, shortValue, longPrice, shortPrice) =
    Helpers.Tuple.make4(Helpers.randomInteger);

  describe("calculateNewCumulativeRate", () => {
    let promiseRef:
      ref(
        JsPromise.t(Staker.Exposed.calculateNewCumulativeRateExposedReturn),
      ) =
      ref(None->Obj.magic);
    before_once'(() => {
      let%AwaitThen _ =
        stakerRef->deployAndSetupStakerToUnitTest(
          ~functionName="calculateNewCumulativeRate",
          ~contracts,
          ~accounts,
        );

      let {staker} = contracts^;
      stakerRef := staker;

      StakerSmocked.InternalMock.mockCalculateFloatPerSecondToReturn(
        longFloatPerSecond,
        shortFloatPerSecond,
      );

      StakerSmocked.InternalMock.mockCalculateTimeDeltaToReturn(timeDelta);

      let%Await _ =
        (stakerRef^)
        ->Staker.Exposed.setCalculateNewCumulativeRateParams(
            ~marketIndex,
            ~latestRewardIndexForMarket,
            ~accumFloatLong,
            ~accumFloatShort,
          );

      promiseRef :=
        (stakerRef^)
        ->Staker.Exposed.calculateNewCumulativeRateExposed(
            ~marketIndex,
            ~longPrice,
            ~shortPrice,
            ~longValue,
            ~shortValue,
          );
      let%Await _ = promiseRef^;
      ();
    });

    it(
      "returns the old cumulative float + (timeDelta * floatPerSecond) for each market side",
      () => {
        let mockFn = (~oldCumulative, ~timeDelta, ~fps) =>
          oldCumulative->Ethers.BigNumber.add(
            timeDelta->Ethers.BigNumber.mul(fps),
          );
        let%Await result = promiseRef^;
        let longCumulative: Ethers.BigNumber.t =
          result->Obj.magic->Array.getUnsafe(0);

        let shortCumulative: Ethers.BigNumber.t =
          result->Obj.magic->Array.getUnsafe(1);

        longCumulative->Chai.bnEqual(
          mockFn(
            ~oldCumulative=accumFloatLong,
            ~timeDelta,
            ~fps=longFloatPerSecond,
          ),
        );
        shortCumulative->Chai.bnEqual(
          mockFn(
            ~oldCumulative=accumFloatShort,
            ~timeDelta,
            ~fps=shortFloatPerSecond,
          ),
        );
      },
    );

    it("calls calculateFloatPerSecond with correct arguments", () => {
      let call =
        StakerSmocked.InternalMock.calculateFloatPerSecondCalls()
        ->Array.getExn(0);

      call->Chai.recordEqualFlat({
        marketIndex,
        longPrice,
        shortPrice,
        longValue,
        shortValue,
      });
    });

    it("calls calculateTimeDelta with correct arguments", () => {
      let call =
        StakerSmocked.InternalMock.calculateTimeDeltaCalls()
        ->Array.getUnsafe(0);
      call->Chai.recordEqualFlat({marketIndex: marketIndex});
    });
  });
};
