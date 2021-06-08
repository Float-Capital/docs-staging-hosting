open LetOps;

let mintAndStake =
    (
      ~marketIndex,
      ~amount,
      ~token,
      ~user: Ethers.Wallet.t,
      ~longShort: LongShort.t,
      ~isLong: bool,
    ) => {
  let%Await _ =
    token->Contract.PaymentTokenHelpers.mintAndApprove(
      ~amount,
      ~user,
      ~spender=longShort.address,
    );
  let contract = longShort->ContractHelpers.connect(~address=user);
  if (isLong) {
    contract->LongShort.mintLongAndStake(~marketIndex, ~amount);
  } else {
    contract->LongShort.mintShortAndStake(~marketIndex, ~amount);
  };
};

type marketBalance = {
  longValue: Ethers.BigNumber.t,
  shortValue: Ethers.BigNumber.t,
};
let getMarketBalance = (longShort, ~marketIndex) => {
  let%AwaitThen longValue =
    longShort->LongShort.syntheticTokenBackedValue(
      CONSTANTS.longTokenType,
      marketIndex,
    );
  let%Await shortValue =
    longShort->LongShort.syntheticTokenBackedValue(
      CONSTANTS.shortTokenType,
      marketIndex,
    );
  {longValue, shortValue};
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
      (currentValues, {paymentToken, longSynth, shortSynth, marketIndex}) => {
        let%AwaitThen (synthsUserHasStakedIn, marketsUserHasStakedIn) = currentValues;
        let mintStake =
          mintAndStake(
            ~marketIndex,
            ~token=paymentToken,
            ~user=userToStakeWith,
            ~longShort,
          );

        let%AwaitThen {
          longValue: valueLongBefore,
          shortValue: valueShortBefore,
        } =
          longShort->getMarketBalance(~marketIndex);

        let%Await newSynthsUserHasStakedIn =
          switch (Helpers.randomMintLongShort()) {
          | Long(amount) =>
            let%AwaitThen _ = mintStake(~isLong=true, ~amount);
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
            let%AwaitThen _ = mintStake(~isLong=false, ~amount);

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
            let%AwaitThen _ = mintStake(~isLong=true, ~amount=longAmount);
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
              longShort->getMarketBalance(~marketIndex);
            let%AwaitThen _ = mintStake(~isLong=false, ~amount=shortAmount);
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
    (prevPromise, {paymentToken, marketIndex}) => {
      let%AwaitThen _ = prevPromise;

      let mintStake =
        mintAndStake(
          ~marketIndex,
          ~token=paymentToken,
          ~user=userToStakeWith,
          ~longShort,
        );
      let%AwaitThen _ =
        mintStake(~isLong=true, ~amount=Helpers.randomTokenAmount());
      let%Await _ =
        mintStake(~isLong=false, ~amount=Helpers.randomTokenAmount());
      ();
    },
  );
