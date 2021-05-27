open Contract
type markets = {
  paymentToken: PaymentToken.t,
  oracleManager: OracleManagerMock.t,
  yieldManager: YieldManagerMock.t,
  longSynth: SyntheticToken.t,
  shortSynth: SyntheticToken.t,
  marketIndex: int,
}
type coreContracts = {
  // floatCapital_v0: Contract.FloatCapital_v0.t,
  tokenFactory: TokenFactory.t,
  treasury: Treasury_v0.t,
  floatToken: FloatToken.t,
  staker: Staker.t,
  longShort: LongShort.t,
  markets: array<markets>,
}

@ocaml.doc(`Generates random BigNumber between 1 and 2147483647 (max js int)`)
let randomInteger = () => Js.Math.random_int(1, Js.Int.max)->Ethers.BigNumber.fromInt

@ocaml.doc(`Generates random BigNumber between 0.00001 and 21474.83647 of a token (10^18 in BigNumber units)`)
let randomTokenAmount = () =>
  randomInteger()->Ethers.BigNumber.mul(Ethers.BigNumber.fromUnsafe("10000000000000"))

type mint =
  | Long(Ethers.BigNumber.t)
  | Short(Ethers.BigNumber.t)
  | Both(Ethers.BigNumber.t, Ethers.BigNumber.t)

let randomMintLongShort = () => {
  switch Js.Math.random_int(0, 3) {
  | 0 => Long(randomTokenAmount())
  | 1 => Short(randomTokenAmount())
  | 2
  | _ =>
    Both(randomTokenAmount(), randomTokenAmount())
  }
}

let createSyntheticMarket = (
  ~admin,
  ~longShort: LongShort.t,
  ~treasury: Treasury_v0.t,
  ~fundToken: PaymentToken.t,
  ~marketName,
  ~marketSymbol,
) => {
  JsPromise.all2((
    OracleManagerMock.make(admin),
    YieldManagerMock.make(admin, longShort.address, treasury.address, fundToken.address),
  ))->JsPromise.then(((oracleManager, yieldManager)) => {
    let _ignorePromise = fundToken->PaymentToken.grantMintRole(~user=yieldManager.address)
    longShort
    ->LongShort.newSyntheticMarket(
      ~marketName,
      ~marketSymbol,
      ~paymentToken=fundToken.address,
      ~oracleManager=oracleManager.address,
      ~yieldManager=yieldManager.address,
    )
    ->JsPromise.then(_ => longShort->LongShort.latestMarket)
    ->JsPromise.then(marketIndex => {
      longShort->LongShort.initializeMarket(
        ~marketIndex,
        ~baseEntryFee=0,
        ~badLiquidityEntryFee=50,
        ~baseExitFee=50,
        ~badLiquidityExitFee=50,
        ~kInitialMultiplier=Ethers.BigNumber.fromUnsafe("1000000000000000000"),
        ~kPeriod=Ethers.BigNumber.fromInt(0),
      )
    })
  })
}

let getAllMarkets = longShort => {
  longShort
  ->LongShort.latestMarket
  ->JsPromise.then(nextMarketIndex => {
    let marketIndex = nextMarketIndex

    Belt.Array.range(1, marketIndex)
    ->Array.map(marketIndex =>
      JsPromise.all5((
        longShort->LongShort.longSynth(~marketIndex)->JsPromise.then(SyntheticToken.at),
        longShort->LongShort.shortSynth(~marketIndex)->JsPromise.then(SyntheticToken.at),
        longShort->LongShort.fundTokens(~marketIndex)->JsPromise.then(PaymentToken.at),
        longShort->LongShort.oracleManagers(~marketIndex)->JsPromise.then(OracleManagerMock.at),
        longShort->LongShort.yieldManagers(~marketIndex)->JsPromise.then(YieldManagerMock.at),
      ))->JsPromise.map(((longSynth, shortSynth, fundToken, oracleManager, yieldManager)) => {
        {
          paymentToken: fundToken,
          oracleManager: oracleManager,
          yieldManager: yieldManager,
          longSynth: longSynth,
          shortSynth: shortSynth,
          marketIndex: marketIndex,
        }
      })
    )
    ->JsPromise.all
  })
}

let inititialize = (~admin: Ethers.Wallet.t, ~exposeInternals: bool) => {
  JsPromise.all6((
    FloatCapital_v0.make(),
    Treasury_v0.make(),
    FloatToken.make(),
    exposeInternals ? Staker.makeExposed() : Staker.make(),
    exposeInternals ? LongShort.makeExposed() : LongShort.make(),
    JsPromise.all2((
      PaymentToken.make(~name="Pay Token 1", ~symbol="PT1"),
      PaymentToken.make(~name="Pay Token 2", ~symbol="PT2"),
    )),
  ))->JsPromise.then(((
    floatCapital,
    treasury,
    floatToken,
    staker,
    longShort,
    (payToken1, payToken2),
  )) => {
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
      ))
      ->JsPromise.then(_ => {
        [payToken1, payToken1, payToken2, payToken1]
        ->Array.reduceWithIndex(JsPromise.resolve(), (previousPromise, paymentToken, index) => {
          previousPromise->JsPromise.then(() =>
            createSyntheticMarket(
              ~admin=admin.address,
              ~longShort,
              ~treasury,
              ~fundToken=paymentToken,
              ~marketName=`Test Market ${index->Int.toString}`,
              ~marketSymbol=`TM${index->Int.toString}`,
            )
          )
        })
        ->JsPromise.then(_ => {
          longShort->getAllMarkets
        })
      })
      ->JsPromise.map(markets => {
        staker: staker,
        longShort: longShort,
        floatToken: floatToken,
        tokenFactory: tokenFactory,
        treasury: treasury,
        markets: markets,
      })
    })
  })
}

let increaseTime: int => JsPromise.t<
  unit,
> = %raw(`(seconds) => ethers.provider.send("evm_increaseTime", [seconds])`)
