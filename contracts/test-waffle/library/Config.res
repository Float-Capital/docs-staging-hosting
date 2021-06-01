@module("dotenv") external configEnv: unit => unit = "config"

configEnv()

@val
external optRunValueSimulations: option<string> = "process.env.RUN_VALUE_SIMULATIONS"
let runValueSimulations =
  optRunValueSimulations->Option.getWithDefault("false")->Js.String2.toLowerCase == "true"
