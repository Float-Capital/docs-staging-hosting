module Link = Next.Link

@react.component
let make = () => {
  let optCurrentUser = RootProvider.useCurrentUser()

  <div className="floating w-full">
    <Link
      href={switch optCurrentUser {
      | Some(_) => "/markets"
      | None => "/login?nextPath=/markets"
      }}>
      <span className="cursor-pointer opacity-70 w-full flex justify-center">
        <img src="/img/start-trading.png" className="p-4" />
      </span>
    </Link>
  </div>
}
