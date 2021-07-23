open Mocha;
open LetOps;

let testUnit =
    (
      ~contracts: ref(Contract.YieldManagerAaveHelpers.contractsType),
      ~accounts: ref(array(Ethers.Wallet.t)),
    ) => {
  describe_only("Withdrawing tokens", () => {
    describe("withdrawErc20TokenToTreasuryTxPromise", () => {
      let amountOfWMaticInYieldManager = Helpers.randomTokenAmount();

      let setup = () => {
        let%Await _ =
          (contracts.contents)#erc20Mock
          ->ERC20Mock.mint(
              ~_to=(contracts.contents)#yieldManagerAave.address,
              ~amount=amountOfWMaticInYieldManager,
            );
        ();
      };

      it(
        "allows treasury to call 'transfer' function on any erc20 to transfer it to the treasury",
        () => {
          let%AwaitThen _ = setup();

          let treasury = accounts.contents->Array.getUnsafe(1);

          let withdrawErc20TokenToTreasuryTxPromise =
            (contracts.contents)#yieldManagerAave
            ->ContractHelpers.connect(~address=treasury)
            ->YieldManagerAave.withdrawErc20TokenToTreasury(
                ~erc20Token=(contracts.contents)#erc20Mock.address,
              );
          Chai.callEmitEvents(
            ~call=withdrawErc20TokenToTreasuryTxPromise,
            ~eventName="TransferCalled",
            ~contract=(contracts.contents)#erc20Mock->Obj.magic,
          )
          ->Chai.withArgs3(
              (contracts.contents)#yieldManagerAave.address,
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
  });
};
