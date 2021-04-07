@react.component
let make = (~tokenAddress) => {
  let signer = ContractActions.useSignerExn()

  let (contractExecutionHandler, _txState, _setTxState) = ContractActions.useContractFunction(
    ~signer,
  )

  let stakerAddress = Config.useStakerAddress()

  <Button.Tiny
    onClick={_ => {
      let _ = contractExecutionHandler(
        ~makeContractInstance=Contracts.Staker.make(~address=stakerAddress),
        ~contractFunction=Contracts.Staker.claimFloatImmediately(~tokenAddress),
      )
    }}>
    "Claim Float"
  </Button.Tiny>
}
