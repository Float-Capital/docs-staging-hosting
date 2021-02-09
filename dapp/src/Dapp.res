module Dapp = {
  @react.component
  let make = () => {
    let router = Next.Router.useRouter()
    <AccessControl
      alternateComponent={<h1 onClick={_ => router->Next.Router.push("/login?nextPath=/dashboard")}>
        {"login to view this"->React.string}
      </h1>}>
      <h1> {"Dapp"->React.string} </h1>
      <ApproveDai />
      <hr />
      <MintLong />
      <hr />
      <RedeemLong />
      <hr />
      <MintShort />
      <hr />
      <RedeemShort />
      <hr />
      <UpdateSystemState />
    </AccessControl>
  }
}
let default = () => <Dapp />
