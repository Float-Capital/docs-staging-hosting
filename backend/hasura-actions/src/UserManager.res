module ApolloQueryResult = ApolloClient.Types.ApolloQueryResult

@decco.decode
type usersData = {username: option<string>}
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
  session_variables: AuthHook.authResponse,
  input: usersData
}

@get external getBody: Express.Request.t => bodyObj = "body"

let getUsersAddress: Express.Request.t => option<string> = request => { 
  let {session_variables: {
    xHasuraUserId
  }} = request->getBody
  xHasuraUserId
}

type createUserInput = {
  ethAddress: option<string>,
  username: option<string>
}

let getUsername: Express.Request.t => option<string> = request => (request->getBody).input.username

let createUser = Serbet.endpoint({
  verb: POST,
  path: "/create-user",
  handler: req =>
    req.requireBody(value => {
      body_in_decode(value)
    })->JsPromise.then(_ => {
      let userAddress = getUsersAddress(req.req)
      let username = getUsername(req.req)

      gqlClient.mutate(~mutation=module(Query.CreateUser), {object_: {ethAddress: userAddress, userName: username}})
      -> JsPromise.map(result => 
        switch result {
        | Ok(_result) => {success: true, error: None}
        | Error(error) =>
          let {message}: ApolloClient__ApolloClient.ApolloError.t = error
          {
            success: false,
            error: Some(message),
          }
        }
        ->body_out_encode
        ->Serbet.Endpoint.OkJson
      )
    }),
})
