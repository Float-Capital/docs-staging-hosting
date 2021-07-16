@react.component
let make = () => {
  let router = Next.Router.useRouter()

  <section
    id="governance"
    className="py-10 min-h-screen w-screen flex flex-col items-center justify-center ballot-box">
    <div className="max-w-5xl flex flex-col md:flex-row justify-evenly items-center mx-auto">
      <div className="w-full md:w-1/2 order-2 md:order-1 p-4 md:p-0">
        <h3
          className="text-2xl md:text-4xl flex flex-row items-center my-2 font-bold leading-tight">
          {`Simple`->React.string}
          <br />
          {`Community First`->React.string}
          <br />
          {`Governance`->React.string}
        </h3>
        <p
          className="text-lg md:text-2xl p-4 md:p-0 bg-white bg-opacity-80 rounded-lg md:bg-transparent">
          {"Float Capital will be managed by the decentralized community of FLT token-holders. Simply use FLT to author, propose and vote on protocol upgrades."->React.string}
        </p>
        <div className="flex flex-row my-4 items-center justify-evenly md:justify-start  ">
          <div className="mr-4">
            <a
              href="https://docs.float.capital/docs/governance"
              target="_blank"
              rel="noopener noreferrer">
              <Button> {"Read more"} </Button>
            </a>
          </div>
          <div>
            <Button onClick={_ => router->Next.Router.push(`/app/stake-markets`)}>
              {"Earn FLT"}
            </Button>
          </div>
        </div>
      </div>
      <div className="w-full md:w-1/2 order-1 md:order-2" />
    </div>
  </section>
}
