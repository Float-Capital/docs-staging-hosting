@react.component
let make = (
  ~txStateApprove,
  ~txStateStake,
  ~resetFormButton,
  ~tokenToStake,
  ~buttonText,
  ~buttonDisabled,
) => {
  switch (txStateApprove, txStateStake) {
  | (ContractActions.Created, _) =>
    <Modal>
      <div className="text-center m-3">
        <p> {`Confirm approve transaction in your wallet `->React.string} </p>
      </div>
    </Modal>
  | (ContractActions.SignedAndSubmitted(txHash), _) =>
    <Modal>
      <div className="text-center m-3">
        <MiniLoader />
        <p> {"Approval transaction pending... "->React.string} </p>
        <a target="_" rel="noopenner noreferer" href={`${Config.defaultBlockExplorer}tx/${txHash}`}>
          <p> {`View on ${Config.defaultBlockExplorerName}`->React.string} </p>
        </a>
      </div>
    </Modal>
  | (ContractActions.Complete({transactionHash}), ContractActions.Created)
  | (ContractActions.Complete({transactionHash}), ContractActions.UnInitialised) =>
    <Modal>
      <div className="text-center m-3">
        <p> {`Confirm transaction to stake ${tokenToStake}`->React.string} </p>
      </div>
    </Modal>
  | (ContractActions.Declined(message), _) => <> {resetFormButton()} </>
  | (ContractActions.Failed, _) =>
    <Modal>
      <div className="text-center m-3">
        <p> {`The transaction failed.`->React.string} </p>
        <p>
          <a target="_" rel="noopenner noreferer" href=Config.discordInviteLink>
            {"Connect with us on discord, if you would like some assistance"->React.string}
          </a>
        </p>
        {resetFormButton()}
      </div>
    </Modal>
  | (_, ContractActions.Created) =>
    <Modal>
      <div className="text-center m-3">
        <h1> {`Confirm the transaction to stake ${tokenToStake}`->React.string} </h1>
      </div>
    </Modal>
  | (ContractActions.Complete({transactionHash}), ContractActions.SignedAndSubmitted(txHash)) =>
    <Modal>
      <div className="text-center m-3">
        <p>
          <a
            target="_"
            rel="noopenner noreferer"
            href={`${Config.defaultBlockExplorer}tx/${transactionHash}`}>
            {`Approval confirmed`->React.string}
          </a>
        </p>
        <h1>
          <a
            target="_"
            rel="noopenner noreferer"
            href={`${Config.defaultBlockExplorer}tx/${txHash}`}>
            {`Pending staking ${tokenToStake}`->React.string}
          </a>
        </h1>
      </div>
    </Modal>
  | (_, ContractActions.SignedAndSubmitted(txHash)) =>
    <Modal>
      <div className="text-center m-3">
        <MiniLoader />
        <p> {"Staking transaction pending... "->React.string} </p>
        <a
          className="hover:underline"
          target="_"
          rel="noopenner noreferer"
          href={`${Config.defaultBlockExplorer}tx/${txHash}`}>
          <p> {`View on ${Config.defaultBlockExplorerName}`->React.string} </p>
        </a>
      </div>
    </Modal>
  | (_, ContractActions.Complete({transactionHash})) =>
    <Modal>
      <div className="text-center m-3">
        <p> {`Transaction complete`->React.string} </p> {resetFormButton()}
      </div>
    </Modal>
  | (_, ContractActions.Declined(message)) =>
    <Modal>
      <div className="text-center m-3">
        <p> {`The transaction was rejected by your wallet`->React.string} </p>
        <a target="_" rel="noopenner noreferer" href=Config.discordInviteLink>
          {"Connect with us on discord, if you would like some assistance"->React.string}
        </a>
        {resetFormButton()}
      </div>
    </Modal>
  | (_, ContractActions.Failed) =>
    <Modal>
      <div className="text-center m-3">
        <h1> {`The transaction failed.`->React.string} </h1>
        <p>
          <a target="_" rel="noopenner noreferer" href=Config.discordInviteLink>
            {"Connect with us on discord, if you would like some assistance"->React.string}
          </a>
        </p>
        {resetFormButton()}
      </div>
    </Modal>
  | _ => <Button disabled=buttonDisabled onClick={_ => ()}> {buttonText} </Button>
  }
}
