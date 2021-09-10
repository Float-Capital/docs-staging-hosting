@react.component
let make = () => {
  let globalStateQuery = Queries.GlobalState.use()
  let marketDetailsQuery = Queries.MarketDetails.use()

  <div className="flex flex-col overflow-x-hidden">
    {switch (globalStateQuery, marketDetailsQuery) {
    | ({loading: true}, _)
    | (_, {loading: true}) =>
      <Loader.Mini />
    | ({error: Some(_error)}, _)
    | (_, {error: Some(_error)}) =>
      "Error loading data"->React.string
    | (
        {
          data: Some({
            globalStates: [{totalFloatMinted, totalUsers, timestampLaunched, txHash} as global],
          }),
        },
        {data: Some({syntheticMarkets})},
      ) =>
      let {totalValueLocked, totalValueStaked} = StatsCalcs.getTotalValueLockedAndTotalStaked(
        syntheticMarkets,
      )
      let totalSynthValue = StatsCalcs.getTotalSynthValue(~totalValueLocked, ~totalValueStaked)
      let numberOfSynths = (syntheticMarkets->Array.length * 2)->Int.toString

      <div className="w-full max-w-7xl flex flex-col self-center items-center justify-start">
        <TotalValueCard totalValueLocked />
        <div className={"w-full flex flex-col md:flex-row justify-between"}>
          <div className={"w-full md:w-1/3 px-3 md:px-0 m-0 md:m-4"}>
            <FloatProtocolHighlightsCard
              liveSince=timestampLaunched totalUsers txHash numberOfSynths
            />
          </div>
          <div className={"w-full md:w-1/3 px-3 md:px-0 m-0 md:m-4"}>
            <SyntheticAssetsHighlightCard totalSynthValue />
            <FloatTokenHighlightCard totalFloatMinted />
          </div>
          <div className={"w-full md:w-1/3 px-3 md:px-0 m-0 md:m-4"}>
            <StakeHighlightsCard totalValueStaked global />
          </div>
        </div>
      </div>

    | (_, {data: Some(_), error: None, loading: false})
    | ({data: Some(_), error: None, loading: false}, _) =>
      "Query returned wrong number of results"->React.string
    | (_, {data: None, error: None, loading: false}) => "Error getting data"->React.string
    }}
  </div>
}

let default = make
