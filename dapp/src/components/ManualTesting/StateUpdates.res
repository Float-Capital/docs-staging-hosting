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
    let longShortAddress = Config.useLongShortAddress()
    <button
      onClick={_ => {
        contractExecutionHandler(
          ~makeContractInstance=Contracts.LongShort.make(~address=longShortAddress),
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
    let (latestStateChangeTimestamp, setLatestStateChangeTimestamp) = React.useState(_ =>
      Misc.Time.getCurrentTimestamp()->Ethers.BigNumber.fromInt
    )

    let optCurrentUser = RootProvider.useCurrentUser()

    let client = Client.useApolloClient()
    let basicUserQuery = Queries.UserQuery.use({
      userId: optCurrentUser->Option.mapWithDefault(
        "0x374252d2c9f0075b7e2ca2a9868b44f1f62fba80",
        ethAdrToLowerStr,
      ),
    })

    let handleQuery = currentUser => {
      let pollVariables = {
        Queries.StateChangePoll.userId: currentUser,
        timestamp: latestStateChangeTimestamp->GqlConverters.BigInt.serialize,
      }
      let _ = queryLatestStateChanges(~client, ~pollVariables)->JsPromise.map(queryResult => {
        switch queryResult {
        | Ok({data: {stateChanges: []}}) => ()
        | Ok({data: {stateChanges}}) =>
          let _ = stateChanges->Array.map(({timestamp, affectedUsers}) => {
            if timestamp->Ethers.BigNumber.gt(latestStateChangeTimestamp) {
              setLatestStateChangeTimestamp(_ => timestamp)
            }

            let _ = affectedUsers->Option.map(affectedUsers =>
              affectedUsers->Array.map(userData => {
                let _unusedRef = client.writeFragment(
                  ~fragment=module(Queries.BasicUserInfo),
                  ~data={
                    ...userData,
                    __typename: userData.__typename,
                  },
                  ~id=`User:${"0x374252d2c9f0075b7e2ca2a9868b44f1f62fba80"}`,
                  (),
                )
              })
            )
          })
        | Error(_) => ()
        }
      })
    }

    React.useEffect2(() => {
      switch optCurrentUser {
      | Some(currentUser) =>
        // polling interval of 3 seconds seems reasonable since blocktimes on binance are 3 seconds
        //   -- might be worth moving to block-polling from ethers.js: https://docs.ethers.io/v5/api/providers/provider/#Provider--events
        let interval = Js.Global.setInterval(() => handleQuery(currentUser->ethAdrToLowerStr), 3000)

        Some(() => Js.Global.clearInterval(interval))
      | None =>
        // Nothing on the website updates if the user isn't logged in... Might change this for specific things in the future (eg. gamification, interesting notifications etc)
        None
      }
    }, (optCurrentUser, latestStateChangeTimestamp))

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
        {switch basicUserQuery {
        | {data: Some({user: Some({numberOfTransactions, totalGasUsed})})} => <>
            {`you have done ${numberOfTransactions->Ethers.BigNumber.toString} transactions and used ${totalGasUsed->Ethers.BigNumber.toString} in the float platform`->React.string}
          </>
        | {error: Some(_)} => "Error loading users float data"->React.string
        | _ => "Loading total minted by user"->React.string
        }}
      </div>
      <AccessControl alternateComponent={<Login />}> <TestTxButton /> </AccessControl>
    </>
  }
}

let default = () => <ExampleStateUpdates />
