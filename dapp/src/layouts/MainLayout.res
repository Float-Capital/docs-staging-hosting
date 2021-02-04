module Link = Next.Link

module Navigation = {
  @react.component
  let make = () => {
    let router = Next.Router.useRouter()
    let optCurrentUser = RootProvider.useCurrentUser()

    <nav className="p-2 h-12 flex border-b border-gray-200 justify-between items-center text-sm">
      <Link href="/">
        <a className="flex items-center w-1/3">
          // <img className="w-5" src="/static/zeit-black-triangle.svg" />
          <span className="text-xl text-green-800 ml-2 align-middle font-semibold">
            <img src="/img/float-capital-logo.png" />
          </span>
        </a>
      </Link>
      <div className="flex w-2/3 justify-end">
        <Link href="/"> <a className="px-3"> {React.string("Home")} </a> </Link>
        <Link href="/dapp"> <a className="px-3"> {React.string("Dapp")} </a> </Link>
        <Link href="/admin"> <a className="px-3"> {React.string("Admin")} </a> </Link>
        <a
          className="px-3 font-bold" target="_blank" href="https://github.com/avolabs-io/longshort">
          {React.string("Github")}
        </a>
        {switch optCurrentUser {
        | Some(currentUser) =>
          <p> {`logged in as ${currentUser->Ethers.Utils.toString}`->React.string} </p>
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
