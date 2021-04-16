@react.component
let make = (~totalLockedLong, ~totalValueLocked) => {
  let percentStrLong = Globals.percentStr(~n=totalLockedLong, ~outOf=totalValueLocked)
  let percentStrShort =
    (100.0 -. percentStrLong->Float.fromString->Option.getExn)
      ->Js.Float.toFixedWithPrecision(~digits=2)

  <div className="relative w-full h-6 my-1">
    <div className="w-full flex h-8 justify-between items-center absolute bottom-0 z-10">
      <div className="font-bold text-xs ml-2 text-gray-100">
        {`${percentStrLong}%`->React.string}
        <span className="text-lg"> {` 🐮`->React.string} </span>
      </div>
      <div className="font-bold text-xs mr-2 text-gray-100">
        <span className="text-lg"> {`🐻 `->React.string} </span>
        {`${percentStrShort}% `->React.string}
      </div>
    </div>
    <div className="w-full flex h-8 absolute bottom-0 z-0">
      <div
        style={ReactDOM.Style.make(~width=`${percentStrLong}%`, ())} className="h-8 bg-blue-400"
      />
      <div
        style={ReactDOM.Style.make(~width=`${percentStrShort}%`, ())} className="h-8 bg-blue-300"
      />
    </div>
  </div>
}
