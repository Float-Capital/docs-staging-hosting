module EthNetwork = {
  @react.component
  let make = (~children, ~alternateComponent=React.null) => {
    let optChainID = RootProvider.useChainId()

    switch optChainID {
    | None => alternateComponent
    | Some(_chainId) => children
    }
  }
}

@react.component
let make = (~children, ~alternateComponent=React.null) => {
  let optUser = RootProvider.useCurrentUser()

  switch optUser {
  | None => alternateComponent
  | Some(_user) => children
  }
}
