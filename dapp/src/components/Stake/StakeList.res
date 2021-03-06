@react.component
let make = () => {
  let router = Next.Router.useRouter()
  let stakeDetailsQuery = Queries.StakingDetails.use()

  <AccessControl
    alternateComponent={<h1 onClick={_ => router->Next.Router.push("/login?nextPath=/dashboard")}>
      <Login />
    </h1>}>
    <div className="w-full max-w-4xl mx-auto">
      {switch stakeDetailsQuery {
      | {loading: true} => <div className="m-auto"> <MiniLoader /> </div>
      | {error: Some(_error)} => "Error loading data"->React.string
      | {data: Some({syntheticMarkets})} => <>
          {syntheticMarkets
          ->Array.map(({
            name,
            timestampCreated,
            latestSystemState: {
              timestamp,
              totalLockedLong,
              totalLockedShort,
              longTokenPrice,
              shortTokenPrice,
            },
            syntheticShort: {shortTotalStaked, shortTokenAddress},
            syntheticLong: {longTotalStaked, longTokenAddress},
          }) =>
            <StakeCard
              key={name}
              marketName={name}
              totalLockedLong={totalLockedLong}
              totalLockedShort={totalLockedShort}
              router={router}
              longTokenPrice={longTokenPrice}
              shortTokenPrice={shortTokenPrice}
              longStaked={longTotalStaked}
              shortStaked={shortTotalStaked}
              shortAddress={shortTokenAddress}
              longAddress={longTokenAddress}
              currentTimestamp={timestamp}
              createdTimestamp={timestampCreated}
            />
          )
          ->React.array}
        </>
      | {data: None, error: None, loading: false} =>
        "You might think this is impossible, but depending on the situation it might not be!"->React.string
      }}
    </div>
  </AccessControl>
}
