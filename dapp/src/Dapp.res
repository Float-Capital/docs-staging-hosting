let shortTokenAddress = Ethers.Utils.getAddressUnsafe("0x096c8301e153037df723c23e2de113941cb973ef")
let longTokenAddress = Ethers.Utils.getAddressUnsafe("0x096c8301e153037df723c23e2de113941cb973ef")

module Dapp = {
  @react.component
  let make = () => {
    let router = Next.Router.useRouter()
    let markets = Queries.MarketDetails.use()

    <AccessControl
      alternateComponent={<h1 onClick={_ => router->Next.Router.push("/login?nextPath=/dashboard")}>
        {"login to view this"->React.string}
      </h1>}>
      <section>
        {switch markets {
        | {loading: true} => <Loader />
        | {error: Some(_error)} => "Error loading data"->React.string
        | {data: Some({syntheticMarkets})} =>
          let firstMarket = syntheticMarkets->Array.getUnsafe(0)
          <TradeForm market={firstMarket} />
        | {data: None, error: None, loading: false} =>
          "You might think this is impossible, but depending on the situation it might not be!"->React.string
        }}
      </section>
    </AccessControl>
  }
}
let default = () => <Dapp />
