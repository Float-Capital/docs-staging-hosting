type coreContracts = {
  tokenFactory: Contract.TokenFactory.t,
  // floatCapital_v0: Contract.FloatCapital_v0.t,
  treasury: Contract.Treasury_v0.t,
  floatToken: Contract.FloatToken.t,
  staker: Contract.Staker.t,
  longShort: Contract.LongShort.t,
}

let inititialize = () => {
  let admin = "0x0000000000000000000000000000000000000000"
  open Contract
  JsPromise.all5((
    FloatCapital_v0.make(),
    Treasury_v0.make(),
    FloatToken.make(),
    Staker.make(),
    LongShort.make(),
  ))->JsPromise.then(((floatCapital, treasury, floatToken, staker, longShort)) => {
    TokenFactory.make(admin, longShort.address)->JsPromise.map(tokenFactory => {
      JsPromise.all4((
        floatToken->FloatToken.setup("Float token", "FLOAT TOKEN", staker.address),
        treasury->Treasury_v0.setup(admin),
        longShort->LongShort.setup(admin, treasury.address, tokenFactory.address, staker.address),
        staker->Staker.setup(admin, longShort.address, floatToken.address, floatCapital.address),
      ))->JsPromise.map(_ => {
        staker: staker,
        longShort: longShort,
        floatToken: floatToken,
        tokenFactory: tokenFactory,
        treasury: treasury,
      })
    })
  })
}
