open Ethers.Utils
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

let querySwitcherLink = (~graphUri, ~dbUri, ~user) =>
  ApolloClient.Link.split(
    ~test=operation => {
      let context = operation->getContext
      switch context {
      | Some({context}) =>
        switch context {
        | Graph => true
        | DB => false
        }
      | None => true
      }
    },
    ~whenTrue=httpLink(~uri=graphUri),
    ~whenFalse=ApolloClient.Link.HttpLink.make(
      ~uri=_ => dbUri,
      ~headers={
        // NOTE: the user is hardcoded to `NONE` and will need to be configured for database use in the future
        switch getAuthHeaders(~user) {
        | Some(headers) => headers->Obj.magic
        | None => Js.Obj.empty->Obj.magic
        }
      },
      (),
    ),
  )

// This sets up session storage caching for SWR
// SwrPersist.syncWithSessionStorage->Misc.onlyExecuteClientSide

// This is a normal apollo client, it isn't optimized for nextjs yet.
let makeClient = (~graphUri, ~dbUri, ~user) => {
  open ApolloClient
  make(
    ~cache=Cache.InMemoryCache.make(),
    // I would turn this off in production
    ~connectToDevTools=true,
    ~link=querySwitcherLink(~graphUri, ~dbUri, ~user),
    (),
  )
}
