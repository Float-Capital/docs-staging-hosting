module MarketingSite = {
  @react.component
  let make = () => {
    <> <Landing /> <WhatIsFloat /> <Roadmap /> <Governance /> <Security /> <TVL /> </>
  }
}

let default = () => <MarketingSite />
