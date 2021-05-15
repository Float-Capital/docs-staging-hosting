module Home = {
  @react.component
  let make = () => {
    let (hasVisitedEnoughTimes, setHasVisitedEnoughTimes) = React.useState(() => false)
    let (isPartOfActiveSession, setIsPartOfActiveSession) = React.useState(() => false)
    let (clickedTrading, setClickedTrading) = React.useState(() => false)

    // update local storage
    React.useEffect1(() => {
      let key = "numberOfVisits"
      let localStorage = Dom.Storage2.localStorage
      let optNumberOfVisits = localStorage->Dom.Storage2.getItem(key)
      let numberOfVisits = switch optNumberOfVisits {
      | Some(numberOfVisits) => numberOfVisits->Int.fromString->Option.getWithDefault(0) + 1
      | None => 0
      }
      setHasVisitedEnoughTimes(_ => numberOfVisits >= 3)
      localStorage->Dom.Storage2.setItem(key, numberOfVisits->Int.toString)
      None
    }, [])

    // update session storage
    React.useEffect1(() => {
      let key = "isActiveSession"
      let sessionStorage = Dom.Storage2.sessionStorage
      let optIsActiveSession = sessionStorage->Dom.Storage2.getItem(key)
      switch optIsActiveSession {
      | Some(session) => setIsPartOfActiveSession(_ => session == "true")
      | None => sessionStorage->Dom.Storage2.setItem(key, "true")
      }
      None
    }, [])

    if hasVisitedEnoughTimes || isPartOfActiveSession || clickedTrading {
      <Markets />
    } else {
      <StartTrading clickedTrading={setClickedTrading} />
    }
  }
}

let default = () => <Home />
