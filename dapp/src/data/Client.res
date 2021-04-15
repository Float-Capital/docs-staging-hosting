open Ethers.Utils
type context =
  | Graph
  | PriceHistory
  | DB

type queryContext = {context: option<context>}

let createContext: context => Js.Json.t = queryType => {context: Some(queryType)}->Obj.magic

@send
external getContext: ApolloClient__Link_Core_ApolloLink.Operation.Js_.t => option<queryContext> =
  "getContext"

let httpLink = (~uri) => ApolloClient.Link.HttpLink.make(~uri=_ => uri, ())

type clientHeaders = {
  @as("eth-address")
  ethAddress: string,
  @as("eth-signature")
  ethSignature: string,
}

let setSignInData = (~ethAddress: string, ~ethSignature: string) =>
  Dom.Storage2.localStorage->Dom.Storage2.setItem(ethAddress, ethSignature)

let getAuthHeaders = (~user) => {
  switch user {
  | None => None
  | Some(u) => {
      let getUserSignature = Dom.Storage2.getItem(_, u->ethAdrToLowerStr)
      switch getUserSignature(Dom.Storage2.localStorage) {
      | None => None
      | Some(uS) => Some({ethAddress: u->ethAdrToLowerStr, ethSignature: uS})
      }
    }
  }
}

let querySwitcherLink = (~user) =>
  ApolloClient.Link.split(
    ~test=operation => {
      let context = operation->getContext
      switch context {
      | Some({context: Some(context)}) =>
        switch context {
        | Graph => true
        | PriceHistory => false
        | DB => false
        }
      | Some({context: None})
      | None => true
      }
    },
    ~whenTrue=httpLink(~uri=Config.graphEndpoint),
    ~whenFalse=ApolloClient.Link.split(
      ~test=operation => {
        let context = operation->getContext
        let isPriceHistory = switch context {
        | Some({context: Some(PriceHistory)}) => true
        | _ => false
        }

        Js.log2("isPriceHistory", isPriceHistory)
        isPriceHistory
      },
      ~whenTrue=httpLink(~uri=Config.priceHistoryGraphEndpoint),
      ~whenFalse=ApolloClient.Link.HttpLink.make(
        ~uri=_ =>
          "TODO: no (hasura) backend configured yet - http://localhost:8080/v1/graphql" /* NOTE CURRENTLY USED */,
        ~headers={
          // NOTE: the user is hardcoded to `NONE` and will need to be configured for database use in the future
          switch getAuthHeaders(~user) {
          | Some(headers) => headers->Obj.magic
          | None => Js.Obj.empty->Obj.magic
          }
        },
        (),
      ),
    ),
  )

// This sets up session storage caching for SWR
// SwrPersist.syncWithSessionStorage->Misc.onlyExecuteClientSide

// This is a normal apollo client, it isn't optimized for nextjs yet.
let makeClient = (~user) => {
  open ApolloClient
  make(
    ~cache=Cache.InMemoryCache.make(),
    // I would turn this off in production
    ~connectToDevTools=true,
    ~link=querySwitcherLink(~user),
    (),
  )
}

@ocaml.doc(`the default client is the client connected to the default network`)
let defaultClient = makeClient(~user=None)

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
  let make = (~children) => {
    React.createElement(provider, {"value": defaultClient, "children": children})
  }
}

@react.component
let make = (~children) => {
  <Provider> <GraphQl> children </GraphQl> </Provider>
}
