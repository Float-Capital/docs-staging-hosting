@react.component
let make = () => {
  let router = Next.Router.useRouter()
  let marketIndexOption = router.query->Js.Dict.get("marketIndex")
  let marketDetailsQuery = Queries.MarketDetails.use()

  <div className="w-full mx-auto px-2 md:px-0 flex flex-row">
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
          ->Array.mapWithIndex((index, marketData) => {
            <div
              className={`max-w-lg min-w-340 mx-2 ${index == 1
                  ? "transform -translate-y-48 translate-x-16 "
                  : ""} ${index == 2 ? "transform translate-y-32 -translate-x-60" : ""}`}>
              <MarketCard.Mini key={marketData.name} marketData />
            </div>
          })
          ->React.array}
        </>
      }
    | {data: None, error: None, loading: false} => ""->React.string
    }}
  </div>
}

let default = make
