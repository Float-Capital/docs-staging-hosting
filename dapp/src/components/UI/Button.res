@react.component
let make = (~onClick, ~children: string, ~variant="small") =>
  <div className="float-button-outer-container">
    <div
      className={`float-button-container ${variant == "small"
          ? "float-button-container-small"
          : ""}`}>
      <button className={`float-button ${variant == "small" ? "float-button-small" : ""}`} onClick>
        {children->React.string}
      </button>
    </div>
  </div>
