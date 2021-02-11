@react.component
let make = (~onClick, ~text) =>
  <div className="float-button-outer-container">
    <div className="float-button-container">
      <button className="float-button" onClick> {text->React.string} </button>
    </div>
  </div>
