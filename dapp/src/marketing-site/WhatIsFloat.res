@react.component
let make = () => {
  <section
    id="what-is-float"
    className="py-10 bg-white min-h-screen w-screen flex flex-col items-center justify-center purple-moon relative">
    <div className="flex flex-col items-center">
      <div className="flex flex-row my-4 items-center justify-between max-w-6xl">
        <div className="w-full md:w-1/2 m-4 md:m-0 ">
          <h3 className="text-2xl md:text-4xl flex flex-row items-center my-2 font-bold">
            {`Synthetic assets reimagined`->React.string}
          </h3>
          <p className="text-lg md:text-xl my-2">
            <span> {"The "->React.string} </span>
            <span className="font-bold"> {"easiest"->React.string} </span>
            <span> {" and most "->React.string} </span>
            <span className="font-bold"> {"efficient"->React.string} </span>
            <span> {" way to gain "->React.string} </span>
            <span className="italic"> {"long"->React.string} </span>
            <span> {" or "->React.string} </span>
            <span className="italic"> {"short"->React.string} </span>
            <span> {" exposure to a wide variety of assets."->React.string} </span>
          </p>
          <ul className="my-2">
            <li>
              <span className="font-vt323 font-bold mr-2"> {">"->React.string} </span>
              {"No liquidations"->React.string}
            </li>
            <li>
              <span className="font-vt323 font-bold mr-2"> {">"->React.string} </span>
              {"No over-collateralization"->React.string}
            </li>
            <li>
              <span className="font-vt323 font-bold mr-2"> {">"->React.string} </span>
              {"No front-running"->React.string}
            </li>
            <li>
              <span className="font-vt323 font-bold mr-2"> {">"->React.string} </span>
              {"No fees"->React.string}
            </li>
          </ul>
        </div>
      </div>
      <div className="hidden md:block absolute bottom-10 right-10"> <FeaturedMarkets /> </div>
    </div>
  </section>
}
