@react.component
let make = (~children) =>
  <div
    className="py-3 px-5 my-2 mx-0 flex flex-col items-center bg-white bg-opacity-75  rounded w-full">
    {children}
  </div>
