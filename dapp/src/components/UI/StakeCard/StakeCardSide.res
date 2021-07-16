open APYProvider

let isHotAPY = apy => apy > CONSTANTS.hotAPYThreshold

let mapVal = apy =>
  `${(apy *. 100.)->Js.Float.toFixedWithPrecision(~digits=2)}%${apy->isHotAPY
      ? `🔥`
      : ""}`->React.string

@react.component
let make = (~orderPostion, ~orderPostionMobile, ~marketName, ~isLong, ~apy, ~floatApy) => {
  <div
    className={`order-${orderPostionMobile->Int.toString} md:order-${orderPostion->Int.toString} w-1/2 md:w-1/4 flex items-center flex grow flex-wrap flex-col`}>
    <h2 className="font-bold text-sm">
      {marketName->React.string}
      <span className="text-xs"> {isLong ? `↗️`->React.string : `↘️`->React.string} </span>
    </h2>
    <div className="flex flex-col items-center justify-center pt-0 mt-auto">
      <h3 className="text-xs mt-2">
        <span className="font-bold"> {isLong ? "LONG"->React.string : "SHORT"->React.string} </span>
        {" FLOAT rewards"->React.string}
      </h3>
      <p className="text-2xl md:text-4xl tracking-widest font-alphbeta"> {floatApy->mapVal} </p>
    </div>
    <div className="flex flex-col items-center justify-center pt-0 mt-auto text-gray-600">
      <h3 className="text-xxs mt-1">
        <span className="font-bold"> {isLong ? "LONG"->React.string : "SHORT"->React.string} </span>
        {" APY"->React.string}
      </h3>
      {switch apy {
      | Loaded(apyVal) =>
        <p className="text-xl tracking-widest font-alphbeta"> {apyVal->mapVal} </p>
      | _ => <Loader.Mini />
      }}
    </div>
  </div>
}
