module Overlay = {
  @react.component
  let make = () =>
    <div className="absolute top-0 left-0 w-full h-full flex justify-center">
      <img src="/img/loading.gif" className="object-contain" />
    </div>
}
@react.component
let make = () =>
  <div className="screen-centered-container">
    <img src="/img/loading.gif" className="loader" />
  </div>
