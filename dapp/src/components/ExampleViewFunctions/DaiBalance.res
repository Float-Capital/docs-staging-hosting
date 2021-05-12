@react.component
let make = () => {
  let {data: optBalance} = ContractHooks.useDaiBalanceRefresh()

  <>
    {switch optBalance {
    | Some(balance) =>
      <div className="flex justify-between w-full">
        <p> {`DAI balance: `->React.string} </p>
        <p> {`$${Misc.NumberFormat.formatEther(balance)}`->React.string} </p>
      </div>
    | None => <Loader.Mini />
    }}
  </>
}
