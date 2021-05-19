let buttonOuterStyle = `relative my-1`
let buttonShaddowStyle = active =>
  `${active ? "" : "transform translate-x-1 translate-y-1"} w-full bg-primary inline-block`
let buttonTopStyle = active =>
  `${active
      ? "text-white bg-primary outline-none"
      : "transform -translate-x-1 -translate-y-1 hover:-translate-x-0.5 hover:-translate-y-0.5 active:translate-x-0 active:translate-y-0 active:text-white active:bg-primary active:outline-none"} w-full transition ease-linear duration-0 italic cursor-pointer bg-white border text-primary uppercase tracking-btn-text`

module Tiny = {
  @react.component
  let make = (~onClick=_ => (), ~children: string, ~disabled=false, ~active=false) => {
    <div className="flex">
      <div className={`${buttonOuterStyle} w-full`}>
        <div className={`${buttonShaddowStyle(active)} h-full`}>
          <button
            disabled={disabled}
            className={`${buttonTopStyle(
                active,
              )} min-h-full focus:outline-none px-2 text-xxs ${disabled
                ? " transform -translate-x-0.5 -translate-y-0.5 bg-gray-200 cursor-not-allowed"
                : ""}`}
            onClick>
            {children->React.string}
          </button>
        </div>
      </div>
    </div>
  }
}
module Small = {
  @react.component
  let make = (~onClick=_ => (), ~children: string, ~disabled=false, ~active=false) => {
    <div className=buttonOuterStyle>
      <div className={`${buttonShaddowStyle(active)} border`}>
        <button
          disabled={disabled}
          className={`${buttonTopStyle(active)} p-2 text-sm focus:outline-none ${disabled
              ? " transform -translate-x-0.5 -translate-y-0.5 bg-gray-200 cursor-not-allowed"
              : ""}`}
          onClick>
          {children->React.string}
        </button>
      </div>
    </div>
  }
}

module Element = {
  @react.component
  let make = (~onClick=_ => (), ~children: React.element, ~disabled=false, ~active=false) => {
    <div className="inline-block">
      <div className={buttonOuterStyle}>
        <div className={`${buttonShaddowStyle(active)} border-0 `}>
          <button
            disabled={disabled}
            className={`${buttonTopStyle(
                active,
              )} p-3 focus:outline-none text-base mx-auto ${disabled
                ? " transform -translate-x-0.5 -translate-y-0.5 bg-gray-200 cursor-not-allowed"
                : ""}`}
            onClick>
            {children}
          </button>
        </div>
      </div>
    </div>
  }
}

@react.component
let make = (~onClick=_ => (), ~children: string, ~disabled=false, ~active=false) => {
  <div className=buttonOuterStyle>
    <div className={`${buttonShaddowStyle(active)} border-0`}>
      <button
        disabled={disabled}
        className={`${buttonTopStyle(active)} p-3 focus:outline-none text-base ${disabled
            ? " transform -translate-x-0.5 -translate-y-0.5 bg-gray-200 cursor-not-allowed"
            : ""}`}
        onClick>
        {children->React.string}
      </button>
    </div>
  </div>
}
