open LetOps;
open StakerHelpers;
open Mocha;

let test =
    (
      ~contracts: ref(Helpers.coreContracts),
      ~accounts: ref(array(Ethers.Wallet.t)),
    ) => {
  let stakerRef: ref(Staker.t) = ref(""->Obj.magic);
  let marketIndex = Helpers.randomJsInteger();

  describe("calculateFloatPerSecond", () => {
    let mockReturnFormula = (~k, ~oppositeSideValue, ~sidePrice, ~totalLocked) => {
      k
      ->Ethers.BigNumber.mul(oppositeSideValue)
      ->Ethers.BigNumber.mul(sidePrice)
      ->Ethers.BigNumber.div(totalLocked);
    };

    let test =
        (
          ~kVal,
          ~longPrice,
          ~shortPrice,
          ~longValue,
          ~shortValue,
          ~expectedLongFPS,
          ~expectedShortFPS,
        ) => {
      let {staker} = contracts^;
      stakerRef := staker;
      let%AwaitThen _ =
        stakerRef->deployAndSetupStakerToUnitTest(
          ~functionName="calculateFloatPerSecond",
          ~contracts,
          ~accounts,
        );

      StakerSmocked.InternalMock.mockGetKValueToReturn(kVal);

      let%Await result =
        (stakerRef^)
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
        let%Await _ =
          test(
            ~kVal,
            ~longValue,
            ~shortValue,
            ~longPrice,
            ~shortPrice,
            ~expectedLongFPS=
              mockReturnFormula(
                ~k=kVal,
                ~oppositeSideValue=shortValue,
                ~sidePrice=longPrice,
                ~totalLocked,
              ),
            ~expectedShortFPS=
              mockReturnFormula(
                ~k=kVal,
                ~oppositeSideValue=longValue,
                ~sidePrice=shortPrice,
                ~totalLocked,
              ),
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
      test(
        ~kVal=Helpers.randomInteger(),
        ~longValue=CONSTANTS.zeroBn,
        ~shortValue=CONSTANTS.zeroBn,
        ~longPrice=Helpers.randomInteger(),
        ~shortPrice=Helpers.randomInteger(),
        ~expectedLongFPS=CONSTANTS.zeroBn,
        ~expectedShortFPS=CONSTANTS.zeroBn,
      )
    });
  });
};
