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
  }
}

@react.component
let make = (~txStateRedeem, ~resetFormButton, ~buttonText, ~buttonDisabled, ~marketIndex) => {
  let {showModal, hideModal: _} = ModalProvider.useModalDisplay()

  React.useEffect1(() => {
    switch txStateRedeem {
    | ContractActions.Created =>
      showModal(
        <div className="text-center m-3">
          <Loader.Ellipses />
          <h1> {`Confirm the transaction to redeem ${Config.paymentTokenName}`->React.string} </h1>
        </div>,
      )
    | ContractActions.SignedAndSubmitted(txHash) =>
      showModal(
        <div className="text-center m-3">
          <div className="m-2"> <Loader.Mini /> </div>
          <p> {"Redeem transaction pending... "->React.string} </p>
          <p className="text-xxs text-yellow-600">
            {`⚡ Redeeming your position requires a second withdraw transaction once the oracle price has updated ⚡`->React.string}
          </p>
          <ViewOnBlockExplorer txHash />
        </div>,
      )
    | ContractActions.Complete(_) => showModal(<ConfirmedTransactionModal marketIndex />)
    | ContractActions.Declined(_message) =>
      showModal(
        <div className="text-center m-3">
          <p> {`The transaction was rejected by your wallet`->React.string} </p>
          <MessageUsOnDiscord />
        </div>,
      )
    | ContractActions.Failed(txHash) =>
      showModal(
        <div className="text-center m-3">
          <h1> {`The transaction failed.`->React.string} </h1>
          <ViewOnBlockExplorer txHash />
          <MessageUsOnDiscord />
        </div>,
      )
    | _ => ()
    }
    None
  }, [txStateRedeem])

  switch txStateRedeem {
  | ContractActions.Declined(_)
  | ContractActions.Failed(_) =>
    resetFormButton()
  | _ => <Button disabled={buttonDisabled} onClick={_ => ()}> {buttonText} </Button>
  }
}
