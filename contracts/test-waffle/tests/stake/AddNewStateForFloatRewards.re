open Globals;
open LetOps;
open Mocha;

let testUnit =
    (
      ~contracts: ref(Helpers.stakerUnitTestContracts),
      ~accounts as _: ref(array(Ethers.Wallet.t)),
    ) => {
  let marketIndex = Helpers.randomJsInteger();
  let (longPrice, shortPrice, longValue, shortValue, timeDeltaGreaterThanZero) =
    Helpers.Tuple.make5(Helpers.randomInteger);

  describe("addNewStateForFloatRewards", () => {
    before_once'(() => {
      contracts.contents.staker
      ->StakerSmocked.InternalMock.setupFunctionForUnitTesting(
          ~functionName="addNewStateForFloatRewards",
        )
    });

    let setup =
        (~longShortMarketPriceSnapshotIndexIfShiftExecuted, ~timeDelta) => {
      StakerSmocked.InternalMock.mock_calculateTimeDeltaToReturn(timeDelta);

      contracts.contents.staker
      ->Staker.addNewStateForFloatRewards(
          ~marketIndex,
          ~longPrice,
          ~shortPrice,
          ~longValue,
          ~shortValue,
          ~longShortMarketPriceSnapshotIndexIfShiftExecuted,
        );
    };

    describe("modifiers", () =>
      it("calls the onlyLongShort modifier", () => {
        let%Await _ =
          contracts.contents.staker
          ->Staker.addNewStateForFloatRewards(
              ~marketIndex,
              ~longPrice,
              ~shortPrice,
              ~longValue,
              ~shortValue,
              ~longShortMarketPriceSnapshotIndexIfShiftExecuted=zeroBn,
            );

        StakerSmocked.InternalMock.onlyLongShortModifierLogicCalls()
        ->Array.length
        ->Chai.intEqual(1);
      })
    );

    describe("case timeDelta > 0", () => {
      let longShortMarketPriceSnapshotIndexIfShiftExecuted =
        Helpers.randomTokenAmount();

      before_once'(() =>
        setup(
          ~timeDelta=timeDeltaGreaterThanZero,
          ~longShortMarketPriceSnapshotIndexIfShiftExecuted,
        )
      );

      it("calls calculateTimeDelta with correct arguments", () => {
        StakerSmocked.InternalMock._calculateTimeDeltaCalls()
        ->Chai.recordArrayDeepEqualFlat([|{marketIndex: marketIndex}|])
      });

      it("calls setRewardObjects with correct arguments", () => {
        StakerSmocked.InternalMock._setRewardObjectsCalls()
        ->Chai.recordArrayDeepEqualFlat([|
            {marketIndex, longPrice, shortPrice, longValue, shortValue},
          |])
      });
    });

    describe("case longShortMarketPriceSnapshotIndexIfShiftExecuted > 0", () => {
      let nextTokenShiftIndex = Helpers.randomInteger();
      let latestRewardIndex = Helpers.randomInteger();
      let longShortMarketPriceSnapshotIndexIfShiftExecuted =
        Helpers.randomInteger();
      let addNewStateForFloatRewardsTxPromise = ref("Not set yet"->Obj.magic);

      before_once'(() => {
        let%Await _ =
          contracts.contents.staker
          ->Staker.Exposed.setAddNewStateForFloatRewardsGlobals(
              ~marketIndex,
              ~nextTokenShiftIndex,
              ~latestRewardIndex,
            );

        addNewStateForFloatRewardsTxPromise :=
          setup(
            ~timeDelta=timeDeltaGreaterThanZero,
            ~longShortMarketPriceSnapshotIndexIfShiftExecuted,
          );

        addNewStateForFloatRewardsTxPromise.contents;
      });

      it(
        "updates longShortMarketPriceSnapshotIndex to the 'longShortMarketPriceSnapshotIndexIfShiftExecuted' value recieved from long short",
        () => {
          let%Await longShortMarketPriceSnapshotIndex =
            contracts.contents.staker
            ->Staker.longShortMarketPriceSnapshotIndex(nextTokenShiftIndex);
          Chai.bnEqual(
            longShortMarketPriceSnapshotIndex,
            longShortMarketPriceSnapshotIndexIfShiftExecuted,
          );
        },
      );

      it("increments the tokenShiftIndexToStakerStateMapping", () => {
        let%Await tokenShiftIndexToStakerStateMapping =
          contracts.contents.staker
          ->Staker.tokenShiftIndexToStakerStateMapping(nextTokenShiftIndex);
        Chai.bnEqual(
          tokenShiftIndexToStakerStateMapping,
          latestRewardIndex->add(oneBn),
        );
      });

      it("increments the nextTokenShiftIndex", () => {
        let%Await updatedNextTokenShiftIndex =
          contracts.contents.staker->Staker.nextTokenShiftIndex(marketIndex);
        Chai.bnEqual(
          updatedNextTokenShiftIndex,
          nextTokenShiftIndex->add(oneBn),
        );
      });

      it("emits the SynthTokensShifted event", () => {
        Chai.callEmitEvents(
          ~call=addNewStateForFloatRewardsTxPromise.contents,
          ~contract=contracts.contents.staker->Obj.magic,
          ~eventName="SynthTokensShifted",
        )
        ->Chai.withArgs0
      });
    });

    describe("case timeDelta == 0", () => {
      it("doesn't call setRewardObjects", () => {
        let%Await _ =
          setup(
            ~timeDelta=CONSTANTS.zeroBn,
            ~longShortMarketPriceSnapshotIndexIfShiftExecuted=zeroBn,
          );
        StakerSmocked.InternalMock._setRewardObjectsCalls()
        ->Chai.recordArrayDeepEqualFlat([||]);
      })
    });
  });
};
