@react.component
let make = (
  ~placeholder,
  ~value,
  ~disabled,
  ~onBlur,
  ~onChange,
  ~onMaxClick,

) =>(
    <div className="flex flex-row m-3">
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
      <span
        className="flex items-center bg-gray-100 hover:bg-white hover:text-grey-darkest px-5 font-bold">
      <span onClick={onMaxClick}> {"MAX"->React.string} </span>
    </span>
  </div>
)