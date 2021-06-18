open LetOps;
open Mocha;

describe("Float System", () => {
  describe("Staking", () => {
    let contracts: ref(Helpers.coreContracts) = ref(None->Obj.magic);
    let accounts: ref(array(Ethers.Wallet.t)) = ref(None->Obj.magic);

    before(() => {
      let%Await loadedAccounts = Ethers.getSigners();
      accounts := loadedAccounts;
    });

    before_each(() => {
      let%AwaitThen deployedContracts =
        Helpers.inititialize(
          ~admin=accounts.contents->Array.getUnsafe(0),
          ~exposeInternals=false,
        );
      contracts := deployedContracts;
      let setupUser = accounts.contents->Array.getUnsafe(2);

      let%Await _ =
        HelperActions.stakeRandomlyInBothSidesOfMarket(
          ~marketsToStakeIn=deployedContracts.markets,
          ~userToStakeWith=setupUser,
          ~longShort=deployedContracts.longShort,
        );
      ();
    });

    it("should update correct markets in the 'claimFloatCustom' function", () => {
      let {longShort, markets, staker} = contracts.contents;
      let testUser = accounts.contents->Array.getUnsafe(1);

      let%Await (_synthsUserHasStakedIn, marketsUserHasStakedIn) =
        HelperActions.stakeRandomlyInMarkets(
          ~marketsToStakeIn=markets,
          ~userToStakeWith=testUser,
          ~longShort,
        );

      let%Await _ = Helpers.increaseTime(50);

      let%Await _ =
        staker
        ->ContractHelpers.connect(~address=testUser)
        ->Staker.claimFloatCustom(~marketIndexes=marketsUserHasStakedIn);

      let%Await _ =
        marketsUserHasStakedIn
        ->Array.map(market => {
            JsPromise.all2((
              staker->Staker.userIndexOfLastClaimedReward(
                market,
                testUser.address,
              ),
              staker->Staker.latestRewardIndex(market),
            ))
            ->JsPromise.map(((userLastClaimed, latestRewardIndex)) => {
                Chai.bnEqual(userLastClaimed, latestRewardIndex)
              })
          })
        ->JsPromise.all;
      ();
    });
  })
});
