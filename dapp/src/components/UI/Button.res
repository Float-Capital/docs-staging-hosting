let buttonOuterStyle = `relative my-1`
let buttonShaddowStyle = `transform translate-x-1 translate-y-1 w-full bg-primary inline-block`
let buttonTopStyle = `transform -translate-x-1 -translate-y-1 hover:-translate-x-0.5 hover:-translate-y-0.5 active:translate-x-0 active:translate-y-0 w-full transition ease-linear duration-0 italic cursor-pointer bg-white border text-primary active:text-white active:bg-primary active:outline-none uppercase tracking-btn-text`

module Tiny = {
  @react.component
  let make = (~onClick=_ => (), ~children: string, ~disabled=false) => {
    // No idea why a flex is needed here, without it some small buttons looks kak
    <div className="flex">
      <div className={`${buttonOuterStyle} w-full`}>
        <div className={`${buttonShaddowStyle} h-full`}>
          <button
            disabled={disabled}
            className={`${buttonTopStyle} min-h-full focus:outline-none px-2 text-xxs ${disabled
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
  let make = (~onClick=_ => (), ~children: string, ~disabled=false) => {
    <div className=buttonOuterStyle>
      <div className={`${buttonShaddowStyle} border`}>
        <button
          disabled={disabled}
          className={`${buttonTopStyle} p-2 text-sm focus:outline-none ${disabled
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
let make = (~onClick=_ => (), ~children: React.element, ~disabled=false) => {
  <div className="inline-block">
  <div className={`${buttonOuterStyle}`} >
    <div className={`${buttonShaddowStyle} border-0 `}>
      <button
        disabled={disabled}
        className={`${buttonTopStyle} p-3 focus:outline-none text-base mx-auto ${disabled
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
let make = (~onClick=_ => (), ~children: string, ~disabled=false) => {
  <div className=buttonOuterStyle>
    <div className={`${buttonShaddowStyle} border-0`}>
      <button
        disabled={disabled}
        className={`${buttonTopStyle} p-3 focus:outline-none text-base ${disabled
            ? " transform -translate-x-0.5 -translate-y-0.5 bg-gray-200 cursor-not-allowed"
            : ""}`}
        onClick>
        {children->React.string}
      </button>
    </div>
  </div>
}
