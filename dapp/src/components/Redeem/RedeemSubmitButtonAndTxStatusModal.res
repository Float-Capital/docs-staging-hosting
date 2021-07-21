module ConfirmedTransactionModal = {
  @react.component
  let make = (~marketIndex) => {
    let lastOracleTimestamp = DataHooks.useOracleLastUpdate(
      ~marketIndex=marketIndex->Ethers.BigNumber.toString,
    )

    let (timerFinished, setTimerFinished) = React.useState(_ => false)

    let oracleHeartBeat = Backend.getMarketInfoUnsafe(
      marketIndex->Ethers.BigNumber.toNumber,
    ).oracleHeartbeat

    let milisecondsInSecond = 1000.
    let (completeTimestamp, _setCompleteTimestamp) = React.useState(_ =>
      Js.Date.now() /. milisecondsInSecond
    )

    <>
      <Modal id={8}>
        <div className="text-center m-3">
          <Tick />
          <p> {`Transaction complete 🎉`->React.string} </p>
          <p className="text-xxs text-gray-700">
            {`You can withdraw your ${Config.paymentTokenName} on the next oracle price update`->React.string}
          </p>
          {switch lastOracleTimestamp {
          | Response(lastOracleUpdateTimestamp) =>
            !timerFinished
              ? <ProgressBar
                  txConfirmedTimestamp={completeTimestamp->Belt.Int.fromFloat}
                  nextPriceUpdateTimestamp={lastOracleUpdateTimestamp->Ethers.BigNumber.toNumber +
                    oracleHeartBeat}
                  setTimerFinished
                />
              : <Withdraw marketIndex />
          | GraphError(error) => <p> {error->React.string} </p>
          | Loading => <Loader.Tiny />
          }}
          <ViewProfileButton />
        </div>
      </Modal>
    </>
  }
}

@react.component
let make = (~txStateRedeem, ~resetFormButton, ~buttonText, ~buttonDisabled, ~marketIndex) => {
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
  | ContractActions.Complete(_) => <ConfirmedTransactionModal marketIndex />
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
