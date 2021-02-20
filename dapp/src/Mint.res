module Mint = {
  @react.component
  let make = () => {
    let router = Next.Router.useRouter()
    let markets = Queries.MarketDetails.use()
    let marketIndex = router.query->Js.Dict.get("marketIndex")->Option.getWithDefault("1")
    <AccessControl
      alternateComponent={<h1 onClick={_ => router->Next.Router.push("/login?nextPath=/mint")}>
        {"login to view this"->React.string}
      </h1>}>
      <section>
        {switch markets {
        | {loading: true} => <Loader />
        | {error: Some(_error)} => "Error loading data"->React.string
        | {data: Some({syntheticMarkets})} =>
          let optFirstMarket =
            syntheticMarkets[marketIndex->Belt.Int.fromString->Option.getWithDefault(1) - 1]
          switch optFirstMarket {
          | Some(firstMarket) => <MintForm market={firstMarket} />
          | None => <p> {"No markets exist"->React.string} </p>
          }
        | {data: None, error: None, loading: false} =>
          "You might think this is impossible, but depending on the situation it might not be!"->React.string
        }}
      </section>
    </AccessControl>
  }
}
let default = () => <Mint />
