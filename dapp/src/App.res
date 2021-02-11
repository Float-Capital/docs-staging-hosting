// This type is based on the getInitialProps return value.
// If you are using getServerSideProps or getStaticProps, you probably
// will never need this
// See https://nextjs.org/docs/advanced-features/custom-app
type pageProps

module PageComponent = {
  type t = React.component<pageProps>
}

type props = {
  @as("Component")
  component: PageComponent.t,
  pageProps: pageProps,
}

// This sets up session storage caching for SWR
// SwrPersist.syncWithSessionStorage->Misc.onlyExecuteClientSide

// This is a normal apollo client, it isn't optimized for nextjs yet.
let client = (~uriLink: string) => {
  open ApolloClient
  make(
    ~cache=Cache.InMemoryCache.make(),
    // I would turn this off in production
    ~connectToDevTools=true,
    ~uri=uriLink->Obj.magic,
    (),
  )
}

module GraphQl = {
  @react.component
  let make = (~children) => {
    let networkId = RootProvider.useChainId()
    let client = React.useMemo1(() =>
      client(
        ~uriLink={
          switch networkId {
          | Some(5) => "https://api.thegraph.com/subgraphs/name/avolabs-io/float-capital-goerli"
          | Some(321) => "goerli"
          | Some(97) => "https://api.thegraph.com/subgraphs/name/avolabs-io/float-capital-goerli"
          | Some(_)
          | None => "https://api.thegraph.com/subgraphs/name/avolabs-io/float-capital-goerli"
          }
        },
      )
    , [networkId])

    <ApolloClient.React.ApolloProvider client> children </ApolloClient.React.ApolloProvider>
  }
}

// We are not using `[@react.component]` since we will never
// use <App/> within our Reason code. It's only used within `pages/_app.js`
let default = (props: props): React.element => {
  let {component, pageProps} = props

  let router = Next.Router.useRouter()

  let content = React.createElement(component, pageProps)

  <RootProvider>
    <GraphQl>
      {switch router.route {
      | "/examples" =>
        <MainLayout>
          <h1 className="font-bold"> {React.string("Examples Section")} </h1> <div> content </div>
        </MainLayout>
      | _ => <MainLayout> content </MainLayout>
      }}
    </GraphQl>
  </RootProvider>
}
