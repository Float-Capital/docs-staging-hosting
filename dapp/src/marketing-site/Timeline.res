@react.component
let make = () => {
  <div className="container">
    <div className="flex flex-row flex-wrap">
      <div className="w-full md:w-1/2 mx-4 md:mx-0 order">
        <div
          className="bg-white p-4 rounded-md md:rounded-br-none my-4 shadow-md inline-block w-full md:w-auto relative">
          <h3 className="font-semibold text-lg mb-1"> {"Q1 2021"->React.string} </h3>
          <ul>
            <li> {"Protocol mechanism researched & designed"->React.string} </li>
            <li> {"Core suite of smart contracts implemented"->React.string} </li>
            <li> {"MVP UI created"->React.string} </li>
            <li> {"Functional testnet deployment to BSC"->React.string} </li>
          </ul>
          <div className="bg-white h-4 w-4 border rounded-full absolute -right-2 -bottom-6" />
        </div>
      </div>
      <div className="w-full md:w-1/2 mx-4 md:mx-0">
        <div
          className="bg-white p-4 rounded-md md:rounded-br-none my-4 shadow-md  inline-block w-full md:w-auto relative">
          <h3 className="font-semibold text-lg mb-1"> {"Q3 2021"->React.string} </h3>
          <ul>
            <li> {"Finalize protocol design"->React.string} </li>
            <li> {"Audit smart contracts"->React.string} </li>
            <li> {"Build dream team"->React.string} </li>
            <li> {"UI/UX refinement"->React.string} </li>
          </ul>
          <div className="bg-white h-4 w-4 border rounded-full absolute -right-2 -bottom-6" />
        </div>
      </div>
    </div>
    <hr />
    <div className="flex flex-row">
      <div className="w-1/4" />
      <div
        className="bg-white p-4 rounded-md rounded-tr-none my-4 shadow-md  inline-block w-full md:w-auto relative">
        <h3 className="font-semibold text-lg mb-1"> {"Q2 2021"->React.string} </h3>
        <ul>
          <li> {"UI Design and iteration"->React.string} </li>
          <li> {"Move from BSC to Polygon"->React.string} </li>
          <li> {"Integrate Chainlink and Aave"->React.string} </li>
          <li> {"Raise seed funding"->React.string} </li>
        </ul>
        <div className="bg-white h-4 w-4 border rounded-full absolute -right-2 -top-6" />
      </div>
      <div className="w-1/4" />
      <div
        className="bg-white p-4 rounded-md rounded-tr-none my-4 shadow-md ml-auto inline-block  w-full md:w-auto relative">
        <h3 className="font-semibold text-lg mb-1"> {"Q4 2021"->React.string} </h3>
        <ul>
          <li> {"Launch new markets"->React.string} </li>
          <li> {"Support offchain markets"->React.string} </li>
          <li> {"Raise Series A"->React.string} </li>
          <li> {"Implement Governance module"->React.string} </li>
        </ul>
        <div className="bg-white h-4 w-4 border rounded-full absolute -right-2 -top-6" />
      </div>
    </div>
  </div>
}
