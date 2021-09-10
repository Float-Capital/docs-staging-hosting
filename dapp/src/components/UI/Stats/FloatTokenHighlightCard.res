@react.component
let make = (~totalFloatMinted) =>
  <div className={"bg-white w-full bg-opacity-75 rounded-lg shadow-lg mb-2 md:mb-5 p-6"}>
    <h1 className="font-bold text-center text-lg font-alphbeta">
      {`🌊🌊 alphaFloat Token 🌊🌊`->React.string}
    </h1>
    <ul className="my-2 text-center">
      <li>
        <span className="text-sm mr-2"> {`🗳 alphaFloat supply:`->React.string} </span>
        <span className="text-md">
          {totalFloatMinted->Misc.NumberFormat.formatEther->React.string}
        </span>
        //   <Tooltip tip="The number of Float tokens in circulation" />
      </li>
      // TODO: reinstate with real Flt
      //   <li>
      //     <span className="text-sm mr-2"> {`😏 Float price:`->React.string} </span>
      //     <span className="text-md" />
      //   </li>
      //   <li>
      //     <span className="text-sm mr-2"> {`🧢 Market cap:`->React.string} </span>
      //     <span className="text-md" />
      //   </li>
    </ul>
    <a href="https://docs.float.capital/docs/alpha">
      <p className="text-center text-xxs text-gray mx-8">
        {`The alphaFloat token is the temporary non-transferable Float token for the alpha release. You can read more on the alpha release `->React.string}
        <span className="underline"> {"here."->React.string} </span>
      </p>
    </a>
  </div>
