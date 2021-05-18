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
      let%Await deployedContracts =
        Helpers.inititialize(~admin=accounts.contents->Array.getUnsafe(0));
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
  })
});
