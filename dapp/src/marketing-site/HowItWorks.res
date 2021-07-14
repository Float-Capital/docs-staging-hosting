@react.component
let make = () => {
  <section
    id="how-it-works"
    className="py-10 bg-white min-h-screen w-screen flex flex-col items-center justify-center purple-moon">
    <div className="flex flex-col items-center">
      <Heading title="how it works" suffixEmoji=`🔬` />
      <div
        className="grid grid-cols-1 md:grid-cols-2 mx-4 my-4 gap-4 md:gap-10 md:flex-row items-center max-w-5xl">
        <div className="bg-white bg-opacity-60 p-4 rounded-md">
          <h3 className="text-xl md:text-4xl flex flex-row items-center">
            <span> {"Mint"->React.string} </span>
            <img src="/icons/mint.png" className="h-6 md:h-10" />
          </h3>
          <p className="text-md md:text-xl">
            {"Open a postion by depositing DAI into a market to mint synthetic tokens"->React.string}
          </p>
        </div>
        <div className="bg-white bg-opacity-60 p-4 rounded-md">
          <h3 className="text-xl md:text-4xl flex flex-row items-center">
            <span> {"Stake"->React.string} </span>
            <img src="/icons/stake.png" className="h-6 md:h-10" />
          </h3>
          <p className="text-md md:text-xl">
            {"Stake your synth tokens to earn FLT token"->React.string}
          </p>
        </div>
        <div className="bg-white bg-opacity-60 p-4 rounded-md">
          <h3 className="text-xl md:text-4xl flex flex-row items-center">
            <span> {"Redeem "->React.string} </span>
            <span className="text-xl md:text-4xl"> {` 📈`->React.string} </span>
          </h3>
          <p className="text-md md:text-xl">
            {"Redeem your synth tokens for DAI to close a position"->React.string}
          </p>
        </div>
        <div className="bg-white bg-opacity-60 p-4 rounded-md">
          <h3 className="text-xl md:text-4xl flex flex-row items-center">
            <span> {`Govern`->React.string} </span>
            <span className="text-xl md:text-4xl"> {` 🗳`->React.string} </span>
          </h3>
          <p className="text-md md:text-xl">
            {"Use your FLT tokens to govern the future of the protocol"->React.string}
          </p>
        </div>
      </div>
      // <div className="my-2 text-4xl">
      //   <p className="text-md">
      //     {"Float Capital is a peer to peer mechanism which means there is;"->React.string}
      //   </p>
      //   <h2> {"No over-collateralization"->React.string} </h2>
      //   <h2> {"No liquidiation"->React.string} </h2>
      //   <h2> {"No centralization"->React.string} </h2>
      // </div>
    </div>
  </section>
}

// <div className="flex flex-col md:flex-row items-center">
//   <div className="w-full md:w-2/5 mx-2 relative">
//     <Heading title="how it works" suffixEmoji=`🔬` />
//   </div>
//   <div className="w-full md:w-3/5"> <FeaturedMarkets /> </div>
// </div>
