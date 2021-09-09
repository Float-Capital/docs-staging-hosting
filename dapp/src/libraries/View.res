@scope("window") @val
external windowInnerWidth: int = "innerWidth"
@scope("window") @val
external addWindowEventListener: (string, unit => unit) => unit = "addEventListener"
@scope("window") @val
external removeWindowEventListener: (string, unit => unit) => unit = "removeEventListener"

@scope("window") @val
external windowInnerHeight: int = "innerHeight"

let useViewport = () => {
  let (width, setWidth) = React.useState(_ => windowInnerWidth)

  React.useEffect0(() => {
    let handleWindowResize = () => setWidth(_ => windowInnerWidth)
    addWindowEventListener("resize", handleWindowResize)

    Some(() => removeWindowEventListener("resize", handleWindowResize))
  })

  width
}

type dimensions = {width: int, height: int}
let useViewDimensions = () => {
  let (dimensions, setDimensions) = React.useState(_ => {
    width: 1000,
    height: 1000,
  })

  React.useEffect0(() => {
    Misc.onlyExecuteClientSide(() => {
      setDimensions(_ => {
        width: windowInnerWidth,
        height: windowInnerHeight,
      })
    })
    let handleWindowResize = () => {
      Misc.onlyExecuteClientSide(() => {
        setDimensions(_ => {
          width: windowInnerWidth,
          height: windowInnerHeight,
        })
      })
    }
    addWindowEventListener("resize", handleWindowResize)

    Some(() => removeWindowEventListener("resize", handleWindowResize))
  })

  dimensions
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
