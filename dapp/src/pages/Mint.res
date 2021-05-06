module DetailsWrapper = {
  @react.component
  let make = (~market: Queries.SyntheticMarketInfo.t, ~children) =>   <div
      className="p-5 rounded-lg max-w-xl mx-auto flex flex-col bg-white bg-opacity-70 shadow-lg">
      <div className="flex justify-between mb-2 text-xl">
      {`${market.name} (${market.symbol})`->React.string}
    </div>
          {children}
          </div>
}


module Mint ={
  @react.component
  let make = (~withHeader) => {
    let router = Next.Router.useRouter()
    let markets = Queries.MarketDetails.use()
    let marketIndex = router.query->Js.Dict.get("marketIndex")->Option.getWithDefault("1")
    let actionOption = router.query->Js.Dict.get("actionOption")->Option.getWithDefault("short")

    <section className="h-full px-6">
      {switch markets {
      | {loading: true} => <Loader />
      | {error: Some(_error)} => "Error loading data"->React.string
      | {data: Some({syntheticMarkets})} =>
        let optFirstMarket =
          syntheticMarkets[marketIndex->Belt.Int.fromString->Option.getWithDefault(1) - 1]
        switch optFirstMarket {
        | Some(firstMarket) => 
        withHeader ?
        <DetailsWrapper market=firstMarket>
          <MintForm market={firstMarket} isLong={actionOption == "short" ? false : true} />  
          </DetailsWrapper>
          :
          <MintForm market={firstMarket} isLong={actionOption == "short" ? false : true} />  
        | None => <p> {"No markets exist"->React.string} </p>
        }
      | {data: None, error: None, loading: false} =>
        "You might think this is impossible, but depending on the situation it might not be!"->React.string
      }}
    </section>
  }
  }

let default = () => <Mint withHeader={true} />
