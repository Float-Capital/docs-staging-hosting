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


module GraphQl = {
  @react.component
  let make = (~children) => {
    let networkId = RootProvider.useChainId()
    let user = RootProvider.useCurrentUser()
    let client = React.useMemo1(() =>
      Client.makeClient(
        ~graphUri={
          switch networkId {
          | Some(5) => Config.goerliGraphEndpoint
          | Some(321) => Config.localhostGraphEndpoint
          | Some(97)
          | Some(_)
          | None => Config.binancTestnetGraphEndpoint
          }
        },
        ~dbUri="http://localhost:8080/v1/graphql",
        ~user
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
      <StateChangeMonitor>
        {switch router.route {
        | _ => <MainLayout> content </MainLayout>
        }}
      </StateChangeMonitor>
    </GraphQl>
  </RootProvider>
}
