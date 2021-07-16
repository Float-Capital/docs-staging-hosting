open Globals;
open LetOps;
open StakerHelpers;
open Mocha;

let test =
    (
      ~contracts: ref(Helpers.coreContracts),
      ~accounts: ref(array(Ethers.Wallet.t)),
    ) => {
  describe("addNewStakingFund", () => {
    let marketIndex = 1;
    let sampleLongAddress = Helpers.randomAddress();
    let sampleShortAddress = Helpers.randomAddress();
    let sampleMockAddress = Helpers.randomAddress();
    let kInitialMultiplier = Helpers.randomInteger();
    let kPeriod = Helpers.randomInteger();
    let unstakeFeeBasisPoints = Helpers.randomInteger();

    let timestampRef = ref(0);

    let promiseRef: ref(JsPromise.t(ContractHelpers.transaction)) =
      ref(()->JsPromise.resolve->Obj.magic);

    before_once'(() => {
      let%Await _ =
        deployAndSetupStakerToUnitTest(
          ~functionName="addNewStakingFund",
          ~contracts,
          ~accounts,
        );
      StakerSmocked.InternalMock.mock_changeMarketLaunchIncentiveParametersToReturn();
      StakerSmocked.InternalMock.mock_changeUnstakeFeeToReturn();
      // StakerSmocked.InternalMock.mockOnlyFloatToReturn();

      let longShortAddress = (accounts^)->Array.getUnsafe(5);
      let%AwaitThen _ =
        contracts^.staker
        ->Staker.Exposed.setAddNewStakingFundParams(
            ~marketIndex=1,
            ~longToken=sampleLongAddress,
            ~shortToken=sampleShortAddress,
            ~mockAddress=sampleMockAddress,
            ~longShortAddress=longShortAddress.address,
          );

      let%AwaitThen {timestamp} = Helpers.getBlock();
      timestampRef := timestamp;
      let promise =
        contracts^.staker
        ->ContractHelpers.connect(~address=longShortAddress)
        ->Obj.magic
        ->Staker.Exposed.addNewStakingFund(
            ~marketIndex,
            ~longToken=sampleLongAddress,
            ~shortToken=sampleShortAddress,
            ~kInitialMultiplier,
            ~kPeriod,
            ~unstakeFeeBasisPoints,
            ~balanceIncentiveCurveExponent=bnFromInt(5),
            ~balanceIncentiveCurveEquilibriumOffset=bnFromInt(0),
          );
      promiseRef := promise;
      let%Await _ = promise;
      ();
    });

    it_skip("calls the onlyLongShortModifier", () => {
      // StakerSmocked.InternalMock.onlyFloatCalls()
      // ->Array.length
      // ->Chai.intEqual(1)
      ()
    });

    it(
      "calls _changeMarketLaunchIncentiveParameters with correct arguments", () => {
      StakerSmocked.InternalMock._changeMarketLaunchIncentiveParametersCalls()
      ->Array.getUnsafe(0)
      ->Chai.recordEqualFlat({
          marketIndex,
          period: kPeriod,
          initialMultiplier: kInitialMultiplier,
        })
    });

    it("calls _changeUnstakeFee with correct arguments", () => {
      StakerSmocked.InternalMock._changeUnstakeFeeCalls()
      ->Array.getUnsafe(0)
      ->Chai.recordEqualFlat({
          marketIndex,
          newMarketUnstakeFeeBasisPoints: unstakeFeeBasisPoints,
        })
    });

    it("mutates syntheticRewardParams", () => {
      let%Await params =
        contracts^.staker->Staker.syntheticRewardParams(1, CONSTANTS.zeroBn);

      params->Chai.recordEqualFlat({
        timestamp: Ethers.BigNumber.fromInt(timestampRef^ + 1), // one second per block in hardhat
        accumulativeFloatPerLongToken: CONSTANTS.zeroBn,
        accumulativeFloatPerShortToken: CONSTANTS.zeroBn,
      });
    });

    it("mutates syntheticTokens", () => {
      let%Await tokenLong =
        contracts^.staker->Staker.syntheticTokens(1, true);
      let%Await tokenShort =
        contracts^.staker->Staker.syntheticTokens(1, false);

      Chai.addressEqual(~otherAddress=tokenLong, sampleLongAddress);
      Chai.addressEqual(~otherAddress=tokenShort, sampleShortAddress);
    });

    it("mutates marketIndexOfTokens", () => {
      let%AwaitThen longMarketIndex =
        contracts^.staker->Staker.marketIndexOfToken(sampleLongAddress);
      let%Await shortMarketIndex =
        contracts^.staker->Staker.marketIndexOfToken(sampleShortAddress);

      Chai.intEqual(marketIndex, longMarketIndex);
      Chai.intEqual(marketIndex, shortMarketIndex);
    });

    it("emits StateAddedEvent", () => {
      Chai.callEmitEvents(
        ~call=promiseRef^,
        ~contract=contracts^.staker->Obj.magic,
        ~eventName="StateAdded",
      )
      ->Chai.withArgs4(
          marketIndex,
          CONSTANTS.zeroBn,
          CONSTANTS.zeroBn,
          CONSTANTS.zeroBn,
        )
    });
  });
};
