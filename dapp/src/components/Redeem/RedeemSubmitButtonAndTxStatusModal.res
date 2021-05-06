@react.component
let make = (
  // TODO: we can completely delete this variable. I (Jason) have left it here as reference since this would be the way to make a single component modal for both minting and redeeming etc.
  //       in this code it is always 'None'
  ~txStateApprove=?,
  ~txStateRedeem,
  ~resetFormButton,
  ~redeemToken,
  ~buttonText,
  ~buttonDisabled,
) => {
  switch (txStateApprove, txStateRedeem) {
  | (Some(ContractActions.Created), _) => <>
      <Modal id={1}>
        <div className="text-center mx-3 my-6">
          <EllipsesLoader /> <p> {`Please approve your ${redeemToken} token `->React.string} </p>
        </div>
      </Modal>
      <Button disabled=true onClick={_ => ()}> {buttonText} </Button>
    </>
  | (Some(ContractActions.SignedAndSubmitted(txHash)), _) => <>
      <Modal id={2}>
        <div className="text-center m-3">
          <div className="m-2"> <MiniLoader /> </div>
          <p> {"Approval transaction pending... "->React.string} </p>
          <ViewOnBlockExplorer txHash />
        </div>
      </Modal>
      <Button disabled=true onClick={_ => ()}> {buttonText} </Button>
    </>
  | (Some(ContractActions.Complete({transactionHash: _})), ContractActions.Created)
  | (Some(ContractActions.Complete({transactionHash: _})), ContractActions.UnInitialised) => <>
      <Modal id={3}>
        <div className="text-center mx-3 my-6">
          <EllipsesLoader />
          <p> {`Confirm transaction to redeem ${Config.paymentTokenName}`->React.string} </p>
        </div>
      </Modal>
      <Button disabled=true onClick={_ => ()}> {buttonText} </Button>
    </>
  | (Some(ContractActions.Declined(_message)), _) => <> {resetFormButton()} </>
  | (Some(ContractActions.Failed(txHash)), _) => <>
      <Modal id={4}>
        <div className="text-center m-3">
          <p> {`The transaction failed.`->React.string} </p>
          <ViewOnBlockExplorer txHash />
          <MessageUsOnDiscord />
        </div>
      </Modal>
      {resetFormButton()}
    </>
  | (_, ContractActions.Created) => <>
      <Modal id={5}>
        <div className="text-center m-3">
          <EllipsesLoader />
          <h1> {`Confirm the transaction to redeem ${Config.paymentTokenName}`->React.string} </h1>
        </div>
      </Modal>
      <Button disabled=true onClick={_ => ()}> {buttonText} </Button>
    </>
  | (
      Some(ContractActions.Complete({transactionHash})),
      ContractActions.SignedAndSubmitted(txHash),
    ) => <>
      <Modal id={6}>
        <div className="text-center m-3">
          <p> {`Approval confirmed 🎉`->React.string} </p>
          <ViewOnBlockExplorer txHash={transactionHash} />
          <h1>
            {`Pending redeem ${Config.paymentTokenName} transaction`->React.string}
            <ViewOnBlockExplorer txHash />
          </h1>
        </div>
      </Modal>
      <Button disabled=true onClick={_ => ()}> {buttonText} </Button>
    </>
  | (_, ContractActions.SignedAndSubmitted(txHash)) => <>
      <Modal id={7}>
        <div className="text-center m-3">
          <div className="m-2"> <MiniLoader /> </div>
          <p> {"Redeem transaction pending... "->React.string} </p>
          <ViewOnBlockExplorer txHash />
        </div>
      </Modal>
      <Button disabled=true onClick={_ => ()}> {buttonText} </Button>
    </>
  | (_, ContractActions.Complete({transactionHash: _})) => <>
      <Modal id={8}>
        <div className="text-center m-3">
          <Tick /> <p> {`Transaction complete 🎉`->React.string} </p>
        </div>
      </Modal>
      {resetFormButton()}
    </>
  | (_, ContractActions.Declined(_message)) => <>
      <Modal id={9}>
        <div className="text-center m-3">
          <p> {`The transaction was rejected by your wallet`->React.string} </p>
          <MessageUsOnDiscord />
        </div>
      </Modal>
      {resetFormButton()}
    </>
  | (_, ContractActions.Failed(txHash)) => <>
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
