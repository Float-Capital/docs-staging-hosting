module ApolloQueryResult = ApolloClient.Types.ApolloQueryResult

@decco.decode
type usersData = {usersAddress: string, userName: option<string>}
@decco.decode
type body_in = {input: usersData}

@decco.encode
type body_out = {
  success: bool,
  error: option<string>,
  // depositTxHash: string
}

let gqlClient = ClientConfig.createInstance(
  ~headers={"x-hasura-admin-secret": "testing"},
  ~graphqlEndpoint="http://graphql-engine:8080/v1/graphql",
  (),
)

type bodyObj = {
  session_variables: AuthHook.authResponse
}

@get external getAuthHeaders: Express.Request.t => bodyObj = "body"

let getUsersAddress: Express.Request.t => option<string> = request => { 
  let {session_variables: {xHasuraUserId}} = request->getAuthHeaders
  xHasuraUserId
}

let createUser = Serbet.endpoint({
  verb: POST,
  path: "/create-user",
  handler: req =>
    req.requireBody(value => {
      body_in_decode(value)
    })->JsPromise.map(({input: {usersAddress}}) => {
      let result = getUsersAddress(req.req)
      Js.log(("Headers", result))

      Js.log(`Eth address to register ${usersAddress}`)

      {
        success: true,
        error: None,
      }
      ->body_out_encode
      ->Serbet.Endpoint.OkJson
    }),
})
