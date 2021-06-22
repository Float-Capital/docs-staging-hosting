@react.component
let make = (
  ~value,
  ~optBalance=None,
  ~disabled,
  ~onBlur,
  ~onChange,
  ~onMaxClick,
  ~optCurrency=None,
) =>
  <div className="flex flex-row my-3 shadow-md">
    <input
      id="amount"
      className="py-2 font-normal text-grey-darkest w-full py-1 px-2 outline-none text-md text-gray-600"
      type_="text"
      placeholder={"0.0"}
      value={value}
      disabled={disabled}
      onBlur={onBlur}
      onChange={onChange}
    />
    {switch optCurrency {
    | Some(currency: CONSTANTS.displayToken) =>
      <span className="flex items-center bg-white pr-3 text-md text-gray-300 min-w-56">
        <img src={currency.iconUrl} className="h-5 pr-1" /> {currency.name->React.string}
      </span>
    | _ => React.null
    }}
    {switch optBalance {
    | Some(balance) =>
      <span className="flex items-center bg-white px-1 text-xxs text-gray-400">
        {`balance ${balance->Ethers.Utils.formatEtherToPrecision(2)}`->React.string}
      </span>
    | _ => React.null
    }}
    <span
      className="flex items-center bg-gray-200 hover:bg-white hover:text-gray-700 px-5 font-bold">
      <span onClick={onMaxClick}> {"MAX"->React.string} </span>
    </span>
  </div>
