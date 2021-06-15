open Globals;
open LetOps;

let randomAddress = () => Ethers.Wallet.createRandom().address;

let test = (~contracts: ref(Helpers.coreContracts)) => {
  describe("addNewStakingFund", () => {
    let stakerRef: ref(Staker.t) = ref(""->Obj.magic);

    let marketIndex = 1;
    let sampleLongAddress = randomAddress();
    let sampleShortAddress = randomAddress();
    let sampleMockAddress = randomAddress();
    let kInitialMultiplier = Helpers.randomInteger();
    let kPeriod = Helpers.randomInteger();

    let timestampRef = ref(0);

    let promiseRef: ref(JsPromise.t(ContractHelpers.transaction)) =
      ref(()->JsPromise.resolve->Obj.magic);

    before_once'(() => {
      let {staker} = contracts^;
      stakerRef := staker;
      let%AwaitThen _ = (stakerRef^)->StakerSmocked.InternalMock.setup;
      let%AwaitThen _ =
        (stakerRef^)
        ->StakerSmocked.InternalMock.setupFunctionForUnitTesting(
            ~functionName="addNewStakingFund",
          );
      let _ =
        StakerSmocked.InternalMock.mock_changeMarketLaunchIncentiveParametersToReturn();
      let _ = StakerSmocked.InternalMock.mockonlyFloatToReturn();
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
          );
      promiseRef := promise;
      let%Await _ = promise;
      ();
    });

    it''("calls the onlyFloatModifier", () => {
      StakerSmocked.InternalMock.onlyFloatCalls()
      ->Array.length
      ->Chai.intEqual(1)
    });

    it''(
      "calls \_changeMarketLaunchIncentiveParameters with correct arguments",
      () => {
      StakerSmocked.InternalMock._changeMarketLaunchIncentiveParametersCalls()
      ->Array.getUnsafe(0)
      ->Chai.recordEqualFlat({
          marketIndex,
          period: kPeriod,
          initialMultiplier: kInitialMultiplier,
        })
    });

    it'("mutates syntheticRewardParams", () => {
      let%Await params =
        (stakerRef^)->Staker.syntheticRewardParams(1, CONSTANTS.zeroBn);

      params->Chai.recordEqualFlat({
        timestamp: Ethers.BigNumber.fromInt(timestampRef^ + 1), // one second per block in hardhat
        accumulativeFloatPerLongToken: CONSTANTS.zeroBn,
        accumulativeFloatPerShortToken: CONSTANTS.zeroBn,
      });
    });

    it'("mutates syntheticTokens", () => {
      let%Await tokens = (stakerRef^)->Staker.syntheticTokens(1);

      tokens->Chai.recordEqualFlat({
        longToken: sampleLongAddress,
        shortToken: sampleShortAddress,
      });
    });

    it'("mutates marketIndexOfToken", () => {
      let%AwaitThen longMarketIndex =
        (stakerRef^)->Staker.marketIndexOfToken(sampleLongAddress);
      let%Await shortMarketIndex =
        (stakerRef^)->Staker.marketIndexOfToken(sampleShortAddress);

      Chai.intEqual(marketIndex, longMarketIndex);
      Chai.intEqual(marketIndex, shortMarketIndex);
    });

    it'("emits StateAddedEvent", () => {
      Chai.callEmitEvents(
        ~call=promiseRef^,
        ~contract=(stakerRef^)->Obj.magic,
        ~eventName="StateAdded",
      )
      ->Chai.withArgs5(
          marketIndex,
          CONSTANTS.zeroBn,
          Ethers.BigNumber.fromInt(timestampRef^ + 1),
          CONSTANTS.zeroBn,
          CONSTANTS.zeroBn,
        )
    });
  });
};
