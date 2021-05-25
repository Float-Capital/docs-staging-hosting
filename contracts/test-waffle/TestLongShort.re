open BsMocha;
let (it', it_skip', before_each, before) =
  Promise.(it, it_skip, before_each, before);

let (describe, it, it_skip) = Mocha.(describe, it, it_skip);
open LetOps;

describe("Float System", () => {
  describe("LongShort", () => {
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

    describe("_updateSystemState", () => {
      // TODOs:
      // Check it reverts if oracle returns a negative value.
      ()
    });

    describe("LongShort - internals exposed", () => {
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

      LazyDeposit.testExposed(~contracts, ~accounts);
    });
  })
});
