open Globals;
open LetOps;
open Contract;

let testIntegration =
    (
      ~contracts: ref(Helpers.coreContracts),
      ~accounts: ref(array(Ethers.Wallet.t)),
    ) =>
  describe("lazyRedeem", () => {
    it_only'("[THIS TEST IS FLAKY] should work as expected happy path", () => {
      // let admin = accounts.contents->Array.getUnsafe(0);
      let testUser = accounts.contents->Array.getUnsafe(8);
      let amountToLazyMint = Helpers.randomTokenAmount();

      Js.log({"TEST": 1});

      let {longShort, markets} =
        // let {tokenFactory, treasury, floatToken, staker, longShort, markets} =
        contracts.contents;

      Js.log({"TEST": 2});
      let longShortUserConnected =
        longShort->ContractHelpers.connect(~address=testUser);
      Js.log({"TEST": 3});

      let {
        paymentToken,
        oracleManager,
        // yieldManager,
        longSynth,
        // shortSynth,
        marketIndex,
      } =
        markets->Array.getUnsafe(0);
      Js.log({"TEST": 4});

      let%AwaitThen _longValueBefore =
        longShort->LongShort.syntheticTokenBackedValue(
          CONSTANTS.longTokenType,
          marketIndex,
        );
      Js.log({"TEST": 5});

      let%AwaitThen _ =
        paymentToken->ERC20Mock.mint(
          ~_to=testUser.address,
          ~amount=amountToLazyMint,
        );
      Js.log({"TEST": 6});

      let%AwaitThen _ =
        paymentToken->ERC20Mock.setShouldMockTransfer(~value=false);

      Js.log({"TEST": 7});
      let%AwaitThen _ =
        paymentToken
        ->ContractHelpers.connect(~address=testUser)
        ->ERC20Mock.approve(
            ~spender=longShort.address,
            ~amount=amountToLazyMint,
          );
      Js.log({"TEST": 8});

      let%AwaitThen _ =
        HelperActions.mintDirect(
          ~marketIndex,
          ~amount=amountToLazyMint,
          ~token=paymentToken,
          ~user=testUser,
          ~longShort,
          ~oracleManagerMock=oracleManager,
          ~isLong=true,
        );
      Js.log({"TEST": 9});

      let%AwaitThen usersBalanceAvailableForRedeem =
        longSynth->SyntheticToken.balanceOf(~account=testUser.address);
      Js.log({"TEST": 10});
      let%AwaitThen _ =
        longShortUserConnected->LongShort.redeemLongLazy(
          ~marketIndex,
          ~tokensToRedeem=usersBalanceAvailableForRedeem,
        );
      Js.log({"TEST": 11});
      let%AwaitThen usersBalanceAfterLazyRedeem =
        longSynth->SyntheticToken.balanceOf(~account=testUser.address);

      Js.log({"TEST": 12});
      Chai.bnEqual(
        ~message=
          "Balance after price system update but before user settlement should be the same as after settlement",
        usersBalanceAfterLazyRedeem,
        CONSTANTS.zeroBn,
      );
      Js.log({"TEST": 13});

      let%AwaitThen paymentTokenBalanceBeforeWithdrawal =
        paymentToken->ERC20Mock.balanceOf(~account=testUser.address);
      Js.log({"TEST": 14});

      let%AwaitThen {longValue: valueLongBefore, shortValue: valueShortBefore} =
        longShort->LongShortHelpers.getMarketBalance(~marketIndex);
      Js.log({"TEST": 15});

      let%AwaitThen previousPrice =
        oracleManager->OracleManagerMock.getLatestPrice;

      let nextPrice =
        previousPrice
        ->mul(bnFromInt(12)) // 20% increase
        ->div(bnFromInt(10));

      Js.log({"TEST": 15});
      let%AwaitThen _ =
        oracleManager->OracleManagerMock.setPrice(~newPrice=nextPrice);

      Js.log({"TEST": 16});
      let {
        totalLockedLong: newLongValueSansRedemptions,
        totalLockedShort: newShortValueSansRedemptions,
      } =
        MarketSimulation.simulateMarketPriceChange(
          ~oldPrice=previousPrice,
          ~newPrice=nextPrice,
          ~totalLockedLong=valueLongBefore,
          ~totalLockedShort=valueShortBefore,
        );
      Js.log({"TEST": 17});

      let%AwaitThen _ = longShort->LongShort._updateSystemState(~marketIndex);
      Js.log({"TEST": 18});
      let%AwaitThen latestUpdateIndex =
        longShort->LongShort.latestUpdateIndex(marketIndex);

      Js.log({"TEST": 19});
      let%AwaitThen batchedRedemptionAmountWithoutFees =
        longShort->LongShortHelpers.getBatchedRedemptionAmountWithoutFees(
          ~marketIndex,
          ~updateIndex=latestUpdateIndex,
          ~marketSide=CONSTANTS.longTokenType,
        );
      Js.log({"TEST": 20});
      let%AwaitThen feesForRedeemLazy =
        longShort->LongShortHelpers.getFeesRedeemLazy(
          ~marketIndex,
          ~amount=batchedRedemptionAmountWithoutFees,
          ~valueInRemovalSide=newLongValueSansRedemptions,
          ~valueInOtherSide=newShortValueSansRedemptions,
        );
      Js.log({"TEST": 21});

      let amountExpectedToBeRedeemed =
        batchedRedemptionAmountWithoutFees->sub(feesForRedeemLazy);

      let%AwaitThen _ =
        longShort->LongShort.executeOutstandingLazySettlementsUser(
          ~marketIndex,
          ~user=testUser.address,
        );

      Js.log({"TEST": 22});
      let%Await paymentTokenBalanceAfterWithdrawal =
        paymentToken->ERC20Mock.balanceOf(~account=testUser.address);

      Js.log({"TEST": 23});
      let deltaBalanceChange =
        paymentTokenBalanceAfterWithdrawal->sub(
          paymentTokenBalanceBeforeWithdrawal,
        );

      Chai.bnEqual(
        ~message="Balance of paymentToken didn't update correctly",
        deltaBalanceChange,
        amountExpectedToBeRedeemed,
      );
      Js.log({"TEST": 24});
    })
  });
