@react.component
let make = () => {
  let stakeDetailsQuery = Queries.StakingDetails.use()

  <div className="w-full max-w-4xl mx-auto">
    {switch stakeDetailsQuery {
    | {loading: true} => <div className="m-auto"> <MiniLoader /> </div>
    | {error: Some(_error)} => "Error loading data"->React.string
    | {data: Some({syntheticMarkets})} => <>
        {syntheticMarkets
        ->Array.map(syntheticMarket => <StakeCard key={syntheticMarket.name} syntheticMarket />)
        ->React.array}
      </>
    | {data: None, error: None, loading: false} =>
      "You might think this is impossible, but depending on the situation it might not be!"->React.string
    }}
  </div>
}
