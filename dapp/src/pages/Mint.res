module DetailsWrapper = {
  @react.component
  let make = (~market: Queries.SyntheticMarketInfo.t, ~marketIndex, ~actionOption, ~children) =>
    <div className="max-w-xl mx-auto">
      <Next.Link href="/app/markets">
        <div className="uppercase text-sm text-gray-600 hover:text-gray-500 cursor-pointer mb-2">
          {`◀`->React.string}
          <span className="text-xxs"> {" Back to markets"->React.string} </span>
        </div>
      </Next.Link>
      <div className="p-5 rounded-lg flex flex-col bg-white bg-opacity-70 shadow-lg">
        <div className="flex justify-between items-center mb-2">
          <div className="text-xl"> {`${market.name} (${market.symbol})`->React.string} </div>
          <Next.Link href={`/?marketIndex=${marketIndex}&actionOption=${actionOption}`}>
            <div className="text-xxs hover:underline cursor-pointer">
              {`view details`->React.string}
            </div>
          </Next.Link>
        </div>
        {children}
      </div>
    </div>
}

@react.component
let make = (~withHeader=true) => {
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
        withHeader
          ? <DetailsWrapper market=firstMarket marketIndex actionOption>
              <MintForm market={firstMarket} isLong={actionOption == "short" ? false : true} />
            </DetailsWrapper>
          : <MintForm market={firstMarket} isLong={actionOption == "short" ? false : true} />
      | None => <p> {"No markets exist"->React.string} </p>
      }
    | {data: None, error: None, loading: false} =>
      "You might think this is impossible, but depending on the situation it might not be!"->React.string
    }}
  </section>
}

let default = make
