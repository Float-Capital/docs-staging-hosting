open Globals;
open LetOps;

let testExposed =
    (
      ~contracts: ref(Helpers.coreContracts),
      ~accounts: ref(array(Ethers.Wallet.t)),
    ) =>
  describe("lazyDeposits", () => {
    it'("calls the executeOutstandingLazySettlements modifier", () => {
      // TODO: turn this into a re-usable template (just pass in the transaction that should emmit the event)
      //       test all other relevant 'functions
      let {longShort} = contracts.contents;
      let marketIndex = 1;
      let amount = Ethers.BigNumber.fromInt(1);
      let testWallet = accounts.contents->Array.getUnsafe(1);

      let%Await _ =
        longShort->Contract.LongShort.Exposed.setUseexecuteOutstandingLazySettlementsMock(
          ~shouldUseMock=true,
        );

      let _ =
        Chai.callEmitEvents(
          ~call=
            longShort
            ->Contract.connect(~address=testWallet)
            ->Contract.LongShort.mintLongLazy(~marketIndex, ~amount),
          ~eventName="executeOutstandingLazySettlementsMock",
          ~contract=longShort->Obj.magic,
        )
        ->Chai.withArgs2((testWallet, marketIndex));
      ();
    });
    describe("mintLongLazy", () => {
      let mintLongLazyTxPromise: ref(JsPromise.t(Contract.transaction)) =
        ref(None->Obj.magic);
      let marketIndex = 1;
      let amount = Ethers.BigNumber.fromInt(1);

      before_each(() => {
        let {longShort} = contracts.contents;
        let testWallet = accounts.contents->Array.getUnsafe(1);

        mintLongLazyTxPromise :=
          longShort
          ->Contract.connect(~address=testWallet)
          ->Contract.LongShort.mintLongLazy(~marketIndex, ~amount);
      });

      it'("should emit the correct event", () => {
        let {longShort} = contracts.contents;
        let testWallet = accounts.contents->Array.getUnsafe(1);

        Chai.callEmitEvents(
          ~call=mintLongLazyTxPromise.contents,
          ~eventName="LazyLongMinted",
          ~contract=longShort->Obj.magic,
        )
        ->Chai.withArgs5(marketIndex, amount, testWallet.address, amount, 1);
      });
      /*
        fundTokens[marketIndex].transferFrom(msg.sender, address(this), amount);

         batchedLazyDeposit[marketIndex].mintLong += amount;
         userLazyActions[marketIndex][msg.sender].mintLong += amount;
         userLazyActions[marketIndex][msg.sender].usersCurrentUpdateIndex =
             latestUpdateIndex[marketIndex] +
       */
      it'("transfer all the payment tokens to the LongShort contract", () => {
        let {longShort, markets} = contracts.contents;
        let paymentToken = markets->Array.getUnsafe(1).paymentToken;

        Chai.changeBallance(
          ~transaction=() => mintLongLazyTxPromise.contents,
          ~token=paymentToken->Obj.magic,
          ~to_=longShort->Obj.magic,
          ~amount,
        );
      });
      it'("updates the mintLong value for the market", () => {
        let {longShort} = contracts.contents;
        let%AwaitThen _ = mintLongLazyTxPromise.contents;
        let%Await {mintLong} =
          longShort->Contract.LongShort.batchedLazyDeposit(~marketIndex);

        Chai.bnEqual(
          ~message="Incorrect batched lazy deposit mint long",
          amount,
          mintLong,
        );
      });
      it'("updates the user's batched mint long amount", () =>
        JsPromise.resolve()
      );
      it'("updates the user's oracle index for lazy minting", () =>
        JsPromise.resolve()
      );
    });
  });
