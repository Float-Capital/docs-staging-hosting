@react.component
let make = (~children) => {
  <div className="flex lg:justify-center min-h-screen">
    <div className="max-w-5xl w-full text-gray-900 font-base">
      <div className="flex flex-col h-screen">
        <Navigation /> <div className="m-auto w-full"> children </div>
      </div>
    </div>
    <Lost />
  </div>
}
