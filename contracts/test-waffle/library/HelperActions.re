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
  Js.log({"SD": 1});

  let%AwaitThen _ =
    token->Contract.PaymentTokenHelpers.mintAndApprove(
      ~amount,
      ~user,
      ~spender=longShort.address,
    );
  Js.log({"SD": 2});
  let contract = longShort->ContractHelpers.connect(~address=user);
  Js.log({"SD": 3});
  let%AwaitThen currentOraclePrice =
    oracleManagerMock->OracleManagerMock.getLatestPrice;
  Js.log({"SD": 4});
  let tempOraclePrice = currentOraclePrice->add(bnFromInt(1));
  let _ =
    oracleManagerMock->OracleManagerMock.setPrice(~newPrice=tempOraclePrice);
  Js.log({"SD": 5});
  let%AwaitThen _ = contract->LongShort._updateSystemState(~marketIndex);
  Js.log({"SD": 6});
  let%AwaitThen _mintLazy =
    if (isLong) {
      contract->LongShort.mintLongLazy(~marketIndex, ~amount);
    } else {
      contract->LongShort.mintShortLazy(~marketIndex, ~amount);
    };
  Js.log({"SD": 7});
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
  Js.log({"MASD": 1});
  let%AwaitThen isLong = synthToken->Contract.SyntheticTokenHelpers.getIsLong;
  Js.log({"MASD": 2});
  let%AwaitThen balanceBeforeMinting =
    synthToken->SyntheticToken.balanceOf(~account=user.address);
  Js.log({"MASD": 3});
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
  Js.log({"MASD": 4});
  let%AwaitThen availableToStakeAfter =
    synthToken->SyntheticToken.balanceOf(~account=user.address);
  Js.log({"MASD": 5});
  let amountToStake = availableToStakeAfter->sub(balanceBeforeMinting);
  let synthTokenConnected =
    synthToken->ContractHelpers.connect(~address=user);
  Js.log({"MASD": 6});
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
                CONSTANTS.longTokenType,
                marketIndex,
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
                CONSTANTS.shortTokenType,
                marketIndex,
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
                CONSTANTS.longTokenType,
                marketIndex,
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
                CONSTANTS.shortTokenType,
                marketIndex,
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
      Js.log({"SRIB": 1});

      let mintStake =
        mintAndStakeDirect(
          ~marketIndex,
          ~token=paymentToken,
          ~user=userToStakeWith,
          ~longShort,
          ~oracleManagerMock=oracleManager,
        );
      Js.log({"SRIB": 2});
      let%AwaitThen _ =
        mintStake(~synthToken=longSynth, ~amount=Helpers.randomTokenAmount());
      Js.log({"SRIB": 3});
      let%Await _ =
        mintStake(
          ~synthToken=shortSynth,
          ~amount=Helpers.randomTokenAmount(),
        );
      Js.log({"SRIB": 4});
      ();
    },
  );
