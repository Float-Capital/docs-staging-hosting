open Mocha;
open LetOps;

let testUnit =
    (
      ~contracts: ref(Helpers.coreContracts),
      ~accounts: ref(array(Ethers.Wallet.t)),
    ) => {
  describe("depositing funds", () => {
    let amount = Helpers.randomTokenAmount();
    let marketIndex = 1;

    describe("_depositFunds", () => {
      let paymentTokenSmocked = ref(ERC20MockSmocked.uninitializedValue);

      let setup = (~testWallet: Ethers.walletType) => {
        let {paymentToken} = contracts.contents.markets->Array.getUnsafe(0);

        let%Await _ =
          contracts.contents.longShort
          ->LongShortSmocked.InternalMock.setupFunctionForUnitTesting(
              ~functionName="_depositFunds",
            );

        let%AwaitThen smockedPaymentToken =
          ERC20MockSmocked.make(paymentToken);
        smockedPaymentToken->ERC20MockSmocked.mockTransferFromToReturn(true);
        paymentTokenSmocked := smockedPaymentToken;

        let%AwaitThen _ =
          contracts.contents.longShort
          ->LongShort.Exposed.setDepositFundsGlobals(
              ~marketIndex,
              ~paymentToken=smockedPaymentToken.address,
            );

        let longShort =
          contracts.contents.longShort
          ->ContractHelpers.connect(~address=testWallet);

        longShort->LongShort.Exposed._depositFundsExposed(
          ~marketIndex,
          ~amount,
        );
      };

      it("calls paymentToken.transferFrom with correct arguments", () => {
        let testWallet = accounts.contents->Array.getUnsafe(1);
        let%Await _ = setup(~testWallet);

        let transferFromCalls =
          paymentTokenSmocked.contents->ERC20MockSmocked.transferFromCalls;

        transferFromCalls->Chai.recordArrayDeepEqualFlat([|
          {
            sender: testWallet.address,
            recipient: contracts.contents.longShort.address,
            amount,
          },
        |]);
      });
    });
  });
};
