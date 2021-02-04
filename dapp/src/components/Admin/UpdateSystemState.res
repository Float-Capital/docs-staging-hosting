let useLongContractAddress = () => {
  switch RootProvider.useNetworkId() {
  | Some(97) => "0x60250481EcE03F321c12134FACC0fDfA9F95012C"
  | Some(321) => "0xa9e638f77Eea6036D05F00d0AC55169357De114E"
  | Some(5)
  | Some(_)
  | None => "0x0dFD477dD71664821DE0c376DD23c3dcdE207448"
  }->Ethers.Utils.getAddressUnsafe
}

@react.component
let make = () => {
  let (contractExecutionHandler, txState, setTxState) = ContractActions.useContractFunction()

  let tokenAddress = useLongContractAddress()

  let onClick = _ => contractExecutionHandler(
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
          <button
            className={"text-lg disabled:opacity-50 bg-green-500 rounded-lg"}
            onClick=onClick
          >
          {"Submit"->React.string}
          </button>
        </div>
      </div>
    </div>
  </TxTemplate>
}
