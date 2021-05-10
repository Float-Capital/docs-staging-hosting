open Contract
type coreContracts = {
  tokenFactory: Contract.TokenFactory.t,
  // floatCapital_v0: Contract.FloatCapital_v0.t,
  treasury: Contract.Treasury_v0.t,
  floatToken: Contract.FloatToken.t,
  staker: Contract.Staker.t,
  longShort: Contract.LongShort.t,
}

let createSyntheticMarket = (
  ~admin,
  ~longShort: LongShort.t,
  ~fundToken: PaymentToken.t,
  ~marketName,
  ~marketSymbol,
) => {
  let _ = JsPromise.all2((
    OracleManagerMock.make(admin),
    YieldManagerMock.make(admin, longShort.address, fundToken.address),
  ))->JsPromise.then(((oracleManager, yieldManager)) => {
    let _ignorePromise = fundToken->PaymentToken.grantMintRole(~user=yieldManager.address)
    longShort->LongShort.newSyntheticMarket(
      ~marketName,
      ~marketSymbol,
      ~paymentToken=fundToken.address,
      ~oracleManager=oracleManager.address,
      ~yieldManager=yieldManager.address,
    )
  })
}

let inititialize = (~admin: Ethers.Wallet.t) => {
  JsPromise.all6((
    FloatCapital_v0.make(),
    Treasury_v0.make(),
    FloatToken.make(),
    Staker.make(),
    LongShort.make(),
    PaymentToken.make(~name="Pay Token", ~symbol="PT"),
  ))->JsPromise.then(((floatCapital, treasury, floatToken, staker, longShort, paymentToken)) => {
    TokenFactory.make(admin.address, longShort.address)->JsPromise.then(tokenFactory => {
      JsPromise.all4((
        floatToken->FloatToken.setup("Float token", "FLOAT TOKEN", staker.address),
        treasury->Treasury_v0.setup(admin.address),
        longShort->LongShort.setup(
          admin.address,
          treasury.address,
          tokenFactory.address,
          staker.address,
        ),
        staker->Staker.setup(
          admin.address,
          longShort.address,
          floatToken.address,
          floatCapital.address,
        ),
      ))->JsPromise.map(_ => {
        let _ignorePromise = createSyntheticMarket(
          ~admin=admin.address,
          ~longShort,
          ~fundToken=paymentToken,
          ~marketName="Test Market 1",
          ~marketSymbol="TM1",
        )
        {
          staker: staker,
          longShort: longShort,
          floatToken: floatToken,
          tokenFactory: tokenFactory,
          treasury: treasury,
        }
      })
    })
  })
}
