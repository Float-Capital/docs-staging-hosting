module MarketingSite = {
  @react.component
  let make = () => {
    <>
      <Landing />
      <HowItWorks />
      <Roadmap />
      <Governance />
      <Security />      
      <TVL />
    </>
  }
}

let default = () => <MarketingSite />
