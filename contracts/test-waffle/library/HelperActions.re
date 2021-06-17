open LetOps;
open Contract;
open Globals;

let mintDirect =
    (
      ~marketIndex,
      ~amount,
      ~token,
      ~user: Ethers.Wallet.t,
      ~longShort: LongShort.t,
      ~oracleManagerMock: OracleManagerMock.t,
      ~isLong: bool,
    ) => {
  let%AwaitThen _ =
    token->Contract.PaymentTokenHelpers.mintAndApprove(
      ~amount,
      ~user,
      ~spender=longShort.address,
    );
  let contract = longShort->ContractHelpers.connect(~address=user);
  let%AwaitThen currentOraclePrice =
    oracleManagerMock->OracleManagerMock.getLatestPrice;
  let tempOraclePrice = currentOraclePrice->add(bnFromInt(1));
  let _ =
    oracleManagerMock->OracleManagerMock.setPrice(~newPrice=tempOraclePrice);
  let%AwaitThen _ = contract->LongShort._updateSystemState(~marketIndex);
  let%AwaitThen _mintNextPrice =
    if (isLong) {
      contract->LongShort.mintLongNextPrice(~marketIndex, ~amount);
    } else {
      contract->LongShort.mintShortNextPrice(~marketIndex, ~amount);
    };
  // NOTE: this code changes the oracle price then resets it back to the original value which should the same value (for the sake of simplicity in the tests)
  let _ =
    oracleManagerMock->OracleManagerMock.setPrice(
      ~newPrice=currentOraclePrice,
    );
  contract->LongShort._updateSystemState(~marketIndex);
};
let mintAndStakeDirect =
    (
      ~marketIndex,
      ~amount,
      ~token,
      ~user: Ethers.Wallet.t,
      ~longShort: LongShort.t,
      ~oracleManagerMock: OracleManagerMock.t,
      ~synthToken: SyntheticToken.t,
    ) => {
  let%AwaitThen isLong = synthToken->Contract.SyntheticTokenHelpers.getIsLong;
  let%AwaitThen balanceBeforeMinting =
    synthToken->SyntheticToken.balanceOf(~account=user.address);
  let%AwaitThen _mintDirect =
    mintDirect(
      ~marketIndex,
      ~amount,
      ~token,
      ~user,
      ~longShort,
      ~oracleManagerMock,
      ~isLong,
    );
  let%AwaitThen availableToStakeAfter =
    synthToken->SyntheticToken.balanceOf(~account=user.address);
  let amountToStake = availableToStakeAfter->sub(balanceBeforeMinting);
  let synthTokenConnected =
    synthToken->ContractHelpers.connect(~address=user);
  synthTokenConnected->SyntheticToken.stake(~amount=amountToStake);
};

type randomStakeInfo = {
  marketIndex: int,
  synth: SyntheticToken.t,
  amount: Ethers.BigNumber.t,
  priceOfSynthForAction: Ethers.BigNumber.t,
  valueInEntrySide: Ethers.BigNumber.t,
  valueInOtherSide: Ethers.BigNumber.t,
};
let stakeRandomlyInMarkets =
    (
      ~marketsToStakeIn: array(Helpers.markets),
      ~userToStakeWith: Ethers.Wallet.t,
      ~longShort: LongShort.t,
    ) =>
  [|marketsToStakeIn->Array.getUnsafe(0)|]
  ->Belt.Array.reduce(
      JsPromise.resolve(([||], [||])),
      (
        currentValues,
        {paymentToken, longSynth, shortSynth, marketIndex, oracleManager},
      ) => {
        let%AwaitThen (synthsUserHasStakedIn, marketsUserHasStakedIn) = currentValues;
        let mintStake =
          mintAndStakeDirect(
            ~marketIndex,
            ~token=paymentToken,
            ~user=userToStakeWith,
            ~longShort,
            ~oracleManagerMock=oracleManager,
          );

        let%AwaitThen {
          longValue: valueLongBefore,
          shortValue: valueShortBefore,
        } =
          longShort->LongShortHelpers.getMarketBalance(~marketIndex);

        let%Await newSynthsUserHasStakedIn =
          switch (Helpers.randomMintLongShort()) {
          | Long(amount) =>
            let%AwaitThen _ = mintStake(~synthToken=longSynth, ~amount);
            let%Await longTokenPrice =
              longShort->LongShort.syntheticTokenPrice(
                marketIndex,
                CONSTANTS.longTokenType,
              );

            synthsUserHasStakedIn->Array.concat([|
              {
                marketIndex,
                synth: longSynth,
                amount,
                priceOfSynthForAction: longTokenPrice,
                valueInEntrySide: valueLongBefore,
                valueInOtherSide: valueShortBefore,
              },
            |]);
          | Short(amount) =>
            let%AwaitThen _ = mintStake(~synthToken=shortSynth, ~amount);
            let%Await shortTokenPrice =
              longShort->LongShort.syntheticTokenPrice(
                marketIndex,
                CONSTANTS.shortTokenType,
              );
            synthsUserHasStakedIn->Array.concat([|
              {
                marketIndex,
                synth: shortSynth,
                amount,
                priceOfSynthForAction: shortTokenPrice,
                valueInOtherSide: valueLongBefore,
                valueInEntrySide: valueShortBefore,
              },
            |]);
          | Both(longAmount, shortAmount) =>
            let%AwaitThen _ =
              mintStake(~synthToken=longSynth, ~amount=longAmount);
            let%AwaitThen longTokenPrice =
              longShort->LongShort.syntheticTokenPrice(
                marketIndex,
                CONSTANTS.longTokenType,
              );
            let newSynthsUserHasStakedIn =
              synthsUserHasStakedIn->Array.concat([|
                {
                  marketIndex,
                  synth: longSynth,
                  amount: longAmount,
                  priceOfSynthForAction: longTokenPrice,
                  valueInEntrySide: valueLongBefore,
                  valueInOtherSide: valueShortBefore,
                },
              |]);
            let%AwaitThen {
              longValue: valueLongBefore,
              shortValue: valueShortBefore,
            } =
              longShort->LongShortHelpers.getMarketBalance(~marketIndex);
            let%AwaitThen _ =
              mintStake(~synthToken=shortSynth, ~amount=shortAmount);
            let%Await shortTokenPrice =
              longShort->LongShort.syntheticTokenPrice(
                marketIndex,
                CONSTANTS.shortTokenType,
              );
            newSynthsUserHasStakedIn->Array.concat([|
              {
                marketIndex,
                synth: shortSynth,
                amount: shortAmount,
                priceOfSynthForAction: shortTokenPrice,
                valueInOtherSide: valueLongBefore,
                valueInEntrySide: valueShortBefore,
              },
            |]);
          };

        (
          newSynthsUserHasStakedIn,
          marketsUserHasStakedIn->Array.concat([|marketIndex|]),
        );
      },
    );

let stakeRandomlyInBothSidesOfMarket =
    (
      ~marketsToStakeIn: array(Helpers.markets),
      ~userToStakeWith: Ethers.Wallet.t,
      ~longShort: LongShort.t,
    ) =>
  marketsToStakeIn->Belt.Array.reduce(
    JsPromise.resolve(),
    (
      prevPromise,
      {paymentToken, marketIndex, longSynth, shortSynth, oracleManager},
    ) => {
      let%AwaitThen _ = prevPromise;

      let mintStake =
        mintAndStakeDirect(
          ~marketIndex,
          ~token=paymentToken,
          ~user=userToStakeWith,
          ~longShort,
          ~oracleManagerMock=oracleManager,
        );
      let%AwaitThen _ =
        mintStake(~synthToken=longSynth, ~amount=Helpers.randomTokenAmount());
      let%Await _ =
        mintStake(
          ~synthToken=shortSynth,
          ~amount=Helpers.randomTokenAmount(),
        );
      ();
    },
  );
