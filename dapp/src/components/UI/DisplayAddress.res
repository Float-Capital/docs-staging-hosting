@react.component
let make = (~address) => <>
  {`${Js.String.slice(~from=0, ~to_=7, address)}...${Js.String.slice(
      ~from=address->Js.String2.length - 7,
      ~to_=address->Js.String2.length,
      address,
    )}`->React.string}
</>
