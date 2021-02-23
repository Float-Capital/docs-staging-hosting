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
    | Some(balance) => <p> {FormatMoney.formatEther(balance)->React.string} </p>
    | None => <MiniLoader />
    }}
  </>
}
