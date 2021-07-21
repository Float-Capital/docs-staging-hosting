@react.component
let make = (~marketIndex) => {
  let signer = ContractActions.useSignerExn()

  let (contractExecutionHandler, txState, _setTxState) = ContractActions.useContractFunction(
    ~signer,
  )

  let user = RootProvider.useCurrentUserExn()

  let toastDispatch = React.useContext(ToastProvider.DispatchToastContext.context)

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
      let _ = Queries.UsersConfirmedRedeems.use(
        {userId: user->Ethers.Utils.ethAdrToLowerStr},
        ~fetchPolicy=NetworkOnly,
      )
      toastDispatch(
        ToastProvider.Show(`Withdraw transaction confirmed 🎉`, "", ToastProvider.Success),
      )
    | Failed(_) =>
      toastDispatch(ToastProvider.Show(`The transaction failed`, "", ToastProvider.Error))
    | _ => ()
    }
    None
  }, [txState])

  let executeNextPriceSettlementsCall = _ =>
    contractExecutionHandler(
      ~makeContractInstance=Contracts.LongShort.make(~address=Config.longShort),
      ~contractFunction=Contracts.LongShort.executeOutstandingNextPriceSettlementsUser(
        ~marketIndex,
        ~user,
      ),
    )

  <>
    <Button.Tiny onClick={_ => executeNextPriceSettlementsCall()}> "Withdraw DAI" </Button.Tiny>
    <WithdrawTxStatusModal txState />
  </>
}
