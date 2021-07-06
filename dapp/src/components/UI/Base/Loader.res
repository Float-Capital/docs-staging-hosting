module Overlay = {
  @react.component
  let make = () =>
    <div className="absolute top-0 left-0 w-full h-full flex justify-center align-center">
      <img src="/img/loading.gif" className="object-contain" />
    </div>
}

module Mini = {
  @react.component
  let make = () => <img src="/img/mini-loading.gif" className="w-6 mx-auto" />
}

module Ellipses = {
  @react.component
  let make = () =>
    <div className="relative">
      <div className="ellipsis"> <div className="ellipsis-inner" /> </div>
    </div>
}

module Tiny = {
  @react.component
  let make = () => {
    let (inlineLoaderState, setInlineLoaderState) = React.useState(_ => 0)

    Misc.Time.useInterval(() => setInlineLoaderState(current => mod(current + 1, 3)), ~delay=300)

    let elipsisDot = (~hide) =>
      <span className={`opacity-${hide ? "10" : "100"}`}> {`.`->React.string} </span>
    <div>
      {elipsisDot(~hide=inlineLoaderState == 0)}
      {elipsisDot(~hide=inlineLoaderState == 1)}
      {elipsisDot(~hide=inlineLoaderState == 2)}
    </div>
  }
}

@react.component
let make = () =>
  <div className="screen-centered-container">
    <img src="/img/loading.gif" className="loader" />
  </div>
