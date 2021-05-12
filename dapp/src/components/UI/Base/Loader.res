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

@react.component
let make = () =>
  <div className="screen-centered-container">
    <img src="/img/loading.gif" className="loader" />
  </div>
