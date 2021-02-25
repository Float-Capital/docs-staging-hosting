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

type context =
  | Graph
  | DB

let chainContextToStr = chain =>
  switch chain {
  | Graph => "graph"
  | DB => "db"
  }
type queryContext = {context: context}

let createContext: context => Js.Json.t = queryType => {context: queryType}->Obj.magic

@send
external getContext: ApolloClient__Link_Core_ApolloLink.Operation.Js_.t => option<queryContext> =
  "getContext"

let httpLink = (~uri) => ApolloClient.Link.HttpLink.make(~uri=_ => uri, ())

let headers = {
  "eth-address": "0x738edd7F6a625C02030DbFca84885b4De5252903",
  "eth-signature": "0x169b856dd3650bede1cfcd8fcb0957a0dcc259880e6264b666c521e6bd28f3822183f56d90a440c02b151014bf24d0454ce065a6a30dd6169c388be7f32fe2a41b",
}

let querySwitcherLink = (~graphUri, ~dbUri) => ApolloClient.Link.split(~test=operation => {
    let context = operation->getContext

    switch context {
    | Some({context}) =>
      switch context {
      | Graph => Js.log("Wrong context")
      | DB => Js.log("using the DB context!!!")
      }
    | None => Js.log("NO context")
    }
    switch context {
    | Some({context}) =>
      switch context {
      | Graph => true
      | DB => false
      }
    | None => true
    }
  }, ~whenTrue=httpLink(
    ~uri=graphUri,
  ), ~whenFalse=ApolloClient.Link.HttpLink.make(~uri=_ => dbUri, ~headers=Obj.magic(headers), ()))

// This sets up session storage caching for SWR
// SwrPersist.syncWithSessionStorage->Misc.onlyExecuteClientSide

// This is a normal apollo client, it isn't optimized for nextjs yet.
let client = (~graphUri, ~dbUri) => {
  open ApolloClient
  make(
    ~cache=Cache.InMemoryCache.make(),
    // I would turn this off in production
    ~connectToDevTools=true,
    ~link=querySwitcherLink(~graphUri, ~dbUri),
    (),
  )
}

module GraphQl = {
  @react.component
  let make = (~children) => {
    let networkId = RootProvider.useChainId()
    let client = React.useMemo1(() =>
      client(
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
