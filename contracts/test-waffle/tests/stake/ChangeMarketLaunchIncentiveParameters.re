open Globals;
open LetOps;
open StakerHelpers;
open Mocha;

let test =
    (
      ~contracts: ref(Helpers.coreContracts),
      ~accounts: ref(array(Ethers.Wallet.t)),
    ) => {
  let marketIndex = 2;
  let period = Helpers.randomInteger();

  describe("changeMarketLaunchIncentiveParameters (external)", () => {
    let initialMultiplier = Helpers.randomInteger();
    before_once'(() => {
      let%AwaitThen _ =
        deployAndSetupStakerToUnitTest(
          ~functionName="changeMarketLaunchIncentiveParameters",
          ~contracts,
          ~accounts,
        );
      StakerSmocked.InternalMock.mock_changeMarketLaunchIncentiveParametersToReturn();

      let%Await _ =
        contracts^.staker
        ->Staker.Exposed.changeMarketLaunchIncentiveParameters(
            ~marketIndex,
            ~period,
            ~initialMultiplier,
          );
      ();
    });

    it_skip("calls the onlyAdminModifier", () => {
      // StakerSmocked.InternalMock.onlyAdminCalls()
      // ->Array.length
      // ->Chai.intEqual(1)
      ()
    });

    it(
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

    let changeMarketLaunchIncentiveParametersCall = ref(None->Obj.magic);

    let setup = (~initialMultiplier) => {
      let%Await deployedContracts =
        Helpers.inititialize(
          ~admin=accounts.contents->Array.getUnsafe(0),
          ~exposeInternals=true,
        );
      let {staker} = deployedContracts;
      contracts := deployedContracts;
      changeMarketLaunchIncentiveParametersCall :=
        staker->Staker.Exposed.changeMarketLaunchIncentiveParameters(
          ~marketIndex,
          ~period,
          ~initialMultiplier,
        );
    };

    describe("passing transaction", () => {
      before_once'(() => {setup(~initialMultiplier=initialMultiplierFine)});

      it("mutates marketLaunchIncentivePeriod", () => {
        let%Await setPeriod =
          contracts^.staker->Staker.marketLaunchIncentivePeriod(marketIndex);

        period->Chai.bnEqual(setPeriod);
      });

      it("mutates marketLaunchIncentiveMultiplier", () => {
        let%Await setMultiplier =
          contracts^.staker
          ->Staker.marketLaunchIncentiveMultipliers(marketIndex);

        initialMultiplierFine->Chai.bnEqual(setMultiplier);
      });

      it("emits MarketLaunchIncentiveParametersChanges event", () => {
        Chai.callEmitEvents(
          ~call=changeMarketLaunchIncentiveParametersCall^,
          ~contract=contracts^.staker->Obj.magic,
          ~eventName="MarketLaunchIncentiveParametersChanges",
        )
        ->Chai.withArgs3(marketIndex, period, initialMultiplierFine)
      });
    });

    describe("failing transaction", () => {
      before_once'(() => {
        setup(~initialMultiplier=initialMultiplierNotFine)
      });
      it("reverts if initialMultiplier < 1e18", () => {
        let%Await _ =
          Chai.expectRevert(
            ~transaction=changeMarketLaunchIncentiveParametersCall^,
            ~reason="marketLaunchIncentiveMultiplier must be >= 1e18",
          );
        ();
      });
    });
  });
};
