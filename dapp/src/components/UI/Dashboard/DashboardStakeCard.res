let isHotAPY = apy => apy > 0.15

let mapVal = apy =>
  `${(apy *. 100.)->Js.Float.toFixedWithPrecision(~digits=2)}%${apy->isHotAPY
      ? `🔥`
      : ""}`


@react.component
let make = (~marketName, ~isLong, ~yield, ~rewards) =>                 
<div className="mb-5 flex w-11/12 mx-auto border-2 border-light-purple rounded-lg z-10 shadow">
    <div className="my-2 ml-5 text-sm">
    {marketName->React.string}
    <br className="mt-1"/>
    {(isLong ? `Long↗️`: `Short↘️`)->React.string}
    </div>
    <div className="text-center w-full my-2 text-sm">
    {`Yield: ${~mapVal(yield)}`->React.string}
    <br className="mt-1"/>
    {`Float rewards: ${~mapVal(rewards)}`->React.string}
    </div>
</div>
