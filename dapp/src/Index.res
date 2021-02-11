module P = {
  @react.component
  let make = (~children) => <p className="mb-2"> children </p>
}

let default = () =>
  <div>
    <StartTrading />
    // <h1 className="text-3xl font-semibold"> {"What is this about?"->React.string} </h1>
    // <P>
    //   {React.string(`Get exposure to a large variety of assets without requiring any additional collateral`)}
    // </P>
    // <h2 className="text-2xl font-semibold mt-5"> {React.string("Peace and respect from")} </h2>
    // <pre> {React.string(`avolabs`)} </pre>
  </div>
