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
    let stakerRef: ref(Staker.t) = ref(""->Obj.magic);

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
        stakerRef->deployAndSetupStakerToUnitTest(
          ~functionName="addNewStakingFund",
          ~contracts,
          ~accounts,
        );
      StakerSmocked.InternalMock.mock_changeMarketLaunchIncentiveParametersToReturn();
      StakerSmocked.InternalMock.mockOnlyFloatToReturn();
      let%AwaitThen _ =
        (stakerRef^)
        ->Staker.Exposed.setAddNewStakingFundParams(
            ~marketIndex=1,
            ~longToken=sampleLongAddress,
            ~shortToken=sampleShortAddress,
            ~mockAddress=sampleMockAddress,
          );

      let%AwaitThen {timestamp} = Helpers.getBlock();
      timestampRef := timestamp;
      let promise =
        (stakerRef^)
        ->Staker.Exposed.addNewStakingFund(
            ~marketIndex,
            ~longToken=sampleLongAddress,
            ~shortToken=sampleShortAddress,
            ~kInitialMultiplier,
            ~kPeriod,
            ~unstakeFeeBasisPoints,
          );
      promiseRef := promise;
      let%Await _ = promise;
      ();
    });

    it("calls the onlyFloatModifier", () => {
      StakerSmocked.InternalMock.onlyFloatCalls()
      ->Array.length
      ->Chai.intEqual(1)
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

    it("mutates syntheticRewardParams", () => {
      let%Await params =
        (stakerRef^)->Staker.syntheticRewardParams(1, CONSTANTS.zeroBn);

      params->Chai.recordEqualFlat({
        timestamp: Ethers.BigNumber.fromInt(timestampRef^ + 1), // one second per block in hardhat
        accumulativeFloatPerLongToken: CONSTANTS.zeroBn,
        accumulativeFloatPerShortToken: CONSTANTS.zeroBn,
      });
    });

    it("mutates syntheticTokens", () => {
      let%Await tokenLong = (stakerRef^)->Staker.syntheticTokens(1, true);
      let%Await tokenShort = (stakerRef^)->Staker.syntheticTokens(1, false);

      Chai.addressEqual(~otherAddress=tokenLong, sampleLongAddress);
      Chai.addressEqual(~otherAddress=tokenShort, sampleShortAddress);
    });

    it("mutates marketIndexOfTokens", () => {
      let%AwaitThen longMarketIndex =
        (stakerRef^)->Staker.marketIndexOfToken(sampleLongAddress);
      let%Await shortMarketIndex =
        (stakerRef^)->Staker.marketIndexOfToken(sampleShortAddress);

      Chai.intEqual(marketIndex, longMarketIndex);
      Chai.intEqual(marketIndex, shortMarketIndex);
    });

    it("emits StateAddedEvent", () => {
      Chai.callEmitEvents(
        ~call=promiseRef^,
        ~contract=(stakerRef^)->Obj.magic,
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
