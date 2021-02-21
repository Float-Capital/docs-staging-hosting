module Redeem = {
  @react.component
  let make = () => {
    let router = Next.Router.useRouter()
    let markets = Queries.MarketDetails.use()

    <AccessControl
      alternateComponent={<h1 onClick={_ => router->Next.Router.push("/login?nextPath=/redeem")}>
        <Login />
      </h1>}>
      <section>
        {switch markets {
        | {loading: true} => <Loader />
        | {error: Some(_error)} => "Error loading data"->React.string
        | {data: Some({syntheticMarkets})} =>
          let optFirstMarket = syntheticMarkets[0]
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
let default = () => <Redeem />
