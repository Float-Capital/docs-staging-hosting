module MarketingSite = {
  @react.component
  let make = () => {
    <> <Landing /> <Roadmap /> <Governance /> <EcosystemPartners /> <Footer /> <TVL /> </>
  }
}

let default = () => <MarketingSite />
