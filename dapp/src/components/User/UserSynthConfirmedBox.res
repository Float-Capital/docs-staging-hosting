module ClaimSynthTokensTxStatusModals = {
  @react.component
  let make = (~txState: ContractActions.transactionState) => {
    let toastDispatch = React.useContext(ToastProvider.DispatchToastContext.context)

    React.useEffect1(() => {
      switch txState {
      | Created =>
        toastDispatch(
          ToastProvider.Show(
            `Confirm claim synth transaction in your wallet`,
            "",
            ToastProvider.Info,
          ),
        )
      | SignedAndSubmitted(_) =>
        toastDispatch(ToastProvider.Show(`claim synth transaction pending`, "", ToastProvider.Info))
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
          ToastProvider.Show(`Claim synth transaction confirmed 🎉`, "", ToastProvider.Success),
        )
      | Failed(_) =>
        toastDispatch(ToastProvider.Show(`The transaction failed`, "", ToastProvider.Error))
      | _ => ()
      }
      None
    }, [txState])

    <> </>
  }
}

@react.component
let make = (~name, ~isLong, ~daiSpend, ~marketIndex) => {
  let signer = ContractActions.useSignerExn()
  let optCurrentUser = RootProvider.useCurrentUser()

  let (contractExecutionHandler, txState, _setTxState) = ContractActions.useContractFunction(
    ~signer,
  )

  let claimSynthTokensCall = _ =>
    contractExecutionHandler(
      ~makeContractInstance=Contracts.LongShort.make(~address=Config.longShort),
      ~contractFunction=Contracts.LongShort.executeOutstandingNextPriceSettlementsUser(
        ~user={optCurrentUser->Option.getWithDefault(CONSTANTS.zeroAddress)}, // TODO: change arb logic
        ~marketIndex,
      ),
    )
  <div
    className=`flex flex-col justify-between w-11/12 mx-auto p-2 mb-2 border-2 border-primary rounded-lg shadow relative`>
    <div className="flex flex-row justify-between">
      <div className=` text-sm self-center`> {name->React.string} </div>
      <div className=` text-sm self-center`> {(isLong ? "Long" : "Short")->React.string} </div>
      <div className=`flex  text-sm self-center`>
        <img src={CONSTANTS.daiDisplayToken.iconUrl} className="h-5 pr-1" />
        {daiSpend->Ethers.Utils.formatEther->React.string}
      </div>
    </div>
    <Button.Tiny onClick={_ => claimSynthTokensCall()}> "Claim synth tokens" </Button.Tiny>
    <ClaimSynthTokensTxStatusModals txState />
  </div>
}
