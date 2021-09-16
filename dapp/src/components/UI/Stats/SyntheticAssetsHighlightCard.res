@react.component
let make = (~totalSynthValue) =>
  <div className={"bg-white w-full bg-opacity-75 rounded-lg shadow-lg mb-2 md:mb-5 p-6"}>
    <h1 className="font-bold text-center text-lg font-alphbeta">
      {`Synthetic Assets`->React.string}
      <img className="inline h-5 ml-2" src="/icons/dollar-coin.png" />
    </h1>
    <div className="p-6 py-4 text-center">
      <div>
        <span className="text-sm mr-2"> {`💰 Total synth value`->React.string} </span>
        <div className="text-green-700 text-xl ">
          {`$${totalSynthValue->Misc.NumberFormat.formatEther}`->React.string}
          <span className="text-black">
            <Tooltip tip={"Redeemable value of synths in the open market"} />
          </span>
        </div>
      </div>
    </div>
    <Next.Link href="/app/markets">
      <div className="w-full text-sm cursor-pointer hover:opacity-70 mx-auto">
        <div className="flex justify-center">
          <div className="inline-block mx-auto">
            <p> {`👀 See markets`->React.string} </p>
            <p className="ml-5"> {`to learn more...`->React.string} </p>
          </div>
        </div>
      </div>
    </Next.Link>
  </div>
