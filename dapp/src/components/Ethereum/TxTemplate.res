let centerFlex = {
  open CssJs
  style(. [display(#flex), justifyContent(#center)])
}

@react.component
let make = (
  ~children: React.element,
  ~txState: ContractActions.transactionState,
  ~resetTxState=?,
) => {
  switch txState {
  | ContractActions.UnInitialised => children
  | ContractActions.Created => <>
      <h1> {"Processing Transaction "->React.string} <Loader /> </h1>
      <p> {"Tx created."->React.string} </p>
      <div className={centerFlex}> <Loader /> </div>
    </>
  | ContractActions.SignedAndSubmitted(txHash) => <>
      <h1> {"Processing Transaction "->React.string} <Loader /> </h1>
      <p>
        <a href={`${Config.blockExplorer}/tx/${txHash}`} target="_blank" rel="noopener noreferrer">
          {`View the transaction on ${Config.blockExplorerName}`->React.string}
        </a>
      </p>
      <div className="bg-white"> <Loader /> </div>
    </>
  | ContractActions.Complete(result) =>
    let txHash = result.transactionHash
    <>
      <h1> {"Transaction Complete "->React.string} <Loader /> </h1>
      <p>
        <a
          href={`https://${Config.blockExplorer}/tx/${txHash}`}
          target="_blank"
          rel="noopener noreferrer">
          {`View the transaction on ${Config.blockExplorerName}`->React.string}
        </a>
      </p>
      {switch resetTxState {
      | Some(resetTxState) =>
        <button onClick={_ => resetTxState()}> {"Go back"->React.string} </button>
      | None => React.null
      }}
    </>
  | ContractActions.Declined(message) => <>
      <h1> {"The transaction was declined by your wallet, please try again."->React.string} </h1>
      <p> {("Failure reason: " ++ message)->React.string} </p>
      children
    </>
  | ContractActions.Failed(_) => <>
      <h1> {"The transaction failed."->React.string} <Loader /> </h1>
      <p> {"This operation isn't permitted by the smart contract."->React.string} </p>
      children
    </>
  }
}
