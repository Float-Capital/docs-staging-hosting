@react.component
let make = (~signer) => {
  let (contractExecutionHandler, txState, setTxState) = ContractActions.useContractFunction(~signer)

  let tokenAddress = Config.useLongContractAddress()

  let onClick = _ =>
    contractExecutionHandler(
      ~makeContractInstance=Contracts.LongShort.make(~address=tokenAddress),
      ~contractFunction=Contracts.LongShort._updateSystemState,
    )

  <TxTemplate
    txState
    resetTxState={() => {
      setTxState(_ => ContractActions.UnInitialised)
    }}>
    <div>
      <div className="">
        <h2 className="text-xl"> {"Update System State"->React.string} </h2>
        <div>
          <button className={"text-lg disabled:opacity-50 bg-green-500 rounded-lg"} onClick>
            {"Submit"->React.string}
          </button>
        </div>
      </div>
    </div>
  </TxTemplate>
}
