let activeSelectionStyle = `bg-primary text-white  shadow-lg`
let inactiveSelectionStyle = `bg-white text-primary shadow-inner hover:bg-primary hover:bg-opacity-75 hover:text-white hover:shadow-md `
let transitionStyling = `transition-all duration-500 `

@react.component
let make = (~isLong, ~selectPosition, ~onBlur) => {
  <div
    className="flex flex-row justify-between w-full border-2 border-primary uppercase rounded-full bg-white text-center mb-4">
    <div
      className={`cursor-pointer w-full py-2 rounded-l-full ${isLong
          ? activeSelectionStyle
          : inactiveSelectionStyle} ${transitionStyling}`}
      onClick={_ => selectPosition("long")}>
      {`Long 🐮`->React.string}
    </div>
    <div
      className={`cursor-pointer w-full border-l-2 rounded-r-full border-primary hover:border-white py-2 ${!isLong
          ? activeSelectionStyle
          : inactiveSelectionStyle} ${transitionStyling}`}
      onClick={_ => selectPosition("short")}>
      {`Short 🐻`->React.string}
    </div>
  </div>
}
