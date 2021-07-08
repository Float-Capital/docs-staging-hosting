@react.component
let make = () => {
  <div className="container">
    <div className="flex flex-col md:grid grid-cols-9 mx-auto p-2 text-white">
      // <!-- left -->
      <div className="flex flex-row-reverse md:contents">
        <div className="bg-primary col-start-1 col-end-5 p-4 rounded-xl my-4 ml-auto shadow-md">
          <h3 className="font-semibold text-lg mb-1"> {"Q1 2021"->React.string} </h3>
          <ul>
            <li> {"Protocol mechanism researched, designed"->React.string} </li>
            <li> {"Core suite of smart contracts implemented"->React.string} </li>
            <li> {"Basic UI created"->React.string} </li>
            <li> {"Functional testnet deployment to BSC"->React.string} </li>
          </ul>
        </div>
        <div className="col-start-5 col-end-6 md:mx-auto relative mr-10">
          <div className="h-full w-6 flex items-center justify-center">
            <div className="h-full w-1 bg-blue-800 pointer-events-none" />
          </div>
          <div className="w-6 h-6 absolute top-1/2 -mt-3 rounded-full bg-primary shadow" />
        </div>
      </div>
      // <!-- right -->
      <div className="flex md:contents">
        <div className="col-start-5 col-end-6 mr-10 md:mx-auto relative">
          <div className="h-full w-6 flex items-center justify-center">
            <div className="h-full w-1 bg-blue-800 pointer-events-none" />
          </div>
          <div className="w-6 h-6 absolute top-1/2 -mt-3 rounded-full bg-primary shadow" />
        </div>
        <div className="bg-primary col-start-6 col-end-10 p-4 rounded-xl my-4 mr-auto shadow-md">
          <h3 className="font-semibold text-lg mb-1"> {"Q2 2021"->React.string} </h3>
          <ul>
            <li> {"UI Design and iteration"->React.string} </li>
            <li> {"Move from BSC to Polygon (Matic)"->React.string} </li>
            <li>
              {"Updated testnet deployment with using Chainlink and Aave integration"->React.string}
            </li>
            <li>
              {"Fundraise to fund full time focus on protocol and sideline consulting"->React.string}
            </li>
          </ul>
        </div>
      </div>
      // <!-- left -->
      <div className="flex flex-row-reverse md:contents">
        <div className="bg-primary col-start-1 col-end-5 p-4 rounded-xl my-4 ml-auto shadow-md">
          <h3 className="font-semibold text-lg mb-1"> {"Q3 2021"->React.string} </h3>
          <ul>
            <li> {"Finalize protocol design "->React.string} </li>
            <li> {"Audit smart contracts"->React.string} </li>
            <li> {"Build dream team"->React.string} </li>
            <li> {"UI/UX refinement"->React.string} </li>
          </ul>
        </div>
        <div className="col-start-5 col-end-6 md:mx-auto relative mr-10">
          <div className="h-full w-6 flex items-center justify-center">
            <div className="h-full w-1 bg-blue-800 pointer-events-none" />
          </div>
          <div className="w-6 h-6 absolute top-1/2 -mt-3 rounded-full bg-primary shadow" />
        </div>
      </div>
      // <!-- left -->
      <div className="flex flex-row-reverse md:contents">
        <div className="bg-primary col-start-1 col-end-5 p-4 rounded-xl my-4 ml-auto shadow-md">
          <h3 className="font-semibold text-lg mb-1"> {"Q3 2021"->React.string} </h3>
          <ul>
            <li> {"Finalize protocol design "->React.string} </li>
            <li> {"Audit smart contracts"->React.string} </li>
            <li> {"Build dream team"->React.string} </li>
            <li> {"UI/UX refinement"->React.string} </li>
          </ul>
        </div>
        <div className="col-start-5 col-end-6 md:mx-auto relative mr-10">
          <div className="h-full w-6 flex items-center justify-center">
            <div className="h-full w-1 bg-blue-800 pointer-events-none" />
          </div>
          <div className="w-6 h-6 absolute top-1/2 -mt-3 rounded-full bg-primary shadow" />
        </div>
      </div>
      // <!-- right -->
      <div className="flex md:contents">
        <div className="col-start-5 col-end-6 mr-10 md:mx-auto relative">
          <div className="h-full w-6 flex items-center justify-center">
            <div className="h-full w-1 bg-blue-800 pointer-events-none" />
          </div>
          <div className="w-6 h-6 absolute top-1/2 -mt-3 rounded-full bg-primary shadow" />
        </div>
        <div className="bg-primary col-start-6 col-end-10 p-4 rounded-xl my-4 mr-auto shadow-md">
          <h3 className="font-semibold text-lg mb-1"> {"Q4 2021"->React.string} </h3>
          <ul> <li> {"10x"->React.string} </li> </ul>
        </div>
      </div>
    </div>
  </div>
}
