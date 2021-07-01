open Globals;
open LetOps;
open StakerHelpers;
open Mocha;

let randomLengthIntegerArr = (~minLength, ~maxLength) =>
  Array.makeBy(Js.Math.random_int(minLength, maxLength + 1), _ =>
    Helpers.randomJsInteger()
  );

let test =
    (
      ~contracts: ref(Helpers.coreContracts),
      ~accounts: ref(array(Ethers.Wallet.t)),
    ) => {
  describe("claimFloatCustom", () => {
    let stakerRef: ref(Staker.t) = ref(""->Obj.magic);

    let longShortSmockedRef: ref(LongShortSmocked.t) =
      ref(LongShortSmocked.uninitializedValue);

    let promiseRef: ref(JsPromise.t(ContractHelpers.transaction)) =
      ref(None->Obj.magic);

    let setup = (~marketIndices, ~shouldWaitForTransactionToFinish) => {
      let%AwaitThen _ =
        stakerRef->deployAndSetupStakerToUnitTest(
          ~functionName="claimFloatCustom",
          ~contracts,
          ~accounts,
        );

      let%AwaitThen longShortSmocked =
        LongShortSmocked.make(contracts^.longShort);

      longShortSmockedRef := longShortSmocked;

      longShortSmocked->LongShortSmocked.mockUpdateSystemStateMultiToReturn;

      StakerSmocked.InternalMock.mock_claimFloatToReturn();

      let%AwaitThen _ =
        (stakerRef^)
        ->Staker.Exposed.setClaimFloatCustomParams(
            ~longshort=longShortSmockedRef^.address,
          );

      let promise =
        (stakerRef^)->Staker.claimFloatCustom(~marketIndexes=marketIndices);
      promiseRef := promise;
      if (shouldWaitForTransactionToFinish) {
        promise;
      } else {
        ()->JsPromise.resolve;
      };
    };

    describe("case less than 51 markets", () => {
      let marketIndices = randomLengthIntegerArr(~minLength=0, ~maxLength=50);
      before_once'(() =>
        setup(~marketIndices, ~shouldWaitForTransactionToFinish=true)
      );

      it("calls LongShort.updateSystemStateMulti for the markets", () => {
        (longShortSmockedRef^)
        ->LongShortSmocked.updateSystemStateMultiCalls
        ->Array.getExn(0)
        ->Chai.recordEqualDeep({marketIndexes: marketIndices})
      });

      it("calls _claimFloat with the correct arguments", () => {
        StakerSmocked.InternalMock._claimFloatCalls()
        ->Array.getExn(0)
        ->Chai.recordEqualDeep({marketIndexes: marketIndices})
      });
    });

    describe("case more than 50 markets", () => {
      before_each(() =>
        setup(
          ~marketIndices=
            randomLengthIntegerArr(~minLength=51, ~maxLength=120),
          ~shouldWaitForTransactionToFinish=false,
        )
      );
      it("reverts", () => {
        Chai.expectRevertNoReason(~transaction=promiseRef^)
      });
    });
  });
};
