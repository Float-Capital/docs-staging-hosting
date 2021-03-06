/* NOTE:

This context provides the very initial steps how to keep state fresh in the UI of the app.

General idea, libraries such as SWR (just an example) allow you to only re-fetch data when a value changes.
This provider exposes a hook `useDataFreshnessString()` that provides such a string for use throughout the application so data is only updated when it changes.

Over time the strategy for keeping data fresh can become more refined.
The initial version is to reload all data every time a 'state change' happens on the contracts of the system.
Over time, this can be refined to only reload when it is needed (eg. only reload if data related to the current user changes, or fragment into multiple data freshness strings).

Is this the best way to do things? - definitely not, but it is a sure way to get things working predictably and simply.

Future plans - an better approach would be to poll the graph for 'state changes' that effect the user that are more recent than the timestamp of the most recent 'state change' and then update the apollo cache directly with the changes directly. (see docs: https://www.apollographql.com/docs/react/caching/cache-interaction/#cachemodify) If this were successful, re-fetching queries wouldn't be necessary from the graph.

Another approach - use re-fetch callbacks on actions that the user makes. Basic idea, whenever the user makes a contract call that is expected to change contract state (that requires data to be refreshed). This is a great approach, but reliability and code complexity are the biggest concerns.

Related to re-fetch callbacks are optimistic updates (we update the data how we think the users action will affect the state before the action is completed). These may be useful to add in some niche circumstances, but it isn't a substitute for correctly updating the data from a reliable source.
*/

let initialDataFreshnessId = "refetchString"
let context = React.createContext(initialDataFreshnessId)

let provider = React.Context.provider(context)

module LatestStateChange = %graphql(`
{
  stateChanges (first: 1, orderBy: timestamp, orderDirection:desc) {
    id
  }
}
`)

@ocaml.doc("This component is a context that is responsible for managing state changes")
@react.component
let make = (~children) => {
  let ((currentDataFreshnessId, nextDataFreshnessId), setDataFreshnessId) = React.useState(_ => (
    initialDataFreshnessId,
    initialDataFreshnessId,
  ))
  let (executeQuery, queryResult) = LatestStateChange.useLazy(~fetchPolicy=CacheAndNetwork, ())
  let isLoggedIn = RootProvider.useIsLoggedIn()

  React.useEffect1(() => {
    switch queryResult {
    | Executed({data: Some({stateChanges: [{id}]})}) =>
      if id != nextDataFreshnessId {
        setDataFreshnessId(_ => (nextDataFreshnessId, id))
      }
    | Unexecuted(_)
    | Executed(_) => ()
    }

    None
  }, [queryResult])

  // React.useEffect1(() => {
  //   if isLoggedIn {
  //     // Fetch the latest data initially on load.
  //     executeQuery()

  //     // seems reasonable since blocktimes on binance are 3 seconds
  //     //   -- might be worth moving to block-polling from ethers.js: https://docs.ethers.io/v5/api/providers/provider/#Provider--events
  //     let interval = Js.Global.setInterval(() => executeQuery(), 3000)

  //     Some(() => Js.Global.clearInterval(interval))
  //   } else {
  //     None
  //   }
  // }, [isLoggedIn])

  React.createElement(provider, {"value": currentDataFreshnessId, "children": children})
}

let useDataFreshnessString = () => React.useContext(context)
