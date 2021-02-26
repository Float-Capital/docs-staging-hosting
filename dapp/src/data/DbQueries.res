module CreateUser = %graphql(`
mutation test($userName: String)
  @ppxConfig(schema: "graphql_schema_db.json") {
  createUser(username: $userName) {
    success
    error
  }
}
`)

