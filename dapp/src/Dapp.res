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
        // <div className="screen-centered-container">
        //   <div className="trade-form">
        //     <h2> {"FTSE 100"->React.string} </h2>
        //     <select name="longshort" className="trade-select">
        //       <option value="long"> {`Long 🐮`->React.string} </option>
        //       <option value="short"> {`Short 🐻`->React.string} </option>
        //     </select>
        //     {isMint
        //       ? <input className="trade-input" placeholder="mint" />
        //       : <input className="trade-input" placeholder="redeem" />}
        //     <div className="trade-switch" onClick={_ => setIsMint(_ => !isMint)}>
        //       {j`↑↓`->React.string}
        //     </div>
        //     {isMint
        //       ? <input className="trade-input" placeholder="redeem" />
        //       : <input className="trade-input" placeholder="mint" />}
        //     <button className="trade-action"> {"OPEN POSITION"->React.string} </button>
        //   </div>
        // </div>
        // <br />
        // <br />
        // <br />
        // <br />
        // <br />
        // <br />
        // <br />
        // <br />
        // <h1> {"Dapp"->React.string} </h1>
        // <ApproveDai />
        // <hr />
        // <MintLong />
        // <hr />
        // <RedeemLong longTokenAddress />
        // <hr />
        // <MintShort shortTokenAddress />
        // <hr />
        // <RedeemShort shortTokenAddress />
        // <hr />
        // <UpdateSystemState />
      </section>
    </AccessControl>
  }
}
let default = () => <Dapp />
