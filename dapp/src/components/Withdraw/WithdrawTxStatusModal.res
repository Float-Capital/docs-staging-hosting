@react.component
let make = (~txState) => {
  switch txState {
  | ContractActions.Created =>
    <Modal id={11}>
      <div className="text-center m-3">
        <Loader.Ellipses />
        <h1> {`Confirm the transaction to withdraw your DAI`->React.string} </h1>
      </div>
    </Modal>
  | ContractActions.SignedAndSubmitted(txHash) =>
    <Modal id={12}>
      <div className="text-center m-3">
        <div className="m-2"> <Loader.Mini /> </div>
        <p> {"Withdraw transaction pending... "->React.string} </p>
        <ViewOnBlockExplorer txHash />
      </div>
    </Modal>
  | ContractActions.Complete({transactionHash: txHash}) =>
    <Modal id={13}>
      <div className="text-center m-3">
        <Tick /> <p> {`Transaction complete 🎉`->React.string} </p> <ViewOnBlockExplorer txHash />
      </div>
    </Modal>
  | ContractActions.Declined(_message) =>
    <Modal id={14}>
      <div className="text-center m-3">
        <p> {`The transaction was rejected by your wallet`->React.string} </p>
        <MessageUsOnDiscord />
      </div>
    </Modal>
  | ContractActions.Failed(txHash) =>
    <Modal id={15}>
      <div className="text-center m-3">
        <h1> {`The transaction failed.`->React.string} </h1>
        <ViewOnBlockExplorer txHash />
        <MessageUsOnDiscord />
      </div>
    </Modal>
  | _ => React.null
  }
}
