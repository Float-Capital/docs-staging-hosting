@react.component
let make = () => {
  let marketDetailsQuery = DataHooks.useGetMarkets()
  let stakeApys = DataHooks.useStakingAPYs()

  <div className="w-full max-w-5xl mx-auto px-2 md:px-0">
    {switch marketDetailsQuery {
    | Response(syntheticMarkets) =>
      <div>
        {syntheticMarkets
        ->Array.map(syntheticMarket =>
          <StakeCard key={syntheticMarket.name} syntheticMarket _stakeApys={stakeApys} />
        )
        ->React.array}
      </div>
    | GraphError(msg) => `Error: ${msg}`->React.string
    | Loading => <div className="m-auto"> <Loader.Mini /> </div>
    }}
  </div>
}
