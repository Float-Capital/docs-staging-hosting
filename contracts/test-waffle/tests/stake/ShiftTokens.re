open Globals;
open LetOps;
open StakerHelpers;
open Mocha;

let testUnit =
    (
      ~contracts: ref(Helpers.stakerUnitTestContracts),
      ~accounts: ref(array(Ethers.Wallet.t)),
    ) => {
  describe_only("shiftTokens", () => {
    let marketIndex = Helpers.randomJsInteger();
    let synthTokensToShift = Helpers.randomTokenAmount();
    let synthTokensToShiftBeforeValue = Helpers.randomTokenAmount();

    before_once'(() => {
      let {staker, longShortSmocked} = contracts.contents;
      let%Await _ =
        staker->Staker.Exposed.setLongShort(
          ~longShort=longShortSmocked.address,
        );
      contracts.contents.staker
      ->StakerSmocked.InternalMock.setupFunctionForUnitTesting(
          ~functionName="shiftTokens",
        );
    });

    let setup =
        (
          ~isShiftFromLong,
          ~synthTokensToShiftBeforeValue,
          ~synthTokensToShift,
          ~shiftIndex,
          ~nextTokenShiftIndex,
          ~userAmountStaked,
        ) => {
      let user = accounts.contents->Array.getUnsafe(0).address;
      let {staker, syntheticTokenSmocked} = contracts.contents;

      let%Await _ =
        staker->Staker.Exposed.setShiftTokensParams(
          ~marketIndex,
          ~isShiftFromLong,
          ~user,
          ~synthTokensToShift=synthTokensToShiftBeforeValue,
          ~shiftIndex,
          ~nextTokenShiftIndex,
          ~userAmountStaked,
          ~syntheticToken=syntheticTokenSmocked.address,
        );
      staker->Staker.shiftTokens(
        ~synthTokensToShift,
        ~marketIndex,
        ~isShiftFromLong,
      );
    };

    let isShiftFromLong = true;

    it(
      "reverts if market doesn't exist or user doesn't have any staked tokens",
      () => {
      Chai.expectRevert(
        ~transaction=
          contracts.contents.staker
          ->Staker.shiftTokens(
              ~synthTokensToShift,
              ~marketIndex,
              ~isShiftFromLong,
            ),
        ~reason="Not enough tokens to shift",
      )
    });

    it(
      "calls _mintAccumulatedFloat with the correct argumetns if the user has a 'confirmed' shift that needs to be settled",
      () => {
        let user = accounts.contents->Array.getUnsafe(0).address;
        let shiftIndex = Helpers.randomInteger();
        let nextTokenShiftIndex = shiftIndex->add(Helpers.randomInteger());

        let%Await _ =
          setup(
            ~isShiftFromLong,
            ~synthTokensToShiftBeforeValue,
            ~shiftIndex,
            ~nextTokenShiftIndex,
            ~synthTokensToShift,
            ~userAmountStaked=synthTokensToShift,
          );

        let mintAccumulatedFloatCalls =
          StakerSmocked.InternalMock._mintAccumulatedFloatCalls();

        mintAccumulatedFloatCalls->Chai.recordArrayDeepEqualFlat([|
          {marketIndex, user},
        |]);
      },
    );

    it("doesn't call _mintAccumulatedFloat if shiftIndex == 0", () => {
      let nextTokenShiftIndex = Helpers.randomInteger();

      let%Await _ =
        setup(
          ~isShiftFromLong,
          ~synthTokensToShiftBeforeValue,
          ~shiftIndex=zeroBn,
          ~nextTokenShiftIndex,
          ~synthTokensToShift,
          ~userAmountStaked=synthTokensToShift,
        );

      let mintAccumulatedFloatCalls =
        StakerSmocked.InternalMock._mintAccumulatedFloatCalls();

      mintAccumulatedFloatCalls->Chai.recordArrayDeepEqualFlat([||]);
    });
    it(
      "doesn't call _mintAccumulatedFloat if shiftIndex == nextTokenShiftIndex",
      () => {
      let shiftIndex = Helpers.randomInteger();
      let nextTokenShiftIndex = shiftIndex;

      let%Await _ =
        setup(
          ~isShiftFromLong,
          ~synthTokensToShiftBeforeValue,
          ~shiftIndex,
          ~nextTokenShiftIndex,
          ~synthTokensToShift,
          ~userAmountStaked=synthTokensToShift,
        );

      let mintAccumulatedFloatCalls =
        StakerSmocked.InternalMock._mintAccumulatedFloatCalls();

      mintAccumulatedFloatCalls->Chai.recordArrayDeepEqualFlat([||]);
    });

    it(
      "doesn't call _mintAccumulatedFloat if shiftIndex > nextTokenShiftIndex",
      () => {
      let nextTokenShiftIndex = Helpers.randomInteger();
      let shiftIndex = nextTokenShiftIndex->add(Helpers.randomInteger());

      let%Await _ =
        setup(
          ~isShiftFromLong,
          ~synthTokensToShiftBeforeValue,
          ~shiftIndex,
          ~nextTokenShiftIndex,
          ~synthTokensToShift,
          ~userAmountStaked=synthTokensToShift,
        );

      let mintAccumulatedFloatCalls =
        StakerSmocked.InternalMock._mintAccumulatedFloatCalls();

      mintAccumulatedFloatCalls->Chai.recordArrayDeepEqualFlat([||]);
    });

    it("sets the shiftIndex for the user to the nextTokenShiftIndex value", () => {
      let nextTokenShiftIndex = Helpers.randomInteger();
      let user = accounts.contents->Array.getUnsafe(0).address;

      let%Await _ =
        setup(
          ~isShiftFromLong,
          ~synthTokensToShiftBeforeValue,
          ~shiftIndex=zeroBn,
          ~nextTokenShiftIndex,
          ~synthTokensToShift,
          ~userAmountStaked=synthTokensToShift,
        );

      let%Await shiftIndexAfter =
        contracts.contents.staker->Staker.shiftIndex(marketIndex, user);

      Chai.bnEqual(shiftIndexAfter, nextTokenShiftIndex);
    });

    let sideSpecificTests = (~isShiftFromLong) => {
      it(
        "calls the shiftPositionFrom"
        ++ (isShiftFromLong ? "Long" : "Short")
        ++ "NextPrice function on long short with the correct parameters",
        () => {
          let {longShortSmocked} = contracts.contents;
          let nextTokenShiftIndex = Helpers.randomInteger();

          let%Await _ =
            setup(
              ~isShiftFromLong,
              ~synthTokensToShiftBeforeValue,
              ~shiftIndex=zeroBn,
              ~nextTokenShiftIndex,
              ~synthTokensToShift,
              ~userAmountStaked=synthTokensToShift,
            );

          let shiftPositionFromLongNextPriceCalls =
            longShortSmocked->LongShortSmocked.shiftPositionFromLongNextPriceCalls;
          let shiftPositionFromShortNextPriceCalls =
            longShortSmocked->LongShortSmocked.shiftPositionFromShortNextPriceCalls;
          if (isShiftFromLong) {
            shiftPositionFromLongNextPriceCalls->Chai.recordArrayDeepEqualFlat([|
              {marketIndex, synthTokensToShift},
            |]);
            shiftPositionFromShortNextPriceCalls->Chai.recordArrayDeepEqualFlat([||]);
          } else {
            shiftPositionFromLongNextPriceCalls->Chai.recordArrayDeepEqualFlat([||]);
            shiftPositionFromShortNextPriceCalls->Chai.recordArrayDeepEqualFlat([|
              {marketIndex, synthTokensToShift},
            |]);
          };
        },
      );
      it(
        "updates the amountToShiftFrom"
        ++ (isShiftFromLong ? "Long" : "Short")
        ++ "User value with the amount to shift",
        () => {
          let nextTokenShiftIndex = Helpers.randomInteger();
          let user = accounts.contents->Array.getUnsafe(0).address;

          let%Await _ =
            setup(
              ~isShiftFromLong,
              ~synthTokensToShiftBeforeValue,
              ~shiftIndex=zeroBn,
              ~nextTokenShiftIndex,
              ~synthTokensToShift,
              ~userAmountStaked=synthTokensToShift,
            );

          let getTotalAmountToShiftFromSide =
            isShiftFromLong
              ? Staker.amountToShiftFromLongUser
              : Staker.amountToShiftFromShortUser;

          let%Await totalAmountToShiftFromSide =
            contracts.contents.staker
            ->getTotalAmountToShiftFromSide(marketIndex, user);

          Chai.bnEqual(
            totalAmountToShiftFromSide,
            synthTokensToShiftBeforeValue->add(synthTokensToShift),
          );
        },
      );
    };

    describe("Shift from Long", () =>
      sideSpecificTests(~isShiftFromLong=true)
    );

    describe("Shift from Short", () =>
      sideSpecificTests(~isShiftFromLong=false)
    );
  });
};
