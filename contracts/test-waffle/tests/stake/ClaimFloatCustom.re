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
    let longShortSmockedRef: ref(LongShortSmocked.t) =
      ref(LongShortSmocked.uninitializedValue);

    let promiseRef: ref(JsPromise.t(ContractHelpers.transaction)) =
      ref(None->Obj.magic);

    let setup = (~marketIndices, ~shouldWaitForTransactionToFinish) => {
      let%AwaitThen _ =
        deployAndSetupStakerToUnitTest(
          ~functionName="claimFloatCustom",
          ~contracts,
          ~accounts,
        );

      let%AwaitThen longShortSmocked =
        LongShortSmocked.make(contracts^.longShort);

      longShortSmockedRef := longShortSmocked;

      longShortSmocked->LongShortSmocked.mockUpdateSystemStateMultiToReturn;

      StakerSmocked.InternalMock.mock_mintAccumulatedFloatMultiToReturn();

      let%AwaitThen _ =
        contracts^.staker
        ->Staker.Exposed.setClaimFloatCustomParams(
            ~longshortAddress=longShortSmockedRef^.address,
          );

      let promise =
        contracts^.staker
        ->Staker.claimFloatCustom(~marketIndexes=marketIndices);
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

      it("calls _mintAccumulatedFloatMulti with the correct arguments", () => {
        StakerSmocked.InternalMock._mintAccumulatedFloatMultiCalls()
        ->Array.getExn(0)
        ->Chai.recordEqualDeep({
            marketIndexes: marketIndices,
            user: accounts.contents->Array.getUnsafe(0).address,
          })
      });
    });
  });
};
