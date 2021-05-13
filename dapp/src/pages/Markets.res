module MarketsList = {
  @react.component
  let make = () => {
    let router = Next.Router.useRouter()
    let marketIndexOption = router.query->Js.Dict.get("marketIndex")
    let marketDetailsQuery = Queries.MarketDetails.use()

    <div className="w-full max-w-5xl mx-auto px-2 md:px-0">
      {switch marketDetailsQuery {
      | {loading: true} => <div className="m-auto"> <Loader.Mini /> </div>
      | {error: Some(_error)} => "Error loading data"->React.string
      | {data: Some({syntheticMarkets})} =>
        switch marketIndexOption {
        | Some(queryMarketIndex) =>
          if (
            queryMarketIndex->Belt.Int.fromString->Option.mapWithDefault(1000, x => x) <=
              syntheticMarkets->Belt.Array.length
          ) {
            let selectedMarketData =
              syntheticMarkets[
                queryMarketIndex->Belt.Int.fromString->Option.mapWithDefault(1000, x => x) - 1
              ]
            switch selectedMarketData {
            | Some(marketData) => <Market marketData />
            | None => React.null
            }
          } else {
            React.null
          }
        | None => <>
            {syntheticMarkets
            ->Array.map(marketData =>
              <div className="mb-4"> <MarketCard key={marketData.name} marketData /> </div>
            )
            ->React.array}
          </>
        }
      | {data: None, error: None, loading: false} => ""->React.string
      }}
    </div>
  }
}

let default = () => <MarketsList />
