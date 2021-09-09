@react.component
let make = (
  ~marketIndex,
  ~txState: ContractActions.transactionState,
  ~contractExecutionHandler,
) => {
  let user = RootProvider.useCurrentUserExn()

  let toastDispatch = React.useContext(ToastProvider.DispatchToastContext.context)

  let client = Client.useApolloClient()
  let reqVariables = {
    Queries.UsersConfirmedRedeems.userId: user->Ethers.Utils.ethAdrToLowerStr,
  }

  React.useEffect1(() => {
    switch txState {
    | Created =>
      toastDispatch(
        ToastProvider.Show(`Confirm withdraw transaction in your wallet`, "", ToastProvider.Info),
      )
    | SignedAndSubmitted(_) =>
      toastDispatch(ToastProvider.Show(`withdraw transaction pending`, "", ToastProvider.Info))
    | Declined(reason) =>
      toastDispatch(
        ToastProvider.Show(
          `The transaction was rejected by your wallet`,
          reason,
          ToastProvider.Error,
        ),
      )
    | Complete(_) =>
      toastDispatch(
        ToastProvider.Show(`Withdraw transaction confirmed 🎉`, "", ToastProvider.Success),
      )

    | Failed(_) =>
      toastDispatch(ToastProvider.Show(`The transaction failed`, "", ToastProvider.Error))
    | _ => ()
    }

    None
  }, [txState])

  React.useEffect1(() => {
    let timeForGraphToUpdate = 1000 // Give the graph a chance to capture the data before making the request
    let timeout = Js.Global.setTimeout(() => {
      let _ = client.query(
        ~query=module(Queries.UsersConfirmedRedeems),
        ~fetchPolicy=NetworkOnly,
        reqVariables,
      )->JsPromise.map(queryResult => {
        switch queryResult {
        | Ok({data: {user}}) =>
          switch user {
          | Some(usr) => {
              let _ = client.writeQuery(
                ~query=module(Queries.UsersConfirmedRedeems),
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
  }, [txState])

  let executeNextPriceSettlementsCall = _ =>
    contractExecutionHandler(
      ~makeContractInstance=Contracts.LongShort.make(~address=Config.longShort),
      ~contractFunction=Contracts.LongShort.executeOutstandingNextPriceSettlementsUser(
        ~marketIndex,
        ~user,
      ),
    )

  <Button.Tiny onClick={_ => executeNextPriceSettlementsCall()}> "Withdraw DAI" </Button.Tiny>
}
