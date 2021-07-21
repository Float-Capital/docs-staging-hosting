open Globals;
open LetOps;
open Mocha;

let testIntegration =
    (
      ~contracts: ref(Helpers.coreContracts),
      ~accounts: ref(array(Ethers.Wallet.t)),
    ) =>
  describe("mintLongNextPrice", () => {
    it("should work as expected happy path", () => {
      // let admin = accounts.contents->Array.getUnsafe(0);
      let testUser = accounts.contents->Array.getUnsafe(8);
      let amountToNextPriceMint = Helpers.randomTokenAmount();

      let {longShort, markets} =
        // let {tokenFactory, treasury, floatToken, staker, longShort, markets} =
        contracts.contents;
      let {
        paymentToken,
        oracleManager,
        // yieldManager,
        longSynth,
        // shortSynth,
        marketIndex,
      } =
        markets->Array.getUnsafe(0);

      let%AwaitThen _longValueBefore =
        longShort->LongShort.syntheticTokenPoolValue(
          marketIndex,
          true /*long*/,
        );

      let%AwaitThen _ =
        paymentToken->ERC20Mock.mint(
          ~_to=testUser.address,
          ~amount=amountToNextPriceMint,
        );

      let%AwaitThen _ =
        paymentToken
        ->ContractHelpers.connect(~address=testUser)
        ->ERC20Mock.approve(
            ~spender=longShort.address,
            ~amount=amountToNextPriceMint,
          );

      let%AwaitThen _ =
        longShort
        ->ContractHelpers.connect(~address=testUser)
        ->LongShort.mintLongNextPrice(
            ~marketIndex,
            ~amount=amountToNextPriceMint,
          );

      let%AwaitThen previousPrice =
        oracleManager->OracleManagerMock.getLatestPrice;

      let nextPrice =
        previousPrice
        ->mul(bnFromInt(12)) // 20% increase
        ->div(bnFromInt(10));

      // let%AwaitThen userNextPriceActions =
      //   longShort->Contract.LongShort.userNextPriceActions(
      //     ~marketIndex,
      //     ~user=testUser.address,
      //   );

      // let%AwaitThen usersBalanceBeforeOracleUpdate =
      //   longSynth->Contract.SyntheticToken.balanceOf(
      //     ~account=testUser.address,
      //   );

      let%AwaitThen _ =
        oracleManager->OracleManagerMock.setPrice(~newPrice=nextPrice);

      let%AwaitThen _ = longShort->LongShort.updateSystemState(~marketIndex);

      let%AwaitThen usersBalanceBeforeSettlement =
        longSynth->SyntheticToken.balanceOf(~account=testUser.address);

      // This triggers the _executeOutstandingNextPriceSettlements function
      let%AwaitThen _ =
        longShort
        ->ContractHelpers.connect(~address=testUser)
        ->LongShort.mintLongNextPrice(~marketIndex, ~amount=bnFromInt(0));
      let%AwaitThen usersUpdatedBalance =
        longSynth->SyntheticToken.balanceOf(~account=testUser.address);

      Chai.bnEqual(
        ~message=
          "Balance after price system update but before user settlement should be the same as after settlement",
        usersBalanceBeforeSettlement,
        usersUpdatedBalance,
      );

      let%Await longTokenPrice =
        longShort->Contract.LongShortHelpers.getSyntheticTokenPrice(
          ~marketIndex,
          ~isLong=true,
        );

      let expectedNumberOfTokensToRecieve =
        amountToNextPriceMint
        ->mul(CONSTANTS.tenToThe18)
        ->div(longTokenPrice);

      Chai.bnEqual(
        ~message="balance is incorrect",
        expectedNumberOfTokensToRecieve,
        usersUpdatedBalance,
      );
    })
  });

let testUnit =
    (
      ~contracts: ref(Helpers.coreContracts),
      ~accounts: ref(array(Ethers.Wallet.t)),
    ) => {
  describe("mintNextPrice", () => {
    let marketIndex = 1;
    let marketUpdateIndex = bnFromInt(1);
    let amount = bnFromInt(10);
    let isLong = true;

    let setup = (~testWallet: Ethers.walletType) => {
      let%AwaitThen _ =
        contracts.contents.longShort->LongShortSmocked.InternalMock.setup;

      let%AwaitThen _ =
        contracts.contents.longShort
        ->LongShortSmocked.InternalMock.setupFunctionForUnitTesting(
            ~functionName="_mintNextPrice",
          );

      LongShortSmocked.InternalMock.mock_depositFundsToReturn();

      let%AwaitThen _ =
        contracts.contents.longShort
        ->LongShort.Exposed.setMintNextPriceGlobals(
            ~marketIndex,
            ~marketUpdateIndex,
          );

      let longShort =
        contracts.contents.longShort
        ->ContractHelpers.connect(~address=testWallet);

      longShort->LongShort.Exposed._mintNextPriceExposed(
        ~marketIndex,
        ~amount,
        ~isLong,
      );
    };

    it("calls the executeOutstandingNextPriceSettlements modifier", () => {
      let testWallet = accounts.contents->Array.getUnsafe(1);

      let%Await _ = setup(~testWallet);

      let executeOutstandingNextPriceSettlementsCalls =
        LongShortSmocked.InternalMock._executeOutstandingNextPriceSettlementsCalls();

      Chai.intEqual(
        executeOutstandingNextPriceSettlementsCalls->Array.length,
        1,
      );

      executeOutstandingNextPriceSettlementsCalls->Chai.recordArrayDeepEqualFlat([|
        {user: testWallet.address, marketIndex},
      |]);
    });

    it("emits the NextPriceDeposit event", () => {
      let testWallet = accounts.contents->Array.getUnsafe(1);

      Chai.callEmitEvents(
        ~call=setup(~testWallet),
        ~eventName="NextPriceDeposit",
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

    it("calls depositFunds with correct parameters", () => {
      let testWallet = accounts.contents->Array.getUnsafe(1);

      let%Await _ = setup(~testWallet);

      let depositFundsCalls =
        LongShortSmocked.InternalMock._depositFundsCalls();

      Chai.intEqual(depositFundsCalls->Array.length, 1);

      depositFundsCalls->Chai.recordArrayDeepEqualFlat([|
        {marketIndex, amount},
      |]);
    });

    it("updates the correct state variables with correct values", () => {
      let testWallet = accounts.contents->Array.getUnsafe(1);

      let%AwaitThen _ = setup(~testWallet);

      let%AwaitThen updatedBatchedAmountOfTokensToDeposit =
        contracts.contents.longShort
        ->LongShort.batchedAmountOfTokensToDeposit(marketIndex, isLong);

      let%AwaitThen updatedUserNextPriceDepositAmount =
        contracts.contents.longShort
        ->LongShort.userNextPriceDepositAmount(
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
        ~message="batchedAmountOfTokensToDeposit not updated correctly",
        updatedBatchedAmountOfTokensToDeposit,
        amount,
      );

      Chai.bnEqual(
        ~message="userNextPriceDepositAmount not updated correctly",
        updatedUserNextPriceDepositAmount,
        amount,
      );

      Chai.bnEqual(
        ~message="userCurrentNextPriceUpdateIndex not updated correctly",
        updatedUserCurrentNextPriceUpdateIndex,
        marketUpdateIndex->add(oneBn),
      );
    });
  });
};
