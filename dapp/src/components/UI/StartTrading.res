module StartTradingStorage = {
  type state = Rendering | Rendered

  let useStartTradingStorage = () => {
    let numberOfTimesShown = 1

    let (hasVisitedEnoughTimes, setHasVisitedEnoughTimes) = React.useState(_ => false)
    let (isPartOfActiveSession, setIsPartOfActiveSession) = React.useState(_ => false)
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
      setHasVisitedEnoughTimes(_ => numberOfVisits >= numberOfTimesShown)
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

    (hasVisitedEnoughTimes, isPartOfActiveSession, state)
  }
}

module ClickedTradingProvider = {
  type action = Clicked | NotClicked

  module ClickedTradingContext = {
    let context = React.createContext(false)

    module Provider = {
      let provider = React.Context.provider(context)

      @react.component
      let make = (~value, ~children) => {
        React.createElement(provider, {"value": value, "children": children})
      }
    }
  }

  module DispatchClickedTradingContext = {
    let context = React.createContext((_action: action) => ())

    module Provider = {
      let provider = React.Context.provider(context)

      @react.component
      let make = (~value, ~children) => {
        React.createElement(provider, {"value": value, "children": children})
      }
    }
  }

  @react.component
  let make = (~children) => {
    let (state, dispatch) = React.useReducer((_state, action) => {
      switch action {
      | Clicked => true
      | NotClicked => false
      }
    }, false)
    <ClickedTradingContext.Provider value=state>
      <DispatchClickedTradingContext.Provider value=dispatch>
        {children}
      </DispatchClickedTradingContext.Provider>
    </ClickedTradingContext.Provider>
  }
}

@react.component
let make = () => {
  let clickedTradingDispatch = React.useContext(
    ClickedTradingProvider.DispatchClickedTradingContext.context,
  )
  <div className="floating w-full">
    <div onClick={_ => clickedTradingDispatch(ClickedTradingProvider.Clicked)}>
      <span className="cursor-pointer hover:opacity-70 w-full flex justify-center">
        <img alt="start-trading" src="/img/start-trading.png" className="p-4" />
      </span>
    </div>
  </div>
}
