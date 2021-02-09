@react.component
let make = () => {
  let {
    data: optBalance,
    isValidating: _isValidating,
    error: _errorLoadingBalance,
    mutate: _mutate,
  } = ContractHooks.useDaiBalance()

  <>
    {switch optBalance {
    | Some(balance) =>
      <h1> {`dai balance: ${balance->Ethers.Utils.formatEther} DAI`->React.string} </h1>
    | None => <h1> {"Loading dai balance"->React.string} </h1>
    }}
  </>
}
