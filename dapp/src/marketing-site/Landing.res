module Link = Next.Link

@react.component
let make = () => {
  <section className="blue-dusk-island flex flex-col md:flex-row items-center min-h-screen">
    <div className="w-full mx-2 relative">
      <div className="v-align-in-responsive-height">
        <div className="block static">
          <div className="font-bold leading-none w-full md:min-w-400 my-2">
            <div className="logo-container mx-auto">
              <img
                src="/img/float-capital-logo-sq-center.svg"
                className="h-14 md:h-44 my-5 w-full md:w-auto"
              />
            </div>
            <h1 className="text-2xl font-vt323 font-extrabold text-center">
              {"Peer-to-peer synthetic assets"->React.string}
            </h1>
          </div>
          <LandingNav />
        </div>
      </div>
    </div>
    <EcosystemPartners />
  </section>
}
