@react.component
let make = (~onClick, ~children: string, ~variant="small", ~disabled=false) => {
  let outerContainerClass = `float-button-outer-container ${variant == "tiny"
      ? "float-button-outer-container-tiny"
      : ""}`

  let containerClass = `float-button-container ${variant == "small"
      ? "float-button-container-small"
      : ""} ${variant == "tiny" ? "float-button-container-tiny" : ""}`

  let buttonClass = `float-button ${variant == "small"
      ? "float-button-small"
      : ""} ${variant == "tiny" ? "float-button-tiny" : ""}`

  <div className={outerContainerClass}>
    <div className={containerClass}>
      <button
        disabled={disabled}
        className={`${buttonClass}${disabled
            ? " transform -translate-x-0.5 -translate-y-0.5 bg-gray-300"
            : ""}`}
        onClick={_ => Js.log("WAS CLICKED")}>
        {children->React.string}
      </button>
    </div>
  </div>
}
