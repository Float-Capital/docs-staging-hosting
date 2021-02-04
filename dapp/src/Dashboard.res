module Access = {
  @react.component
  let make = (~children) => {
    let optUser = RootProvider.useCurrentUser()
    let router = Next.Router.useRouter()

    switch optUser {
    | None =>
      <h1 onClick={_ => router->Next.Router.push("/login?nextPath=/dashboard")}>
        {"Login to view your dashboard"->React.string}
      </h1>
    | Some(_user) => children
    }
  }
}
let default = () => <Access> <h1> {"Dashboard"->React.string} </h1> <DaiBalance /> </Access>
