open Globals
module Link = Next.Link

module Navigation = {
  @react.component
  let make = () => {
    let router = Next.Router.useRouter()
    let optCurrentUser = RootProvider.useCurrentUser()

    <nav className="p-2 h-12 flex justify-between items-center text-sm">
      <Link href="/">
        <a className="flex items-center">
          <span className="text-xl text-green-800 ml-2 align-middle font-semibold">
            <div className="logo-container">
              <img src="/img/float-capital-logo.png" className="h-5 md:h-7" />
            </div>
          </span>
        </a>
      </Link>
      <div className="flex w-2/3 text-base items-center justify-end">
        <Link href="/markets">
          <a className="px-3 hover:bg-white"> {React.string("MARKETS")} </a>
        </Link>
        <Link href="/mint"> <a className="px-3 hover:bg-white"> {React.string("MINT")} </a> </Link>
        // <Link href="/redeem">
        //   <a className="px-3 hover:bg-white"> {React.string("REDEEM")} </a>
        // </Link>
        <Link href="/stake">
          <a className="px-3 hover:bg-white"> {`STAKE🔥`->React.string} </a>
        </Link>
        <Link href="/dashboard">
          <a className="px-3 hover:bg-white"> {React.string("DASHBOARD")} </a>
        </Link>
        <a className="px-3 hover:bg-white" target="_blank" href="https://docs.float.capital">
          {React.string("DOCS")}
        </a>
        <a
          className="px-3 hover:opacity-60"
          target="_blank"
          href="https://github.com/avolabs-io/longshort">
          <img src="/icons/github.svg" className="h-5" />
        </a>
        {switch optCurrentUser {
        | Some(currentUser) =>
          <Link href={`/profile?address=${currentUser->ethAdrToStr}`}>
            <p
              className="px-3 bg-white hover:bg-black hover:text-gray-200 text-base cursor-pointer">
              <DisplayAddress address={currentUser->ethAdrToStr} /> //TODO route to Profile page
            </p>
          </Link>
        | None =>
          <Button
            onClick={_ => {
              router->Next.Router.push(`/login?nextPath=${router.asPath}`)
            }}
            variant="small">
            "LOGIN"
          </Button>
        }}
      </div>
    </nav>
  }
}

@react.component
let make = (~children) => {
  <div className="flex lg:justify-center min-h-screen">
    <div className="max-w-5xl w-full text-gray-900 font-base">
      <div className="flex flex-col h-screen">
        <Navigation /> <div className="m-auto w-full"> children </div>
      </div>
    </div>
  </div>
}
