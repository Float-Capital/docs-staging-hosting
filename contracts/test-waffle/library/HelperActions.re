open LetOps;

let mintAndStake =
    (
      ~marketIndex,
      ~amount,
      ~token,
      ~user: Ethers.Wallet.t,
      ~longShort: Contract.LongShort.t,
      ~isLong: bool,
    ) => {
  let%Await _ =
    token->Contract.PaymentToken.mintAndApprove(
      ~amount,
      ~user,
      ~spender=longShort.address,
    );
  let contract = longShort->Contract.connect(~address=user);
  if (isLong) {
    contract->Contract.LongShort.mintLongAndStake(~marketIndex, ~amount);
  } else {
    contract->Contract.LongShort.mintShortAndStake(~marketIndex, ~amount);
  };
};

let stakeRandomlyInMarkets =
    (
      ~marketsToStakeIn: array(Helpers.markets),
      ~userToStakeWith: Ethers.Wallet.t,
      ~longShort: Contract.LongShort.t,
    ) =>
  marketsToStakeIn->Belt.Array.reduce(
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
      let%Await newSynthsUserHasStakedIn =
        switch (Helpers.randomMintLongShort()) {
        | Long(amount) =>
          let%Await _ = mintStake(~isLong=true, ~amount);
          synthsUserHasStakedIn->Array.concat([|longSynth|]);
        | Short(amount) =>
          let%Await _ = mintStake(~isLong=false, ~amount);
          synthsUserHasStakedIn->Array.concat([|shortSynth|]);
        | Both(longAmount, shortAmount) =>
          let%AwaitThen _ = mintStake(~isLong=true, ~amount=longAmount);
          let%Await _ = mintStake(~isLong=false, ~amount=shortAmount);
          synthsUserHasStakedIn->Array.concat([|shortSynth, longSynth|]);
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
      ~longShort: Contract.LongShort.t,
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
