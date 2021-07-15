@react.component
let make = () => {
  let q1_2021Content =
    <>
      <h3 className="font-semibold text-lg mb-1"> {"Q1 2021"->React.string} </h3>
      <ul>
        <li> {"Protocol mechanism researched & designed"->React.string} </li>
        <li> {"Core suite of smart contracts implemented"->React.string} </li>
        <li> {"MVP UI created"->React.string} </li>
        <li> {"Functional testnet deployment to BSC"->React.string} </li>
      </ul>
    </>
  let q2_2021Content =
    <>
      <h3 className="font-semibold text-lg mb-1"> {"Q2 2021"->React.string} </h3>
      <ul>
        <li> {"UI Design and iteration"->React.string} </li>
        <li> {"Move from BSC to Polygon"->React.string} </li>
        <li> {"Integrate Chainlink and Aave"->React.string} </li>
        <li> {"Raise seed funding"->React.string} </li>
      </ul>
    </>
  let q3_2021Content =
    <>
      <h3 className="font-semibold text-lg mb-1"> {"Q3 2021"->React.string} </h3>
      <ul>
        <li> {"Finalize protocol design"->React.string} </li>
        <li> {"Audit smart contracts"->React.string} </li>
        <li> {"Build dream team"->React.string} </li>
        <li> {"UI/UX refinement"->React.string} </li>
      </ul>
    </>
  let q4_2021Content =
    <>
      <h3 className="font-semibold text-lg mb-1"> {"Q4 2021"->React.string} </h3>
      <ul>
        <li> {"Launch new markets"->React.string} </li>
        <li> {"Support offchain markets"->React.string} </li>
        <li> {"Raise Series A"->React.string} </li>
        <li> {"Implement Governance module"->React.string} </li>
      </ul>
    </>

  <div className="container my-4">
    <div className="flex flex-row flex-wrap border-l md:border-l-0 ml-2 md:m-0">
      <div className="w-full md:w-1/2 mx-4 md:mx-0 order-1 md:order-1">
        <div
          className="bg-white p-4 rounded-md rounded-tl-none md:rounded-tl-md md:rounded-br-none my-4 shadow-md inline-block w-full md:w-auto relative">
          {q1_2021Content}
          <div
            className="bg-white h-4 w-4 border rounded-full absolute -left-6 -top-2 md:top-auto md:left-auto md:-right-2 md:-bottom-6 "
          />
        </div>
      </div>
      <div className="w-full md:w-1/2 mx-4 md:mx-0 order-5 md:order-2 ">
        <div
          className="bg-white p-4 rounded-md rounded-tl-none md:rounded-tl-md md:rounded-br-none my-4 shadow-md  inline-block w-full md:w-auto relative">
          {q3_2021Content}
          <div
            className="bg-white h-4 w-4 border rounded-full absolute -left-6 -top-2 md:top-auto md:left-auto md:-right-2 md:-bottom-6"
          />
        </div>
      </div>
      <div className="md:border-b w-full order-3 md:order-3" />
      <div className="w-1/4  order-4 md:order-4" />
      <div className="w-full md:w-1/2 mx-4 md:mx-0 order-2 md:order-5">
        <div
          className="bg-white p-4 rounded-md rounded-tl-none md:rounded-tl-md md:rounded-tr-none my-4 shadow-md  inline-block w-full md:w-auto relative">
          {q2_2021Content}
          <div
            className="bg-white h-4 w-4 border rounded-full absolute  -left-6 -top-2 md:left-auto md:-right-2 md:-top-6"
          />
        </div>
      </div>
      <div className="w-full md:w-auto mx-4 md:ml-auto md:mr-0 order-6 md:order-6">
        <div
          className="bg-white p-4 rounded-md rounded-tl-none md:rounded-tl-md md:rounded-tr-none my-4 shadow-md  inline-block  w-full md:w-auto relative">
          {q4_2021Content}
          <div
            className="bg-white h-4 w-4 border rounded-full absolute -left-6 -top-2 md:left-auto md:-right-2 md:-top-6"
          />
        </div>
      </div>
    </div>
  </div>
}
