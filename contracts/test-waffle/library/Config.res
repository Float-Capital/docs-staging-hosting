@module("dotenv") external configEnv: unit => unit = "config"

configEnv()

@val
external optRunValueSimulations: option<string> = "process.env.RUN_VALUE_SIMULATIONS"
let runValueSimulations =
  optRunValueSimulations->Option.getWithDefault("false")->Js.String2.toLowerCase == "true"

@val
external optDontRunIntegrationTests: option<string> = "process.env.DONT_RUN_INTEGRATION_TESTS"
let dontRunIntegrationTests =
  optDontRunIntegrationTests->Option.getWithDefault("false")->Js.String2.toLowerCase == "true"

@val
external optDontRunUnitTests: option<string> = "process.env.DONT_RUN_UNIT_TESTS"
let dontRunUnitTests =
  optDontRunUnitTests->Option.getWithDefault("false")->Js.String2.toLowerCase == "true"
