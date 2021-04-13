// EXAMPLE component that automatically updates some basic user data via direct cache modification.
//         A poll query asks the graph every 3 seconds if there is a change. When there is a change it takes that data and directly modifies the cache.
open Globals

let queryLatestStateChanges = (~client: ApolloClient__Core_ApolloClient.t, ~pollVariables) => {
  client.query(~query=module(Queries.StateChangePoll), ~fetchPolicy=NetworkOnly, pollVariables)
}

module TestTxButton = {
  @react.component
  let make = () => {
    let signer = ContractActions.useSignerExn()
    let (contractExecutionHandler, _txState, _setTxState) = ContractActions.useContractFunction(
      ~signer,
    )
    <button
      onClick={_ => {
        contractExecutionHandler(
          ~makeContractInstance=Contracts.LongShort.make(~address=Config.longShort),
          ~contractFunction=Contracts.LongShort.mintShortAndStake(
            ~marketIndex=3->Ethers.BigNumber.fromInt,
            ~amount=Ethers.Utils.parseEther(~amount="1")->Obj.magic,
          ),
        )
      }}>
      {">>Make test transaction<<"->React.string}
    </button>
  }
}

module ExampleStateUpdates = {
  @react.component
  let make = () => {
    let (latestStateChangeTimestamp, _setLatestStateChangeTimestamp) = React.useState(_ =>
      Misc.Time.getCurrentTimestamp()->Ethers.BigNumber.fromInt
    )

    let optCurrentUser = RootProvider.useCurrentUser()

    let basicUserQuery = Queries.UserQuery.use({
      userId: optCurrentUser->Option.mapWithDefault(
        "0x374252d2c9f0075b7e2ca2a9868b44f1f62fba80" /* Just a random address so we don't need to conditionally run this query */,
        ethAdrToLowerStr,
      ),
    })

    let lastChangeJsDate =
      latestStateChangeTimestamp->Ethers.BigNumber.toNumberFloat->DateFns.fromUnixTime

    <>
      <div>
        {`Latest timestamp: ${lastChangeJsDate->DateFns.format(
            "PPPppp",
          )} (${lastChangeJsDate->DateFns.formatDistanceToNow} ago)`->React.string}
      </div>
      <hr />
      <hr />
      <hr />
      <div>
        {switch optCurrentUser {
        | Some(_) =>
          switch basicUserQuery {
          | {data: Some({user: Some({numberOfTransactions, totalGasUsed})})} => <>
              {`you have done ${numberOfTransactions->Ethers.BigNumber.toString} transactions and used ${totalGasUsed->Ethers.BigNumber.toString} in the float platform`->React.string}
            </>
          | {error: Some(_)} => "Error loading users float interaction data"->React.string
          | _ => "Loading users float interaction data"->React.string
          }
        | None => "Your data will load once you log in"->React.string
        }}
      </div>
      <AccessControl
        alternateComponent={<h1> {"LOGIN TO MAKE TEST TRANSACTIONS"->React.string} </h1>}>
        <TestTxButton />
      </AccessControl>
    </>
  }
}

let default = () => <ExampleStateUpdates />
