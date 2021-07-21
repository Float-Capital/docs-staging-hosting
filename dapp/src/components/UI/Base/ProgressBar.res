@react.component
let make = (~txConfirmedTimestamp=0, ~nextPriceUpdateTimestamp=100, ~rerenderCallback=() => ()) => {
  let totalSecondsUntilExecution = nextPriceUpdateTimestamp - txConfirmedTimestamp

  let (countupPercentage, setCountupPercentage) = React.useState(_ => 0)
  let (secondsUntilExecution, setSecondsUntilExecution) = React.useState(_ => 0)

  React.useEffect1(() => {
    let countup = ref(0)
    let _ticker = Js.Global.setInterval(() => {
      if countup.contents * 100 / totalSecondsUntilExecution < 100 {
        countup := countup.contents + 1
        setSecondsUntilExecution(_ => totalSecondsUntilExecution - countup.contents)
        setCountupPercentage(_ => countup.contents * 100 / totalSecondsUntilExecution)
      }
      if (
        countup.contents * 100 / totalSecondsUntilExecution < 100 &&
          mod(countup.contents * 100 / totalSecondsUntilExecution, 10) == 0
      ) {
        rerenderCallback()
      }
    }, 1000)

    None
  }, [nextPriceUpdateTimestamp])

  {
    countupPercentage < 100
      ? <div className="relative pt-1">
          <div className="text-xxs text-center">
            {`Please wait while your transaction is processed`->React.string}
            <Tooltip tip="The transaction will execute on the next oracle price update" />
          </div>
          <div className={`w-2/3 mx-auto ${countupPercentage < 100 ? "mt-7" : "mt-5"}`}>
            <div className="relative pt-1">
              <div
                style={ReactDOM.Style.make(
                  ~position="absolute",
                  ~top="-22px",
                  ~left=`calc(${countupPercentage->string_of_int}% - 38px)`,
                  (),
                )}
                className="text-center bg-pink text-xxxs leading-none bg-black opacity-60 text-white py-1 rounded-sm">
                {`eta: < ${DateFns.intervalToDuration({
                    start: Js.Date.fromFloat(0.),
                    end: Js.Date.fromFloat((secondsUntilExecution * 1000)->float_of_int),
                  })->DateFns.formatDuration({format: ["minutes", "seconds"]})}`->React.string}
              </div>
              <div className="overflow-hidden h-2 mb-4 text-xs flex rounded bg-indigo-200">
                <div
                  style={ReactDOM.Style.make(~width=`${countupPercentage->string_of_int}%`, ())}
                  className="w-10 shadow-none flex flex-col text-center whitespace-nowrap text-white justify-center animated-color-progress-bar"
                />
              </div>
            </div>
          </div>
        </div>
      : <div className="mx-auto"> <Loader.Tiny /> </div>
  }
}
