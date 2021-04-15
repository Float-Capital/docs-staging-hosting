@react.component
let make = () => {
  let stakeDetailsQuery = DataHooks.useGetStakes()
  let user = RootProvider.useCurrentUser()
  let currentBalancesOrAdrZeroBalances = DataHooks.useUsersBalances(
    ~userId=user->Option.getWithDefault(CONSTANTS.zeroAddress)->Ethers.Utils.ethAdrToLowerStr,
  )

  let optUserBalanceAddressSet = user->Option.mapWithDefault(
    {
      let none: option<DataHooks.graphResponse<HashSet.String.t>> = None
      none
    },
    _ =>
      switch currentBalancesOrAdrZeroBalances {
      | Response({balances}) =>
        Some(
          Response(
            balances->Array.reduce(HashSet.String.fromArray([]), (set, balance) => {
              let _ =
                balance.tokenBalance->Ethers.BigNumber.gt(CONSTANTS.zeroBN)
                  ? set->HashSet.String.add(balance.addr->Ethers.Utils.ethAdrToStr)
                  : ()
              set
            }),
          ),
        )
      | Loading => Some(Loading)
      | GraphError(s) => Some(GraphError(s))
      },
  )

  <div className="w-full max-w-5xl mx-auto px-2 md:px-0">
    {switch stakeDetailsQuery {
    | Response(syntheticMarkets) =>
      <div>
        {syntheticMarkets
        ->Array.map(syntheticMarket =>
          <StakeCard key={syntheticMarket.name} syntheticMarket optUserBalanceAddressSet />
        )
        ->React.array}
      </div>
    | GraphError(msg) => `Error: ${msg}`->React.string
    | Loading => <div className="m-auto"> <MiniLoader /> </div>
    }}
  </div>
}
