@react.component
let make = (~marketName, ~isLong, ~value, ~beta) => {
  <>
    <h2 className="font-bold text-sm">
      {marketName->React.string}
      <span className="text-xs"> {isLong ? `↗️`->React.string : `↘️`->React.string} </span>
    </h2>
    <div className="flex flex-col items-center justify-center pt-0 mt-auto">
      <h3 className="text-xs mt-1">
        <span className="font-bold"> {isLong ? "LONG"->React.string : "SHORT"->React.string} </span>
        {" Liquidity"->React.string}
      </h3>
      <div className="text-2xl tracking-widest font-alphbeta my-3">
        {`$${value->FormatMoney.formatEther}`->React.string}
      </div>
    </div>
    <div className="text-sm text-center m-auto">
      <span className="font-bold"> {`Exposure`->React.string} </span>
      <Tooltip
        tip={`The impact ${marketName} price movements have on ${isLong ? "long" : "short"} value`}
      />
      <span className="font-bold"> {`: `->React.string} </span>
      {`${beta}%`->React.string}
    </div>
  </>
}
