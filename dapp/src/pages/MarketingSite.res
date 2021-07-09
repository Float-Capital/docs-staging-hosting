module MarketingSite = {
  @react.component
  let make = () => {
    <>
      <Landing />
      <HowItWorks/>
      <Roadmap />
      <Governance />
      <EcosystemPartners />
      <Footer />
      <TVL />
    </>
  }
}

let default = () => <MarketingSite />
