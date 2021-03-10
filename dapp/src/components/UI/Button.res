@react.component
let make = (~onClick, ~children: string, ~variant="small") => {
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
      <button className={buttonClass} onClick> {children->React.string} </button>
    </div>
  </div>
}
