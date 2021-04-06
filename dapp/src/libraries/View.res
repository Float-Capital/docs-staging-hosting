@scope("window") @val
external windowInnerWidth: int = "innerWidth"
@scope("window") @val
external addWindowEventListener: (string, unit => unit) => unit = "addEventListener"
@scope("window") @val
external removeWindowEventListener: (string, unit => unit) => unit = "removeEventListener"

let useViewport = () => {
  let (width, setWidth) = React.useState(_ => windowInnerWidth)

  React.useEffect0(() => {
    let handleWindowResize = () => setWidth(_ => windowInnerWidth)
    addWindowEventListener("resize", handleWindowResize)

    Some(() => removeWindowEventListener("resize", handleWindowResize))
  })

  width
}

let useIsTailwindMobile = () => {
  let width = useViewport()
  width < 768
}

let useIsTailwindMd = () => {
  let width = useViewport()
  width > 768 && width < 1024
}

let useIsTailwindLg = () => {
  let width = useViewport()
  width > 1024
}
