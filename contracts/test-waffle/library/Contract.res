open ContractHelpers

module PaymentTokenHelpers = {
  let mintAndApprove = (
    t: ERC20Mock.t,
    ~user: Ethers.Wallet.t,
    ~amount: Ethers.BigNumber.t,
    ~spender: Ethers.ethAddress,
  ) =>
    t
    ->ERC20Mock.mint(~amount, ~_to=user.address)
    ->JsPromise.then(_ => {
      t->connect(~address=user)->ERC20Mock.approve(~amount, ~spender)
    })
}

module DataFetchers = {
  let marketIndexOfSynth = (longShort: LongShort.t, ~syntheticToken: SyntheticToken.t): JsPromise.t<
    int,
  > =>
    longShort
    ->LongShort.staker
    ->JsPromise.then(Staker.at)
    ->JsPromise.then(Staker.marketIndexOfToken(_, syntheticToken.address))
}
