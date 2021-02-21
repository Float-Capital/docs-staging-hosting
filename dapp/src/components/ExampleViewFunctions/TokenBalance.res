@react.component
let make = (~erc20Address) => {
  let {
    data: optBalance,
    isValidating: _isValidating,
    error: _errorLoadingBalance,
    mutate: _mutate,
  } = ContractHooks.useErc20Balance(~erc20Address)
  // let useErc20Balance = (~erc20Address) => {

  <>
    {switch optBalance {
    | Some(balance) =>
      <p>
        {FormatMoney.formatMoney(
          ~number=balance->Ethers.Utils.formatEther->Float.fromString->Option.getWithDefault(0.),
        )->React.string}
      </p>
    | None => <MiniLoader />
    }}
  </>
}
