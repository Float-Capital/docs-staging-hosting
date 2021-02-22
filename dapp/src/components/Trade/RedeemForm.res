// Wrote this code in less that 5 minutes, no UX thought put into it...
@react.component
let make = (~market: Queries.MarketDetails.MarketDetails_inner.t_syntheticMarkets) => {
  Js.log(("Market", market))
  let {Swr.data: optShortBalance} = ContractHooks.useErc20BalanceRefresh(
    ~erc20Address=market.syntheticShort.tokenAddress,
  )
  let {Swr.data: optLongBalance} = ContractHooks.useErc20BalanceRefresh(
    ~erc20Address=market.syntheticLong.tokenAddress,
  )
  let hasShortBalance =
    optShortBalance->Option.mapWithDefault(false, balance =>
      balance->Ethers.BigNumber.gt(Ethers.BigNumber.fromInt(0))
    )
  let hasLongBalance =
    optLongBalance->Option.mapWithDefault(false, balance =>
      balance->Ethers.BigNumber.gt(Ethers.BigNumber.fromInt(0))
    )

  switch (hasShortBalance, hasLongBalance) {
  | (true, true) => <>
      <RedeemSynth marketIndex=market.marketIndex isLong=true />
      <RedeemSynth marketIndex=market.marketIndex isLong=false />
    </>
  | (true, false) => <RedeemSynth marketIndex=market.marketIndex isLong=false />
  | (false, true) => <RedeemSynth marketIndex=market.marketIndex isLong=true />
  | (false, false) => "You don't have any tokens to redeem"->React.string
  }
}
