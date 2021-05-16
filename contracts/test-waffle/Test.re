// let {it: it', it_skip: it_skip', before_each, before} = module(BsMocha.Async)
// let {describe, it, it_skip} = module(BsMocha.Mocha)
open BsMocha;
let (it', it_skip', before_each, before) =
  Promise.(it, it_skip, before_each, before);
// let (it', it_skip', before_each, before) =
//   Async.(it, it_skip, before_each, before);
let (describe, it, it_skip) = Mocha.(describe, it, it_skip);
open LetOps;

describe("Float System", () => {
  describe("Staking", () => {
    let contracts: ref(Helpers.coreContracts) = ref(None->Obj.magic);
    let accounts: ref(array(Ethers.Wallet.t)) = ref(None->Obj.magic);

    before(() => {
      Ethers.getSigners()
      ->JsPromise.map(loadedAccounts => {accounts := loadedAccounts})
    });
    before_each(() => {
      Helpers.inititialize(~admin=accounts.contents->Array.getUnsafe(0))
      ->JsPromise.map(deployedContracts => {contracts := deployedContracts})
    });
    it'("should update correct markets in the 'claimFloatCustom' function", () => {
      let {longShort, markets, staker} = contracts.contents;
      let testUser = accounts.contents->Array.getUnsafe(1);

      let%Await (synthsUserHasStakedIn, marketsUserHasStakedIn) =
        HelperActions.stakeRandomlyInMarkets(
          ~marketsToStakeIn=markets,
          ~userToStakeWith=testUser,
          ~longShort,
        );

      let%Await _ = Helpers.increaseTime(50);

      Js.log({
        "marketsUserHasStakedIn": marketsUserHasStakedIn,
        "synthsUserHasStakedIn":
          synthsUserHasStakedIn->Array.map(synth => synth.address),
      });
      let%Await _ =
        staker->Contract.Staker.claimFloatCustomUser(
          ~user=testUser,
          ~syntheticTokens=synthsUserHasStakedIn,
          ~markets=marketsUserHasStakedIn,
        );

      let%Await _ =
        synthsUserHasStakedIn
        ->Array.map(synth => {
            JsPromise.all2((
              staker->Contract.Staker.userIndexOfLastClaimedReward(
                ~synthTokenAddr=synth.address,
                ~user=testUser.address,
              ),
              staker->Contract.Staker.latestRewardIndex(
                ~synthTokenAddr=synth.address,
              ),
            ))
            ->JsPromise.map(((userLastClaimed, latestRewardIndex)) => {
                // These values should be equal but they are not - investigate
                Chai.bnEqual(
                  userLastClaimed,
                  latestRewardIndex,
                )
              })
          })
        ->JsPromise.all;
      ();
    });
  })
});
