@react.component
let make = () => {
  let router = Next.Router.useRouter()

  <section className="min-h-screen blue-dusk-island">
    <SiteNav />
    <div className="min-h-screen flex flex-col md:flex-row items-center">
      <div className="w-full md:w-2/5 mx-2 relative">
        <div className="v-align-in-responsive-height">
          <div className="block static">
            <div className="font-bold leading-none w-full md:min-w-400 my-2">
              <div className="logo-container">
                <img
                  src="/img/float-capital-logo-sq.svg"
                  className="h-10 md:h-32 my-5 w-full md:w-auto"
                />
              </div>
              <h1 className="text-3xl  font-arimo font-extrabold">
                {"PEER TO PEER PERPETUAL "->React.string}
              </h1>
              <h1 className="text-3xl  font-arimo font-extrabold">
                {"SYNTHETIC ASSETS"->React.string}
              </h1>
            </div>
            <div className="my-2 text-lg">
              <h2> {"No overcollateralization"->React.string} </h2>
              <h2> {"No liquidiation"->React.string} </h2>
              <h2> {"No centralisation"->React.string} </h2>
            </div>
            <div className="flex flex-row items-center w-1/2">
              <Button onClick={_ => router->Next.Router.pushShallow("/markets")}> {"APP"} </Button>
              <a href={Config.discordInviteLink} target="_" rel="noopenner noreferer">
                <img
                  src="icons/discord-sq.svg" className="h-12 mx-4 cursor-pointer hover:opacity-75"
                />
              </a>
              <a href="https://twitter.com/float_capital" target="_" rel="noopenner noreferer">
                <img src="icons/twitter-sq.svg" className="h-12 cursor-pointer hover:opacity-75" />
              </a>
            </div>
          </div>
        </div>
      </div>
      <div className="w-full md:w-3/5"> <FeaturedMarkets /> </div>
    </div>
  </section>
}
