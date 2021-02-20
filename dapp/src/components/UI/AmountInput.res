@react.component
let make = (~placeholder, ~value, ~optBalance=?, ~disabled, ~onBlur, ~onChange, ~onMaxClick) =>
  <div className="flex flex-row my-3">
    <input
      id="amount"
      className="py-2 font-normal text-grey-darkest w-full py-1 px-2 outline-none text-md text-gray-600"
      type_="text"
      placeholder={placeholder}
      value={value}
      disabled={disabled}
      onBlur={onBlur}
      onChange={onChange}
    />
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
