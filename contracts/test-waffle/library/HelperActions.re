let stakeRandomlyInMarkets =
    (
      ~marketsToStakeIn: array(Helpers.markets),
      ~userToStakeWith: Ethers.Wallet.t,
      ~longShort: Contract.LongShort.t,
    ) =>
  marketsToStakeIn->Belt.Array.reduce(
    ([||], [||]),
    (
      (synthsUserHasStakedIn, marketsUserHasStakedIn),
      {paymentToken, longSynth, shortSynth, marketIndex},
    ) => {
      let mintStake =
        Helpers.mintAndStake(
          ~marketIndex,
          ~token=paymentToken,
          ~user=userToStakeWith,
          ~longShort,
        );
      let newSynthsUserHasStakedIn =
        switch (Helpers.randomMintLongShort()) {
        | Long(amount) =>
          let _ = mintStake(~isLong=true, ~amount);
          synthsUserHasStakedIn->Array.concat([|longSynth|]);
        | Short(amount) =>
          let _ = mintStake(~isLong=false, ~amount);
          synthsUserHasStakedIn->Array.concat([|shortSynth|]);
        | Both(longAmount, shortAmount) =>
          let _ =
            mintStake(~isLong=true, ~amount=longAmount)
            ->JsPromise.then_(_ =>
                mintStake(~isLong=false, ~amount=shortAmount)
              );
          synthsUserHasStakedIn->Array.concat([|shortSynth, shortSynth|]);
        };
      (
        newSynthsUserHasStakedIn,
        marketsUserHasStakedIn->Array.concat([|marketIndex|]),
      );
    },
  );
