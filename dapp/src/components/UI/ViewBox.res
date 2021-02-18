@react.component
let make = (~children) =>
  <div className="flex flex-col max-w-xl w-full m-auto p-6 border-white border-solid border-4">
    {children}
  </div>
