open LetOps;
open Mocha;

describe("YieldManagerAave", () => {
  describe("WithdrawTokens", () => {
    describe("WithdrawWmaticToTreasury mocks", () => {
      let accounts: ref(array(Ethers.Wallet.t)) = ref(None->Obj.magic);
      let contracts = ref(None->Obj.magic);
      let amountOfWMaticInYieldManager = Helpers.randomTokenAmount();

      before_each(() => {
        let%AwaitThen loadedAccounts = Ethers.getSigners();
        accounts := loadedAccounts;

        let admin = loadedAccounts->Array.getUnsafe(0);
        let treasury = loadedAccounts->Array.getUnsafe(1);

        let longShortAddress = Ethers.Wallet.createRandom().address;
        let lendingPoolAddress = Ethers.Wallet.createRandom().address;
        let fundTokenAddress = Ethers.Wallet.createRandom().address;
        let%AwaitThen paymentTokenMock =
          ERC20Mock.make(~name="Payment Token Mock", ~symbol="PaymentToken");
        let paymentTokenAddress = paymentTokenMock.address;

        let%AwaitThen erc20Mock =
          ERC20Mock.make(~name="Test APaymentToken", ~symbol="APaymentToken");
        let%AwaitThen yieldManagerAave =
          YieldManagerAave.make(
            ~admin=admin.address,
            ~longShort=longShortAddress,
            ~treasury=treasury.address,
            ~paymentToken=paymentTokenAddress,
            ~aToken=fundTokenAddress,
            ~lendingPool=lendingPoolAddress,
            ~aaveReferalCode=6543,
          );
        let%Await _ =
          erc20Mock->ERC20Mock.mint(
            ~_to=yieldManagerAave.address,
            ~amount=amountOfWMaticInYieldManager,
          );
        contracts :=
          {"erc20Mock": erc20Mock, "yieldManagerAave": yieldManagerAave};
      });

      it(
        "allows treasury to call 'transfer' function on any erc20 to transfer it to the treasury",
        () => {
          let treasury = (accounts^)->Array.getUnsafe(1);
          let withdrawErc20TokenToTreasuryTxPromise =
            contracts.contents##yieldManagerAave
            ->ContractHelpers.connect(~address=treasury)
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
      it("Should withdraw WMATIC to the treasury", () => {
        JsPromise.resolve()
      });
      it("should revert if not called by treasury", () => {
        JsPromise.resolve()
      });
      it("should revert if trying to withdraw aToken", () =>
        JsPromise.resolve()
      );
    })
  })
});
