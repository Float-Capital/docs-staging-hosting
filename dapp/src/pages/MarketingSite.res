module MarketingSite = {
  @react.component
  let make = () => {
    <>
      <Landing />
      <HowItWorks />
      <Roadmap />
      <Governance />
      <Security />
      // <Footer />
      <TVL />
    </>
  }
}

let default = () => <MarketingSite />
