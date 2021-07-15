@react.component
let make = () => {
  let marketDetailsQuery = Queries.MarketDetails.use()

  <div className="w-full mx-auto px-2 md:px-0 flex flex-col md:flex-row">
    {switch marketDetailsQuery {
    | {loading: true} => <div className="m-auto"> <Loader.Mini /> </div>
    | {error: Some(_error)} => "Error loading data"->React.string
    | {data: Some({syntheticMarkets})} => <>
        {syntheticMarkets
        ->Array.mapWithIndex((index, marketData) => {
          <div className="absolute right-10 bottom-10">
            <div
              className={`min-w-500 m-4 ${index == 0 ? "md:transform md:-translate-y-28 " : ""}
                 ${index == 1
                  ? "md:transform md:-translate-y-14 md:-translate-x-10 "
                  : ""} ${index == 2 ? "md:transform  md:-translate-x-20" : ""}`}>
              <Mint.DetailsWrapper
                market=marketData
                marketIndex={index->Belt.Int.toString}
                actionOption={"long"}
                view={Mint.LandingPage}>
                <MintForm market={marketData} isLong={true} />
              </Mint.DetailsWrapper>
            </div>
          </div>
        })
        ->React.array}
      </>
    | {data: None, error: None, loading: false} => ""->React.string
    }}
  </div>
}

let default = make
