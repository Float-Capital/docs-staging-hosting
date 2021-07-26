open Globals;
open LetOps;
open Mocha;

let testIntegration =
    (
      ~contracts: ref(Helpers.coreContracts),
      ~accounts: ref(array(Ethers.Wallet.t)),
    ) =>
  describe("lazyRedeem", () => {
    let runLazyRedeemTest = (~isLong) =>
      it(
        "should work as expected happy path for redeem "
        ++ (isLong ? "Long" : "Short"),
        () => {
          let testUser = accounts.contents->Array.getUnsafe(8);
          let amountToNextPriceMint = Helpers.randomTokenAmount();

          let {longShort, markets} = contracts.contents;

          let longShortUserConnected =
            longShort->ContractHelpers.connect(~address=testUser);

          let {
            paymentToken,
            oracleManager,
            longSynth,
            shortSynth,
            marketIndex,
          } =
            markets->Array.getUnsafe(0);

          let testSynth = isLong ? longSynth : shortSynth;
          let redeemNextPriceFunction =
            isLong
              ? LongShort.redeemLongNextPrice : LongShort.redeemShortNextPrice;

          let%AwaitThen _longValueBefore =
            longShort->LongShort.syntheticTokenPoolValue(marketIndex, isLong);

          let%AwaitThen _ =
            paymentToken->ERC20Mock.mint(
              ~_to=testUser.address,
              ~amount=amountToNextPriceMint,
            );

          let%AwaitThen _ =
            paymentToken->ERC20Mock.setShouldMockTransfer(~value=false);

          let%AwaitThen _ =
            paymentToken
            ->ContractHelpers.connect(~address=testUser)
            ->ERC20Mock.approve(
                ~spender=longShort.address,
                ~amount=amountToNextPriceMint,
              );

          let%AwaitThen _ =
            HelperActions.mintDirect(
              ~marketIndex,
              ~amount=amountToNextPriceMint,
              ~token=paymentToken,
              ~user=testUser,
              ~longShort,
              ~oracleManagerMock=oracleManager,
              ~isLong,
            );

          let%AwaitThen usersBalanceAvailableForRedeem =
            testSynth->SyntheticToken.balanceOf(~account=testUser.address);
          let%AwaitThen _ =
            longShortUserConnected->redeemNextPriceFunction(
              ~marketIndex,
              ~tokensToRedeem=usersBalanceAvailableForRedeem,
            );
          let%AwaitThen usersBalanceAfterNextPriceRedeem =
            testSynth->SyntheticToken.balanceOf(~account=testUser.address);

          Chai.bnEqual(
            ~message=
              "Balance after price system update but before user settlement should be the same as after settlement",
            usersBalanceAfterNextPriceRedeem,
            CONSTANTS.zeroBn,
          );

          let%AwaitThen paymentTokenBalanceBeforeWithdrawal =
            paymentToken->ERC20Mock.balanceOf(~account=testUser.address);

          let%AwaitThen previousPrice =
            oracleManager->OracleManagerMock.getLatestPrice;

          let nextPrice =
            previousPrice
            ->mul(bnFromInt(12)) // 20% increase
            ->div(bnFromInt(10));

          let%AwaitThen _ =
            oracleManager->OracleManagerMock.setPrice(~newPrice=nextPrice);

          let%AwaitThen _ =
            longShort->LongShort.updateSystemState(~marketIndex);
          let%AwaitThen latestUpdateIndex =
            longShort->LongShort.marketUpdateIndex(marketIndex);
          let%AwaitThen redemptionPriceWithFees =
            longShort->LongShort.syntheticTokenPriceSnapshot(
              marketIndex,
              isLong,
              latestUpdateIndex,
            );

          let amountExpectedToBeRedeemed =
            usersBalanceAvailableForRedeem
            ->mul(redemptionPriceWithFees)
            ->div(CONSTANTS.tenToThe18);

          let%AwaitThen _ =
            longShort->LongShort.executeOutstandingNextPriceSettlementsUser(
              ~marketIndex,
              ~user=testUser.address,
            );

          let%Await paymentTokenBalanceAfterWithdrawal =
            paymentToken->ERC20Mock.balanceOf(~account=testUser.address);

          let deltaBalanceChange =
            paymentTokenBalanceAfterWithdrawal->sub(
              paymentTokenBalanceBeforeWithdrawal,
            );

          Chai.bnEqual(
            ~message="Balance of paymentToken didn't update correctly",
            deltaBalanceChange,
            amountExpectedToBeRedeemed,
          );
        },
      );

    runLazyRedeemTest(~isLong=true);
    runLazyRedeemTest(~isLong=false);
  });

let testUnit =
    (
      ~contracts: ref(Helpers.coreContracts),
      ~accounts: ref(array(Ethers.Wallet.t)),
    ) => {
  describe("redeemNextPrice", () => {
    let marketIndex = 1;
    let marketUpdateIndex = Helpers.randomInteger();
    let amount = Helpers.randomTokenAmount();
    let smockedSynthToken = ref(SyntheticTokenSmocked.uninitializedValue);

    let setup = (~isLong, ~testWallet: Ethers.walletType) => {
      let {longSynth} = contracts.contents.markets->Array.getUnsafe(0);
      let%AwaitThen longSynthSmocked = longSynth->SyntheticTokenSmocked.make;
      longSynthSmocked->SyntheticTokenSmocked.mockTransferFromToReturn(true);
      smockedSynthToken := longSynthSmocked;

      let%AwaitThen _ =
        contracts.contents.longShort->LongShortSmocked.InternalMock.setup;

      let%AwaitThen _ =
        contracts.contents.longShort
        ->LongShortSmocked.InternalMock.setupFunctionForUnitTesting(
            ~functionName="_redeemNextPrice",
          );

      let%AwaitThen _ =
        contracts.contents.longShort
        ->LongShort.Exposed.setRedeemNextPriceGlobals(
            ~marketIndex,
            ~marketUpdateIndex,
            ~syntheticToken=longSynthSmocked.address,
            ~isLong,
          );

      let longShort =
        contracts.contents.longShort
        ->ContractHelpers.connect(~address=testWallet);

      longShort->LongShort.Exposed._redeemNextPriceExposed(
        ~marketIndex,
        ~tokensToRedeem=amount,
        ~isLong,
      );
    };

    let testMarketSide = (~isLong) => {
      it("calls the executeOutstandingNextPriceSettlements modifier", () => {
        let testWallet = accounts.contents->Array.getUnsafe(1);

        let%Await _ = setup(~isLong, ~testWallet);

        let executeOutstandingNextPriceSettlementsCalls =
          LongShortSmocked.InternalMock._executeOutstandingNextPriceSettlementsCalls();

        executeOutstandingNextPriceSettlementsCalls->Chai.recordArrayDeepEqualFlat([|
          {user: testWallet.address, marketIndex},
        |]);
      });

      it("emits the NextPriceRedeem event", () => {
        let testWallet = accounts.contents->Array.getUnsafe(1);

        Chai.callEmitEvents(
          ~call=setup(~isLong, ~testWallet),
          ~eventName="NextPriceRedeem",
          ~contract=contracts.contents.longShort->Obj.magic,
        )
        ->Chai.withArgs5(
            marketIndex,
            isLong,
            amount,
            testWallet.address,
            marketUpdateIndex->add(oneBn),
          );
      });

      it(
        "transfers synthetic tokens (calls transferFrom with the correct parameters)",
        () => {
        let testWallet = accounts.contents->Array.getUnsafe(1);

        let%Await _ = setup(~isLong, ~testWallet);

        let transferFromCalls =
          smockedSynthToken.contents->SyntheticTokenSmocked.transferFromCalls;

        transferFromCalls->Chai.recordArrayDeepEqualFlat([|
          {
            sender: testWallet.address,
            recipient: contracts.contents.longShort.address,
            amount,
          },
        |]);
      });

      it("updates the correct state variables with correct values", () => {
        let testWallet = accounts.contents->Array.getUnsafe(1);

        let%AwaitThen _ = setup(~isLong, ~testWallet);

        let%AwaitThen updatedBatchedAmountOfSynthTokensToRedeem =
          contracts.contents.longShort
        ->LongShort.batchedAmountOfSynthTokensToRedeem(
              marketIndex,
              isLong,
            );

        let%AwaitThen updatedUserNextPriceRedemptionAmount =
          contracts.contents.longShort
          ->LongShort.userNextPriceRedemptionAmount(
              marketIndex,
              isLong,
              testWallet.address,
            );

        let%Await updatedUserCurrentNextPriceUpdateIndex =
          contracts.contents.longShort
          ->LongShort.userCurrentNextPriceUpdateIndex(
              marketIndex,
              testWallet.address,
            );

        Chai.bnEqual(
          ~message="batchedAmountOfSynthTokensToRedeem not updated correctly",
          updatedBatchedAmountOfSynthTokensToRedeem,
          amount,
        );

        Chai.bnEqual(
          ~message="userNextPriceRedemptionAmount not updated correctly",
          updatedUserNextPriceRedemptionAmount,
          amount,
        );

        Chai.bnEqual(
          ~message="userCurrentNextPriceUpdateIndex not updated correctly",
          updatedUserCurrentNextPriceUpdateIndex,
          marketUpdateIndex->add(oneBn),
        );
      });
    };

    describe("long", () => {
      testMarketSide(~isLong=true)
    });
    describe("short", () => {
      testMarketSide(~isLong=false)
    });
  });
};
