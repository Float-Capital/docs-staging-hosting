open BsMocha;
let (it', it_skip', before_each, before) =
  Promise.(it, it_skip, before_each, before);

let (add, sub, bnFromInt, mul, div) =
  Ethers.BigNumber.(add, sub, fromInt, mul, div);
let (describe, it, it_skip) = Mocha.(describe, it, it_skip);
open LetOps;

describe("Float System", () => {
  describe("Staking", () => {
    let contracts: ref(Helpers.coreContracts) = ref(None->Obj.magic);
    let accounts: ref(array(Ethers.Wallet.t)) = ref(None->Obj.magic);

    before(() => {
      let%Await loadedAccounts = Ethers.getSigners();
      accounts := loadedAccounts;
    });

    before_each(() => {
      let%Await deployedContracts =
        Helpers.inititialize(
          ~admin=accounts.contents->Array.getUnsafe(0),
          ~exposeInternals=false,
        );
      contracts := deployedContracts;
    });

    it'(
      "should correctly be able to stake their long/short tokens and view their staked amount immediately",
      () => {
        let {longShort, markets, staker} = contracts.contents;
        let testUser = accounts.contents->Array.getUnsafe(1);

        let%Await (synthsUserHasStakedIn, _marketsUserHasStakedIn) =
          HelperActions.stakeRandomlyInMarkets(
            ~marketsToStakeIn=markets,
            ~userToStakeWith=testUser,
            ~longShort,
          );

        let%Await _ =
          synthsUserHasStakedIn
          ->Array.map(stake => {
              let%Await amountStaked =
                staker->Contract.Staker.userAmountStaked(
                  ~syntheticToken=stake##synth.address,
                  ~user=testUser.address,
                );
              Chai.bnEqual(amountStaked, stake##amount);
            })
          ->JsPromise.all;
        ();
      },
    );
  });
  describe("Staking - internals exposed", () => {
    let contracts: ref(Helpers.coreContracts) = ref(None->Obj.magic);
    let accounts: ref(array(Ethers.Wallet.t)) = ref(None->Obj.magic);

    before(() => {
      let%Await loadedAccounts = Ethers.getSigners();
      accounts := loadedAccounts;
    });

    before_each(() => {
      let%Await deployedContracts =
        Helpers.inititialize(
          ~admin=accounts.contents->Array.getUnsafe(0),
          ~exposeInternals=true,
        );
      contracts := deployedContracts;
    });

    describe("calculateAccumulatedFloat", () => {
      // generate all parameters randomly
      let token = Ethers.Wallet.createRandom().address;
      let user = Ethers.Wallet.createRandom().address;

      let accumulativeFloatPerTokenUser = Helpers.randomTokenAmount();
      let accumulativeFloatPerTokenLatest =
        accumulativeFloatPerTokenUser->add(Helpers.randomTokenAmount());
      let newUserAmountStaked = Helpers.randomTokenAmount();

      it'(
        "[HAPPY] should correctly return the float tokens due for the user", () => {
        let {staker} = contracts.contents;

        // Value of these two isn't important, as long as `usersLatestClaimedReward` is less than `newLatestRewardIndex`
        let usersLatestClaimedReward = Helpers.randomInteger();
        let newLatestRewardIndex =
          usersLatestClaimedReward->add(Helpers.randomInteger());

        let%AwaitThen _ =
          staker->Contract.Staker.Exposed.setFloatRewardCalcParams(
            ~token,
            ~newLatestRewardIndex,
            ~user,
            ~usersLatestClaimedReward,
            ~accumulativeFloatPerTokenLatest,
            ~accumulativeFloatPerTokenUser,
            ~newUserAmountStaked,
          );
        let%Await floatDue =
          staker->Contract.Staker.Exposed.calculateAccumulatedFloatExposedCall(
            ~token,
            ~user,
          );

        let expectedFloatDue =
          accumulativeFloatPerTokenLatest
          ->sub(accumulativeFloatPerTokenUser)
          ->mul(newUserAmountStaked)
          ->div(CONSTANTS.floatIssuanceFixedDecimal);

        Chai.bnEqual(
          floatDue,
          expectedFloatDue,
          ~message="calculated float due is incorrect",
        );
      });

      it'(
        "should return zero if `usersLatestClaimedReward` is equal to `newLatestRewardIndex`",
        () => {
          let {staker} = contracts.contents;

          // exact value doesn't matter, must be equal!
          let newLatestRewardIndex = Helpers.randomInteger();
          let usersLatestClaimedReward = newLatestRewardIndex;

          let%AwaitThen _ =
            staker->Contract.Staker.Exposed.setFloatRewardCalcParams(
              ~token,
              ~newLatestRewardIndex,
              ~user,
              ~usersLatestClaimedReward,
              ~accumulativeFloatPerTokenLatest,
              ~accumulativeFloatPerTokenUser,
              ~newUserAmountStaked,
            );
          let%Await floatDue =
            staker->Contract.Staker.Exposed.calculateAccumulatedFloatExposedCall(
              ~token,
              ~user,
            );

          Chai.bnEqual(
            floatDue,
            bnFromInt(0),
            ~message="calculated float due should be zero",
          );
        },
      );

      it'(
        "should throw (assert) if `usersLatestClaimedReward` is bigger than `newLatestRewardIndex`",
        () => {
          let {staker} = contracts.contents;
          // exact value doesn't matter, must be zero!
          let usersLatestClaimedReward = Helpers.randomInteger();
          let newLatestRewardIndex =
            usersLatestClaimedReward->sub(bnFromInt(1));

          let%AwaitThen _ =
            staker->Contract.Staker.Exposed.setFloatRewardCalcParams(
              ~token,
              ~newLatestRewardIndex,
              ~user,
              ~usersLatestClaimedReward,
              ~accumulativeFloatPerTokenLatest,
              ~accumulativeFloatPerTokenUser,
              ~newUserAmountStaked,
            );
          Chai.expectRevertNoReason(
            ~transaction=
              staker->Contract.Staker.Exposed.calculateAccumulatedFloatExposed(
                ~token,
                ~user,
              ),
          );
        },
      );
    });
  });
});
