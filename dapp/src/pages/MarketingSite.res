module MarketingSite = {
  @react.component
  let make = () => {
    <> <Landing /> <Roadmap /> <Governance /> <EcosystemPartners /> <Footer /> </>
  }
}

let default = () => <MarketingSite />
