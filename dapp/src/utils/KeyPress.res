@scope("window") @val
external addWindowEventListener: (string, ReactEvent.Keyboard.t => unit) => unit =
  "addEventListener"
@scope("window") @val
external removeWindowEventListener: (string, ReactEvent.Keyboard.t => unit) => unit =
  "removeEventListener"

let useKeyPress = (targetKey: string) => {
  let (keyPressed, setKeyPressed) = React.useState(_ => false)
  let downHandler = (keyboardEvent: ReactEvent.Keyboard.t) => {
    if keyboardEvent->ReactEvent.Keyboard.key === targetKey {
      setKeyPressed(_ => true)
    }
  }
  let upHandler = (keyboardEvent: ReactEvent.Keyboard.t) => {
    if keyboardEvent->ReactEvent.Keyboard.key === targetKey {
      setKeyPressed(_ => false)
    }
  }

  let preventArrowScrolling = keyboardEvent => {
    if ["ArrowUp", "ArrowDown"]->Js.Array2.indexOf(ReactEvent.Keyboard.key(keyboardEvent)) > -1 {
      keyboardEvent->ReactEvent.Keyboard.preventDefault
    }
  }

  // Add event listeners
  React.useEffect1(() => {
    addWindowEventListener("keydown", downHandler)
    addWindowEventListener("keyup", upHandler)
    addWindowEventListener("keydown", preventArrowScrolling)

    // Remove event listeners on cleanup
    Some(
      _ => {
        removeWindowEventListener("keydown", downHandler)
        removeWindowEventListener("keyup", upHandler)
        removeWindowEventListener("keydown", preventArrowScrolling)
      },
    )
  }, [])

  keyPressed
}
