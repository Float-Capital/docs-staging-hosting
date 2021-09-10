@react.component
let make = (~totalValueStaked, ~global) =>
  <div className={"bg-white w-full bg-opacity-75 rounded-lg shadow-lg mb-2 md:mb-5 p-6"}>
    <h1 className="font-bold text-center text-lg font-alphbeta">
      {`Staking 🔥`->React.string}
    </h1>
    <div className="text-center mt-5">
      <div className="text-sm"> {`💰 Total staked value `->React.string} </div>
      <div className="text-green-700 text-xl ">
        {`$${totalValueStaked->Misc.NumberFormat.formatEther}`->React.string}
      </div>
    </div>
    <div className="text-left mt-4 text-sm font-bold"> {`Trending`->React.string} </div>
    <div className="pt-2 pb-5"> <TrendingStakes global /> </div>
  </div>
