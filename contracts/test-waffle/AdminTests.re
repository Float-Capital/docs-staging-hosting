open BsMocha;
let (it', it_skip', before_each, before) =
  Promise.(it, it_skip, before_each, before);
let (describe, it, it_skip) = Mocha.(describe, it, it_skip);
describe("Float System", () => {
  describe("Admin", () => {
    let contracts: ref(Helpers.coreContracts) = ref(None->Obj.magic);
    let accounts: ref(array(Ethers.Wallet.t)) = ref(None->Obj.magic);
    ();
    before(() => {
      Ethers.getSigners()
      ->JsPromise.map(loadedAccounts => {accounts := loadedAccounts})
    });
    before_each(() => {
      Helpers.inititialize(~admin=accounts.contents->Array.getUnsafe(0))
      ->JsPromise.map(deployedContracts => {contracts := deployedContracts})
    });
    it'("shouldn't allow non admin to update the oracle", () => {
      let newOracleAddress = Ethers.Wallet.createRandom().address;
      Chai.expectRevert(
        ~transaction=
          contracts^.longShort
          ->Contract.connect(~address=(accounts^)->Array.getUnsafe(5))
          ->Contract.LongShort.updateMarketOracle(
              ~marketIndex=1,
              ~newOracleAddress,
            ),
        ~reason="only admin",
      );
    });
  })
});
