open BsMocha;
let (it', it_skip', before_each, before) =
  Promise.(it, it_skip, before_each, before);

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

    it'("should update correct markets in the 'claimFloatCustom' function", () => {
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
        staker->Contract.Staker.claimFloatCustomUser(
          ~user=testUser,
          ~markets=marketsUserHasStakedIn,
        );

      let%Await _ =
        marketsUserHasStakedIn
        ->Array.map(market => {
            JsPromise.all2((
              staker->Contract.Staker.userIndexOfLastClaimedReward(
                ~market,
                ~user=testUser.address,
              ),
              staker->Contract.Staker.latestRewardIndex(~market),
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
