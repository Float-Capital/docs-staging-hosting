@react.component
let make = () => {
  let stakeDetailsQuery = DataHooks.useGetStakes()

  <div className="w-full max-w-4xl mx-auto">
    {switch stakeDetailsQuery {
    | Response(syntheticMarkets) =>
      <div>
        {syntheticMarkets
        ->Array.map(syntheticMarket => <StakeCard key={syntheticMarket.name} syntheticMarket />)
        ->React.array}
      </div>
    | GraphError(msg) => `Error: ${msg}`->React.string
    | Loading => <div className="m-auto"> <MiniLoader /> </div>
    }}
  </div>
}
