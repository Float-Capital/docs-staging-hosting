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
      <h1>
        {`BUSD balance: $${FormatMoney.formatMoney(
            ~number=balance->Ethers.Utils.formatEther->Float.fromString->Option.getWithDefault(0.),
          )}`->React.string}
      </h1>
    | None => <MiniLoader />
    }}
  </>
}
