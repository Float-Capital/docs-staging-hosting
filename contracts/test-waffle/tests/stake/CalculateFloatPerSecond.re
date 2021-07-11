open LetOps;
open StakerHelpers;
open Mocha;
open Globals;

let getRequiredAmountOfBitShiftForSafeExponentiation = (number, exponent) => {
  let amountOfBitShiftRequired = ref(bnFromInt(0));
  let targetMaxNumberSizeBinaryDigits = bnFromInt(256)->div(exponent);

  // Note this can be optimised, this gets a quick easy to compute safe upper bound, not the actuall upper bound.
  let targetMaxNumber = twoBn->pow(targetMaxNumberSizeBinaryDigits);

  while (number
         ->div(twoBn->pow(amountOfBitShiftRequired.contents))
         ->bnGt(targetMaxNumber)) {
    amountOfBitShiftRequired := amountOfBitShiftRequired.contents->add(oneBn);
  };
  amountOfBitShiftRequired.contents;
};

let test =
    (
      ~contracts: ref(Helpers.coreContracts),
      ~accounts: ref(array(Ethers.Wallet.t)),
    ) => {
  let marketIndex = 1;

  let (kVal, longPrice, shortPrice, value1, value2) =
    Helpers.Tuple.make5(Helpers.randomTokenAmount);

  // let kVal = bnFromString("2000000000000000000"); // 2e18
  // let longPrice = bnFromString("10000000000000000000"); // 1e19
  // let shortPrice = bnFromString("15000000000000000000"); // 1.5e19
  // let value1 = bnFromString("8841300250000000000000000"); // 8.8e24
  // let value2 = bnFromString("12319741990000000000000000"); // 1.2e25

  describe("calculateFloatPerSecond", () => {
    let calculateFloatPerSecondPerPaymentTokenLocked =
        (
          ~underBalancedSideValue,
          ~overBalancedSideValue,
          ~exponent,
          ~equilibriumOffsetMarket,
          ~totalLocked,
          ~requiredBitShifting,
        ) => {
      let overflowProtectionDivision = twoBn->pow(requiredBitShifting);

      let numerator =
        underBalancedSideValue
        ->sub(equilibriumOffsetMarket)
        ->div(overflowProtectionDivision)
        ->mul(twoBn)
        ->pow(exponent);
      let numerator =
        underBalancedSideValue
        ->sub(equilibriumOffsetMarket)
        ->div(overflowProtectionDivision->div(twoBn))
        ->pow(exponent);
      let denominator =
        totalLocked
        ->div(overflowProtectionDivision)
        ->pow(exponent)
        ->div(tenToThe18);

      let overBalancedSideRate = numerator->div(denominator)->div(twoBn);
      let underBalancedSideRate = tenToThe18->sub(overBalancedSideRate);
      Chai.expectTrue(underBalancedSideRate->bnGte(overBalancedSideRate));
      (overBalancedSideRate, underBalancedSideRate);
    };

    let balanceIncentiveCurveExponent = ref(None->Obj.magic);

    before_each(() => {
      let%Await _ =
        deployAndSetupStakerToUnitTest(
          ~functionName="_calculateFloatPerSecond",
          ~contracts,
          ~accounts,
        );
      let%Await balanceIncentiveCurveExponentFetched =
        contracts^.staker->Staker.balanceIncentiveCurveExponent(marketIndex);
      balanceIncentiveCurveExponent := balanceIncentiveCurveExponentFetched;

      let requiredBitShifting =
        getRequiredAmountOfBitShiftForSafeExponentiation(
          value1->add(value2),
          balanceIncentiveCurveExponentFetched,
        );

      StakerSmocked.InternalMock.mockGetKValueToReturn(kVal);
    });

    let testHelper = (~longPrice, ~shortPrice, ~longValue, ~shortValue) => {
      let totalLocked = longValue->add(shortValue);

      let requiredBitShifting =
        getRequiredAmountOfBitShiftForSafeExponentiation(
          totalLocked,
          balanceIncentiveCurveExponent^,
        );

      StakerSmocked.InternalMock.mockGetRequiredAmountOfBitShiftForSafeExponentiationToReturn(
        requiredBitShifting,
      );

      let%Await result =
        contracts^.staker
        ->Staker.Exposed.calculateFloatPerSecondExposedCall(
            ~marketIndex,
            ~longPrice,
            ~shortPrice,
            ~longValue,
            ~shortValue,
          );

      let longFloatPerSecond: Ethers.BigNumber.t = result.longFloatPerSecond;
      let shortFloatPerSecond: Ethers.BigNumber.t = result.shortFloatPerSecond;
      if (longValue->bnGte(shortValue)) {
        let (longRate, shortRate) =
          calculateFloatPerSecondPerPaymentTokenLocked(
            ~underBalancedSideValue=shortValue,
            ~overBalancedSideValue=longValue,
            ~exponent=balanceIncentiveCurveExponent^,
            ~equilibriumOffsetMarket=CONSTANTS.zeroBn,
            ~totalLocked,
            ~requiredBitShifting,
          );

        let longRateScaled =
          longRate->mul(kVal)->mul(longPrice)->div(tenToThe18);
        let shortRateScaled =
          shortRate->mul(kVal)->mul(shortPrice)->div(tenToThe18);
        longFloatPerSecond->Chai.bnEqual(longRateScaled);
        shortRateScaled->Chai.bnEqual(shortRateScaled);
      } else {
        let (shortRate, longRate) =
          calculateFloatPerSecondPerPaymentTokenLocked(
            ~underBalancedSideValue=longValue,
            ~overBalancedSideValue=shortValue,
            ~exponent=balanceIncentiveCurveExponent^,
            ~equilibriumOffsetMarket=CONSTANTS.zeroBn,
            ~totalLocked,
            ~requiredBitShifting,
          );

        let longRateScaled =
          longRate->mul(kVal)->mul(longPrice)->div(tenToThe18);
        let shortRateScaled =
          shortRate->mul(kVal)->mul(shortPrice)->div(tenToThe18);
        longFloatPerSecond->Chai.bnEqual(longRateScaled);
        shortRateScaled->Chai.bnEqual(shortRateScaled);
      };
    };

    describe(
      "returns correct longFloatPerSecond and shortFloatPerSecond for each market side and calls getKValue correctly",
      () => {
        it("longValue > shortValue", () => {
          let%Await _ =
            testHelper(
              ~longValue=value1->add(value2),
              ~shortValue=value2,
              ~longPrice,
              ~shortPrice,
            );
          ();
        });
        it("longValue < shortValue", () => {
          let%Await _ =
            testHelper(
              ~longValue=value1,
              ~shortValue=value1->add(value2),
              ~longPrice,
              ~shortPrice,
            );
          ();
        });
      },
    );
    it("calls getKValue correctly", () => {
      StakerSmocked.InternalMock.mockGetRequiredAmountOfBitShiftForSafeExponentiationToReturn(
        bnFromInt(55) // conservatively high
      );
      StakerSmocked.InternalMock.mockGetKValueToReturn(kVal);

      let%Await result =
        contracts^.staker
        ->Staker.Exposed.calculateFloatPerSecondExposedCall(
            ~marketIndex,
            ~longPrice,
            ~shortPrice,
            ~longValue=value1,
            ~shortValue=value2,
          );

      let call =
        StakerSmocked.InternalMock.getKValueCalls()->Array.getUnsafe(0);
      call->Chai.recordEqualFlat({marketIndex: marketIndex});
    });
    it("reverts for empty markets", () => {
      Chai.expectRevertNoReason(
        ~transaction=
          contracts^.staker
          ->Staker.Exposed.calculateFloatPerSecondExposed(
              ~marketIndex,
              ~longPrice=CONSTANTS.zeroBn,
              ~shortPrice=CONSTANTS.zeroBn,
              ~longValue=CONSTANTS.zeroBn,
              ~shortValue=CONSTANTS.zeroBn,
            ),
      )
    });
  });
};
