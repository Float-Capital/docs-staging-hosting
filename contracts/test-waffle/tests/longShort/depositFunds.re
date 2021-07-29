open Mocha;
open LetOps;

let mockTransferFromToRevert: ERC20MockSmocked.t => unit =
  _r => {
    let _ = [%raw "_r.smocked.transferFrom.will.revert()"];
  };

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
      let longShortRef: ref(LongShort.t) = ref(""->Obj.magic);

      let setup = (~testWallet: Ethers.walletType, ~failTransfer: bool) => {
        let {paymentToken} = contracts.contents.markets->Array.getUnsafe(0);

        let%AwaitThen _ =
          contracts.contents.longShort
          ->LongShortSmocked.InternalMock.setupFunctionForUnitTesting(
              ~functionName="_depositFunds",
            );

        let%AwaitThen smockedPaymentToken =
          ERC20MockSmocked.make(paymentToken);

        if (failTransfer) {
          smockedPaymentToken->mockTransferFromToRevert;
        } else {
          smockedPaymentToken->ERC20MockSmocked.mockTransferFromToReturn(
            true,
          );
        };
        paymentTokenSmocked := smockedPaymentToken;

        let%Await _ =
          contracts.contents.longShort
          ->LongShort.Exposed.setDepositFundsGlobals(
              ~marketIndex,
              ~paymentToken=smockedPaymentToken.address,
            );

        let longShort =
          contracts.contents.longShort
          ->ContractHelpers.connect(~address=testWallet);

        longShortRef := longShort;
      };

      it("calls paymentToken.transferFrom with correct arguments", () => {
        let testWallet = accounts.contents->Array.getUnsafe(1);
        let%Await _ = setup(~testWallet, ~failTransfer=false);

        let%Await _ =
          longShortRef.contents
          ->LongShort.Exposed._depositFundsExposed(~marketIndex, ~amount);

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

      it("fails if paymetToken.transferFrom fails", () => {
        let testWallet = accounts.contents->Array.getUnsafe(1);
        let%Await _ = setup(~testWallet, ~failTransfer=true);

        Chai.expectRevertNoReason(
          ~transaction=
            longShortRef.contents
            ->LongShort.Exposed._depositFundsExposed(~marketIndex, ~amount),
        );
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

      it("calls _depositFunds with correct arguments", () => {
        let depositFundsCalls =
          LongShortSmocked.InternalMock._depositFundsCalls();

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
