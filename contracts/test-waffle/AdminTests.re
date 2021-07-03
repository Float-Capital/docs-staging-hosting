open LetOps;
open Mocha;
open Globals;

// These tests can be considered both integration and unit tests for sake of coverage
describe("Float System", () => {
  describeBoth("Admin", () => {
    let contracts: ref(Helpers.coreContracts) = ref(None->Obj.magic);
    let accounts: ref(array(Ethers.Wallet.t)) = ref(None->Obj.magic);

    before(() => {
      let%Await loadedAccounts = Ethers.getSigners();
      accounts := loadedAccounts;

      let%Await deployedContracts =
        Helpers.inititialize(
          ~admin=accounts.contents->Array.getUnsafe(0),
          ~exposeInternals=false,
        );
      contracts := deployedContracts;
    });

    describe("updateMarketOracle", () => {
      let newOracleManager = Ethers.Wallet.createRandom().address;
      let marketIndex = 1;
      it("should allow admin to update the oracle", () => {
        let%Await originalOracleAddress =
          contracts.contents.longShort->LongShort.oracleManagers(marketIndex);
        let%Await _ =
          contracts.contents.longShort
          ->LongShort.updateMarketOracle(~marketIndex, ~newOracleManager);
        let%Await updatedOracleAddress =
          contracts.contents.longShort->LongShort.oracleManagers(marketIndex);

        Chai.addressEqual(
          ~otherAddress=updatedOracleAddress,
          newOracleManager,
        );

        // Reset for the next tests
        let%Await _ =
          contracts.contents.longShort
          ->LongShort.updateMarketOracle(
              ~marketIndex,
              ~newOracleManager=originalOracleAddress,
            );
        ();
      });

      it("shouldn't allow non admin to update the oracle", () => {
        let attackerAddress = accounts.contents->Array.getUnsafe(5);

        Chai.expectRevert(
          ~transaction=
            contracts.contents.longShort
            ->ContractHelpers.connect(~address=attackerAddress)
            ->LongShort.updateMarketOracle(~marketIndex, ~newOracleManager),
          ~reason="only admin",
        );
      });
    });

    describe("changeAdmin", () => {
      it("should allow admin to update the admin address", () => {
        let originalAdminAddress =
          accounts.contents->Array.getUnsafe(0).address;
        let newAdmin = accounts.contents->Array.getUnsafe(5);
        let newAdminAddress = newAdmin.address;

        let%Await _ =
          contracts.contents.longShort
          ->LongShort.changeAdmin(~admin=newAdminAddress);

        let%Await adminFromContract =
          contracts.contents.longShort->LongShort.admin;

        Chai.addressEqual(
          ~message="Admin should be updated by 'changeAdmin' function",
          ~otherAddress=adminFromContract,
          newAdminAddress,
        );

        let%Await _ =
          contracts.contents.longShort
          ->ContractHelpers.connect(~address=newAdmin)
          ->LongShort.changeAdmin(~admin=originalAdminAddress);
        ();
      });

      it("shouldn't allow non admin to update the Admin", () => {
        let attackerAddress = accounts.contents->Array.getUnsafe(5);
        let newAdminAddress = accounts.contents->Array.getUnsafe(6).address;

        Chai.expectRevert(
          ~transaction=
            contracts.contents.longShort
            ->ContractHelpers.connect(~address=attackerAddress)
            ->LongShort.changeAdmin(~admin=newAdminAddress),
          ~reason="only admin",
        );
      });
    });
    describe("changeTreasury", () => {
      let newTreasuryAddress = Ethers.Wallet.createRandom().address;

      it("should allow admin to update the treasury address", () => {
        let%Await _ =
          contracts.contents.longShort
          ->LongShort.changeTreasury(~treasury=newTreasuryAddress);

        let%Await treasuryFromContract =
          contracts.contents.longShort->LongShort.treasury;

        Chai.addressEqual(
          ~otherAddress=treasuryFromContract,
          newTreasuryAddress,
        );
      });

      it("shouldn't allow non admin to update the treasury address", () => {
        let attackerAddress = accounts.contents->Array.getUnsafe(5);

        Chai.expectRevert(
          ~transaction=
            contracts.contents.longShort
            ->ContractHelpers.connect(~address=attackerAddress)
            ->LongShort.changeTreasury(~treasury=newTreasuryAddress),
          ~reason="only admin",
        );
      });
    });
  })
});
