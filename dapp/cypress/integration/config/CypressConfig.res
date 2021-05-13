@val @scope("Cypress") external getCypressConfig: string => option<string> = "env"

let optPort = getCypressConfig("UI_PORT")
let optUrlBase = getCypressConfig("URL_BASE") // Eg. use this to test against a prod version

let baseUrl =
  optUrlBase->Option.getWithDefault("http://localhost:" ++ optPort->Option.getWithDefault("3000"))
