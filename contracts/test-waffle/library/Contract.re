open ContractHelpers;
open Globals;
open LetOps;

module PaymentTokenHelpers = {
  let mintAndApprove =
      (
        t: ERC20Mock.t,
        ~user: Ethers.Wallet.t,
        ~amount: Ethers.BigNumber.t,
        ~spender: Ethers.ethAddress,
      ) =>
    t
    ->ERC20Mock.mint(~amount, ~_to=user.address)
    ->JsPromise.then_(_ => {
        t->connect(~address=user)->ERC20Mock.approve(~amount, ~spender)
      });
};

module DataFetchers = {
  let marketIndexOfSynth =
      (longShort: LongShort.t, ~syntheticToken: SyntheticToken.t)
      : JsPromise.t(int) =>
    longShort
    ->LongShort.staker
    ->JsPromise.then_(Staker.at)
    ->JsPromise.then_(Staker.marketIndexOfToken(_, syntheticToken.address));
};

module LongShortHelpers = {
  let getFeesMint =
      (longShort, ~marketIndex, ~amount, ~valueInEntrySide, ~valueInOtherSide) => {
    // let%AwaitThen baseEntryFee =
    //   longShort->LongShort.baseEntryFee(marketIndex);
    let%AwaitThen badLiquidityEntryFee =
      longShort->LongShort.badLiquidityEntryFee(marketIndex);

    let%Await feeUnitsOfPrecision = longShort->LongShort.feeUnitsOfPrecision;

    let baseFee = bnFromInt(0); //amount->mul(baseEntryFee)->div(feeUnitsOfPrecision);
    if (valueInEntrySide->bnGte(valueInOtherSide)) {
      // All funds are causing imbalance
      baseFee->add(
        amount->mul(badLiquidityEntryFee)->div(feeUnitsOfPrecision),
      );
    } else if (valueInEntrySide->add(amount)->bnGt(valueInOtherSide)) {
      let amountImbalancing =
        amount->sub(valueInOtherSide->sub(valueInEntrySide));
      let penaltyFee =
        amountImbalancing
        ->mul(badLiquidityEntryFee)
        ->div(feeUnitsOfPrecision);

      baseFee->add(penaltyFee);
    } else {
      baseFee;
    };
  };
  let getFeesRedeemLazy =
      (
        longShort,
        ~marketIndex,
        ~amount,
        ~valueInRemovalSide,
        ~valueInOtherSide,
      ) => {
    let%AwaitThen badLiquidityExitFee =
      longShort->LongShort.badLiquidityExitFee(marketIndex);

    let%Await feeUnitsOfPrecision = longShort->LongShort.feeUnitsOfPrecision;

    let baseFee = CONSTANTS.zeroBn;
    if (valueInOtherSide->bnGte(valueInRemovalSide)) {
      // All funds are causing imbalance
      baseFee->add(
        amount->mul(badLiquidityExitFee)->div(feeUnitsOfPrecision),
      );
    } else if (valueInOtherSide->add(amount)->bnGt(valueInRemovalSide)) {
      let amountImbalancing =
        amount->sub(valueInRemovalSide->sub(valueInOtherSide));
      let penaltyFee =
        amountImbalancing
        ->mul(badLiquidityExitFee)
        ->div(feeUnitsOfPrecision);

      baseFee->add(penaltyFee);
    } else {
      baseFee;
    };
  };
  type marketBalance = {
    longValue: Ethers.BigNumber.t,
    shortValue: Ethers.BigNumber.t,
  };
  let getMarketBalance = (longShort, ~marketIndex) => {
    let%AwaitThen longValue =
      longShort->LongShort.syntheticTokenPoolValue(
        marketIndex,
        true/*long*/,
      );
    let%Await shortValue =
      longShort->LongShort.syntheticTokenPoolValue(
        marketIndex,
        false/*short*/,
      );
    {longValue, shortValue};
  };
};

module SyntheticTokenHelpers = {
  let getIsLong = synthToken => {
    let%Await isLong =
      synthToken->SyntheticToken.isLong;
    isLong == true/*long*/;
  };
};
