module MarketingSite = {
  @react.component
  let make = () => {
    <>
      <Landing />
      <HowItWorks/>
      <Roadmap />
      <EcosystemPartners />
      <Governance />
      <Footer />
      <TVL />
    </>
  }
}

let default = () => <MarketingSite />
