type coreContracts = {
  tokenFactory: Contract.TokenFactory.t,
  // floatCapital_v0: Contract.FloatCapital_v0.t,
  treasury: Contract.Treasury_v0.t,
  floatToken: Contract.FloatToken.t,
  staker: Contract.Staker.t,
  longShort: Contract.LongShort.t,
}

let createSyntheticMarket = {
  /*
    const oracleManager = await OracleManager.new(admin, {
    from: admin,
  });

  await yieldManager.setup(admin, longShort.address, fundToken.address, {
    from: admin,
  });

  // Mock yield manager needs to be able to mint tokens to simulate yield.
  var mintRole = await fundToken.MINTER_ROLE.call();
  await fundToken.grantRole(mintRole, yieldManager.address);

  await longShort.newSyntheticMarket(
    syntheticName,
    syntheticSymbol,
    fundToken.address,
    oracleManager.address,
    yieldManager.address,
    { from: admin }
  );
 */
  ()
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
    Js.log("Here...")
    Js.log({"floatCapital": floatCapital})
    Js.log({"treasury": treasury})
    Js.log({"floatToken": floatToken})
    Js.log({"staker": staker})
    Js.log({"longShort": longShort})
    TokenFactory.make(admin, longShort.address)->JsPromise.then(tokenFactory => {
      JsPromise.all4((
        floatToken->FloatToken.setup("Float token", "FLOAT TOKEN", staker.address),
        treasury->Treasury_v0.setup(admin),
        longShort->LongShort.setup(admin, treasury.address, tokenFactory.address, staker.address),
        staker->Staker.setup(admin, longShort.address, floatToken.address, floatCapital.address),
      ))->JsPromise.then(_ => {
        {
          staker: staker,
          longShort: longShort,
          floatToken: floatToken,
          tokenFactory: tokenFactory,
          treasury: treasury,
        }->JsPromise.resolve
      })
    })
  })
}
