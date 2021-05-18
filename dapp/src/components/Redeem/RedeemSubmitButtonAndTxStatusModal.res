@react.component
let make = (~txStateRedeem, ~resetFormButton, ~buttonText, ~buttonDisabled) => {
  switch txStateRedeem {
  | ContractActions.Created => <>
      <Modal id={5}>
        <div className="text-center m-3">
          <Loader.Ellipses />
          <h1> {`Confirm the transaction to redeem ${Config.paymentTokenName}`->React.string} </h1>
        </div>
      </Modal>
      <Button disabled=true onClick={_ => ()}> {buttonText} </Button>
    </>

  | ContractActions.SignedAndSubmitted(txHash) => <>
      <Modal id={7}>
        <div className="text-center m-3">
          <div className="m-2"> <Loader.Mini /> </div>
          <p> {"Redeem transaction pending... "->React.string} </p>
          <ViewOnBlockExplorer txHash />
        </div>
      </Modal>
      <Button disabled=true onClick={_ => ()}> {buttonText} </Button>
    </>
  | ContractActions.Complete({transactionHash: _}) => <>
      <Modal id={8}>
        <div className="text-center m-3">
          <Tick /> <p> {`Transaction complete 🎉`->React.string} </p>
        </div>
      </Modal>
      {resetFormButton()}
    </>
  | ContractActions.Declined(_message) => <>
      <Modal id={9}>
        <div className="text-center m-3">
          <p> {`The transaction was rejected by your wallet`->React.string} </p>
          <MessageUsOnDiscord />
        </div>
      </Modal>
      {resetFormButton()}
    </>
  | ContractActions.Failed(txHash) => <>
      <Modal id={10}>
        <div className="text-center m-3">
          <h1> {`The transaction failed.`->React.string} </h1>
          <ViewOnBlockExplorer txHash />
          <MessageUsOnDiscord />
        </div>
      </Modal>
      {resetFormButton()}
    </>
  | _ => <Button disabled=buttonDisabled onClick={_ => ()}> {buttonText} </Button>
  }
}
