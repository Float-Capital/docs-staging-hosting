module FaucetTxStatusModal = {
  @react.component
  let make = (~txState) => {
    switch txState {
    | ContractActions.Created =>
      <Modal id={1}>
        <div className="text-center m-3">
          <Loader.Ellipses />
          <h1> {`Confirm the transaction to mint testnet DAI`->React.string} </h1>
        </div>
      </Modal>
    | ContractActions.SignedAndSubmitted(txHash) =>
      <Modal id={2}>
        <div className="text-center m-3">
          <div className="m-2"> <Loader.Mini /> </div>
          <p> {"Minting testnet DAI transaction pending... "->React.string} </p>
          <ViewOnBlockExplorer txHash />
        </div>
      </Modal>
    | ContractActions.Complete({transactionHash: _}) =>
      <Modal id={3}>
        <div className="text-center m-3">
          <Tick /> <p> {`Transaction complete 🎉`->React.string} </p>
        </div>
        <Metamask.AddTokenButton token={Config.config.contracts.dai} tokenSymbol={`DAI`} />
      </Modal>
    | ContractActions.Declined(_message) =>
      <Modal id={4}>
        <div className="text-center m-3">
          <p> {`The transaction was rejected by your wallet`->React.string} </p>
          <MessageUsOnDiscord />
        </div>
      </Modal>
    | ContractActions.Failed(txHash) =>
      <Modal id={5}>
        <div className="text-center m-3">
          <h1> {`The transaction failed.`->React.string} </h1>
          <ViewOnBlockExplorer txHash />
          <MessageUsOnDiscord />
        </div>
      </Modal>
    | _ => React.null
    }
  }
}

module FaucetCard = {
  @react.component
  let make = (~signer) => {
    let (contractExecutionHandler, txState, _setTxState) = ContractActions.useContractFunction(
      ~signer,
    )

    let toastDispatch = React.useContext(ToastProvider.DispatchToastContext.context)

    React.useEffect1(() => {
      switch txState {
      | Created =>
        toastDispatch(
          ToastProvider.Show(
            `Confirm mint testnet DAI transaction in your wallet`,
            "",
            ToastProvider.Info,
          ),
        )
      | SignedAndSubmitted(_) =>
        toastDispatch(
          ToastProvider.Show(`Minting testnet DAI transaction pending`, "", ToastProvider.Info),
        )
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
          ToastProvider.Show(
            `Mint testnet DAI transaction confirmed 🎉`,
            "",
            ToastProvider.Success,
          ),
        )
      | Failed(_) =>
        toastDispatch(ToastProvider.Show(`The transaction failed`, "", ToastProvider.Error))
      | _ => ()
      }
      None
    }, [txState])

    let mintMoniesCall = _ =>
      contractExecutionHandler(
        ~makeContractInstance=Contracts.AaveFaucet.make(~address=Config.aaveFaucet),
        ~contractFunction=Contracts.AaveFaucet.mintMonies(~aaveDaiContract=Config.dai),
      )

    <section
      className="max-w-2xl mx-auto p-5  flex-col items-center justify-between bg-white bg-opacity-75 rounded-lg shadow-lg">
      <div className="text-center p-6 pt-0">
        <h1 className="text-lg p-2"> {"Mumbai testnet DAI faucet"->React.string} </h1>
        <p className="text-xxs">
          {"In order to mint testnet DAI you will need testnet "->React.string}
          <a
            href="https://faucet.matic.network/"
            className="hover:bg-white underline"
            target="_blank"
            rel="noopener noreferrer">
            {"Matic token"->React.string}
          </a>
        </p>
      </div>
      <div className="mx-auto max-w-sm">
        <Button onClick={_ => mintMoniesCall()}> {"Mint testnet dai"} </Button>
      </div>
      <FaucetTxStatusModal txState />
    </section>
  }
}

@react.component
let make = () => {
  let optSigner = ContractActions.useSigner()
  switch optSigner {
  | Some(signer) => <FaucetCard signer />
  | None => <Loader />
  }
}

let default = make
