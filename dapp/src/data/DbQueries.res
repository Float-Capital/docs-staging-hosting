module CreateUser = %graphql(`
mutation test($userAddress: String!, $userName: String)
  @ppxConfig(schema: "graphql_schema_db.json") {
  createUser(usersAddress: $userAddress, userName: $userName) {
    success
  }
}
`)

