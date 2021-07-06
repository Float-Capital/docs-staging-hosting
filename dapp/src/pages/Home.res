module Home = {
  @react.component
  let make = () => {
    let (
      hasVisitedEnoughTimes,
      isPartOfActiveSession,
      state,
    ) = StartTrading.StartTradingStorage.useStartTradingStorage()

    let clickedTrading = React.useContext(
      StartTrading.ClickedTradingProvider.ClickedTradingContext.context,
    )

    switch state {
    | StartTrading.StartTradingStorage.Rendering => <Loader />
    | StartTrading.StartTradingStorage.Rendered =>
      if hasVisitedEnoughTimes || isPartOfActiveSession || clickedTrading {
        <Markets />
      } else {
        <StartTrading />
      }
    }
  }
}

let default = () => <Home />
