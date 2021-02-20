@react.component
let make = (~address) => <>
  {`${Js.String.slice(~from=0, ~to_=5, address)}..${Js.String.slice(
      ~from=address->Js.String2.length - 3,
      ~to_=address->Js.String2.length,
      address,
    )}`->React.string}
</>
