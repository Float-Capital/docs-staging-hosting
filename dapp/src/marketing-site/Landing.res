@react.component
let make = () => {
  let router = Next.Router.useRouter()

  <section className="min-h-screen">
    <SiteNav />
    <div className="min-h-screen flex flex-row items-center">
      <div className="w-2/5 mx-2 relative">
        <div className="v-align-in-responsive-height">
          <div className="block static">
            <div className="text-2.5xl font-bold leading-none min-w-400 my-2">
              <h1> {"PEER TO PEER PERPETUAL "->React.string} </h1>
              <h1> {"SYNTHETIC ASSETS"->React.string} </h1>
            </div>
            <h2> {"No overcollateralization"->React.string} </h2>
            <h2> {"No liquidiation"->React.string} </h2>
            <h2> {"No centralisation"->React.string} </h2>
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
      <div className="w-3/5"> <FeaturedMarkets /> </div>
    </div>
  </section>
}
