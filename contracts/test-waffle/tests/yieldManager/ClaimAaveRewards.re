open Globals;
open Mocha;
open LetOps;

let testUnit =
    (~contracts: ref(Contract.YieldManagerAaveHelpers.contractsType)) => {
  describe_only("Claiming Aave reward tokens", () => {
    describe("claimAaveRewardsToTreasuryTxPromise", () => {
      let claimAaveRewardsToTreasuryTxPromise = ref("NotSetYet"->Obj.magic);
      let randomRewardAmount = Helpers.randomTokenAmount();

      before_once'(() => {
        let aaveIncentivesControllerSmockedContract =
          (contracts.contents)#aaveIncentivesController;

        let treasury = (contracts.contents)#treasury;

        aaveIncentivesControllerSmockedContract->AaveIncentivesControllerMockSmocked.mockGetUserUnclaimedRewardsToReturn(
          randomRewardAmount,
        );

        aaveIncentivesControllerSmockedContract->AaveIncentivesControllerMockSmocked.mockClaimRewardsToReturn(
          randomRewardAmount,
        );

        claimAaveRewardsToTreasuryTxPromise :=
          (contracts.contents)#yieldManagerAave
          ->ContractHelpers.connect(~address=treasury)
          ->YieldManagerAave.claimAaveRewardsToTreasury;

        claimAaveRewardsToTreasuryTxPromise.contents;
      });
      it("Calls the ClaimAaveRewardTokenToTreasury event", () => {
        Chai.callEmitEvents(
          ~call=claimAaveRewardsToTreasuryTxPromise.contents,
          ~contract=(contracts.contents)#yieldManagerAave->Obj.magic,
          ~eventName="ClaimAaveRewardTokenToTreasury",
        )
        ->Chai.withArgs1(randomRewardAmount)
      });
      it(
        "it calls claimRewards with the correct parameters on the AaveIncentiveController",
        () => {
          let%Await _ = claimAaveRewardsToTreasuryTxPromise.contents;

          let aaveIncentivesControllerSmockedContract =
            (contracts.contents)#aaveIncentivesController;

          aaveIncentivesControllerSmockedContract
          ->AaveIncentivesControllerMockSmocked.getUserUnclaimedRewardsCalls
          ->Chai.recordArrayDeepEqualFlat([|
              {user: (contracts.contents)#yieldManagerAave.address},
            |]);
        },
      );
      it(
        "it calls claimRewards with the correct parameters on the AaveIncentiveController",
        () => {
          let%Await _ = claimAaveRewardsToTreasuryTxPromise.contents;

          let aaveIncentivesControllerSmockedContract =
            (contracts.contents)#aaveIncentivesController;

          let treasury = (contracts.contents)#treasury;

          aaveIncentivesControllerSmockedContract
          ->AaveIncentivesControllerMockSmocked.claimRewardsCalls
          ->Chai.recordArrayDeepEqualFlat([|
              {
                assets: [|(contracts.contents)#paymentToken.address|],
                amount: randomRewardAmount,
                _to: treasury.address,
              },
            |]);
        },
      );
    })
  });
};
