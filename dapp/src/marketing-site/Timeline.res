@react.component
let make = () => {
  <div className="container">
    <div className="flex flex-row">
      <div className="w-1/2">
        <div className="bg-white p-4 rounded-md rounded-br-none my-4 shadow-md inline-block">
          <h3 className="font-semibold text-lg mb-1"> {"Q1 2021"->React.string} </h3>
          <ul>
            <li> {"Protocol mechanism researched & designed"->React.string} </li>
            <li> {"Core suite of smart contracts implemented"->React.string} </li>
            <li> {"MVP UI created"->React.string} </li>
            <li> {"Functional testnet deployment to BSC"->React.string} </li>
          </ul>
        </div>
      </div>
      <div className="w-1/2">
        <div className="bg-white p-4 rounded-md rounded-br-none my-4 shadow-md  inline-block">
          <h3 className="font-semibold text-lg mb-1"> {"Q3 2021"->React.string} </h3>
          <ul>
            <li> {"Finalize protocol design"->React.string} </li>
            <li> {"Audit smart contracts"->React.string} </li>
            <li> {"Build dream team"->React.string} </li>
            <li> {"UI/UX refinement"->React.string} </li>
          </ul>
        </div>
      </div>
    </div>
    <hr />
    <div className="flex flex-row">
      <div className="w-1/4" />
      <div className="bg-white p-4 rounded-md rounded-tr-none my-4 shadow-md  inline-block">
        <h3 className="font-semibold text-lg mb-1"> {"Q2 2021"->React.string} </h3>
        <ul>
          <li> {"UI Design and iteration"->React.string} </li>
          <li> {"Move from BSC to Polygon"->React.string} </li>
          <li> {"Integrate Chainlink and Aave"->React.string} </li>
          <li> {"Raise seed funding"->React.string} </li>
        </ul>
      </div>
      <div className="w-1/4" />
      <div className="bg-white p-4 rounded-md rounded-tr-none my-4 shadow-md  inline-block">
        <h3 className="font-semibold text-lg mb-1"> {"Q4 2021"->React.string} </h3>
        <ul>
          <li> {"Launch new markets"->React.string} </li>
          <li> {"Pull the rug"->React.string} </li>
          <li> {"Raise Series A"->React.string} </li>
          <li> {"Implement Governance module"->React.string} </li>
        </ul>
      </div>
    </div>
  </div>
}
