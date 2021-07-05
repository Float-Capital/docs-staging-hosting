open LetOps;
open StakerHelpers;
open Mocha;

let test =
    (
      ~contracts: ref(Helpers.coreContracts),
      ~accounts: ref(array(Ethers.Wallet.t)),
    ) => {
  describe("_updateState", () => {
    let stakerRef: ref(Staker.t) = ref(""->Obj.magic);

    let longShortSmockedRef: ref(LongShortSmocked.t) =
      ref(LongShortSmocked.uninitializedValue);

    let marketIndex = Helpers.randomJsInteger();
    let syntheticAddress = Helpers.randomAddress();
    before_each(() => {
      let%AwaitThen _ =
        stakerRef->deployAndSetupStakerToUnitTest(
          ~functionName="_updateState",
          ~contracts,
          ~accounts,
        );

      let%AwaitThen longShortSmocked =
        LongShortSmocked.make(contracts^.longShort);

      longShortSmockedRef := longShortSmocked;

      longShortSmocked->LongShortSmocked.mockUpdateSystemStateToReturn;

      let%AwaitThen _ =
        (stakerRef^)
        ->Staker.Exposed.set_updateStateParams(
            ~longShort=longShortSmocked.address,
            ~token=syntheticAddress,
            ~tokenMarketIndex=marketIndex,
          );

      (stakerRef^)
      ->Staker.Exposed._updateStateExternal(~token=syntheticAddress);
    });

    it("calls longShort updateState with the market index of the token", () => {
      (longShortSmockedRef^)
      ->LongShortSmocked.updateSystemStateCalls
      ->Array.getExn(0)
      ->Chai.recordEqualFlat({marketIndex: marketIndex})
    });
  });
};
