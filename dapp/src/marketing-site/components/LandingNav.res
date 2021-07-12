module Link = Next.Link

type landingNavType = {
  title: string,
  link: string,
}

let makeDefaultHighlightLandingNav: int => array<bool> = length => {
  let defaultFalseArray = Array.make(length, false)
  let _ = defaultFalseArray->Array.set(0, true)
  defaultFalseArray
}

let highlightLandingNavArray: (int, int) => array<bool> = (length, index) => {
  let resetNavs = Array.make(length, false)
  let _ = resetNavs->Array.set(index, true)
  resetNavs
}

let highlightMove: (array<bool>, ~up: bool) => array<bool> = (navs, ~up) => {
  let currentHighlightIndex = navs->Js.Array2.indexOf(true)
  let newIndexPosition = up ? currentHighlightIndex - 1 : currentHighlightIndex + 1
  let navsLength = navs->Array.length
  if newIndexPosition >= 0 && newIndexPosition < navsLength {
    let resetNavs = Array.make(navsLength, false)
    let _ = resetNavs->Array.set(newIndexPosition, true)
    resetNavs
  } else {
    navs
  }
}

@react.component
let make = () => {
  let router = Next.Router.useRouter()

  let landingNav: array<landingNavType> = [
    {title: "How it Works", link: "#how-it-works"},
    {title: "Roadmap", link: "#roadmap"},
    {title: "Team", link: "#team"},
    {title: "Governance", link: "#governance"},
    {title: "Security", link: "#security"},
  ]

  let (show, setShow) = React.useState(_ =>
    landingNav->Array.length->makeDefaultHighlightLandingNav
  )

  let enterClicked = KeyPress.useKeyPress("Enter")
  let upClicked = KeyPress.useKeyPress("ArrowUp")
  let downClicked = KeyPress.useKeyPress("ArrowDown")

  React.useEffect1(() => {
    if enterClicked == true {
      let currentHighlightIndex = show->Js.Array2.indexOf(true)
      let sectionLink = (
        landingNav[currentHighlightIndex]->Option.getWithDefault({title: "", link: ""})
      ).link
      router->Next.Router.pushShallow(`/${sectionLink}`)
    }
    None
  }, [enterClicked])

  React.useEffect1(() => {
    if upClicked == true {
      setShow(_ => highlightMove(show, ~up=true))
    }
    None
  }, [upClicked])

  React.useEffect1(() => {
    if downClicked == true {
      setShow(_ => highlightMove(show, ~up=false))
    }
    None
  }, [downClicked])

  <nav className="text-3xl font-vt323">
    <div className="mx-auto custom-cursor">
      {landingNav
      ->Array.mapWithIndex((index, nav) => {
        <div key=nav.link id={`landing-nav-item-${index->string_of_int}`}>
          <Link href=nav.link>
            <div
              className={`flex items-center hover:bg-white ${show[index]->Option.getWithDefault(
                  false,
                )
                  ? "bg-white"
                  : ""}`}
              onMouseOver={_ => {
                setShow(_ => highlightLandingNavArray(landingNav->Array.length, index))
              }}>
              <span className="text-2xl animate-pulse font-bold  ml-2">
                {(show[index]->Option.getWithDefault(false) ? ">" : `\xa0`)->React.string}
              </span>
              <a className="px-3"> {nav.title->React.string} </a>
            </div>
          </Link>
        </div>
      })
      ->React.array}
    </div>
  </nav>
}
