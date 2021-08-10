open Mocha;

let testUnit =
    (
      ~contracts: ref(Helpers.coreContracts),
      ~accounts: ref(array(Ethers.Wallet.t)),
    ) => {
  describe("Staker Modifiers", () => {
    describe("onlyAdminModifierLogic", () => {
      it("reverts if caller is non-admin", () => {
        let nonAdminWallet = accounts.contents->Array.getUnsafe(1);

        Chai.expectRevert(
          ~transaction=
            contracts.contents.staker
            ->ContractHelpers.connect(~address=nonAdminWallet)
            ->Staker.Exposed.onlyAdminModifierLogicExposed,
          ~reason="not admin",
        );
      })
    });

    describe("onlyValidSyntheticModifierLogic", () => {
      it("reverts if synth invalid (i.e. has yet to be assigned an index)", () => {
        let randomWallet = accounts.contents->Array.getUnsafe(2);
        let synthAddress = Helpers.randomAddress();

        Chai.expectRevert(
          ~transaction=
            contracts.contents.staker
            ->ContractHelpers.connect(~address=randomWallet)
            ->Staker.Exposed.onlyValidSyntheticModifierLogicExposed(
                ~synth=synthAddress,
              ),
          ~reason="not valid synth",
        );
      })
    });

    describe("onlyValidMarketModifierLogic", () => {
      it("reverts if market invalid (i.e. still has the zero address)", () => {
        let randomWallet = accounts.contents->Array.getUnsafe(2);

        Chai.expectRevert(
          ~transaction=
            contracts.contents.staker
            ->ContractHelpers.connect(~address=randomWallet)
            ->Staker.Exposed.onlyValidMarketModifierLogicExposed(
                ~marketIndex=0,
              ),
          ~reason="not valid market",
        );
      })
    });

    describe("onlyLongShortModifierLogic", () => {
      it("reverts if caller is not LongShort", () => {
        let randomWallet = accounts.contents->Array.getUnsafe(3);

        Chai.expectRevert(
          ~transaction=
            contracts.contents.staker
            ->ContractHelpers.connect(~address=randomWallet)
            ->Staker.Exposed.onlyLongShortModifierLogicExposed,
          ~reason="not LongShort",
        );
      })
    });
  });
};
