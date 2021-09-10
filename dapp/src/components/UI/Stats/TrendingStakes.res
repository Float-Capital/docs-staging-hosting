open APYProvider
@react.component
let make = (~global) => {
  let marketDetailsQuery = Queries.MarketDetails.use()
  let apy = APYProvider.useAPY()
  let bnApy = APYProvider.useBnApy()

  {
    switch marketDetailsQuery {
    | {loading: true} => <div className="m-auto"> <Loader.Mini /> </div>
    | {error: Some(_error)} => "Error loading data"->React.string
    | {data: Some({syntheticMarkets})} =>
      switch (apy, bnApy) {
      | (Loaded(apyVal), Loaded(bnApy)) => {
          let trendingStakes = StatsCalcs.trendingStakes(
            ~syntheticMarkets,
            ~apy=apyVal,
            ~global,
            ~bnApy,
          )
          trendingStakes
          ->Array.map(({marketName, isLong, apy, floatApy, stakeApy}) =>
            <StatsStakeCard
              marketName={marketName}
              isLong={isLong}
              yield={apy}
              rewards={floatApy}
              stakeYield={stakeApy}
              key={marketName ++ (isLong ? "-long" : "-short")}
            />
          )
          ->React.array
        }
      | _ => <Loader.Mini />
      }
    | {data: None, error: None, loading: false} =>
      "You might think this is impossible, but depending on the situation it might not be!"->React.string
    }
  }
}
