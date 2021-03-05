@react.component
let make = (~marketName, ~isLong, ~yieldStr, ~rewardsStr) =>                 
<div className="mb-5 flex w-11/12 mx-auto border-2 border-light-purple rounded-lg z-10 shadow">
    <div className="w-1/3 my-2 ml-5 text-sm">
    {marketName->React.string}
    <br className="mt-1"/>
    {(isLong ? `Long↗️`: `Short↘️`)->React.string}
    </div>
    <div className="text-center my-2 ml-5 text-sm">
    {`Yield: ${~yieldStr}`->React.string}
    <br className="mt-1"/>
    {`Float rewards: ${~rewardsStr}`->React.string}
    </div>
</div>