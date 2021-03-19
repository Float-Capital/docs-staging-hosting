let buttonOuterStyle = `relative my-3`
let buttonShaddowStyle = `transform translate-x-1 translate-y-1 w-full bg-primary inline-block`
let buttonTopStyle = `transform -translate-x-1 -translate-y-1 hover:-translate-x-0.5 hover:-translate-y-0.5 w-full transition ease-linear duration-0 italic cursor-pointer bg-white border text-primary uppercase tracking-btn-text `

module Tiny = {
  @react.component
  let make = (~onClick=_ => (), ~children: string, ~disabled=false) => {
    <div className="flex">
      // No idea why a float is needed here, without it some small buttons looks kak
      <div className={`${buttonOuterStyle} w-full`}>
        <div className={`${buttonShaddowStyle} h-full`}>
          <button
            disabled={disabled}
            className={`${buttonTopStyle} min-h-full px-2 text-xxs ${disabled
                ? " transform -translate-x-0.5 -translate-y-0.5 bg-gray-300"
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
  let make = (~onClick=_ => (), ~children: string, ~disabled=false) => {
    <div className=buttonOuterStyle>
      <div className={`${buttonShaddowStyle} border`}>
        <button
          disabled={disabled}
          className={`${buttonTopStyle} p-2 text-sm ${disabled
              ? " transform -translate-x-0.5 -translate-y-0.5 bg-gray-300"
              : ""}`}
          onClick>
          {children->React.string}
        </button>
      </div>
    </div>
  }
}

@react.component
let make = (~onClick=_ => (), ~children: string, ~disabled=false) => {
  <div className=buttonOuterStyle>
    <div className={`${buttonShaddowStyle} border-0`}>
      <button
        disabled={disabled}
        className={`${buttonTopStyle} p-3 text-base ${disabled
            ? " transform -translate-x-0.5 -translate-y-0.5 bg-gray-300"
            : ""}`}
        onClick>
        {children->React.string}
      </button>
    </div>
  </div>
}
