open Globals;
open LetOps;

let testIntegration =
    (
      ~contracts: ref(Helpers.coreContracts),
      ~accounts: ref(array(Ethers.Wallet.t)),
    ) =>
  describe("lazyRedeem", () => {
    it'("[THIS TEST IS FLAKY] should work as expected happy path", () => {
      let testUser = accounts.contents->Array.getUnsafe(8);
      let amountToNextPriceMint = Helpers.randomTokenAmount();

      let {longShort, markets} = contracts.contents;

      let longShortUserConnected =
        longShort->ContractHelpers.connect(~address=testUser);

      let {paymentToken, oracleManager, longSynth, marketIndex} =
        markets->Array.getUnsafe(0);

      let%AwaitThen _longValueBefore =
        longShort->LongShort.syntheticTokenBackedValue(
          CONSTANTS.longTokenType,
          marketIndex,
        );

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
          ~isLong=true,
        );

      let%AwaitThen usersBalanceAvailableForRedeem =
        longSynth->SyntheticToken.balanceOf(~account=testUser.address);
      let%AwaitThen _ =
        longShortUserConnected->LongShort.redeemLongNextPrice(
          ~marketIndex,
          ~tokensToRedeem=usersBalanceAvailableForRedeem,
        );
      let%AwaitThen usersBalanceAfterNextPriceRedeem =
        longSynth->SyntheticToken.balanceOf(~account=testUser.address);

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

      let%AwaitThen _ = longShort->LongShort._updateSystemState(~marketIndex);
      let%AwaitThen latestUpdateIndex =
        longShort->LongShort.latestUpdateIndex(marketIndex);
      let%AwaitThen redemptionPriceWithFees =
        longShort->LongShort.redeemPriceSnapshot(
          marketIndex,
          latestUpdateIndex,
          CONSTANTS.longTokenType,
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
    })
  });
