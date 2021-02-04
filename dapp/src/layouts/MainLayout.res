module Link = Next.Link

module Navigation = {
  @react.component
  let make = () => {
    let router = Next.Router.useRouter()
    let optCurrentUser = RootProvider.useCurrentUser()

    <nav className="p-2 h-12 flex justify-between items-center text-sm">
      <Link href="/">
        <a className="flex items-center w-1/3">
          <span className="text-xl text-green-800 ml-2 align-middle font-semibold">
            <div className="logo-container">
              // <img src="/img/water-tile.gif" className="logo-image" />
              <img src="/img/float-capital-logo.png" className="logo-text" />
            </div>
          </span>
        </a>
      </Link>
      <div className="flex w-2/3 justify-end">
        <Link href="/"> <a className="px-3"> {React.string("Home")} </a> </Link>
        <Link href="/dapp"> <a className="px-3"> {React.string("Dapp")} </a> </Link>
        <Link href="/dashboard"> <a className="px-3"> {React.string("Dashboard")} </a> </Link>
        <Link href="/admin"> <a className="px-3"> {React.string("Admin")} </a> </Link>
        <a className="px-3" target="_blank" href="https://docs.float.capital">
          {React.string("Docs")}
        </a>
        <a className="px-3" target="_blank" href="https://github.com/avolabs-io/longshort">
          {React.string("Github")}
        </a>
        {switch optCurrentUser {
        | Some(currentUser) =>
          <p>
            {"logged in as "->React.string}
            <DisplayAddress address={currentUser->Ethers.Utils.toString} />
          </p>
        | None =>
          <button
            onClick={_ => {
              router->Next.Router.push(`/login?nextPath=${router.asPath}`)
            }}>
            {"login"->React.string}
          </button>
        }}
      </div>
    </nav>
  }
}

@react.component
let make = (~children) => {
  <div className="flex lg:justify-center">
    <div className="max-w-5xl w-full lg:w-3/4 text-gray-900 font-base">
      <Navigation /> <main className="mt-4 mx-4"> children </main>
    </div>
  </div>
}
