open GqlConverters

module LatestSystemState = %graphql(`
{
  systemStates (first:1, orderBy:timestamp, orderDirection: desc) {
    timestamp
    txHash 
    blockNumber
    syntheticPrice
    longTokenPrice
    shortTokenPrice
    totalLockedLong
    totalLockedShort
    totalValueLocked
    setBy
  }
}`)
// module LatestStateChanges = %graphql(`
// {
//   stateChanges (first:5, orderBy:timestamp, orderDirection: desc) {
//     txEventParamList {
//       eventName
//       index
//       params {
//         index
//         param
//         paramType
//       }
//     }
//   }
// }
// `)

module Access = {
  @react.component
  let make = (~children) => {
    let optUser = RootProvider.useCurrentUser()
    let router = Next.Router.useRouter()

    switch optUser {
    | None =>
      <h1 onClick={_ => router->Next.Router.push("/login?nextPath=/dashboard")}>
        {"Login to view your dashboard"->React.string}
      </h1>
    | Some(_user) => children
    }
  }
}
@react.component
let make = () => {
  <Access>
    <h1> {"Dashboard"->React.string} </h1>
    <DaiBalance />
    {switch LatestSystemState.use() {
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
  </Access>
}

let default = make
