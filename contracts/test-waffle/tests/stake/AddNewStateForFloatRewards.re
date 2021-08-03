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
        (
          ~takerTokenShiftIndex_to_longShortMarketPriceSnapshotIndex_mappingIfShiftExecuted,
          ~timeDelta,
        ) => {
      StakerSmocked.InternalMock.mock_calculateTimeDeltaToReturn(timeDelta);

      contracts.contents.staker
      ->Staker.addNewStateForFloatRewards(
          ~marketIndex,
          ~longPrice,
          ~shortPrice,
          ~longValue,
          ~shortValue,
          ~takerTokenShiftIndex_to_longShortMarketPriceSnapshotIndex_mappingIfShiftExecuted,
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
              ~takerTokenShiftIndex_to_longShortMarketPriceSnapshotIndex_mappingIfShiftExecuted=zeroBn,
            );

        StakerSmocked.InternalMock.onlyLongShortModifierLogicCalls()
        ->Array.length
        ->Chai.intEqual(1);
      })
    );

    describe("case timeDelta > 0", () => {
      let takerTokenShiftIndex_to_longShortMarketPriceSnapshotIndex_mappingIfShiftExecuted =
        Helpers.randomTokenAmount();

      before_once'(() =>
        setup(
          ~timeDelta=timeDeltaGreaterThanZero,
          ~takerTokenShiftIndex_to_longShortMarketPriceSnapshotIndex_mappingIfShiftExecuted,
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

    describe(
      "case takerTokenShiftIndex_to_longShortMarketPriceSnapshotIndex_mappingIfShiftExecuted > 0",
      () => {
        let batched_stakerNextTokenShiftIndex = Helpers.randomInteger();
        let latestRewardIndex = Helpers.randomInteger();
        let takerTokenShiftIndex_to_longShortMarketPriceSnapshotIndex_mappingIfShiftExecuted =
          Helpers.randomInteger();
        let addNewStateForFloatRewardsTxPromise =
          ref("Not set yet"->Obj.magic);

        before_once'(() => {
          let%Await _ =
            contracts.contents.staker
            ->Staker.Exposed.setAddNewStateForFloatRewardsGlobals(
                ~marketIndex,
                ~batched_stakerNextTokenShiftIndex,
                ~latestRewardIndex,
              );

          addNewStateForFloatRewardsTxPromise :=
            setup(
              ~timeDelta=timeDeltaGreaterThanZero,
              ~takerTokenShiftIndex_to_longShortMarketPriceSnapshotIndex_mappingIfShiftExecuted,
            );

          addNewStateForFloatRewardsTxPromise.contents;
        });

        it(
          "updates takerTokenShiftIndex_to_longShortMarketPriceSnapshotIndex_mapping to the 'takerTokenShiftIndex_to_longShortMarketPriceSnapshotIndex_mappingIfShiftExecuted' value recieved from long short",
          () => {
            let%Await takerTokenShiftIndex_to_longShortMarketPriceSnapshotIndex_mapping =
              contracts.contents.staker
              ->Staker.takerTokenShiftIndex_to_longShortMarketPriceSnapshotIndex_mapping(
                  batched_stakerNextTokenShiftIndex,
                );
            Chai.bnEqual(
              takerTokenShiftIndex_to_longShortMarketPriceSnapshotIndex_mapping,
              takerTokenShiftIndex_to_longShortMarketPriceSnapshotIndex_mappingIfShiftExecuted,
            );
          },
        );

        it(
          "increments the takerTokenShiftIndex_to_stakerStateIndex_mapping", () => {
          let%Await takerTokenShiftIndex_to_stakerStateIndex_mapping =
            contracts.contents.staker
            ->Staker.takerTokenShiftIndex_to_stakerStateIndex_mapping(
                batched_stakerNextTokenShiftIndex,
              );
          Chai.bnEqual(
            takerTokenShiftIndex_to_stakerStateIndex_mapping,
            latestRewardIndex->add(oneBn),
          );
        });

        it("increments the batched_stakerNextTokenShiftIndex", () => {
          let%Await updatedNextTokenShiftIndex =
            contracts.contents.staker
            ->Staker.batched_stakerNextTokenShiftIndex(marketIndex);
          Chai.bnEqual(
            updatedNextTokenShiftIndex,
            batched_stakerNextTokenShiftIndex->add(oneBn),
          );
        });

        it("emits the SyntheticTokensShifted event", () => {
          Chai.callEmitEvents(
            ~call=addNewStateForFloatRewardsTxPromise.contents,
            ~contract=contracts.contents.staker->Obj.magic,
            ~eventName="SyntheticTokensShifted",
          )
          ->Chai.withArgs0
        });
      },
    );

    describe("case timeDelta == 0", () => {
      it("doesn't call setRewardObjects", () => {
        let%Await _ =
          setup(
            ~timeDelta=CONSTANTS.zeroBn,
            ~takerTokenShiftIndex_to_longShortMarketPriceSnapshotIndex_mappingIfShiftExecuted=zeroBn,
          );
        StakerSmocked.InternalMock._setRewardObjectsCalls()
        ->Chai.recordArrayDeepEqualFlat([||]);
      })
    });
  });
};
