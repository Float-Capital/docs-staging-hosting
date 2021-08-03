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

    describe("_pullPaymentTokensFromUserToLongShort", () => {
      let paymentTokenSmocked = ref(ERC20MockSmocked.uninitializedValue);

      let setup = (~testWallet: Ethers.walletType) => {
        let {paymentToken} = contracts.contents.markets->Array.getUnsafe(0);

        let%Await _ =
          contracts.contents.longShort
          ->LongShortSmocked.InternalMock.setupFunctionForUnitTesting(
              ~functionName="_pullPaymentTokensFromUserToLongShort",
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

        longShort->LongShort.Exposed._pullPaymentTokensFromUserToLongShortExposed(
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

    describe("_lockFundsInMarket", () => {
      let yieldManagerRef = ref("Not Set Yet"->Obj.magic);

      before_each(() => {
        let%Await _ =
          contracts.contents.longShort
          ->LongShortSmocked.InternalMock.setupFunctionForUnitTesting(
              ~functionName="_lockFundsInMarket",
            );

        let {longShort, markets} = contracts.contents;
        let {yieldManager} = markets->Array.getUnsafe(0);

        let%Await smockedYieldManager =
          YieldManagerMockSmocked.make(yieldManager);

        yieldManagerRef := smockedYieldManager;

        let _ =
          smockedYieldManager->YieldManagerMockSmocked.mockDepositPaymentTokenToReturn;
        let%Await _ =
          longShort->LongShort.Exposed.setLockFundsInMarketGlobals(
            ~marketIndex,
            ~yieldManager=smockedYieldManager.address,
          );

        contracts.contents.longShort
        ->LongShort.Exposed._lockFundsInMarketExposed(~marketIndex, ~amount);
      });

      it(
        "calls _pullPaymentTokensFromUserToLongShort with correct arguments",
        () => {
        let depositFundsCalls =
          LongShortSmocked.InternalMock._pullPaymentTokensFromUserToLongShortCalls();

        depositFundsCalls->Chai.recordArrayDeepEqualFlat([|
          {marketIndex, amount},
        |]);
      });

      it("calls YieldManager.depositPaymentToken with correct arguments", () => {
        let depositPaymentTokenCalls =
          yieldManagerRef.contents
          ->YieldManagerMockSmocked.depositPaymentTokenCalls;

        depositPaymentTokenCalls->Chai.recordArrayDeepEqualFlat([|
          {amount: amount},
        |]);
      });
    });
  });
};
