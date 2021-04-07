@react.component
let make = (~tokenAddresses) => {
  let signer = ContractActions.useSignerExn()

  let (contractExecutionHandler, txState, _setTxState) = ContractActions.useContractFunction(
    ~signer,
  )

  let stakerAddress = Config.useStakerAddress()

  let toastDispatch = React.useContext(ToastProvider.DispatchToastContext.context)

  React.useEffect1(() => {
    switch txState {
    | Created =>
      toastDispatch(
        ToastProvider.Show(`Confirm claim transaction in your wallet`, "", ToastProvider.Info),
      )
    | SignedAndSubmitted(_) =>
      toastDispatch(ToastProvider.Show(`claim transaction pending`, "", ToastProvider.Info))
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
        ToastProvider.Show(`Claim transaction confirmed 🎉`, "", ToastProvider.Success),
      )
    | Failed => toastDispatch(ToastProvider.Show(`The transaction failed`, "", ToastProvider.Error))
    | _ => ()
    }
    None
  }, [txState])

  let claimFloatCall = _ =>
    contractExecutionHandler(
      ~makeContractInstance=Contracts.Staker.make(~address=stakerAddress),
      ~contractFunction=Contracts.Staker.claimFloat(
        ~tokenAddresses=tokenAddresses->Array.map(Ethers.Utils.getAddressUnsafe),
      ),
    )

  <>
    <Button.Tiny onClick={_ => claimFloatCall()}> "Claim Float" </Button.Tiny>
    <ClaimTxStatus
      txState buttonText={"Claim Float"} buttonDisabled={false} onClick={_ => claimFloatCall()}
    />
  </>
}
