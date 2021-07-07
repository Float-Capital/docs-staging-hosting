open Globals;
open LetOps;
open StakerHelpers;
open Mocha;

let test =
    (
      ~contracts: ref(Helpers.coreContracts),
      ~accounts: ref(array(Ethers.Wallet.t)),
    ) => {
  describe("_stake", () => {
    let stakerRef: ref(Staker.t) = ref(None->Obj.magic);

    let token = Helpers.randomAddress();
    let (userAmountStaked, userAmountToStake) =
      Helpers.Tuple.make2(Helpers.randomTokenAmount); // will be at least two

    let user = Helpers.randomAddress();

    let marketIndex = Helpers.randomJsInteger();

    let promiseRef: ref(JsPromise.t(ContractHelpers.transaction)) =
      ref(None->Obj.magic);

    let setup = (~userLastRewardIndex, ~latestRewardIndex) => {
      let%Await _ =
        stakerRef->deployAndSetupStakerToUnitTest(
          ~functionName="_stake",
          ~contracts,
          ~accounts,
        );
      StakerSmocked.InternalMock.mockMintAccumulatedFloatToReturn();

      let%AwaitThen _ =
        (stakerRef^)
        ->Staker.Exposed.set_stakeParams(
            ~user,
            ~marketIndex,
            ~latestRewardIndex,
            ~token,
            ~userAmountStaked,
            ~userLastRewardIndex,
          );
      let promise =
        (stakerRef^)
        ->Staker.Exposed._stakeExternal(
            ~user,
            ~token,
            ~amount=userAmountToStake,
          );
      promiseRef := promise;
      promise;
    };

    describe("case user has outstanding float to be minted", () => {
      let latestRewardIndex =
        Js.Math.random_int(2, Js.Int.max)->Ethers.BigNumber.fromInt;
      let randomRewardIndexBelow = num =>
        Js.Math.random_int(1, num->Ethers.BigNumber.toNumber)
        ->Ethers.BigNumber.fromInt;

      before_once'(() =>
        setup(
          ~userLastRewardIndex=randomRewardIndexBelow(latestRewardIndex),
          ~latestRewardIndex,
        )
      );

      it("calls mintAccumulatedFloat with correct args", () => {
        StakerSmocked.InternalMock.mintAccumulatedFloatCalls()
        ->Array.getExn(0)
        ->Chai.recordEqualFlat({marketIndex, user})
      });
      it("mutates userAmountStaked", () => {
        let%Await amountStaked =
          (stakerRef^)->Staker.userAmountStaked(token, user);
        amountStaked->Chai.bnEqual(
          userAmountStaked->Ethers.BigNumber.add(userAmountToStake),
        );
      });

      it("mutates userIndexOfLastClaimedReward", () => {
        let%Await lastClaimedReward =
          (stakerRef^)
          ->Staker.userIndexOfLastClaimedReward(marketIndex, user);

        lastClaimedReward->Chai.bnEqual(latestRewardIndex);
      });

      it("emits StakeAdded", () =>
        Chai.callEmitEvents(
          ~call=promiseRef^,
          ~contract=(stakerRef^)->Obj.magic,
          ~eventName="StakeAdded",
        )
        ->Chai.withArgs4(user, token, userAmountToStake, latestRewardIndex)
      );
    });

    // next two cases still do everything except call mintFloat but unwieldy to test
    describe("case user has last claimed index of 0", () => {
      before_once'(() =>
        setup(
          ~userLastRewardIndex=CONSTANTS.zeroBn,
          ~latestRewardIndex=Helpers.randomInteger(),
        )
      );

      it("doesn't call mintAccumulatedFloat", () => {
        StakerSmocked.InternalMock.mintAccumulatedFloatCalls()
        ->Array.length
        ->Chai.intEqual(0)
      });
    });

    describe(
      "case users last claimed index == latestRewardIndex for market", () => {
      let index = Helpers.randomInteger();
      before_once'(() =>
        setup(~userLastRewardIndex=index, ~latestRewardIndex=index)
      );

      it("doesn't call mintAccumulatedFloat", () => {
        StakerSmocked.InternalMock.mintAccumulatedFloatCalls()
        ->Array.length
        ->Chai.intEqual(0)
      });
    });
  });
};
