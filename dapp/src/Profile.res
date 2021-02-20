module Profile = {
  @react.component
  let make = () => {
    let router = Next.Router.useRouter()
    let userAddress = router.query->Js.Dict.get("address")
    <AccessControl
      alternateComponent={<h1 onClick={_ => router->Next.Router.push(`/login?nextPath=/`)}>
        {"Login"->React.string}
      </h1>}>
      <section>
        <h1> {" Profile "->React.string} </h1>
        {switch userAddress {
        | Some(address) => <div> {address->React.string} <StakeDetails /> </div>
        | _ => React.null
        }}
      </section>
    </AccessControl>
  }
}
let default = () => <Profile />
