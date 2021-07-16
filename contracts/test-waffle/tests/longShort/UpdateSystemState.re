open LetOps;
open Mocha;
open Globals;

let makeIterator = anyArray => {
  let indexRef = ref(0);
  () => {
    let index = indexRef^;
    indexRef := (index + 1) mod anyArray->Array.length;
    anyArray->Array.getExn(index);
  };
};

let testUnit =
    (
      ~contracts: ref(Helpers.coreContracts),
      ~accounts: ref(array(Ethers.Wallet.t)),
    ) => {
  describeUnit("updateSystemState", () => {
    describe("_updateSystemStateInternal", () => {
      let smockedRefreshTokenPriceIterativeBinding = [%raw
        {|(_r, arr) => _r.smocked._recalculateSyntheticTokenPriceMock.will.return.with(makeIterator(arr))|}
      ];

      let getWalletBinding: StakerSmocked.t => Ethers.Wallet.t = [%raw
        {|(_r) => { return _r.wallet;}|}
      ];

      let iterativeMockRefreshTokenPriceToReturn:
        array(Ethers.BigNumber.t) => unit =
        arr => {
          let _ =
            LongShortSmocked.InternalMock.internalRef.contents
            ->Option.map(_r =>
                smockedRefreshTokenPriceIterativeBinding(_r, arr)
              );
          ();
        };

      let send1Ether = [%raw
        {|(wallet, address) => {
          const tx = {
              to: address,
              value: ethers.utils.parseUnits('1.0', 'ether')
          };
          return wallet.sendTransaction(tx);
        }|}
      ];
      let marketIndex = 1;
      let oldAssetPrice = Helpers.randomTokenAmount();
      let newAssetPrice =
        oldAssetPrice->Ethers.BigNumber.add(CONSTANTS.oneBn);

      let oldLongPrice = Helpers.randomTokenAmount();
      let potentialNewLongPrice =
        oldLongPrice->Ethers.BigNumber.add(CONSTANTS.oneBn);
      let oldShortPrice = Helpers.randomTokenAmount();
      let potentialNewShortPrice =
        oldShortPrice->Ethers.BigNumber.add(CONSTANTS.oneBn);

      let latestUpdateIndexForMarket = CONSTANTS.twoBn;

      let (longValue, shortValue) =
        Helpers.Tuple.make2(Helpers.randomTokenAmount);

      let stakerSmockedRef: ref(StakerSmocked.t) = ref(None->Obj.magic);
      let oracleSmockedRef: ref(OracleManagerMockSmocked.t) =
        ref(None->Obj.magic);
      let setup =
          (
            ~oldAssetPrice,
            ~newAssetPrice,
            ~oldLongPrice,
            ~potentialNewLongPrice,
            ~oldShortPrice,
            ~potentialNewShortPrice,
            ~fromStaker,
          ) => {
        let%AwaitThen _ =
          contracts^.longShort->LongShortSmocked.InternalMock.setup;
        let%AwaitThen _ =
          contracts^.longShort
          ->LongShortSmocked.InternalMock.setupFunctionForUnitTesting(
              ~functionName="_updateSystemStateInternal",
            );

        LongShortSmocked.InternalMock.mock_claimAndDistributeYieldToReturn();
        LongShortSmocked.InternalMock.mock_adjustMarketBasedOnNewAssetPriceToReturn();
        LongShortSmocked.InternalMock.mock_performOustandingBatchedSettlementsToReturn();

        iterativeMockRefreshTokenPriceToReturn([|
          potentialNewLongPrice,
          potentialNewShortPrice,
        |]);

        let%AwaitThen stakerSmocked = StakerSmocked.make(contracts^.staker);

        let stakerWallet = stakerSmocked->getWalletBinding;

        let%AwaitThen _ =
          send1Ether((accounts^)->Array.getUnsafe(0), stakerWallet.address);

        let _ =
          stakerSmocked->StakerSmocked.mockAddNewStateForFloatRewardsToReturn;
        let%AwaitThen oracleSmocked =
          contracts^.markets->Array.getExn(1).oracleManager
          ->OracleManagerMockSmocked.make;

        let _ =
          oracleSmocked->OracleManagerMockSmocked.mockUpdatePriceToReturn(
            newAssetPrice,
          );

        oracleSmockedRef := oracleSmocked;
        stakerSmockedRef := stakerSmocked;

        let longShort =
          fromStaker
            ? contracts^.longShort
              ->ContractHelpers.connect(~address=stakerWallet)
            : contracts^.longShort;

        let%AwaitThen _ =
          longShort->LongShort.Exposed.set_updateSystemStateInternalGlobals(
            ~marketIndex,
            ~latestUpdateIndexForMarket,
            ~syntheticTokenPriceLong=oldLongPrice,
            ~syntheticTokenPriceShort=oldShortPrice,
            ~assetPrice=oldAssetPrice,
            ~oracleManager=oracleSmocked.address,
            ~staker=stakerSmocked.address,
            ~longValue,
            ~shortValue,
          );

        longShort->LongShort.Exposed._updateSystemStateInternalExposed(
          ~marketIndex,
        );
      };
      let setupWithoutPriceChange =
        setup(
          ~oldAssetPrice,
          ~newAssetPrice=oldAssetPrice,
          ~oldLongPrice,
          ~oldShortPrice,
          ~potentialNewLongPrice,
          ~potentialNewShortPrice,
        );
      it("calls for the latest price from the oracle", () => {
        let%Await _ = setupWithoutPriceChange(~fromStaker=true);
        (oracleSmockedRef^)
        ->OracleManagerMockSmocked.updatePriceCalls
        ->Array.length
        ->Chai.intEqual(1);
      });
      it(
        "it shouldn't modify state or call other functions IF the `msg.sender` isn't the staker AND the price didn't change",
        () => {
          let%Await _ = setupWithoutPriceChange(~fromStaker=false);

          let%Await updateIndex =
            contracts^.longShort->LongShort.marketUpdateIndex(marketIndex);

          let%Await newLongPrice =
            contracts^.longShort
            ->LongShort.syntheticTokenPriceSnapshot(
                marketIndex,
                true,
                updateIndex,
              );

          let%Await newShortPrice =
            contracts^.longShort
            ->LongShort.syntheticTokenPriceSnapshot(
                marketIndex,
                false,
                updateIndex,
              );

          let%Await assetPrice =
            contracts^.longShort->LongShort.assetPrice(marketIndex);

          let numberOfClaimCalls =
            LongShortSmocked.InternalMock._claimAndDistributeYieldCalls()
            ->Array.length;
          let numberOfAdjustCalls =
            LongShortSmocked.InternalMock._adjustMarketBasedOnNewAssetPriceCalls()
            ->Array.length;
          let numberOfRecalcualteCalls =
            LongShortSmocked.InternalMock._recalculateSyntheticTokenPriceCalls()
            ->Array.length;
          let numberOfOutstandingSettelmentCalls =
            LongShortSmocked.InternalMock._performOustandingBatchedSettlementsCalls()
            ->Array.length;

          let numberOfStakerCalls =
            (stakerSmockedRef^)
            ->StakerSmocked.addNewStateForFloatRewardsCalls
            ->Array.length;

          Chai.bnEqual(oldAssetPrice, assetPrice);
          Chai.bnEqual(updateIndex, latestUpdateIndexForMarket);
          Chai.bnEqual(newLongPrice, oldLongPrice);
          Chai.bnEqual(newShortPrice, oldShortPrice);

          Chai.intEqual(numberOfClaimCalls, 0);
          Chai.intEqual(numberOfAdjustCalls, 0);
          Chai.intEqual(numberOfRecalcualteCalls, 0);
          Chai.intEqual(numberOfOutstandingSettelmentCalls, 0);
          Chai.intEqual(numberOfStakerCalls, 0);
        },
      );

      it(
        "it should call the addNewStateForFloatRewards on the staker function if the `msg.sender` is the staker (with NO price change)",
        () => {
          let%Await _ = setupWithoutPriceChange(~fromStaker=true);
          ();
          (stakerSmockedRef^)
          ->StakerSmocked.addNewStateForFloatRewardsCalls
          ->Array.getExn(0)
          ->Chai.recordEqualFlat({
              marketIndex,
              longPrice: oldLongPrice,
              shortPrice: oldShortPrice,
              longValue,
              shortValue,
            });
        },
      );

      describe("There is a price change", () => {
        let setupWithPriceChange =
          setup(
            ~oldAssetPrice,
            ~newAssetPrice,
            ~oldLongPrice,
            ~oldShortPrice,
            ~potentialNewLongPrice,
            ~potentialNewShortPrice,
          );
        // TODO: there could also be a test to ensure that _claimAndDistributeYield happens before _adjustMarketBasedOnNewAssetPrice
        it(
          "it should call the addNewStateForFloatRewards on the staker function if the `msg.sender` is the staker (WITH a price change)",
          () => {
            let%Await _ = setupWithPriceChange(~fromStaker=true);
            (stakerSmockedRef^)
            ->StakerSmocked.addNewStateForFloatRewardsCalls
            ->Array.getExn(0)
            ->Chai.recordEqualFlat({
                marketIndex,
                longPrice: oldLongPrice,
                shortPrice: oldShortPrice,
                longValue,
                shortValue,
              });
          },
        );

        it(
          "it should call `_claimAndDistributeYield` with correct arguments",
          () => {
          let%Await _ = setupWithPriceChange(~fromStaker=false);
          LongShortSmocked.InternalMock._claimAndDistributeYieldCalls()
          ->Array.getExn(0)
          ->Chai.recordEqualFlat({marketIndex: marketIndex});
        });
        it(
          "it should call `_adjustMarketBasedOnNewAssetPrice` with correct arguments",
          () => {
          let%Await _ = setupWithPriceChange(~fromStaker=false);
          LongShortSmocked.InternalMock._adjustMarketBasedOnNewAssetPriceCalls()
          ->Array.getExn(0)
          ->Chai.recordEqualFlat({marketIndex, oldAssetPrice, newAssetPrice});
        });
        it(
          "it should call `_recalculateSyntheticTokenPrice` twice (one for long, other for short) with correct arguments",
          () => {
            let%Await _ = setupWithPriceChange(~fromStaker=false);

            let calls =
              LongShortSmocked.InternalMock._recalculateSyntheticTokenPriceCalls();
            calls
            ->Array.getExn(0)
            ->Chai.recordEqualFlat({marketIndex, isLong: true});

            calls
            ->Array.getExn(1)
            ->Chai.recordEqualFlat({marketIndex, isLong: false});
          },
        );
        it(
          "it should call `_performOustandingSettlements` with correct arguments",
          () => {
          let%Await _ = setupWithPriceChange(~fromStaker=false);
          LongShortSmocked.InternalMock._performOustandingBatchedSettlementsCalls()
          ->Array.getExn(0)
          ->Chai.recordEqualFlat({
              marketIndex,
              syntheticTokenPriceLong: potentialNewLongPrice,
              syntheticTokenPriceShort: potentialNewShortPrice,
            });
        });
        it(
          "should mutate syntheticTokenPriceSnapshots for long and short correctly",
          () => {
          let%Await _ = setupWithPriceChange(~fromStaker=false);
          let newUpdateIndex =
            latestUpdateIndexForMarket->Ethers.BigNumber.add(CONSTANTS.oneBn);
          let%Await newLongPrice =
            contracts^.longShort
            ->LongShort.syntheticTokenPriceSnapshot(
                marketIndex,
                true,
                newUpdateIndex,
              );

          let%Await newShortPrice =
            contracts^.longShort
            ->LongShort.syntheticTokenPriceSnapshot(
                marketIndex,
                false,
                newUpdateIndex,
              );

          newLongPrice->Chai.bnEqual(potentialNewLongPrice);
          newShortPrice->Chai.bnEqual(potentialNewShortPrice);
        });
        it("it should update the (underlying) asset price correctly", () => {
          let%AwaitThen _ = setupWithPriceChange(~fromStaker=false);
          let%Await assetPrice =
            contracts^.longShort->LongShort.assetPrice(marketIndex);
          Chai.bnEqual(assetPrice, newAssetPrice);
        });
        it("it should increment the marketUpdateIndex by 1", () => {
          let%AwaitThen _ = setupWithPriceChange(~fromStaker=false);
          let%Await updateIndex =
            contracts^.longShort->LongShort.marketUpdateIndex(marketIndex);
          Chai.bnEqual(
            latestUpdateIndexForMarket->Ethers.BigNumber.add(CONSTANTS.oneBn),
            updateIndex,
          );
        });
        it(
          "it should emit the SystemStateUpdated event with the correct arguments",
          () => {
          Chai.callEmitEvents(
            ~call=setupWithPriceChange(~fromStaker=false),
            ~eventName="SystemStateUpdated",
            ~contract=contracts^.longShort->Obj.magic,
          )
          ->Chai.withArgs7(
              marketIndex,
              latestUpdateIndexForMarket->Ethers.BigNumber.add(
                CONSTANTS.oneBn,
              ),
              newAssetPrice,
              longValue,
              shortValue,
              potentialNewLongPrice,
              potentialNewShortPrice,
            )
        });
      });
    });

    describe("updateSystemStateMulti", () => {
      it(
        "should call `_updateSystemStateInternal` for each market in the array",
        () =>
        Js.log("TODO")
      )
    });
    describe("updateSystemState", () => {
      it(
        "should call to `_updateSystemStateInternal` with the correct market as an argument",
        () =>
        Js.log("TODO")
      )
    });
  });
};

let testIntegration =
    (
      ~contracts: ref(Helpers.coreContracts),
      ~accounts as _: ref(array(Ethers.Wallet.t)),
    ) => {
  describe("updateSystemState", () => {
    it("distribute yield to markets flow", () => {
      let {longShort, markets} = contracts.contents;
      let {yieldManager, oracleManager, marketIndex} =
        markets->Array.getUnsafe(0);

      // 32.1... DAI - any random amount would do...
      let amountOfYieldToAward = bnFromString("3216543216543216542");

      // get total balance pools etc before (and amount for treasury)
      let%Await longTokenPoolValueBefore =
        longShort->LongShort.syntheticTokenPoolValue(marketIndex, true);
      let%Await shortTokenPoolValueBefore =
        longShort->LongShort.syntheticTokenPoolValue(marketIndex, false);
      let%Await totalDueForTreasuryBefore =
        yieldManager->YieldManagerMock.totalReservedForTreasury;
      let totalValueRelatedToMarketBefore =
        longTokenPoolValueBefore
        ->add(shortTokenPoolValueBefore)
        ->add(totalDueForTreasuryBefore);

      // add some yield
      let _ =
        yieldManager->YieldManagerMock.settleWithYieldAbsolute(
          ~totalYield=amountOfYieldToAward,
        );

      // update oracle price
      let%Await currentOraclePrice =
        oracleManager->OracleManagerMock.getLatestPrice;
      let%Await _ =
        oracleManager->OracleManagerMock.setPrice(
          ~newPrice=currentOraclePrice->add(bnFromInt(1)),
        );

      // run long short update state
      let%Await _ = longShort->LongShort.updateSystemState(~marketIndex);

      // get total balance pools after and amount for treasury
      let%Await longTokenPoolValueAfter =
        longShort->LongShort.syntheticTokenPoolValue(marketIndex, true);
      let%Await shortTokenPoolValueAfter =
        longShort->LongShort.syntheticTokenPoolValue(marketIndex, false);
      let%Await totalDueForTreasuryAfter =
        yieldManager->YieldManagerMock.totalReservedForTreasury;
      let totalValueRelatedToMarketAfter =
        longTokenPoolValueAfter
        ->add(shortTokenPoolValueAfter)
        ->add(totalDueForTreasuryAfter);

      Chai.bnEqual(
        ~message=
          "yield is either being lost or over-allocated - should be exactly the same",
        totalValueRelatedToMarketBefore->add(amountOfYieldToAward),
        totalValueRelatedToMarketAfter,
      );
    });
    it("cannot call updateSystemState on a market that doesn't exist", () => {
      let nonExistantMarketIndex = 321321654;
      Chai.expectRevert(
        ~transaction=
          contracts.contents.longShort
          ->LongShort.updateSystemState(~marketIndex=nonExistantMarketIndex),
        ~reason="market doesn't exist",
      );
    });
  });
};
