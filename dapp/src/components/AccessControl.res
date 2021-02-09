module EthNetwork = {
  @react.component
  let make = (~children, ~alternateComponent=React.null) => {
    let optChainID = RootProvider.useNetworkId()

    switch optChainID {
    | None => alternateComponent
    | Some(_optUser) => children
    }
  }
}

@react.component
let make = (~children, ~alternateComponent=React.null) => {
  let optUser = RootProvider.useCurrentUser()

  switch optUser {
  | None => alternateComponent
  | Some(_optUser) => children
  }
}
