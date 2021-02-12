@react.component
let make = () => {
  let router = Next.Router.useRouter()

  <AccessControl
    alternateComponent={<h1 onClick={_ => router->Next.Router.push("/login?nextPath=/dashboard")}>
      {"Login to view your dashboard"->React.string}
    </h1>}>
    <h1> {"Dashboard"->React.string} </h1>
    <DaiBalance />
    {switch Queries.LatestSystemState.use() {
    | {loading: true} => "Loading..."->React.string
    | {error: Some(_error)} => "Error loading data"->React.string
    | {
        data: Some({
          systemStates: [
            {
              timestamp,
              txHash,
              // blockNumber,
              syntheticPrice,
              longTokenPrice,
              shortTokenPrice,
              totalLockedLong,
              totalLockedShort,
              totalValueLocked,
              setBy,
            },
          ],
        }),
      } =>
      let timeSinceUpdate =
        timestamp->Ethers.BigNumber.toNumberFloat->DateFns.fromUnixTime->DateFns.formatDistanceToNow
      <>
        <a href={`https://goerli.etherscan.io/tx/${txHash}`}>
          {`Latest update happened ${timeSinceUpdate} ago. (view on block-explorer) by ${setBy}`->React.string}
        </a>
        <p> {`SyntheticPrice ${syntheticPrice->Ethers.Utils.formatEther}$`->React.string} </p>
        <p> {`Long Token Price ${longTokenPrice->Ethers.Utils.formatEther}$`->React.string} </p>
        <p> {`Short Token Price ${shortTokenPrice->Ethers.Utils.formatEther}$`->React.string} </p>
        <p> {`Total locked long ${totalLockedLong->Ethers.Utils.formatEther}$`->React.string} </p>
        <p> {`Total Locked Short ${totalLockedShort->Ethers.Utils.formatEther}$`->React.string} </p>
        <p> {`Total Locked ${totalValueLocked->Ethers.Utils.formatEther}$`->React.string} </p>
        <p> {"TODO:"->React.string} </p>
        <p> {"show the ratio of long to short in the same chart"->React.string} </p>
        <p> {"show historic returns of long asset (history APY)"->React.string} </p>
        <p> {"show current APY on opposing side (probably short)"->React.string} </p>
      </>
    | {data: Some(_), error: None, loading: false} =>
      "Query returned wrong number of results"->React.string
    | {data: None, error: None, loading: false} =>
      "You might think this is impossible, but depending on the situation it might not be!"->React.string
    }}
    {switch Queries.MarketDetails.use() {
    | {loading: true} => "Loading..."->React.string
    | {error: Some(_error)} => "Error loading data"->React.string
    | {data: Some({syntheticMarkets})} => <>
        <h1> {"Markets"->React.string} </h1>
        {syntheticMarkets
        ->Array.map(({
          name,
          symbol,
          // marketIndex,
          // totalValueLockedInMarket,
          // oracleAddress,
          // syntheticLong: {
          //   id: idLong,
          //   tokenAddress: tokenAddressLong,
          //   totalValueLocked: totalValueLockedLong,
          //   tokenSupply: tokenSupplyLong,
          //   tokenPrice: tokenPriceLong,
          // },
          // syntheticShort: {
          //   id: idShort,
          //   tokenAddress: tokenAddressShort,
          //   totalValueLocked: totalValueLockedShort,
          //   tokenSupply: tokenSupplyShort,
          //   tokenPrice: tokenPriceShort,
          // },
        }) => <div key=symbol> {name->React.string} </div>)
        ->React.array}
      </>
    | {data: None, error: None, loading: false} =>
      "You might think this is impossible, but depending on the situation it might not be!"->React.string
    }}
  </AccessControl>
}

let default = make
