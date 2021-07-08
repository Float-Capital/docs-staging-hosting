module MarketingSite = {
  @react.component
  let make = () => {
    <>
      <Landing />
      <EcosystemPartners />
      <p> {"How it works"->React.string} </p>
      <Governance />
      <Roadmap />
      <Footer />
      <TVL />
    </>
  }
}

let default = () => <MarketingSite />
