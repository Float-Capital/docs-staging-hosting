open Globals;

open LetOps;

describe("Float System", () => {
  describe("Admin", () => {
    let contracts: ref(Helpers.coreContracts) = ref(None->Obj.magic);
    let accounts: ref(array(Ethers.Wallet.t)) = ref(None->Obj.magic);

    before'(() => {
      let%Await loadedAccounts = Ethers.getSigners();
      accounts := loadedAccounts;
    });

    before_each'(() => {
      let%Await deployedContracts =
        Helpers.inititialize(
          ~admin=accounts.contents->Array.getUnsafe(0),
          ~exposeInternals=false,
        );
      contracts := deployedContracts;
    });

    it'("shouldn't allow non admin to update the oracle", () => {
      let newOracleAddress = Ethers.Wallet.createRandom().address;
      let attackerAddress = accounts.contents->Array.getUnsafe(5);

      Chai.expectRevert(
        ~transaction=
          contracts.contents.longShort
          ->Contract.connect(~address=attackerAddress)
          ->Contract.LongShort.updateMarketOracle(
              ~marketIndex=1,
              ~newOracleAddress,
            ),
        ~reason="only admin",
      );
    });
  })
});
