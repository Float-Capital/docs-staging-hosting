@react.component
let make = (~erc20Address) => {
  let {
    data: optBalance,
    isValidating: _isValidating,
    error: _errorLoadingBalance,
    mutate: _mutate,
  } = ContractHooks.useErc20BalanceRefresh(~erc20Address)

  <>
    {switch optBalance {
    | Some(balance) => <p> {Misc.NumberFormat.formatEther(balance)->React.string} </p>
    | None => <Loader.Mini />
    }}
  </>
}
