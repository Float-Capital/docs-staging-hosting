module Container = {
  @react.component
  let make = (~children) =>
    <div className={"w-full flex flex-col md:flex-row justify-between"}> {children} </div>
}

module Divider = {
  @react.component
  let make = (~children) =>
    <div className={"w-full md:w-1/3 px-3 md:px-0 m-0 md:m-4"}> {children} </div>
}

module Card = {
  @react.component
  let make = (~children) =>
    <div className={"bg-white w-full bg-opacity-75 rounded-lg shadow-lg mb-2 md:mb-5"}>
      {children}
    </div>
}

module Header = {
  @react.component
  let make = (~children) =>
    <h1 className="font-bold text-center pt-5 text-lg font-vt323"> {children} </h1>
}
