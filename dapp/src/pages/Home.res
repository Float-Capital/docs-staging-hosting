module Home = {
  @react.component
  let make = () => {
    let (hasVisitedEnoughTimes, setHasVisitedEnoughTimes) = React.useState(() => false)
    let (isPartOfActiveSession, setIsPartOfActiveSession) = React.useState(() => false)
    let (clickedTrading, setClickedTrading) = React.useState(() => false)

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
      let sessionStorage = Dom.Storage.sessionStorage
      let sessionKey = "isActiveSession"
      let optIsActiveSession = Dom.Storage.getItem(sessionKey, sessionStorage)
      switch optIsActiveSession {
      | Some(session) => setIsPartOfActiveSession(_ => session == "true")
      | None => Dom.Storage.setItem(sessionKey, "true", sessionStorage)
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
