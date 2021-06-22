@react.component
let make = (~txConfirmedTimestamp=0, ~nextPriceUpdateTimestamp=100) => {
  let secondsUntilExecution = nextPriceUpdateTimestamp - txConfirmedTimestamp

  let (countupPercentage, setCountupPercentage) = React.useState(_ => 0)

  React.useEffect1(() => {
    let countup = ref(0)
    let _ticker = Js.Global.setInterval(() => {
      if countup.contents * 100 / secondsUntilExecution < 100 {
        countup := countup.contents + 1
        Js.log(countup.contents->string_of_int)
        Js.log(secondsUntilExecution->string_of_int)
        Js.log((countup.contents * 100 / secondsUntilExecution)->string_of_int)
        setCountupPercentage(_ => countup.contents * 100 / secondsUntilExecution)
      }
    }, 1000)

    None
  }, [nextPriceUpdateTimestamp])

  <div className="relative pt-1">
    <div className="text-xxs text-center">
      {`Please wait while your transaction is processed`->React.string}
      <Tooltip tip="The transaction will execute on the next oracle price update" />
    </div>
    <div className="relative pt-1">
      <div className="overflow-hidden h-2 mb-4 text-xs flex rounded bg-indigo-200">
        <div
          style={ReactDOM.Style.make(~width=`${countupPercentage->string_of_int}%`, ())}
          className="w-10 shadow-none flex flex-col text-center whitespace-nowrap text-white justify-center animated-color-progress-bar"
        />
      </div>
    </div>
  </div>
}
