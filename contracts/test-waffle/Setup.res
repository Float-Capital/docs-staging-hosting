/*
  Put any global setup that you need done before mocha runs here.
*/

module SeedRandom = {
  type t
  @module external make: string => t = "seedrandom"
}

module Random = {
  type t
  @module("random") external use: SeedRandom.t => unit = "use"

  @module("random") external replaceJsRng: unit => unit = "patch"
}

module Crypto = {
  module Bytes = {
    type t

    @module("crypto") external random: int => t = "randomBytes"

    @send external toString: (t, string) => string = "toString"

    let toHexString = bytes => bytes->toString("Hex")
  }

  let randomString = strLengthDiv2 => Bytes.random(strLengthDiv2)->Bytes.toHexString
}

// called in hardhat.config.js
let mochaSetup = () => {
  // 1. Replace Math.random with a seeded one.
  let seed = Crypto.randomString(20)
  Js.log(`Running tests with random seed: ${seed}`)

  // replace seed->SeedRandom.make with "<seed-str>"->SeedRandom.make if testing a particular seed
  Random.use(seed->SeedRandom.make)

  // limitations:
  //  if you run only some tests, then you'll
  //  be lucky to get the same random value
  //  as if you ran all of them (order of call matters for seed)

  //  random addresses/wallets use crypto.randomBytes -> unaffected by this

  Random.replaceJsRng()
}
