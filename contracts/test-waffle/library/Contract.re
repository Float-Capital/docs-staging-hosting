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
  type marketBalance = {
    longValue: Ethers.BigNumber.t,
    shortValue: Ethers.BigNumber.t,
  };
  let getMarketBalance = (longShort, ~marketIndex) => {
    let%AwaitThen longValue =
      longShort->LongShort.syntheticTokenPoolValue(
        marketIndex,
        true /*long*/,
      );
    let%Await shortValue =
      longShort->LongShort.syntheticTokenPoolValue(
        marketIndex,
        false /*short*/,
      );
    {longValue, shortValue};
  };
  let getSyntheticTokenPrice = (longShort, ~marketIndex, ~isLong) => {
    let%AwaitThen syntheticTokenAddress =
      longShort->LongShort.syntheticTokens(marketIndex, isLong);
    let%AwaitThen synthContract =
      ContractHelpers.attachToContract(
        "SyntheticToken",
        ~contractAddress=syntheticTokenAddress,
      );
    let%AwaitThen totalSupply =
      synthContract->Obj.magic->SyntheticToken.totalSupply;

    let%Await syntheticTokenPoolValue =
      longShort->LongShort.syntheticTokenPoolValue(marketIndex, isLong);

    let syntheticTokenPrice =
      syntheticTokenPoolValue->mul(CONSTANTS.tenToThe18)->div(totalSupply);

    syntheticTokenPrice;
  };
};

module SyntheticTokenHelpers = {
  let getIsLong = synthToken => {
    let%Await isLong = synthToken->SyntheticToken.isLong;
    isLong == true /*long*/;
  };
};
