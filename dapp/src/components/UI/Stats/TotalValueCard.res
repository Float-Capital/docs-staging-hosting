@react.component
let make = (~totalValueLocked) =>
  <div
    className={"mb-2 md:mb-5 mx-3 p-5 md:mt-7 self-center text-center bg-white bg-opacity-75 rounded-lg shadow-lg"}>
    <span className="font-alphbeta text-xl"> {"Total Value"->React.string} </span>
    <span className="text-sm"> {` 🏦 in Float Capital: `->React.string} </span>
    <span className="text-green-700 font-bold text-xl">
      {`$${totalValueLocked->Misc.NumberFormat.formatEther}`->React.string}
    </span>
  </div>
