module Validators = {
  let etherNumberInput = numberStr => {
    let numberStrRegex = %re(`/^[+]?\d+(\.\d+)?$/`)

    switch numberStr {
    | "" => Error("Amount is required")
    | value if !(numberStrRegex->Js.Re.test_(value)) =>
      Error("Incorrect number format - please use '.' for floating points.")
    | amount =>
      Ethers.Utils.parseEther(~amount)->Option.mapWithDefault(
        Error("Couldn't parse Ether value"),
        etherValue => etherValue->Ok,
      )
    }
  }
}

@react.component
let make = (~className, ~onSubmit, ~children) => {
  <form
    className
    onSubmit={event => {
      if !(event->ReactEvent.Form.defaultPrevented) {
        event->ReactEvent.Form.preventDefault
      }
      onSubmit()
    }}>
    children
  </form>
}
