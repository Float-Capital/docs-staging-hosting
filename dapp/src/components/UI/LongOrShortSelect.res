let activeSelectionStyle = `bg-primary text-white  shadow-lg`
let inactiveSelectionStyle = disabled =>
  `bg-white text-primary shadow-inner ${disabled
      ? ""
      : "hover:bg-primary hover:bg-opacity-75 hover:text-white hover:shadow-md"} `
let transitionStyling = `transition-all duration-500 `
let onBlurStyling = disabled => disabled ? `cursor-not-allowed` : ``

@react.component
let make = (~isLong, ~selectPosition, ~disabled) => {
  <div
    className="flex flex-row justify-between w-full border-2  border-primary uppercase rounded-full bg-white text-center">
    <div
      className={`cursor-pointer w-full py-2 rounded-l-full ${isLong
          ? activeSelectionStyle
          : inactiveSelectionStyle(disabled)} ${transitionStyling} ${onBlurStyling(disabled)}`}
      onClick={_ => {
        if !disabled {
          selectPosition("long")
        }
      }}>
      {`Long 🐮`->React.string}
    </div>
    <div
      className={`cursor-pointer w-full border-l-2 rounded-r-full border-primary hover:border-white py-2 ${!isLong
          ? activeSelectionStyle
          : inactiveSelectionStyle(disabled)} ${transitionStyling} ${onBlurStyling(disabled)}`}
      onClick={_ => {
        if !disabled {
          selectPosition("short")
        }
      }}>
      {`Short 🐻`->React.string}
    </div>
  </div>
}
