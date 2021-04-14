@react.component
let make = (~tokenAddress) => {
  let signer = ContractActions.useSignerExn()

  let (contractExecutionHandler, _txState, _setTxState) = ContractActions.useContractFunction(
    ~signer,
  )

  <Button.Tiny
    onClick={_ => {
      let _ = contractExecutionHandler(
        ~makeContractInstance=Contracts.Staker.make(~address=Config.staker),
        ~contractFunction=Contracts.Staker.claimFloatImmediately(~tokenAddress),
      )
    }}>
    "Claim Float"
  </Button.Tiny>
}
