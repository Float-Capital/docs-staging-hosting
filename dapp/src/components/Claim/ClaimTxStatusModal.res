let useClaimTxModal = (~txState) => {
  let {startModalChain, hideModalChain, showNextModalInChain} = ModalProvider.useModalDisplayChain()

  React.useEffect1(() => {
    switch txState {
    | ContractActions.Created =>
      startModalChain(
        <div className="text-center m-3">
          <Loader.Ellipses /> <h1> {`Confirm the transaction to claim ${Config.floatTokenName}`->React.string} </h1>
        </div>,
      )
    | ContractActions.SignedAndSubmitted(txHash) =>
      showNextModalInChain(
        <div className="text-center m-3">
          <div className="m-2"> <Loader.Mini /> </div>
          <p> {"Claiming transaction pending... "->React.string} </p>
          <ViewOnBlockExplorer txHash />
        </div>,
      )
    | ContractActions.Complete({transactionHash: _}) =>
      showNextModalInChain(<>
        <div className="text-center m-3">
          <Tick /> <p> {`Transaction complete 🎉`->React.string} </p>
        </div>
        <Metamask.AddTokenButton token={Config.config.contracts.floatToken} tokenSymbol={Config.config.floatToken.floatTokenName} tokenUrl={Config.config.floatToken.floatTokenImageUrl}/>
      </>)
    | ContractActions.Declined(_message) =>
      showNextModalInChain(
        <div className="text-center m-3">
          <p> {`The transaction was rejected by your wallet`->React.string} </p>
          <MessageUsOnDiscord />
        </div>,
      )
    | ContractActions.Failed(txHash) =>
      showNextModalInChain(
        <div className="text-center m-3">
          <h1> {`The transaction failed.`->React.string} </h1>
          <ViewOnBlockExplorer txHash />
          <MessageUsOnDiscord />
        </div>,
      )
    | _ => hideModalChain()
    }
    None
  }, [txState])
}
