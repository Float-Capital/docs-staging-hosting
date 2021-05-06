@react.component
let make = (~txStateApprove, ~txStateStake, ~resetFormButton, ~tokenToStake) => {
  switch (txStateApprove, txStateStake) {
  | (ContractActions.Created, _) =>
    <Modal id={"stake-approve-1"}>
      <div className="text-center m-3">
        <EllipsesLoader /> <p> {`Confirm approve transaction in your wallet `->React.string} </p>
      </div>
    </Modal>
  | (ContractActions.SignedAndSubmitted(txHash), _) =>
    <Modal id={"stake-approve-2"}>
      <div className="text-center m-3">
        <div className="m-2"> <MiniLoader /> </div>
        <p> {"Approval transaction pending... "->React.string} </p>
        <ViewOnBlockExplorer txHash />
      </div>
    </Modal>
  | (ContractActions.Complete({transactionHash: _}), ContractActions.Created)
  | (ContractActions.Complete({transactionHash: _}), ContractActions.UnInitialised) =>
    <Modal id={"stake-approve-3"}>
      <div className="text-center m-3">
        <EllipsesLoader /> <p> {`Confirm transaction to stake ${tokenToStake}`->React.string} </p>
      </div>
    </Modal>
  | (ContractActions.Declined(_message), _) => <> {resetFormButton()} </>
  | (ContractActions.Failed(txHash), _) =>
    <Modal id={"stake-approve-4"}>
      <div className="text-center m-3">
        <p> {`The transaction failed.`->React.string} </p>
        <ViewOnBlockExplorer txHash />
        <MessageUsOnDiscord />
        {resetFormButton()}
      </div>
    </Modal>
  | (_, ContractActions.Created) =>
    <Modal id={"stake-1"}>
      <div className="text-center m-3">
        <EllipsesLoader />
        <h1> {`Confirm the transaction to stake ${tokenToStake}`->React.string} </h1>
      </div>
    </Modal>
  | (ContractActions.Complete({transactionHash}), ContractActions.SignedAndSubmitted(txHash)) =>
    <Modal id={"stake-2"}>
      <div className="text-center m-3">
        <p>
          <a
            target="_"
            rel="noopenner noreferer"
            href={`${Config.blockExplorer}tx/${transactionHash}`}>
            {`Approval confirmed`->React.string}
          </a>
        </p>
        <h1>
          <a target="_" rel="noopenner noreferer" href={`${Config.blockExplorer}tx/${txHash}`}>
            {`Pending staking ${tokenToStake}`->React.string}
          </a>
        </h1>
      </div>
    </Modal>
  | (_, ContractActions.SignedAndSubmitted(txHash)) =>
    <Modal id={"stake-3"}>
      <div className="text-center m-3">
        <div className="m-2"> <MiniLoader /> </div>
        <p> {"Staking transaction pending... "->React.string} </p>
        <ViewOnBlockExplorer txHash />
      </div>
    </Modal>
  | (_, ContractActions.Complete({transactionHash: _})) => <>
      <Modal id={"stake-4"}>
        <div className="text-center m-3">
          <Tick /> <p> {`Transaction complete 🎉`->React.string} </p>
        </div>
        {resetFormButton()}
      </Modal>
    </>
  | (_, ContractActions.Declined(_message)) =>
    <Modal id={"stake-5"}>
      <div className="text-center m-3">
        <p> {`The transaction was rejected by your wallet`->React.string} </p>
        <MessageUsOnDiscord />
        {resetFormButton()}
      </div>
    </Modal>
  | (_, ContractActions.Failed(txHash)) =>
    <Modal id={"stake-6"}>
      <div className="text-center m-3">
        <h1> {`The transaction failed.`->React.string} </h1>
        <ViewOnBlockExplorer txHash />
        <MessageUsOnDiscord />
        {resetFormButton()}
      </div>
    </Modal>
  | _ => React.null
  }
}
