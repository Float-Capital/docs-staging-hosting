module Profile = {
  @react.component
  let make = () => {
    let router = Next.Router.useRouter()
    let userAddress = router.query->Js.Dict.get("address")
    <AccessControl
      alternateComponent={<h1 onClick={_ => router->Next.Router.push(`/login?nextPath=/`)}>
        <Login />
      </h1>}>
      <section>
        {switch userAddress {
        | Some(address) =>
          <div>
            <p className="text-xs"> {"User: "->React.string} {address->React.string} </p>
            <div className="flex w-full justify-between">
              <div className="w-full mr-3"> <Card> <DaiBalance /> </Card> </div>
              <div className="w-full ml-3"> <StakeDetails /> </div>
            </div>
          </div>
        | _ => React.null
        }}
      </section>
    </AccessControl>
  }
}
let default = () => <Profile />
