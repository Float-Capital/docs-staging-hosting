open APYProvider

@react.component
let make = (~orderPostion, ~orderPostionMobile, ~marketName, ~isLong, ~apy, ~floatApy, ~beta) => {
  let tradeType = isLong ? "long" : "short"
  let textPosition = isLong ? "text-left" : "text-right"

  let isHotAPY = apy => apy > CONSTANTS.hotAPYThreshold

  let mapAPY = apy => {
    let maybeHotFlame = apy->isHotAPY ? `🔥` : ""
    let apyDisplay = (apy *. 100.)->Js.Float.toFixedWithPrecision(~digits=2)

    isLong ? `${apyDisplay}${maybeHotFlame}` : `${maybeHotFlame}${apyDisplay}`
  }

  <div
    className={`${textPosition} order-${orderPostionMobile->Int.toString} md:order-${orderPostion->Int.toString} w-1/2 md:w-1/4 flex flex grow flex-wrap flex-col`}>
    <h2 className="font-bold text-sm">
      {marketName->React.string}
      <span className="text-xs"> {isLong ? `↗️`->React.string : `↘️`->React.string} </span>
    </h2>
    <div className="flex flex-col justify-center pt-0 my-1">
      <h3 className="text-xxs mt-2">
        <span className="font-bold  text-gray-600">
          {isLong ? "LONG"->React.string : "SHORT"->React.string}
        </span>
        {" FLOAT rewards"->React.string}
      </h3>
      <p className="text-lg md:text-xl tracking-widest font-alphbeta">
        {floatApy->mapAPY->React.string}
      </p>
    </div>
    <div className="flex flex-col justify-center pt-0 my-1">
      <h3 className="text-xxs">
        <span className="font-bold  text-gray-600">
          {isLong ? "LONG"->React.string : "SHORT"->React.string}
        </span>
        {" APY"->React.string}
      </h3>
      {switch apy {
      | Loaded(apyVal) =>
        <p className="text-lg  tracking-widest font-alphbeta"> {apyVal->mapAPY->React.string} </p>
      | _ => <Loader.Tiny />
      }}
    </div>
    <div className="text-sm my-1">
      <h3 className="text-xxs">
        <span className="font-bold  text-gray-600"> {`Exposure `->React.string} </span>
        <Tooltip tip={`The impact ${marketName} price movements have on the ${tradeType} value`} />
      </h3>
      <p className="text-lg tracking-widest font-alphbeta"> {`${beta}%`->React.string} </p>
    </div>
  </div>
}
