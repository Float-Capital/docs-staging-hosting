module Markets = {
  @react.component
  let make = () => {
    let router = Next.Router.useRouter()
    <AccessControl
      alternateComponent={<h1 onClick={_ => router->Next.Router.push(`/login?nextPath=/`)}>
        <Login />
      </h1>}>
      <section> <StakeList /> </section>
    </AccessControl>
  }
}
let default = () => <Markets />
