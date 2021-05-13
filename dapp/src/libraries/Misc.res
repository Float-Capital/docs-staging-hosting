@ocaml.doc("localstorage isn't defined in nodejs for nextjs, thus rather use this optional value")
let optLocalstorage: option<Dom.Storage.t> =
  Js.typeof(Dom.Storage.localStorage) == "undefined" ? None : Some(Dom.Storage.localStorage)

@ocaml.doc("The global window object that exists in browsers") @val
external window: 'a = "window"

@ocaml.doc("This is useful for functions that shouldn't be run server side by Next.js for example")
let onlyExecuteClientSide = functionForClientsideExecution =>
  if window->Js.typeof != "undefined" {
    functionForClientsideExecution()
  }

module Time = {
  @ocaml.doc(`Returns the current timestamp in UTC seconds`)
  let getCurrentTimestamp = () => Js.Math.floor(Js.Date.now() /. 1000.)

  @ocaml.doc(`A hook that continuously gives the latest timestamp updated at your chosen interval by setting \`updateInterval\` in miliseconds.
  `)
  let useCurrentTime = (~updateInterval) => {
    let (currentTime, setTimeLeft) = React.useState(() => getCurrentTimestamp())

    React.useEffect2(() => {
      let interval = Js.Global.setInterval(
        () => setTimeLeft(_ => getCurrentTimestamp()),
        updateInterval,
      )
      Some(() => Js.Global.clearInterval(interval))
    }, (setTimeLeft, updateInterval))
    currentTime
  }

  @ocaml.doc(`A hook that continuously gives the latest timestamp updated at your chosen interval by setting \`updateInterval\` in miliseconds.
  Same as 'useCurrentTime' but returns result as a Ethers.BigNumber.t`)
  let useCurrentTimeBN = (~updateInterval) =>
    useCurrentTime(~updateInterval)->Ethers.BigNumber.fromInt

  @ocaml.doc(`Runs a callback on an interval predictably`)
  let useInterval = (callback: unit => unit, ~delay) => {
    let savedCallback: React.ref<unit => unit> = React.useRef(callback)

    // Remember the latest callback so that is persists between renders
    React.useEffect1(() => {
      savedCallback.current = callback
      None
    }, [callback])

    // Set up the interval.
    React.useEffect1(() => {
      let id = Js.Global.setInterval(savedCallback.current, delay)
      Some(() => Js.Global.clearInterval(id))
    }, [delay])
  }
}

module NumberFormat = {
  @ocaml.doc(`Adds a comma between groups of 3 digits to a floating point string`)
  let format = Js.String2.replaceByRe(_, %re("/\d(?=(\d{3})+\.)/g"), "$&,")

  @ocaml.doc(`Adds a comma between groups of 3 digits to an integer string`)
  let formatInt = Js.String2.replaceByRe(_, %re("/\d(?=(\d{3})+$)/g"), "$&,")

  @ocaml.doc(`Formats a float to 2 digits precision with groups of 3 decimals separated by a comma`)
  let formatFloat = (~digits=2, number) => number->Js.Float.toFixedWithPrecision(~digits)->format

  @ocaml.doc(`Formats a string float to 2 digits precision with groups of 3 decimals separated by a comma`)
  let toCentsFixedNoRounding = (~digits=2, floatString) =>
    floatString->Js.Float.fromString->formatFloat(~digits)

  @ocaml.doc(`Formats a BigNumber (10^18, wei) to 2 digits precision (ether) with groups of 3 decimals separated by a comma`)
  let formatEther = (~digits=2, rawNumber) =>
    rawNumber->Ethers.Utils.formatEther->toCentsFixedNoRounding(~digits)
}
