module MarketingSite = {
  @react.component
  let make = () => {
    <> <Landing /> <WhatIsFloat /> <Roadmap /> <Team /> <Governance /> <Security /> <TVL /> </>
  }
}

let default = () => <MarketingSite />
