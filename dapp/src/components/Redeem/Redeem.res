@react.component
let make = (~txState, ~setTxState, ~contractExecutionHandler) => {
  let router = Next.Router.useRouter()
  let markets = Queries.MarketDetails.use()
  let marketIndex = router.query->Js.Dict.get("marketIndex")->Option.getWithDefault("1")
  let actionOption = router.query->Js.Dict.get("actionOption")->Option.getWithDefault("short")

  <section className="h-full">
    {switch markets {
    | {loading: true} => <Loader />
    | {error: Some(_error)} => "Error loading data"->React.string
    | {data: Some({syntheticMarkets})} =>
      let optFirstMarket =
        syntheticMarkets[marketIndex->Belt.Int.fromString->Option.getWithDefault(1) - 1]
      switch optFirstMarket {
      | Some(firstMarket) =>
        <RedeemForm
          txState
          setTxState
          contractExecutionHandler
          market={firstMarket}
          isLong={actionOption->Js.String2.toLowerCase == "long"}
        />
      | None => <p> {"No markets exist"->React.string} </p>
      }
    | {data: None, error: None, loading: false} =>
      "You might think this is impossible, but depending on the situation it might not be!"->React.string
    }}
  </section>
}
