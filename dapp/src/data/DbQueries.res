module CreateUser = %graphql(`
mutation createUser($userName: String)
  @ppxConfig(schema: "graphql_schema_db.json") {
    createUser(username: $userName) {
      success
      error
    }
  }
`)

module GetUser = %graphql(`
query($userAddress: String)
  @ppxConfig(schema: "graphql_schema_db.json") {
    user(where: {ethAddress: {_eq: $userAddress}}){
      ethAddress
      userName
    }
  }
`)

module UpdateUser = %graphql(`
mutation updateUser($userName: String!, $userAddress: String!)
  @ppxConfig(schema: "graphql_schema_db.json") {
  update_user(where: {ethAddress: {_eq: $userAddress}, userName: {}}, _set: {userName: $userName}) {
    returning {
      userName
    }
  }
  }
`)
