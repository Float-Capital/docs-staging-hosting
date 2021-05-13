module Await = {
  let let_ = (prom, cb) => JsPromise.then_(prom, cb);
}
module AwaitM = {
  let let_ = (prom, cb) => JsPromise.map(prom, cb);
}
let test = (markets: array(Helpers.markets), accounts, contracts:Helpers.coreContracts, done_) => {
  let testUser = accounts->Array.getUnsafe(1)
  let {longShort, markets, staker} = contracts
  let synthsUserHasStaked = ref([||])
  let marketsUserHasStakedIn = ref([||])


  let%AwaitM thing = markets
  ->Array.map(({paymentToken, longSynth, shortSynth, marketIndex}) => {
    let mintStake = Helpers.mintAndStake(
      ~marketIndex,
      ~token=paymentToken,
      ~user=testUser,
      ~longShort,
    )
    marketsUserHasStakedIn := marketsUserHasStakedIn.contents->Array.concat([|marketIndex|])
    switch (Helpers.randomMintLongShort()) {
    | Long(amount) =>
      synthsUserHasStaked := synthsUserHasStaked.contents->Array.concat([|longSynth|])
      mintStake(~isLong=true, ~amount)
    | Short(amount) =>
      synthsUserHasStaked := synthsUserHasStaked.contents->Array.concat([|shortSynth|])
      mintStake(~isLong=false, ~amount)
    | Both(longAmount, shortAmount) =>
      synthsUserHasStaked :=
        synthsUserHasStaked.contents->Array.concat([|shortSynth, shortSynth|])
      mintStake(~isLong=true, ~amount=longAmount)->JsPromise.then_(_ =>
        mintStake(~isLong=false, ~amount=shortAmount)
      )
    }
  })->JsPromise.all;
  // let other = thing ++ "string"
  // ->JsPromise.then(_ => {
  let%AwaitM another = staker->Contract.Staker.claimFloatCustomUser(
    ~user=testUser,
    ~syntheticTokens=synthsUserHasStaked.contents,
    ~markets=marketsUserHasStakedIn.contents,
  )
  // })
  // ->JsPromise.map(_ => {
  let%AwaitM other = synthsUserHasStaked.contents
  ->Array.map(synth => {
    JsPromise.all2((
      staker->Contract.Staker.userIndexOfLastClaimedReward(
        ~synthTokenAddr=synth.address,
        ~user=testUser.address,
      ),
      staker->Contract.Staker.latestRewardIndex(~synthTokenAddr=synth.address),
    ))->JsPromise.map(((userLastClaimed, latestRewardIndex)) =>
      Chai.bnEqual(userLastClaimed, latestRewardIndex)
    )
  })
  ->JsPromise.all

  done_()
}
