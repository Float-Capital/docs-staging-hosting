module P = {
  @react.component
  let make = (~children) => <p className="mb-2"> children </p>
}

let default = () => <div> <StartTrading /> </div>
