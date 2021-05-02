let graphqlEndpoint = "localhost:4000"

%raw(`require('isomorphic-fetch')`)

@val
external fetch: ApolloClient.Link.HttpLink.HttpOptions.Js_.t_fetch = "fetch"

Dotenv.config()

@val
external optHasuraApiEndpoint: option<string> = "process.env.HASURA_API_ENDPOINT"
let hasuraApiEndpoint =
  optHasuraApiEndpoint->Option.getWithDefault(
    "http://127.0.0.1:8000/subgraphs/name/float-capital/float-capital",
  )

let httpLink = ApolloClient.Link.HttpLink.make(~uri=_ => hasuraApiEndpoint, ~fetch, ())

let instance = {
  open ApolloClient
  make(
    ~cache=Cache.InMemoryCache.make(),
    ~connectToDevTools=true,
    ~defaultOptions=DefaultOptions.make(
      ~mutate=DefaultMutateOptions.make(~awaitRefetchQueries=true, ~errorPolicy=All, ()),
      ~query=DefaultQueryOptions.make(~fetchPolicy=NetworkOnly, ~errorPolicy=All, ()),
      ~watchQuery=DefaultWatchQueryOptions.make(~fetchPolicy=NetworkOnly, ~errorPolicy=All, ()),
      (),
    ),
    ~link=httpLink,
    (),
  )
}
