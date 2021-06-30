open Globals
type markets = {
  paymentToken: ERC20Mock.t,
  oracleManager: OracleManagerMock.t,
  yieldManager: YieldManagerMock.t,
  longSynth: SyntheticToken.t,
  shortSynth: SyntheticToken.t,
  marketIndex: int,
}
type coreContracts = {
  floatCapital_v0: FloatCapital_v0.t,
  tokenFactory: TokenFactory.t,
  treasury: Treasury_v0.t,
  floatToken: FloatToken.t,
  staker: Staker.t,
  longShort: LongShort.t,
  markets: array<markets>,
}

module Tuple = {
  let make2 = fn => (fn(), fn())
  let make3 = fn => (fn(), fn(), fn())
  let make4 = fn => (fn(), fn(), fn(), fn())
  let make5 = fn => (fn(), fn(), fn(), fn(), fn())
  let make6 = fn => (fn(), fn(), fn(), fn(), fn(), fn())
  let make7 = fn => (fn(), fn(), fn(), fn(), fn(), fn(), fn())
  let make8 = fn => (fn(), fn(), fn(), fn(), fn(), fn(), fn(), fn())
}

@ocaml.doc(`Generates random BigNumber between 1 and 2147483647 (max js int)`)
let randomInteger = () => Js.Math.random_int(1, Js.Int.max)->Ethers.BigNumber.fromInt

@ocaml.doc(`Generates a random JS integer between 0 and 2147483647 (max js int)`)
let randomJsInteger = () => Js.Math.random_int(0, Js.Int.max)

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

let randomAddress = () => Ethers.Wallet.createRandom().address

let createSyntheticMarket = (
  ~admin,
  ~initialMarketSeed=bnFromString("500000000000000000"),
  ~paymentToken: ERC20Mock.t,
  ~treasury,
  ~marketName,
  ~marketSymbol,
  longShort: LongShort.t,
) => {
  JsPromise.all3((
    OracleManagerMock.make(~admin),
    YieldManagerMock.make(
      ~admin,
      ~longShort=longShort.address,
      ~token=paymentToken.address,
      ~treasury,
    ),
    paymentToken
    ->ERC20Mock.mint(~_to=admin, ~amount=initialMarketSeed->mul(bnFromInt(100)))
    ->JsPromise.then(_ =>
      paymentToken->ERC20Mock.approve(
        ~spender=longShort.address,
        ~amount=initialMarketSeed->mul(bnFromInt(100)),
      )
    ),
  ))->JsPromise.then(((oracleManager, yieldManager, _)) => {
    let _ignorePromise =
      paymentToken
      ->ERC20Mock.mINTER_ROLE
      ->JsPromise.map(minterRole =>
        paymentToken->ERC20Mock.grantRole(~role=minterRole, ~account=yieldManager.address)
      )
    longShort
    ->LongShort.newSyntheticMarket(
      ~syntheticName=marketName,
      ~syntheticSymbol=marketSymbol,
      ~paymentToken=paymentToken.address,
      ~oracleManager=oracleManager.address,
      ~yieldManager=yieldManager.address,
    )
    ->JsPromise.then(_ => longShort->LongShort.latestMarket)
    ->JsPromise.then(marketIndex => {
      longShort->LongShort.initializeMarket(
        ~marketIndex,
        ~baseEntryFee=Ethers.BigNumber.fromInt(0),
        ~badLiquidityEntryFee=Ethers.BigNumber.fromInt(0),
        ~baseExitFee=Ethers.BigNumber.fromInt(50),
        ~badLiquidityExitFee=Ethers.BigNumber.fromInt(50),
        ~kInitialMultiplier=Ethers.BigNumber.fromUnsafe("1000000000000000000"),
        ~kPeriod=Ethers.BigNumber.fromInt(0),
        ~initialMarketSeed,
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
        longShort
        ->LongShort.syntheticTokens(marketIndex, true /* long */)
        ->JsPromise.then(SyntheticToken.at),
        longShort
        ->LongShort.syntheticTokens(marketIndex, false /* short */)
        ->JsPromise.then(SyntheticToken.at),
        longShort->LongShort.paymentTokens(marketIndex)->JsPromise.then(ERC20Mock.at),
        longShort->LongShort.oracleManagers(marketIndex)->JsPromise.then(OracleManagerMock.at),
        longShort->LongShort.yieldManagers(marketIndex)->JsPromise.then(YieldManagerMock.at),
      ))->JsPromise.map(((longSynth, shortSynth, paymentToken, oracleManager, yieldManager)) => {
        {
          paymentToken: paymentToken,
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
    exposeInternals ? Staker.Exposed.make() : Staker.make(),
    exposeInternals ? LongShort.Exposed.make() : LongShort.make(),
    JsPromise.all2((
      ERC20Mock.make(~name="Pay Token 1", ~symbol="PT1"),
      ERC20Mock.make(~name="Pay Token 2", ~symbol="PT2"),
    )),
  ))->JsPromise.then(((
    floatCapital,
    treasury,
    floatToken,
    staker,
    longShort,
    (payToken1, payToken2),
  )) => {
    TokenFactory.make(
      ~admin=admin.address,
      ~longShort=longShort.address,
    )->JsPromise.then(tokenFactory => {
      JsPromise.all4((
        floatToken->FloatToken.initialize3(
          ~name="Float token",
          ~symbol="FLOAT TOKEN",
          ~stakerAddress=staker.address,
        ),
        treasury->Treasury_v0.initialize(~admin=admin.address),
        longShort->LongShort.initialize(
          ~admin=admin.address,
          ~treasury=treasury.address,
          ~tokenFactory=tokenFactory.address,
          ~staker=staker.address,
        ),
        staker->Staker.initialize(
          ~admin=admin.address,
          ~longShortCoreContract=longShort.address,
          ~floatToken=floatToken.address,
          ~floatCapital=floatCapital.address,
        ),
      ))
      ->JsPromise.then(_ => {
        [payToken1, payToken1, payToken2, payToken1]
        ->Array.reduceWithIndex(JsPromise.resolve(), (previousPromise, paymentToken, index) => {
          previousPromise->JsPromise.then(() =>
            longShort->createSyntheticMarket(
              ~admin=admin.address,
              ~treasury=treasury.address,
              ~paymentToken,
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
        floatCapital_v0: floatCapital,
      })
    })
  })
}

let increaseTime: int => JsPromise.t<
  unit,
> = %raw(`(seconds) => ethers.provider.send("evm_increaseTime", [seconds])`)

type block = {timestamp: int}
let getBlock: unit => JsPromise.t<block> = %raw(`() => ethers.provider.getBlock()`)

let getRandomTimestampInPast = () => {
  getBlock()->JsPromise.then(({timestamp}) => {
    (timestamp - Js.Math.random_int(200, 630720000))->Ethers.BigNumber.fromInt->JsPromise.resolve
  })
}
