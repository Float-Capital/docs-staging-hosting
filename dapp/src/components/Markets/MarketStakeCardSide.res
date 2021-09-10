open APYProvider

let ifElement = (condition, element) =>
  if condition {
    element
  } else {
    React.null
  }

@react.component
let make = (
  ~orderPostion,
  ~orderPostionMobile,
  ~marketName,
  ~isLong,
  ~apy,
  ~floatApy,
  ~beta,
  ~stakeApy,
) => {
  let tradeType = isLong ? "long" : "short"
  let textPosition = isLong ? "text-left" : "text-right"

  let isHotAPY = apy => apy > CONSTANTS.hotAPYThreshold

  let mapAPY = apy => {
    let maybeHotFlame = apy->isHotAPY ? `🔥` : ""
    let apyDisplay = (apy *. 100.)->Js.Float.toFixedWithPrecision(~digits=2)

    isLong ? `${apyDisplay}%${maybeHotFlame}` : `${maybeHotFlame}${apyDisplay}%`
  }

  let apyComponent = (~header, ~apy, ~suffix) => {
    <div className="flex flex-col justify-center pt-0 my-1">
      <h3 className="text-xxs">
        <span className="font-bold  text-gray-600"> {header->React.string} </span>
        {" APY"->React.string}
        {suffix}
      </h3>
      <p className="text-sm tracking-widest font-alphbeta">
        {`${(apy *. 100.)->Js.Float.toFixedWithPrecision(~digits=2)}%`->React.string}
      </p>
    </div>
  }

  <div
    className={`${textPosition} order-${orderPostionMobile->Int.toString} md:order-${orderPostion->Int.toString} w-1/2 md:w-1/4 flex my-auto grow flex-wrap flex-col`}>
    <div className="flex flex-col justify-center pt-0 my-1">
      <h3 className="text-xxs mt-2">
        <span className="font-bold  text-gray-600">
          {isLong ? "LONG"->React.string : "SHORT"->React.string}
        </span>
        {" FLOAT Multiplier"->React.string}
      </h3>
      <p className="text-lg md:text-xl tracking-widest font-alphbeta">
        {floatApy->mapAPY->React.string}
      </p>
    </div>
    <div className={`flex ${isLong ? "justify-start" : "justify-end"} items-center`}>
      {switch (apy, stakeApy) {
      | (Loaded(apyVal), Loaded(stakeApy)) => {
          let apyGreaterThanZero = apyVal >= 0.01
          let stakeApyGreaterThanZero = stakeApy >= 0.01
          <>
            {ifElement(
              apyGreaterThanZero,
              apyComponent(~header="SYNTH", ~apy=apyVal, ~suffix=React.null),
            )}
            {ifElement(
              stakeApyGreaterThanZero && apyGreaterThanZero,
              <span className="mx-1"> {"+"->React.string} </span>,
            )}
            {ifElement(
              stakeApyGreaterThanZero,
              apyComponent(
                ~header="STAKE",
                ~apy=stakeApy,
                ~suffix=<span className="ml-1">
                  <Tooltip tip="Expected yield from FLT token buybacks" />
                </span>,
              ),
            )}
          </>
        }
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
