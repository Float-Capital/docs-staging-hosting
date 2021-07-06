open Globals;
open LetOps;
open Mocha;

let test = (~contracts: ref(Helpers.coreContracts)) =>
  describe("calculateAccumulatedFloat", () => {
    // generate all parameters randomly
    let marketIndex = Js.Math.random_int(1, 100000);
    let longToken = Ethers.Wallet.createRandom().address;
    let shortToken = Ethers.Wallet.createRandom().address;
    let user = Ethers.Wallet.createRandom().address;

    let accumulativeFloatPerTokenUserLong = Helpers.randomTokenAmount();
    let accumulativeFloatPerTokenLatestLong =
      accumulativeFloatPerTokenUserLong->add(Helpers.randomTokenAmount());
    let newUserAmountStakedLong = Helpers.randomTokenAmount();

    let accumulativeFloatPerTokenUserShort = Helpers.randomTokenAmount();
    let accumulativeFloatPerTokenLatestShort =
      accumulativeFloatPerTokenUserShort->add(Helpers.randomTokenAmount());
    let newUserAmountStakedShort = Helpers.randomTokenAmount();

    it(
      "[HAPPY] should correctly return the float tokens due for the user", () => {
      let {staker} = contracts.contents;

      // Value of these two isn't important, as long as `usersLatestClaimedReward` is less than `newLatestRewardIndex`
      let usersLatestClaimedReward = Helpers.randomInteger();
      let newLatestRewardIndex =
        usersLatestClaimedReward->add(Helpers.randomInteger());

      let%AwaitThen _ =
        staker->Staker.Exposed.setFloatRewardCalcParams(
          ~marketIndex,
          ~longToken,
          ~shortToken,
          ~newLatestRewardIndex,
          ~user,
          ~usersLatestClaimedReward,
          ~accumulativeFloatPerTokenLatestLong,
          ~accumulativeFloatPerTokenLatestShort,
          ~accumulativeFloatPerTokenUserLong,
          ~accumulativeFloatPerTokenUserShort,
          ~newUserAmountStakedLong,
          ~newUserAmountStakedShort,
        );
      let%Await floatDue =
        staker->Staker.Exposed.calculateAccumulatedFloatExposedCall(
          ~marketIndex,
          ~user,
        );

      let expectedFloatDueLong =
        accumulativeFloatPerTokenLatestLong
        ->sub(accumulativeFloatPerTokenUserLong)
        ->mul(newUserAmountStakedLong)
        ->div(CONSTANTS.floatIssuanceFixedDecimal);

      Chai.bnEqual(
        floatDue.longFloatReward,
        expectedFloatDueLong,
        ~message="calculated float due is incorrect",
      );

      let expectedFloatDueShort =
        accumulativeFloatPerTokenLatestShort
        ->sub(accumulativeFloatPerTokenUserShort)
        ->mul(newUserAmountStakedShort)
        ->div(CONSTANTS.floatIssuanceFixedDecimal);

      Chai.bnEqual(
        floatDue.longFloatReward,
        expectedFloatDueLong,
        ~message="calculated float due is incorrect",
      );
      Chai.bnEqual(
        floatDue.shortFloatReward,
        expectedFloatDueShort,
        ~message="calculated float due is incorrect",
      );
    });

    it(
      "should return zero if `usersLatestClaimedReward` is equal to `newLatestRewardIndex`",
      () => {
        let {staker} = contracts.contents;

        // exact value doesn't matter, must be equal!
        let newLatestRewardIndex = Helpers.randomInteger();
        let usersLatestClaimedReward = newLatestRewardIndex;

        let%AwaitThen _ =
          staker->Staker.Exposed.setFloatRewardCalcParams(
            ~marketIndex,
            ~longToken,
            ~shortToken,
            ~newLatestRewardIndex,
            ~user,
            ~usersLatestClaimedReward,
            ~accumulativeFloatPerTokenLatestLong,
            ~accumulativeFloatPerTokenLatestShort,
            ~accumulativeFloatPerTokenUserLong,
            ~accumulativeFloatPerTokenUserShort,
            ~newUserAmountStakedLong,
            ~newUserAmountStakedShort,
          );
        let%Await floatDue =
          staker->Staker.Exposed.calculateAccumulatedFloatExposedCall(
            ~marketIndex,
            ~user,
          );

        Chai.bnEqual(
          floatDue.longFloatReward,
          bnFromInt(0),
          ~message="calculated float (long) due should be zero",
        );
        Chai.bnEqual(
          floatDue.shortFloatReward,
          bnFromInt(0),
          ~message="calculated float (short) due should be zero",
        );
      },
    );

    it(
      "should throw (assert) if `usersLatestClaimedReward` is bigger than `newLatestRewardIndex`",
      () => {
        let {staker} = contracts.contents;
        // exact value doesn't matter, must be zero!
        let usersLatestClaimedReward = Helpers.randomInteger();
        let newLatestRewardIndex =
          usersLatestClaimedReward->sub(bnFromInt(1));

        let%AwaitThen _ =
          staker->Staker.Exposed.setFloatRewardCalcParams(
            ~marketIndex,
            ~longToken,
            ~shortToken,
            ~newLatestRewardIndex,
            ~user,
            ~usersLatestClaimedReward,
            ~accumulativeFloatPerTokenLatestLong,
            ~accumulativeFloatPerTokenLatestShort,
            ~accumulativeFloatPerTokenUserLong,
            ~accumulativeFloatPerTokenUserShort,
            ~newUserAmountStakedLong,
            ~newUserAmountStakedShort,
          );
        Chai.expectRevertNoReason(
          ~transaction=
            staker->Staker.Exposed.calculateAccumulatedFloatExposed(
              ~marketIndex,
              ~user,
            ),
        );
      },
    );

    it(
      "If the user has zero tokens staked they should get zero float tokens",
      () => {
      let {staker} = contracts.contents;
      // Value of these two isn't important, as long as `usersLatestClaimedReward` is less than `newLatestRewardIndex`
      let usersLatestClaimedReward = Helpers.randomInteger();
      let newLatestRewardIndex =
        usersLatestClaimedReward->add(Helpers.randomInteger());

      let%AwaitThen _ =
        staker->Staker.Exposed.setFloatRewardCalcParams(
          ~marketIndex,
          ~longToken,
          ~shortToken,
          ~newLatestRewardIndex,
          ~user,
          ~usersLatestClaimedReward,
          ~accumulativeFloatPerTokenLatestLong,
          ~accumulativeFloatPerTokenLatestShort,
          ~accumulativeFloatPerTokenUserLong,
          ~accumulativeFloatPerTokenUserShort,
          ~newUserAmountStakedLong=Ethers.BigNumber.fromInt(0),
          ~newUserAmountStakedShort=Ethers.BigNumber.fromInt(0),
        );
      let%Await floatDue =
        staker->Staker.Exposed.calculateAccumulatedFloatExposedCall(
          ~marketIndex,
          ~user,
        );
      Chai.bnEqual(
        floatDue.longFloatReward,
        bnFromInt(0),
        ~message="calculated float (long) due should be zero",
      );
      Chai.bnEqual(
        floatDue.shortFloatReward,
        bnFromInt(0),
        ~message="calculated float (short) due should be zero",
      );
    });
  });
