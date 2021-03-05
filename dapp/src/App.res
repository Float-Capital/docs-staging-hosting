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

@ocaml.doc(`the default client is the client connected to the default network`)
let defaultClient = Client.makeClient(
  ~graphUri={
    Config.binancTestnetGraphEndpoint
  },
  ~dbUri="http://localhost:8080/v1/graphql" /* NOTE CURRENTLY USED */,
  ~user=None,
)

module ApolloContext = {
  let context = React.createContext(defaultClient)

  let provider = React.Context.provider(context)
  let useApolloClient = () => React.useContext(context)

  module GraphQl = {
    @react.component
    let make = (~children) => {
      let client = useApolloClient()
      <ApolloClient.React.ApolloProvider client> children </ApolloClient.React.ApolloProvider>
    }
  }

  module Provider = {
    @react.component
    let make = (~client, ~children) => {
      React.createElement(provider, {"value": client, "children": children})
    }
  }

  @react.component
  let make = (~children) => {
    <Provider client=defaultClient> <GraphQl> children </GraphQl> </Provider>
  }
}

// We are not using `@react.component` since we will never
// use <App/> within our Rescript code. It's only used within `pages/_app.js`
let default = (props: props): React.element => {
  let {component, pageProps} = props

  let router = Next.Router.useRouter()

  let content = React.createElement(component, pageProps)

  <RootProvider>
    <ApolloContext>
      <StateChangeMonitor>
        {switch router.route {
        | _ => <MainLayout> content </MainLayout>
        }}
      </StateChangeMonitor>
    </ApolloContext>
  </RootProvider>
}
