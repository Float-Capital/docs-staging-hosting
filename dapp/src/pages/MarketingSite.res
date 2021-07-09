module MarketingSite = {
  @react.component
  let make = () => {
    <>
      <Landing />
      <HowItWorks/>
      <Roadmap />
      <Governance />      
      <Footer />
      <TVL />
    </>
  }
}

let default = () => <MarketingSite />
