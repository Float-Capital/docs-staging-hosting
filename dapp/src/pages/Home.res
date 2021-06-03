module Home = {
  type state = Rendering | Rendered

  @react.component
  let make = () => {
    let (hasVisitedEnoughTimes, setHasVisitedEnoughTimes) = React.useState(_ => false)
    let (isPartOfActiveSession, setIsPartOfActiveSession) = React.useState(_ => false)
    let (clickedTrading, setClickedTrading) = React.useState(_ => false)
    let (state, setState) = React.useState(_ => Rendering)

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

      // update session storage
      let key = "isActiveSession"
      let sessionStorage = Dom.Storage2.sessionStorage
      let optIsActiveSession = sessionStorage->Dom.Storage2.getItem(key)
      switch optIsActiveSession {
      | Some(session) => setIsPartOfActiveSession(_ => session == "true")
      | None => sessionStorage->Dom.Storage2.setItem(key, "true")
      }

      setState(_ => Rendered)
      None
    }, [])

    switch state {
    | Rendering => <Loader />
    | Rendered =>
      if hasVisitedEnoughTimes || isPartOfActiveSession || clickedTrading {
        <Markets />
      } else {
        <StartTrading clickedTrading={setClickedTrading} />
      }
    }
  }
}

let default = () => <Home />
