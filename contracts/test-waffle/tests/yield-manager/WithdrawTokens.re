open Globals;
open LetOps;

describe("YieldManagerAave", () => {
  describe("WithdrawTokens", () => {
    describe("WithdrawWmaticToTreasury mocks", () => {
      let accounts: ref(array(Ethers.Wallet.t)) = ref(None->Obj.magic);
      let contracts = ref(None->Obj.magic);
      let amountOfWMaticInYieldManager = Helpers.randomTokenAmount();

      before_each'(() => {
        let%AwaitThen loadedAccounts = Ethers.getSigners();
        accounts := loadedAccounts;

        let admin = loadedAccounts->Array.getUnsafe(0);
        let treasury = loadedAccounts->Array.getUnsafe(1);

        let daiAddress = Ethers.Wallet.createRandom().address;
        let longShortAddress = Ethers.Wallet.createRandom().address;
        let lendingPoolAddress = Ethers.Wallet.createRandom().address;
        let fundTokenAddress = Ethers.Wallet.createRandom().address;

        let%AwaitThen erc20Mock =
          ERC20Mock.make(~name="TestADAI", ~symbol="ADAI");
        let%AwaitThen yieldManagerAave =
          YieldManagerAave.make(
            admin.address,
            longShortAddress,
            treasury.address,
            daiAddress,
            fundTokenAddress,
            lendingPoolAddress,
            6543,
          );
        let%Await _ =
          erc20Mock->ERC20Mock.mint(
            ~user=yieldManagerAave.address,
            ~amount=amountOfWMaticInYieldManager,
          );
        contracts :=
          {"erc20Mock": erc20Mock, "yieldManagerAave": yieldManagerAave};
      });
      it'(
        "allows treasury to call 'transfer' function on any erc20 to transfer it to the treasury",
        () => {
          let treasury = (accounts^)->Array.getUnsafe(1);
          let withdrawErc20TokenToTreasuryTxPromise =
            contracts.contents##yieldManagerAave
            ->Contract.connect(~address=treasury)
            ->YieldManagerAave.withdrawErc20TokenToTreasury(
                ~erc20Token=contracts.contents##erc20Mock.address,
              );
          Chai.callEmitEvents(
            ~call=withdrawErc20TokenToTreasuryTxPromise,
            ~eventName="TransferCalled",
            ~contract=contracts.contents##erc20Mock->Obj.magic,
          )
          ->Chai.withArgs3(
              contracts.contents##yieldManagerAave.address,
              treasury.address,
              amountOfWMaticInYieldManager,
            );
        },
      );
      it'("Should withdraw WMATIC to the treasury", () => {
        JsPromise.resolve()
      });
      it'("should revert if not called by treasury", () => {
        JsPromise.resolve()
      });
      it'("should revert if trying to withdraw aToken", () =>
        JsPromise.resolve()
      );
    })
  })
});
