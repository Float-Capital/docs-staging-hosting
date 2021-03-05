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
}
