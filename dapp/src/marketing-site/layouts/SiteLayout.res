@react.component
let make = (~children) => {
  <div className="flex lg:justify-center min-h-screen">
    <div className="w-full text-gray-900 font-base">
      <div className="flex flex-col">
        <ComingSoon /> <SiteNav /> <div className="m-auto w-full"> children </div>
      </div>
    </div>
  </div>
}
