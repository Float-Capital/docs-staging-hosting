/* NOTE:

This context provides the very initial steps how to keep state fresh in the UI of the app.

For external APIs (rest apis):
General idea, libraries such as SWR (just an example) allow you to only re-fetch data when a value changes.
This provider exposes a hook `useDataFreshnessString()` that provides such a string for use throughout the application so data is only updated when it changes.

For graph data:
Poll the graph for 'state changes' that effect the user that are more recent than the timestamp of the most recent 'state change' and then update the apollo cache directly with the changes directly. (see docs: https://www.apollographql.com/docs/react/caching/cache-interaction/) 


Other Ideas (not implemented at all yet):
Refetch callbacks - on user actions that the user makes. Basic idea, whenever the user makes a contract call that is expected to change contract state (that requires data to be refreshed). This is a great approach, but reliability and code complexity are the biggest concerns.
Related to re-fetch callbacks are optimistic updates (we update the data how we think the users action will affect the state before the action is completed). These may be useful to add in some niche circumstances, but it isn't a substitute for correctly updating the data from a reliable source.
*/

open GqlConverters
open Globals

let queryLatestStateChanges = (~client: ApolloClient__Core_ApolloClient.t, ~pollVariables) => {
  client.query(~query=module(Queries.StateChangePoll), ~fetchPolicy=NetworkOnly, pollVariables)
}

let initialLatestStateChangeId = Misc.Time.getCurrentTimestamp()->Ethers.BigNumber.fromInt
let context = React.createContext(initialLatestStateChangeId->Ethers.BigNumber.toString)

let provider = React.Context.provider(context)

@ocaml.doc("This component is a context that is responsible for managing state changes")
@react.component
let make = (~children) => {
  let (latestStateChangeTimestamp, setLatestStateChangeTimestamp) = React.useState(_ =>
    initialLatestStateChangeId
  )

  let optCurrentUser = RootProvider.useCurrentUser()

  let client = Client.useApolloClient()

  let handleQuery = currentUser => {
    let pollVariables = {
      Queries.StateChangePoll.userId: currentUser,
      timestamp: latestStateChangeTimestamp->BigInt.serialize,
    }
    let _ = queryLatestStateChanges(~client, ~pollVariables)->JsPromise.map(queryResult => {
      switch queryResult {
      | Ok({data: {stateChanges: []}}) => ()
      | Ok({data: {stateChanges}}) =>
        let _ = stateChanges->Array.map(({timestamp, affectedUsers}) => {
          if timestamp->Ethers.BigNumber.gt(latestStateChangeTimestamp) {
            setLatestStateChangeTimestamp(_ => timestamp)
            // Update cache of values for all affected users
            let _ = affectedUsers->Option.map(users =>
              users->Array.map(({tokenBalances, basicUserInfo: {id}}) => {
                client.query(
                  ~query=module(Queries.UsersBalances),
                  {userId: id},
                )->JsPromise.map(usersBalances => {
                  switch usersBalances {
                  | Ok({data}) =>
                    Js.log2("This is the data", data)
                    ()
                  | Error(error) => Js.log(error)
                  }
                })
              })
            )
          }
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

  React.createElement(
    provider,
    {"value": latestStateChangeTimestamp->Ethers.BigNumber.toString, "children": children},
  )
}

let useDataFreshnessString = () => React.useContext(context)
