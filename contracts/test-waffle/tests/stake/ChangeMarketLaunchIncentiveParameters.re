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
  let marketIndex = 2;
  let period = Helpers.randomInteger();

  describe("changeMarketLaunchIncentiveParameters (external)", () => {
    let initialMultiplier = Helpers.randomInteger();
    before_once'(() => {
      let%AwaitThen _ =
        stakerRef->deployAndSetupStakerToUnitTest(
          ~functionName="changeMarketLaunchIncentiveParameters",
          ~contracts,
          ~accounts,
        );
      StakerSmocked.InternalMock.mock_changeMarketLaunchIncentiveParametersToReturn();
      StakerSmocked.InternalMock.mockonlyAdminToReturn();

      let%Await _ =
        (stakerRef^)
        ->Staker.Exposed.changeMarketLaunchIncentiveParameters(
            ~marketIndex,
            ~period,
            ~initialMultiplier,
          );
      ();
    });

    it'("calls the onlyAdminModifier", () => {
      StakerSmocked.InternalMock.onlyAdminCalls()
      ->Array.length
      ->Chai.intEqual(1)
    });

    it'(
      "calls _changeMarketLaunchIncentiveParameters with correct arguments", () => {
      StakerSmocked.InternalMock._changeMarketLaunchIncentiveParametersCalls()
      ->Array.getUnsafe(0)
      ->Chai.recordEqualFlat({marketIndex, period, initialMultiplier})
    });
  });

  describe("_changeMarketLaunchIncentiveParameters (internal)", () => {
    let initialMultiplierFine =
      Helpers.randomInteger()->Ethers.BigNumber.mul(CONSTANTS.tenToThe18);
    let initialMultiplierNotFine = CONSTANTS.oneBn;

    let promise: ref(JsPromise.t(ContractHelpers.transaction)) =
      ref(None->Obj.magic);

    let setup = (~initialMultiplier) => {
      let%Await deployedContracts =
        Helpers.inititialize(
          ~admin=accounts.contents->Array.getUnsafe(0),
          ~exposeInternals=true,
        );
      let {staker} = deployedContracts;
      stakerRef := staker;
      let prom =
        (stakerRef^)
        ->Staker.Exposed._changeMarketLaunchIncentiveParametersExternal(
            ~marketIndex,
            ~period,
            ~initialMultiplier,
          );
      promise := prom;
    };

    describe("passing transaction", () => {
      before_once'(() => {
        let%Await _ = setup(~initialMultiplier=initialMultiplierFine);
        let%Await _ = promise^;
        ();
      });

      it("mutates marketLaunchIncentivePeriod", () => {
        let%Await setPeriod =
          (stakerRef^)->Staker.marketLaunchIncentivePeriod(marketIndex);

        period->Chai.bnEqual(setPeriod);
      });

      it("mutates marketLaunchIncentiveMultiplier", () => {
        let%Await setMultiplier =
          (stakerRef^)->Staker.marketLaunchIncentiveMultipliers(marketIndex);

        initialMultiplierFine->Chai.bnEqual(setMultiplier);
      });

      it("emits MarketLaunchIncentiveParametersChanges event", () => {
        Chai.callEmitEvents(
          ~call=promise^,
          ~contract=(stakerRef^)->Obj.magic,
          ~eventName="MarketLaunchIncentiveParametersChanges",
        )
        ->Chai.withArgs3(marketIndex, period, initialMultiplierFine)
      });
    });

    describe("failing transaction", () => {
      before_once'(() => setup(~initialMultiplier=initialMultiplierNotFine));
      it("reverts if initialMultiplier < 1e18", () => {
        let%Await _ =
          Chai.expectRevert(
            ~transaction=promise^,
            ~reason="marketLaunchIncentiveMultiplier must be >= 1e18",
          );
        ();
      });
    });
  });
};
