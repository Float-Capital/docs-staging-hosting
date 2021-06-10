open Globals;
open LetOps;
open Contract;

let testIntegration =
    (
      ~contracts: ref(Helpers.coreContracts),
      ~accounts: ref(array(Ethers.Wallet.t)),
    ) =>
  describe("lazyRedeem", () => {
    it'("should work as expected happy path", () => {
      // let admin = accounts.contents->Array.getUnsafe(0);
      let testUser = accounts.contents->Array.getUnsafe(8);
      let amountToLazyMint = Helpers.randomTokenAmount();

      let {longShort, markets} =
        // let {tokenFactory, treasury, floatToken, staker, longShort, markets} =
        contracts.contents;

      let longShortUserConnected =
        longShort->ContractHelpers.connect(~address=testUser);

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
        longShort->LongShort.syntheticTokenBackedValue(
          CONSTANTS.longTokenType,
          marketIndex,
        );

      let%AwaitThen _ =
        paymentToken->ERC20Mock.mint(
          ~_to=testUser.address,
          ~amount=amountToLazyMint,
        );

      let%AwaitThen _ =
        paymentToken->ERC20Mock.setShouldMockTransfer(~value=false);

      let%AwaitThen _ =
        paymentToken
        ->ContractHelpers.connect(~address=testUser)
        ->ERC20Mock.approve(
            ~spender=longShort.address,
            ~amount=amountToLazyMint,
          );

      let%AwaitThen _ =
        longShortUserConnected->LongShort.mintLong(
          ~marketIndex,
          ~amount=amountToLazyMint,
        );
      let%AwaitThen usersBalanceAvailableForRedeem =
        longSynth->SyntheticToken.balanceOf(~account=testUser.address);
      let%AwaitThen _ =
        longShortUserConnected->LongShort.redeemLongLazy(
          ~marketIndex,
          ~tokensToRedeem=usersBalanceAvailableForRedeem,
        );
      let%AwaitThen usersBalanceAfterLazyRedeem =
        longSynth->SyntheticToken.balanceOf(~account=testUser.address);

      Chai.bnEqual(
        ~message=
          "Balance after price system update but before user settlement should be the same as after settlement",
        usersBalanceAfterLazyRedeem,
        CONSTANTS.zeroBn,
      );

      let%AwaitThen paymentTokenBalanceBeforeWithdrawal =
        paymentToken->ERC20Mock.balanceOf(~account=testUser.address);

      let%AwaitThen {longValue: valueLongBefore, shortValue: valueShortBefore} =
        longShort->LongShortHelpers.getMarketBalance(~marketIndex);

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

      let%AwaitThen batchedRedemptionAmountWithoutFees =
        longShort->LongShortHelpers.getBatchedRedemptionAmountWithoutFees(
          ~marketIndex,
          ~updateIndex=latestUpdateIndex,
          ~marketSide=CONSTANTS.longTokenType,
        );
      let%AwaitThen feesForRedeemLazy =
        longShort->LongShortHelpers.getFeesRedeemLazy(
          ~marketIndex,
          ~amount=batchedRedemptionAmountWithoutFees,
          ~valueInRemovalSide=valueLongBefore,
          ~valueInOtherSide=valueShortBefore,
        );

      let amountExpectedToBeRedeemed =
        batchedRedemptionAmountWithoutFees->sub(feesForRedeemLazy);

      let%AwaitThen _ =
        longShort->LongShort._executeOutstandingLazyRedeems(
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
