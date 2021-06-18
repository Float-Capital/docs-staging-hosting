open LetOps;
open Mocha;

let test =
    (
      ~contracts: ref(Helpers.coreContracts),
      ~accounts: ref(array(Ethers.Wallet.t)),
    ) => {
  describe("initializeMarket", () => {
    let stakerSmockedRef = ref(StakerSmocked.uninitializedValue);
    let longShortRef: ref(LongShort.t) = ref(""->Obj.magic);

    let sampleAddress = Ethers.Wallet.createRandom().address;

    let setup = (~marketIndex, ~marketIndexValue, ~latestMarket) => {
      let {longShort} = contracts^;
      longShortRef := longShort;
      let%Await smocked = StakerSmocked.make(contracts^.staker);
      let _ = smocked->StakerSmocked.mockaddNewStakingFundToReturn;
      stakerSmockedRef := smocked;
      let%Await _ = (longShortRef^)->LongShortSmocked.InternalMock.setup;
      let%Await _ =
        (longShortRef^)
        ->LongShortSmocked.InternalMock.setupFunctionForUnitTesting(
            ~functionName="initializeMarket",
          );
      let _ = LongShortSmocked.InternalMock.mock_changeFeesToReturn();

      let _ = LongShortSmocked.InternalMock.mockadminOnlyToReturn();

      let _ = LongShortSmocked.InternalMock.mockseedMarketInitiallyToReturn();

      (longShortRef^)
      ->LongShort.Exposed.setInitializeMarketParams(
          ~marketIndex,
          ~marketIndexValue,
          ~latestMarket,
          ~staker=stakerSmockedRef^.address,
          ~longAddress=sampleAddress,
          ~shortAddress=sampleAddress,
        );
    };

    it'(
      "calls all functions (staker.addNewStakingFund, _changeFees, adminOnly, seedMarketInitially) and mutates state (marketExists) correctly",
      () => {
        let%Await _ =
          setup(~marketIndex=1, ~marketIndexValue=false, ~latestMarket=1);
        let%Await _ =
          (longShortRef^)
          ->ContractHelpers.connect(~address=(accounts^)->Array.getUnsafe(0))
          ->LongShort.initializeMarket(
              ~marketIndex=1,
              ~baseEntryFee=Ethers.BigNumber.fromUnsafe("1"),
              ~badLiquidityEntryFee=Ethers.BigNumber.fromUnsafe("2"),
              ~badLiquidityExitFee=Ethers.BigNumber.fromUnsafe("3"),
              ~kPeriod=Ethers.BigNumber.fromUnsafe("4"),
              ~baseExitFee=Ethers.BigNumber.fromUnsafe("5"),
              ~kInitialMultiplier=Ethers.BigNumber.fromUnsafe("6"),
              ~initialMarketSeed=Ethers.BigNumber.fromUnsafe("7"),
            );

        let stakerCalls =
          (stakerSmockedRef^)->StakerSmocked.addNewStakingFundCalls;

        Chai.recordEqualFlatLabeled(
          ~expected=stakerCalls->Array.getExn(0),
          ~actual={
            kInitialMultiplier: Ethers.BigNumber.fromUnsafe("6"),
            marketIndex: 1,
            longToken: sampleAddress,
            shortToken: sampleAddress,
            kPeriod: Ethers.BigNumber.fromUnsafe("4"),
          },
        );

        let changeFeeCalls = LongShortSmocked.InternalMock._changeFeeCalls();

        Chai.recordEqualFlatLabeled(
          ~actual={
            marketIndex: 1,
            _baseEntryFee: Ethers.BigNumber.fromUnsafe("1"),
            _baseExitFee: Ethers.BigNumber.fromUnsafe("5"),
            _badLiquidityEntryFee: Ethers.BigNumber.fromUnsafe("2"),
            _badLiquidityExitFee: Ethers.BigNumber.fromUnsafe("3"),
          },
          ~expected=changeFeeCalls->Array.getExn(0),
        );

        let seedMarketInitiallyCalls =
          LongShortSmocked.InternalMock.seedMarketInitiallyCalls();

        Chai.recordEqualFlatLabeled(
          ~actual={
            marketIndex: 1,
            initialMarketSeed: Ethers.BigNumber.fromUnsafe("7"),
          },
          ~expected=seedMarketInitiallyCalls->Array.getExn(0),
        );

        // No arguments
        let adminOnlyCalls = LongShortSmocked.InternalMock.adminOnlyCalls();

        Chai.intEqual(1, adminOnlyCalls->Array.length);

        let%Await isMarket = (longShortRef^)->LongShort.marketExists(1);

        Chai.boolEqual(isMarket, true);
      },
    );
    it'("reverts if market exists", () => {
      let%Await _ =
        setup(~marketIndex=1, ~marketIndexValue=true, ~latestMarket=1);
      let%Await _ =
        Chai.expectRevertNoReason(
          ~transaction=
            (longShortRef^)
            ->ContractHelpers.connect(
                ~address=(accounts^)->Array.getUnsafe(0),
              )
            ->LongShort.initializeMarket(
                ~marketIndex=1,
                ~baseEntryFee=Ethers.BigNumber.fromUnsafe("1"),
                ~badLiquidityEntryFee=Ethers.BigNumber.fromUnsafe("2"),
                ~badLiquidityExitFee=Ethers.BigNumber.fromUnsafe("3"),
                ~kPeriod=Ethers.BigNumber.fromUnsafe("4"),
                ~baseExitFee=Ethers.BigNumber.fromUnsafe("5"),
                ~kInitialMultiplier=Ethers.BigNumber.fromUnsafe("6"),
                ~initialMarketSeed=Ethers.BigNumber.fromUnsafe("7"),
              ),
        );
      ();
    });
    it'("reverts if market index is greater than latest market index", () => {
      let%Await _ =
        setup(~marketIndex=2, ~marketIndexValue=false, ~latestMarket=1);
      let%Await _ =
        Chai.expectRevertNoReason(
          ~transaction=
            (longShortRef^)
            ->ContractHelpers.connect(
                ~address=(accounts^)->Array.getUnsafe(0),
              )
            ->LongShort.initializeMarket(
                ~marketIndex=1,
                ~baseEntryFee=Ethers.BigNumber.fromUnsafe("1"),
                ~badLiquidityEntryFee=Ethers.BigNumber.fromUnsafe("2"),
                ~badLiquidityExitFee=Ethers.BigNumber.fromUnsafe("3"),
                ~kPeriod=Ethers.BigNumber.fromUnsafe("4"),
                ~baseExitFee=Ethers.BigNumber.fromUnsafe("5"),
                ~kInitialMultiplier=Ethers.BigNumber.fromUnsafe("6"),
                ~initialMarketSeed=Ethers.BigNumber.fromUnsafe("7"),
              ),
        );
      ();
    });
  });
};
