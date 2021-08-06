open APYProvider

let {ifElement} = module(Masonry)

let isHotAPY = apy => apy > CONSTANTS.hotAPYThreshold

let apyToStr = apy => (apy *. 100.)->Js.Float.toFixedWithPrecision(~digits=2)

let mapVal = apy => `${apyToStr(apy)}%${apy->isHotAPY ? `🔥` : ""}`->React.string

let apyComponent = (~heading, ~suffix, ~apy) => {
  <div className="flex flex-col items-center">
    <h3 className="text-xs mt-1">
      <span className="font-bold"> {heading->React.string} </span> {" APY"->React.string} {suffix}
    </h3>
    <p className="text-xl tracking-widest font-alphbeta"> {`${apy->apyToStr}%`->React.string} </p>
  </div>
}

@react.component
let make = (~orderPostion, ~orderPostionMobile, ~isLong, ~apy, ~floatApy, ~stakeApy) => {
  <div
    className={`order-${orderPostionMobile->Int.toString} md:order-${orderPostion->Int.toString} w-1/2 md:w-1/4 flex items-center flex grow flex-wrap flex-col`}>
    <div className="flex flex-col items-center justify-center pt-0">
      <h3 className="text-xs mt-2">
        <span className="font-bold"> {isLong ? "LONG"->React.string : "SHORT"->React.string} </span>
        {" FLOAT Multiplier"->React.string}
      </h3>
      <p className="text-2xl md:text-4xl tracking-widest font-alphbeta"> {floatApy->mapVal} </p>
    </div>
    <div className="flex items-center justify-center pt-0 text-gray-600">
      {switch (apy, stakeApy) {
      | (Loaded(apyVal), Loaded(stakeApy)) => {
          let apyGreaterThanZero = apyVal >= 0.01
          let stakeApyGreaterThanZero = stakeApy >= 0.01
          <>
            {ifElement(
              apyGreaterThanZero,
              apyComponent(~heading="SYNTH", ~apy=apyVal, ~suffix=React.null),
            )}
            {ifElement(
              apyGreaterThanZero && stakeApyGreaterThanZero,
              <span className="mx-2"> {"+"->React.string} </span>,
            )}
            {ifElement(
              stakeApyGreaterThanZero,
              apyComponent(
                ~heading="STAKE",
                ~apy=stakeApy,
                ~suffix=<span className="ml-1">
                  <Tooltip tip="Expected yield from FLOAT buybacks" />
                </span>,
              ),
            )}
          </>
        }
      | _ => <Loader.Mini />
      }}
    </div>
  </div>
}
