let useRerender = () => {
  let (_v, setV) = React.useState(_ => 0)
  () => setV(v => v + 1)
}

@react.component
let make = (~txStateRedeem, ~resetFormButton, ~buttonText, ~buttonDisabled, ~marketIndex) => {
  let rerender = useRerender()

  let lastOracleTimestamp = DataHooks.useOracleLastUpdate(
    ~marketIndex=marketIndex->Ethers.BigNumber.toString,
  )

  let oracleHeartBeat = 30 // TODO

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
          <p className="text-xxs text-yellow-600">
            {`⚡ Redeeming your position requires a second withdraw transaction once the oracle price has updated ⚡`->React.string}
          </p>
          <ViewOnBlockExplorer txHash />
        </div>
      </Modal>
      <Button disabled=true onClick={_ => ()}> {buttonText} </Button>
    </>
  | ContractActions.Complete({transactionHash: txHash}) => <>
      <Modal id={8}>
        <div className="text-center m-3">
          <Tick />
          <p> {`Transaction complete 🎉`->React.string} </p>
          <p className="text-xxs text-gray-700">
            {`You can withdraw your ${Config.paymentTokenName} on the next oracle price update`->React.string}
          </p>
          {switch lastOracleTimestamp {
          | Response(lastOracleUpdateTimestamp) =>
            <ProgressBar
              txConfirmedTimestamp={1} // TODO: now
              nextPriceUpdateTimestamp={lastOracleUpdateTimestamp->Ethers.BigNumber.toNumber +
                oracleHeartBeat}
              rerenderCallback=rerender
            />
          | GraphError(error) => <p> {error->React.string} </p>
          | Loading => <Loader.Tiny />
          }}
          <ViewOnBlockExplorer txHash />
          <ViewProfileButton />
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
  | _ => <Button disabled={buttonDisabled} onClick={_ => ()}> {buttonText} </Button>
  }
}
