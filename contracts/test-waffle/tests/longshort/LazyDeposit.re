open Globals;
open LetOps;

let testIntegration =
    (
      ~contracts: ref(Helpers.coreContracts),
      ~accounts: ref(array(Ethers.Wallet.t)),
    ) =>
  describe("mintLongLazy", () => {
    it'("should work as expected happy path", () => {
      let admin = accounts.contents->Array.getUnsafe(0);
      let testUser = accounts.contents->Array.getUnsafe(8);
      let amountToLazyMint = Helpers.randomTokenAmount();

      let {tokenFactory, treasury, floatToken, staker, longShort, markets} =
        contracts.contents;
      let {
        paymentToken,
        oracleManager,
        yieldManager,
        longSynth,
        shortSynth,
        marketIndex,
      } =
        markets->Array.getUnsafe(0);

      let%AwaitThen longValueBefore =
        longShort->Contract.LongShort.longValue(~marketIndex);
      let%AwaitThen shortValueBefore =
        longShort->Contract.LongShort.shortValue(~marketIndex);

      let%AwaitThen _ =
        paymentToken->Contract.PaymentToken.mint(
          ~user=testUser.address,
          ~amount=amountToLazyMint,
        );

      let%AwaitThen _ =
        paymentToken
        ->Contract.connect(~address=testUser)
        ->Contract.PaymentToken.approve(
            ~spender=longShort.address,
            ~amount=amountToLazyMint,
          );

      let%AwaitThen _ =
        longShort
        ->Contract.connect(~address=testUser)
        ->Contract.LongShort.mintLongLazy(
            ~marketIndex,
            ~amount=amountToLazyMint,
          );

      let%AwaitThen previousPrice =
        oracleManager->Contract.OracleManagerMock.getLatestPrice;

      let nextPrice =
        previousPrice
        ->mul(bnFromInt(12)) // 20% increase
        ->div(bnFromInt(10));

      let%AwaitThen _ =
        oracleManager->Contract.OracleManagerMock.setPrice(
          ~newPrice=nextPrice,
        );

      Js.log("\n\n\n\n\nthis is the latest price");
      Js.log({"LongShort address": longShort.address});
      Js.log(testUser.address);
      let%AwaitThen userLazyActions =
        longShort->Contract.LongShort.userLazyActions(
          ~marketIndex,
          ~user=testUser.address,
        );
      let%AwaitThen usersBalanceBeforeSettlement =
        longSynth->Contract.SyntheticToken.balanceOf(
          ~account=testUser.address,
        );
      Js.log({
        "usersBalanceBeforeSettlement":
          usersBalanceBeforeSettlement->bnToString,
        "index": userLazyActions.usersCurrentUpdateIndex->bnToString,
      });
      Js.log("this is the latest price\n\n\n\n\n");
      let%AwaitThen _ =
        longShort->Contract.LongShort._updateSystemState(~marketIndex);
      Js.log("\n\n\n\n\nthis is the latest price");
      let%AwaitThen usersBalanceBeforeSettlement =
        longSynth->Contract.SyntheticToken.balanceOf(
          ~account=testUser.address,
        );
      Js.log({"usersBalanceBeforeSettlement": usersBalanceBeforeSettlement});
      Js.log("this is the latest price\n\n\n\n\n");

      let%AwaitThen _ =
        longShort->Contract.LongShort.Exposed._executeOutstandingLazySettlementsExposed(
          ~user=testUser.address,
          ~marketIndex,
        );
      let%AwaitThen usersUpdatedBalance =
        longSynth->Contract.SyntheticToken.balanceOf(
          ~account=testUser.address,
        );

      let%AwaitThen longTokenPrice =
        longShort->Contract.LongShort.longTokenPrice(~marketIndex);

      let expectedNumberOfTokensToRecieve =
        amountToLazyMint->mul(CONSTANTS.tenToThe18)->div(longTokenPrice);

      Chai.bnEqual(
        ~message="balance is incorrect",
        expectedNumberOfTokensToRecieve,
        usersUpdatedBalance,
      );

      JsPromise.resolve();
    })
  });

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
      let amount = bnFromInt(1);
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
      let amount = bnFromInt(1);

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
