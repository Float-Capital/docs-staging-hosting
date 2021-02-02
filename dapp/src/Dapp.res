module Access = {
  @react.component
  let make = (~children) => {
    let optUser = RootProvider.useCurrentUser()

    switch optUser {
    | None => React.null
    | Some(_user) => children
    }
  }
}
let default = () => <Access> <h1> {"Dapp"->React.string} </h1> </Access>
