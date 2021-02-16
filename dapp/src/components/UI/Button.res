@react.component
let make = (~onClick, ~text, ~variant) =>
  <div className="float-button-outer-container">
    <div
      className={`float-button-container ${variant == "small"
          ? "float-button-container-small"
          : ""}`}>
      <button className={`float-button ${variant == "small" ? "float-button-small" : ""}`} onClick>
        {text->React.string}
      </button>
    </div>
  </div>
