open LetOps;
open Mocha;

let test = (~contracts: ref(Helpers.coreContracts)) => {
  let stakerRef: ref(Staker.t) = ref(""->Obj.magic);
  describe("getMarketLaunchParameters", () => {
    before_each'(() => {
      let {staker} = contracts^;
      stakerRef := staker;
      ()->JsPromise.resolve;
    });
    let marketIndex = 5;

    let initialMultiplier =
      Helpers.randomInteger()->Ethers.BigNumber.add(CONSTANTS.oneBn);
    let initialPeriod = Helpers.randomInteger();

    let test =
        (
          ~initialMultiplier,
          ~initialPeriod,
          ~expectedMultiplier,
          ~expectedPeriod,
          (),
        ) => {
      let%AwaitThen _ =
        (stakerRef^)
        ->Staker.Exposed.setGetMarketLaunchIncentiveParametersParams(
            ~marketIndex,
            ~multiplier=initialMultiplier,
            ~period=initialPeriod,
          );
      let%Await result =
        (stakerRef^)
        ->Staker.Exposed.getMarketLaunchIncentiveParametersExternal(
            ~marketIndex,
          );

      let period = result->Obj.magic->Array.getExn(0);
      let multiplier = result->Obj.magic->Array.getExn(1);
      period->Chai.bnEqual(expectedPeriod);
      multiplier->Chai.bnEqual(expectedMultiplier);
    };

    it'(
      "returns kPeriod and kInitialMultiplier correctly for a market once set",
      test(
        ~initialMultiplier,
        ~initialPeriod,
        ~expectedMultiplier=initialMultiplier,
        ~expectedPeriod=initialPeriod,
      ),
    );

    it'(
      "if kInitialMultiplier is zero then returns 1e18 as multiplier",
      test(
        ~initialMultiplier=CONSTANTS.zeroBn,
        ~initialPeriod,
        ~expectedMultiplier=CONSTANTS.tenToThe18,
        ~expectedPeriod=initialPeriod,
      ),
    );
  });
};
