open LetOps;
open Globals;
open Mocha;

describe("Float System", () => {
  describeIntegration("LongShort", () => {
    let contracts: ref(Helpers.coreContracts) = ref(None->Obj.magic);
    let accounts: ref(array(Ethers.Wallet.t)) = ref(None->Obj.magic);

    before_each(() => {
      let%Await loadedAccounts = Ethers.getSigners();
      accounts := loadedAccounts;
      // });

      // before_each(() => {
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

    LazyDeposit.testIntegration(~contracts, ~accounts);
    LazyRedeem.testIntegration(~contracts, ~accounts);
  });

  describeUnit("LongShort - internals exposed", () => {
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
          ~exposeInternals=true,
        );
      contracts := deployedContracts;
      let firstMarketPaymentToken =
        deployedContracts.markets->Array.getUnsafe(1).paymentToken;

      let testUser = accounts.contents->Array.getUnsafe(1);

      let%Await _ =
        firstMarketPaymentToken->Contract.PaymentTokenHelpers.mintAndApprove(
          ~user=testUser,
          ~spender=deployedContracts.longShort.address,
          ~amount=Ethers.BigNumber.fromUnsafe("10000000000000000000000"),
        );
      ();
    });
    InitializeMarket.test(~contracts, ~accounts);
  });
});
