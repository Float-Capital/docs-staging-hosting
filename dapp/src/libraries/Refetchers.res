// Refetch and write to state

let useRefetchLastOracleTimestamp = (~marketIndex, ~stateForRefetchExecution) => {
  let client = Client.useApolloClient()
  let reqVariables = {
    Queries.OraclesLastUpdate.marketIndex: marketIndex->Ethers.BigNumber.toString,
  }
  React.useEffect1(() => {
    let timeForGraphToUpdate = 1000 // Give the graph a chance to capture the data before making the request
    let timeout = Js.Global.setTimeout(() => {
      let _ = client.query(
        ~query=module(Queries.OraclesLastUpdate),
        ~fetchPolicy=NetworkOnly,
        reqVariables,
      )->JsPromise.map(queryResult => {
        switch queryResult {
        | Ok({data}) => {
            let _ = client.writeQuery(
              ~query=module(Queries.OraclesLastUpdate),
              ~data={
                underlyingPrices: data.underlyingPrices,
              },
            )
          }
        | _ => ()
        }
      })
    }, timeForGraphToUpdate)
    Some(() => Js.Global.clearTimeout(timeout))
  }, [stateForRefetchExecution])
}

let useRefetchConfirmedSynths = (~userId, ~stateForRefetchExecution) => {
  let client = Client.useApolloClient()
  let reqVariables = {
    Queries.UsersConfirmedMints.userId: userId,
  }

  React.useEffect1(() => {
    Js.log("refetch confirmed synths in refetched")
    let timeForGraphToUpdate = 1000 // Give the graph a chance to capture the data before making the request
    let timeout = Js.Global.setTimeout(() => {
      let _ = client.query(
        ~query=module(Queries.UsersConfirmedMints),
        ~fetchPolicy=NetworkOnly,
        reqVariables,
      )->JsPromise.map(queryResult => {
        switch queryResult {
        | Ok({data: {user}}) =>
          switch user {
          | Some(usr) => {
              let _ = client.writeQuery(
                ~query=module(Queries.UsersConfirmedMints),
                ~data={
                  user: Some({
                    __typename: usr.__typename,
                    confirmedNextPriceActions: usr.confirmedNextPriceActions,
                  }),
                },
              )
            }
          | None => ()
          }

        | _ => ()
        }
      })
    }, timeForGraphToUpdate)
    Some(() => Js.Global.clearTimeout(timeout))
  }, [stateForRefetchExecution])
}

let useRefetchPendingSynths = (~userId, ~stateForRefetchExecution) => {
  let client = Client.useApolloClient()
  let reqVariables = {
    Queries.UsersPendingMints.userId: userId,
  }

  React.useEffect1(() => {
    Js.log("refetch pending synths in refetched")
    let timeForGraphToUpdate = 1000 // Give the graph a chance to capture the data before making the request
    let timeout = Js.Global.setTimeout(() => {
      let _ = client.query(
        ~query=module(Queries.UsersPendingMints),
        ~fetchPolicy=NetworkOnly,
        reqVariables,
      )->JsPromise.map(queryResult => {
        switch queryResult {
        | Ok({data: {user}}) =>
          switch user {
          | Some(usr) => {
              let _ = client.writeQuery(
                ~query=module(Queries.UsersPendingMints),
                ~data={
                  user: Some({
                    __typename: usr.__typename,
                    pendingNextPriceActions: usr.pendingNextPriceActions,
                  }),
                },
              )
            }
          | None => ()
          }

        | _ => ()
        }
      })
    }, timeForGraphToUpdate)
    Some(() => Js.Global.clearTimeout(timeout))
  }, [stateForRefetchExecution])
}
