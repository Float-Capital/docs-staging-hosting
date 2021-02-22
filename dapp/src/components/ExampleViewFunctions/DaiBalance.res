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
      <div className="flex justify-between w-full">
        <p> {`BUSD balance: `->React.string} </p>
        <p> {`$${FormatMoney.formatEther(balance)}`->React.string} </p>
      </div>
    | None => <MiniLoader />
    }}
  </>
}
