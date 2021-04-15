@react.component
let make = (~txState) => {
  switch txState {
  | ContractActions.Created =>
    <Modal id={1}>
      <div className="text-center m-3">
        <h1> {`Confirm the transaction to claim Float`->React.string} </h1>
      </div>
    </Modal>
  | ContractActions.SignedAndSubmitted(txHash) =>
    <Modal id={2}>
      <div className="text-center m-3">
        <MiniLoader />
        <p> {"Claiming transaction pending... "->React.string} </p>
        <ViewOnBlockExplorer txHash />
      </div>
    </Modal>
  | ContractActions.Complete({transactionHash: _}) =>
    <Modal id={3}>
      <div className="text-center m-3"> <p> {`Transaction complete 🎉`->React.string} </p> </div>
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
