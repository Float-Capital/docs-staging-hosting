module FaucetCard = {
  @react.component
  let make = (~signer) => {
    // let (_contractExecutionHandler, _txState, _setTxState) = ContractActions.useContractFunction(
    //   ~signer,
    // )
    Js.log(signer)

    let _toastDispatch = React.useContext(ToastProvider.DispatchToastContext.context)

    // React.useEffect1(() => {
    //   switch txState {
    //   | Created =>
    //     toastDispatch(
    //       ToastProvider.Show(
    //         `Confirm mint testnet DAI transaction in your wallet`,
    //         "",
    //         ToastProvider.Info,
    //       ),
    //     )
    //   | SignedAndSubmitted(_) =>
    //     toastDispatch(
    //       ToastProvider.Show(`Minting testnet DAI transaction pending`, "", ToastProvider.Info),
    //     )
    //   | Declined(reason) =>
    //     toastDispatch(
    //       ToastProvider.Show(
    //         `The transaction was rejected by your wallet`,
    //         reason,
    //         ToastProvider.Error,
    //       ),
    //     )
    //   | Complete(_) =>
    //     toastDispatch(
    //       ToastProvider.Show(
    //         `Mint testnet DAI transaction confirmed 🎉`,
    //         "",
    //         ToastProvider.Success,
    //       ),
    //     )
    //   | Failed(_) =>
    //     toastDispatch(ToastProvider.Show(`The transaction failed`, "", ToastProvider.Error))
    //   | _ => ()
    //   }
    //   None
    // }, [txState])

    // let mintMoniesCall = _ =>
    //   contractExecutionHandler(
    //     ~makeContractInstance=Contracts.AaveFaucet.make(~address=Config.aaveFaucet),
    //     ~contractFunction=Contracts.AaveFaucet.mintMonies(~aaveDaiContract=Config.dai),
    //   )

    <section
      className="max-w-3xl mx-auto p-5 mb-5 flex-col items-center justify-between bg-white bg-opacity-75 rounded-lg shadow-lg">
      <h1 className="text-lg text-center p-6">
        {"This is a Mumbai testnet faucet to mint some testnet DAI"->React.string}
      </h1>
      <div className="mx-auto max-w-sm" />
      // <FaucetTxStatusModal txState />
    </section>
  }
}

module AaveDaiFaucet = {
  @react.component
  let make = () => {
    let optSigner = ContractActions.useSigner()
    switch optSigner {
    | Some(signer) => <FaucetCard signer />
    | None => <p> {"No signer"->React.string} </p>
    }
  }
}

let default = <AaveDaiFaucet />
