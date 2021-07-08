open LetOps;
open StakerHelpers;
open Mocha;

let test =
    (
      ~contracts: ref(Helpers.coreContracts),
      ~accounts: ref(array(Ethers.Wallet.t)),
    ) => {
  let marketIndex = Helpers.randomJsInteger();

  describe("calculateFloatPerSecond", () => {
    let mockReturnFormula = (~k, ~oppositeSideValue, ~sidePrice, ~totalLocked) => {
      k
      ->Ethers.BigNumber.mul(oppositeSideValue)
      ->Ethers.BigNumber.mul(sidePrice)
      ->Ethers.BigNumber.div(totalLocked);
    };

    let testHelper =
        (
          ~kVal,
          ~longPrice,
          ~shortPrice,
          ~longValue,
          ~shortValue,
          ~expectedLongFPS,
          ~expectedShortFPS,
        ) => {
      let%AwaitThen _ =
        deployAndSetupStakerToUnitTest(
          ~functionName="calculateFloatPerSecond",
          ~contracts,
          ~accounts,
        );

      StakerSmocked.InternalMock.mockGetKValueToReturn(kVal);

      let%Await result =
        contracts^.staker
        ->Staker.Exposed.calculateFloatPerSecondExposed(
            ~marketIndex,
            ~longPrice,
            ~shortPrice,
            ~longValue,
            ~shortValue,
          );

      let longFloatPerSecond: Ethers.BigNumber.t =
        result->Obj.magic->Array.getExn(0);
      let shortFloatPerSecond: Ethers.BigNumber.t =
        result->Obj.magic->Array.getExn(1);

      longFloatPerSecond->Chai.bnEqual(expectedLongFPS);
      shortFloatPerSecond->Chai.bnEqual(expectedShortFPS);
    };

    it(
      "returns (kVal * sidePrice * oppositeSideValue) / totalLocked for each market side and calls getKValue correctly",
      () => {
        let (kVal, longPrice, shortPrice, longValue, shortValue) =
          Helpers.Tuple.make5(Helpers.randomInteger);

        let totalLocked = longValue->Ethers.BigNumber.add(shortValue);
        let expectedLongFPS =
          mockReturnFormula(
            ~k=kVal,
            ~oppositeSideValue=shortValue,
            ~sidePrice=longPrice,
            ~totalLocked,
          );
        let expectedShortFPS =
          mockReturnFormula(
            ~k=kVal,
            ~oppositeSideValue=longValue,
            ~sidePrice=shortPrice,
            ~totalLocked,
          );
        let%Await _ =
          testHelper(
            ~kVal,
            ~longValue,
            ~shortValue,
            ~longPrice,
            ~shortPrice,
            ~expectedLongFPS,
            ~expectedShortFPS,
          );
        ();
      },
    );

    it("calls getKValue correctly", () => {
      // THIS WILL BE FROM PREVIOUS TEST
      let call =
        StakerSmocked.InternalMock.getKValueCalls()->Array.getUnsafe(0);
      call->Chai.recordEqualFlat({marketIndex: marketIndex});
    });

    it("returns 0 for empty markets", () => {
      testHelper(
        ~kVal=Helpers.randomInteger(),
        ~longValue=CONSTANTS.zeroBn,
        ~shortValue=CONSTANTS.zeroBn,
        ~expectedLongFPS=CONSTANTS.zeroBn,
        ~expectedShortFPS=CONSTANTS.zeroBn,
      )
    });
  });
};
