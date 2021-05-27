open Globals

let floatingMenuZoomStyle = shouldDisplay => {
  open CssJs
  style(. [
    position(#fixed),
    top(px(0)),
    left(px(0)),
    width(vw(100.)),
    height(vh(100.)),
    visibility(shouldDisplay ? #visible : #hidden),
    backgroundColor(rgba(255, 255, 255, #num(shouldDisplay ? 0.5 : 0.))),
    zIndex(40),
    transition(~duration=600, ~delay=0, ~timingFunction=ease, "all"),
    // NOTE: these styles need to be on this selector so that the animation happens correctly
    selector(
      ".zoom-in-effect",
      [
        background(rgba(59, 130, 250, #num(0.6))),
        width(vw(100.)),
        height(vh(100.)),
        border(px(1), #solid, grey),
        display(#flex),
        flex(#none),
        alignItems(#center),
        justifyContent(#center),
        transform(shouldDisplay ? scale(1., 1.) : scale(0., 0.)),
        transition(~duration=300, ~delay=0, ~timingFunction=ease, "all"),
      ],
    ),
  ])
}

let hamburgerSvg = () =>
  <svg
    className={
      open Css
      style(list{
        transition(~duration=500, ~delay=0, ~timingFunction=ease, "transform"),
        selector(":hover", list{transform(rotate(deg(180.)))}),
      })
    }
    height="32px"
    id="Layer_1"
    version="1.1"
    fill={"#" ++ "555555"}
    width="32px">
    <path
      d="M4,10h24c1.104,0,2-0.896,2-2s-0.896-2-2-2H4C2.896,6,2,6.896,2,8S2.896,10,4,10z M28,14H4c-1.104,0-2,0.896-2,2  s0.896,2,2,2h24c1.104,0,2-0.896,2-2S29.104,14,28,14z M28,22H4c-1.104,0-2,0.896-2,2s0.896,2,2,2h24c1.104,0,2-0.896,2-2  S29.104,22,28,22z"
    />
  </svg>

let closeSvg = () =>
  <svg
    height="32px"
    className={
      open Css
      style(list{
        transition(~duration=500, ~delay=0, ~timingFunction=ease, "transform"),
        selector(":hover", list{transform(rotate(deg(180.)))}),
      })
    }
    viewBox="0 0 512 512"
    fill={"#" ++ "222222"}
    width="32px">
    <path
      d="M437.5,386.6L306.9,256l130.6-130.6c14.1-14.1,14.1-36.8,0-50.9c-14.1-14.1-36.8-14.1-50.9,0L256,205.1L125.4,74.5  c-14.1-14.1-36.8-14.1-50.9,0c-14.1,14.1-14.1,36.8,0,50.9L205.1,256L74.5,386.6c-14.1,14.1-14.1,36.8,0,50.9  c14.1,14.1,36.8,14.1,50.9,0L256,306.9l130.6,130.6c14.1,14.1,36.8,14.1,50.9,0C451.5,423.4,451.5,400.6,437.5,386.6z"
    />
  </svg>

module Link = Next.Link

@react.component
let make = () => {
  let (isOpen, setIsOpen) = React.useState(_ => false)

  let router = Next.Router.useRouter()
  let optCurrentUser = RootProvider.useCurrentUser()

  <>
    <nav className="mx-auto w-full max-w-5xl p-2 h-12 flex justify-between items-center text-sm">
      <Link href="/">
        <a className="flex items-center">
          <span className="text-xl text-green-800 ml-2 align-middle font-semibold">
            <div className="logo-container">
              <img src="/img/float-capital-logo-long.svg" className="h-8 md:h-7 w-full md:w-auto" />
            </div>
          </span>
        </a>
      </Link>
      <div className="hidden md:flex w-2/3 text-base items-center justify-end">
        <Link href="/"> <a className="px-3 hover:bg-white"> {React.string("MARKETS")} </a> </Link>
        <Link href="/stake-markets">
          <a className="px-3 hover:bg-white"> {`STAKE🔥`->React.string} </a>
        </Link>
        <Link href="/stats">
          <a className="px-3 hover:bg-white"> {React.string("STATS")} </a>
        </Link>
        <a className="px-3 hover:bg-white" target="_blank" href="https://docs.float.capital">
          {React.string("DOCS")}
        </a>
        {
          // Will uncomment this in prod so will leave for now TODO
          // <a
          //   className="px-3 hover:opacity-60" target="_blank" href="https://github.com/Float-Capital">
          //   <img src="/icons/github.svg" className="h-5" />
          // </a>
          switch optCurrentUser {
          | Some(currentUser) =>
            <Link href={`/user/${currentUser->ethAdrToStr}`}>
              <p
                className="flex flex-row items-center px-3 bg-white hover:bg-black hover:text-white ml-1  text-base cursor-pointer">
                {"PROFILE"->React.string}
                <img
                  className="inline h-4 rounded ml-2"
                  src={Blockies.makeBlockie(currentUser->ethAdrToStr)}
                />
              </p>
            </Link>
          | None =>
            <Button.Small
              onClick={_ => {
                router->Next.Router.push(`/login?nextPath=${router.asPath}`)
              }}>
              "LOGIN"
            </Button.Small>
          }
        }
      </div>
      <div className="flex w-2/3 text-base items-center justify-end visible md:hidden">
        <div
          className="z-50 absolute top-0 right-0 p-3" onClick={_ => setIsOpen(isOpen => !isOpen)}>
          {isOpen ? <> {closeSvg()} </> : hamburgerSvg()}
        </div>
        <div className={floatingMenuZoomStyle(isOpen)}>
          <div className="zoom-in-effect flex flex-col text-3xl text-white">
            <div
              onClick={_ => {
                router->Next.Router.push(`/`)
                setIsOpen(_ => false)
              }}
              className="px-3 bg-black m-2">
              {React.string("MARKETS")}
            </div>
            <div
              onClick={_ => {
                router->Next.Router.push(`/stake-markets`)
                setIsOpen(_ => false)
              }}
              className="px-3 bg-black ml-2">
              {`STAKE🔥`->React.string}
            </div>
            <div
              onClick={_ => {
                router->Next.Router.push(`/stats`)
                setIsOpen(_ => false)
              }}
              className="px-3 bg-black m-2">
              {`STATS`->React.string}
            </div>
            {if Config.networkId == 80001 {
              <div
                onClick={_ => {
                  router->Next.Router.push(`/faucet`)
                  setIsOpen(_ => false)
                }}
                className="px-3 bg-black m-2">
                {`FAUCET`->React.string}
              </div>
            } else {
              React.null
            }}
            <a
              onClick={_ => {
                setIsOpen(_ => false)
              }}
              className="px-3 bg-black m-2"
              target="_"
              rel="noopener noreferrer"
              href="https://docs.float.capital">
              {React.string("DOCS")}
            </a>
            {
              // TODO: Uncomment in prod
              // <a
              //   onClick={_ => {
              //     setIsOpen(_ => false)
              //   }}
              //   className="px-3 hover:opacity-60 m-4"
              //   target="_"
              //   rel="noopener noreferrer"
              //   href="https://github.com/float-capital/float-contracts">
              //   <img src="/icons/github.svg" className="h-10" />
              // </a>
              switch optCurrentUser {
              | Some(currentUser) =>
                <p
                  onClick={_ => {
                    router->Next.Router.push(`/user/${currentUser->ethAdrToStr}`)
                    setIsOpen(_ => false)
                  }}
                  className="flex flex-row items-center px-3 bg-white text-black hover:bg-black hover:text-gray-200 
                   cursor-pointer text-3xl">
                  <img
                    className="inline h-6 rounded mr-2"
                    src={Blockies.makeBlockie(currentUser->ethAdrToStr)}
                  />
                  <p className="flex flex-row items-center px-3 hover:bg-white  cursor-pointer">
                    {"PROFILE"->React.string}
                  </p>
                </p>

              | None =>
                <Button.Small
                  onClick={_ => {
                    router->Next.Router.push(`/login?nextPath=${router.asPath}`)
                    setIsOpen(_ => false)
                  }}>
                  "LOGIN"
                </Button.Small>
              }
            }
          </div>
        </div>
      </div>
    </nav>
  </>
}
