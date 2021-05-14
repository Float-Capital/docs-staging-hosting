module Home = {
  @react.component
  let make = () => {
    let (hasVisitedEnoughTimes, setHasVisitedEnoughTimes) = React.useState(() => false)

    React.useEffect1(() => {
      let key = "numberOfVisits"
      let localStorage = Dom.Storage.localStorage
      let optNumberOfVisits = Dom.Storage.getItem(key, localStorage)
      let numberOfVisits = switch optNumberOfVisits {
      | Some(numberOfVisits) => numberOfVisits->Int.fromString->Option.getWithDefault(0) + 1
      | None => 0
      }
      setHasVisitedEnoughTimes(_ => numberOfVisits >= 3)
      Dom.Storage.setItem(key, numberOfVisits->Int.toString, localStorage)
      None
    }, [])

    if hasVisitedEnoughTimes {
      <Markets />
    } else {
      <StartTrading />
    }
  }
}

let default = () => <Home />
