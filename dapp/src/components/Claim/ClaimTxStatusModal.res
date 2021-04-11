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
        <a
          className="hover:underline"
          target="_"
          rel="noopenner noreferer"
          href={`${Config.blockExplorer}tx/${txHash}`}>
          <p> {`view tx on ${Config.blockExplorerName}`->React.string} </p>
        </a>
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
        <a target="_" rel="noopenner noreferer" href=Config.discordInviteLink>
          {"Connect with us on discord, if you would like some assistance"->React.string}
        </a>
      </div>
    </Modal>
  | ContractActions.Failed =>
    <Modal id={5}>
      <div className="text-center m-3">
        <h1> {`The transaction failed.`->React.string} </h1>
        <p>
          <a target="_" rel="noopenner noreferer" href=Config.discordInviteLink>
            {"Connect with us on discord, if you would like some assistance"->React.string}
          </a>
        </p>
      </div>
    </Modal>
  | _ => React.null
  }
}
