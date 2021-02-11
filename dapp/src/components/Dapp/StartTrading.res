@react.component
let make = (~onClick: _ => _) =>
  <div>
    <div className="screen-centered-container">
      <div className="start-trading">
        <div className="floating-container">
          <div className="floating">
            <span className="floating-image-wrapper" onClick={onClick}>
              <img src="/img/start-trading.png" className="start-trading" />
            </span>
          </div>
        </div>
      </div>
    </div>
  </div>
