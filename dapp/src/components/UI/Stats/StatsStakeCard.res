let isHotAPY = apy => apy > CONSTANTS.hotAPYThreshold

let mapVal = apy =>
  `${(apy *. 100.)->Js.Float.toFixedWithPrecision(~digits=2)}%${apy->isHotAPY ? `🔥` : ""}`

@react.component
let make = (~marketName, ~isLong, ~yield, ~rewards, ~stakeYield) =>
  <Next.Link href="/app/stake-markets">
    <div
      className="my-2 flex w-full mx-auto border-2 border-light-purple rounded-lg z-10 shadow cursor-pointer">
      <div className="my-2 ml-5 text-sm">
        {marketName->React.string}
        <br className="mt-1" />
        {(isLong ? `Long↗️` : `Short↘️`)->React.string}
      </div>
      <div className="flex-1 my-2 text-sm flex flex-col items-center">
        <div>
          <div>
            <span className="text-xxs font-bold mr-2"> {`alphaFloat rewards:`->React.string} </span>
            {mapVal(rewards)->React.string}
          </div>
          <div className="mt-2">
            <span className="text-xs font-bold mr-2"> {`Synthetic Yield:`->React.string} </span>
            {mapVal(yield)->React.string}
          </div>
          <div className="mt-2">
            <span className="text-xs font-bold mr-2"> {`Stake Yield:`->React.string} </span>
            {mapVal(stakeYield)->React.string}
          </div>
        </div>
      </div>
    </div>
  </Next.Link>
