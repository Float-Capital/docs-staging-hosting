let centerFlex = {
  open CssJs
  style(.[display(#flex), justifyContent(#center)])
}

@react.component
let make = (
  ~children: React.element,
  ~txState: ContractActions.transactionState,
  ~resetTxState=?,
) => {
  let txExplererUrl = RootProvider.useEtherscanUrl()

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
        <a href=j`https://$txExplererUrl/tx/$txHash` target="_blank" rel="noopener noreferrer">
          {("View the transaction on " ++ txExplererUrl)->React.string}
        </a>
      </p>
      <Loader />
    </>
  | ContractActions.Complete(result) =>
    let txHash = result.transactionHash
    <>
      <h1> {"Transaction Complete "->React.string} <Loader /> </h1>
      <p>
        <a href=j`https://$txExplererUrl/tx/$txHash` target="_blank" rel="noopener noreferrer">
          {("View the transaction on " ++ txExplererUrl)->React.string}
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
  | ContractActions.Failed => <>
      <h1> {"The transaction failed."->React.string} <Loader /> </h1>
      <p>
        {"It is possible that someone else bought the token before you, or the price changed. If you are unsure please feel free to contact our support."->React.string}
      </p>
      children
    </>
  }
}
