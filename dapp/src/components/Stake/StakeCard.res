open Globals
open APYProvider

// Big numbers
let zero = Ethers.BigNumber.fromUnsafe("0")
let oneHundred = Ethers.BigNumber.fromUnsafe("100000000000000000000") // 10 ^ 20
let oneInWei = Ethers.BigNumber.fromUnsafe("1000000000000000000") // 10 ^ 18

let calculateDollarValue = (~tokenPrice: Ethers.BigNumber.t, ~amountStaked: Ethers.BigNumber.t) => {
  tokenPrice->Ethers.BigNumber.mul(amountStaked)->Ethers.BigNumber.div(oneInWei)
}

let basicApyCalc = (collateralTokenApy: float, longVal: float, shortVal: float, tokenType) => {
  switch tokenType {
  | "long" =>
    switch longVal {
    | 0.0 => collateralTokenApy
    | _ => collateralTokenApy *. shortVal /. longVal
    }
  | "short" =>
    switch shortVal {
    | 0.0 => collateralTokenApy
    | _ => collateralTokenApy *. longVal /. shortVal
    }
  | _ => collateralTokenApy
  }
}

let mappedBasicCalc = (apy, longVal, shortVal, tokenType) =>
  switch apy {
  | Loaded(apyVal) => Loaded(basicApyCalc(apyVal, longVal, shortVal, tokenType))
  | a => a
  }

// TODO: emit and pull these from graph. "kperiod, kInitialMultiplier."
// For now going to hardcode them.
let kperiodHardcode = Ethers.BigNumber.fromUnsafe("1664000") // ~20 days
let kmultiplierHardcode = Ethers.BigNumber.fromUnsafe("5000000000000000000")

let kCalc = (
  kperiod: Ethers.BigNumber.t,
  kmultiplier: Ethers.BigNumber.t,
  initialTimestamp: Ethers.BigNumber.t,
  currentTimestamp: Ethers.BigNumber.t,
) => {
  if currentTimestamp->Ethers.BigNumber.sub(initialTimestamp)->Ethers.BigNumber.lte(kperiod) {
    kmultiplier->Ethers.BigNumber.sub(
      kmultiplier
      ->Ethers.BigNumber.sub(oneInWei)
      ->Ethers.BigNumber.mul(currentTimestamp->Ethers.BigNumber.sub(initialTimestamp))
      ->Ethers.BigNumber.div(kperiod),
    )
  } else {
    oneInWei
  }
}

let myfloatCalc = (
  longVal: Ethers.BigNumber.t,
  shortVal: Ethers.BigNumber.t,
  kperiod: Ethers.BigNumber.t,
  kmultiplier: Ethers.BigNumber.t,
  initialTimestamp: Ethers.BigNumber.t,
  currentTimestamp: Ethers.BigNumber.t,
  tokenType,
) => {
  let total = longVal->Ethers.BigNumber.add(shortVal)
  let k = kCalc(kperiod, kmultiplier, initialTimestamp, currentTimestamp)
  switch tokenType {
  | "long" =>
    switch longVal->Ethers.Utils.formatEther->Js.Float.fromString {
    | 0.0 => zero
    | _ => k->Ethers.BigNumber.mul(shortVal)->Ethers.BigNumber.div(total)
    }
  | "short" =>
    switch shortVal->Ethers.Utils.formatEther->Js.Float.fromString {
    | 0.0 => zero
    | _ => k->Ethers.BigNumber.mul(longVal)->Ethers.BigNumber.div(total)
    }
  | _ => oneHundred
  }
}

type handleStakeButtonPress =
  | WaitingForInteraction
  | Loading
  | Form(string)
  | Redirect({marketIndex: string, actionOption: string})

@react.component
let make = (
  ~syntheticMarket as {
    name: marketName,
    timestampCreated,
    marketIndex,
    latestSystemState: {
      timestamp: currentTimestamp,
      totalValueLocked,
      totalLockedLong,
      totalLockedShort,
      longTokenPrice: {price: {price: longTokenPrice}},
      shortTokenPrice: {price: {price: shortTokenPrice}},
    },
    syntheticShort: {totalStaked: shortTotalStaked, tokenAddress: shortTokenAddress},
    syntheticLong: {totalStaked: longTotalStaked, tokenAddress: longTokenAddress},
  }: Queries.SyntheticMarketInfo.t,
  ~optUserBalanceAddressSet=None: option<DataHooks.graphResponse<HashSet.String.t>>,
) => {
  let router = Next.Router.useRouter()

  let toastDispatch = React.useContext(ToastProvider.DispatchToastContext.context)
  let apy = useAPY()

  let longDollarValueStaked = calculateDollarValue(
    ~tokenPrice=longTokenPrice,
    ~amountStaked=longTotalStaked,
  )
  let shortDollarValueStaked = calculateDollarValue(
    ~tokenPrice=shortTokenPrice,
    ~amountStaked=shortTotalStaked,
  )
  let totalDollarValueStake = longDollarValueStaked->Ethers.BigNumber.add(shortDollarValueStaked)

  // TODO: pull in APY from aave api
  let longApy = mappedBasicCalc(
    apy,
    totalLockedLong->Ethers.Utils.formatEther->Js.Float.fromString,
    totalLockedShort->Ethers.Utils.formatEther->Js.Float.fromString,
    "long",
  )
  let shortApy = mappedBasicCalc(
    apy,
    totalLockedLong->Ethers.Utils.formatEther->Js.Float.fromString,
    totalLockedShort->Ethers.Utils.formatEther->Js.Float.fromString,
    "short",
  )

  let longFloatApy = myfloatCalc(
    totalLockedLong,
    totalLockedShort,
    kperiodHardcode,
    kmultiplierHardcode,
    timestampCreated,
    currentTimestamp,
    "long",
  )

  let shortFloatApy = myfloatCalc(
    totalLockedLong,
    totalLockedShort,
    kperiodHardcode,
    kmultiplierHardcode,
    timestampCreated,
    currentTimestamp,
    "short",
  )

  let stakeOption = router.query->Js.Dict.get("tokenAddress")

  let stakeButtons = () =>
    <div className="flex flex-wrap justify-evenly">
      <Button.Small
        onClick={_ => {
          router->Next.Router.pushOptions(
            `/stake?tokenAddress=${longTokenAddress->ethAdrToLowerStr}`,
            None,
            {shallow: true, scroll: false},
          )
        }}>
        "Stake Long"
      </Button.Small>
      <Button.Small
        onClick={_ => {
          router->Next.Router.pushOptions(
            `/stake?tokenAddress=${shortTokenAddress->ethAdrToLowerStr}`,
            None,
            {shallow: true, scroll: false},
          )
        }}>
        "Stake Short"
      </Button.Small>
    </div>

  let stakeButtonPressState: handleStakeButtonPress =
    stakeOption->Option.mapWithDefault(WaitingForInteraction, tokenAddress => {
      let longAdrLower = longTokenAddress->ethAdrToLowerStr
      let shortAdrLower = shortTokenAddress->ethAdrToLowerStr

      if tokenAddress == longAdrLower || tokenAddress == shortAdrLower {
        let redirect = () => Redirect({
          actionOption: tokenAddress == longAdrLower ? "long" : "short",
          marketIndex: marketIndex->Ethers.BigNumber.toString,
        })
        switch optUserBalanceAddressSet {
        | Some(Loading) => Loading
        | Some(Response(set)) =>
          set->HashSet.String.has(
            tokenAddress->Ethers.Utils.getAddressUnsafe->Ethers.Utils.ethAdrToStr,
          )
            ? Form(tokenAddress)
            : redirect()
        | _ => redirect()
        }
      } else {
        WaitingForInteraction
      }
    })

  React.useEffect1(_ => {
    switch stakeButtonPressState {
    | Redirect({actionOption, marketIndex}) => {
        let routeToMint = () =>
          router
          ->Next.Router.pushPromise(
            `/markets?marketIndex=${marketIndex}&actionOption=${actionOption}&tab=mint`,
          )
          ->JsPromise.then(_ => {
            let _ = toastDispatch(
              ToastProvider.Show(
                `Mint some  ${marketName} ${actionOption} tokens to stake.`,
                "",
                ToastProvider.Info,
              ),
            )
            ()->JsPromise.resolve
          })
          ->JsPromise.catch(e => {
            Js.log(e)
            ()->JsPromise.resolve
          })
        let _ =
          router
          ->Next.Router.replaceOptionsPromise(`/stake`, None, {shallow: true, scroll: false}) // for if user presses back
          ->JsPromise.then(_ => routeToMint()->JsPromise.resolve)
          ->JsPromise.catch(e => {
            Js.log(e)
            routeToMint()->JsPromise.resolve
          })
      }
    | _ => ()
    }
    None
  }, [stakeButtonPressState])

  let liquidityRatio = () =>
    <div className={`w-full`}>
      {switch !(totalValueLocked->Ethers.BigNumber.eq(CONSTANTS.zeroBN)) {
      | true => <MarketBar totalLockedLong totalValueLocked />
      | false => React.null
      }}
    </div>

  let closeStakeFormButton = () =>
    <button
      className="absolute left-full pl-4 text-3xl leading-none outline-none focus:outline-none"
      onClick={_ => {
        router->Next.Router.pushOptions(`/stake`, None, {shallow: true, scroll: false})
      }}>
      <span className="opacity-4 block outline-none focus:outline-none">
        {`×`->React.string}
      </span>
    </button>

  <>
    <div className="p-1 mb-8 rounded-lg flex flex-col bg-white bg-opacity-75 my-5 shadow-lg">
      <div className="flex justify-center w-full my-1">
        <h1 className="font-bold text-xl font-alphbeta">
          {marketName->React.string} <Tooltip tip={`This market tracks ${marketName}`} />
        </h1>
      </div>
      <div className="flex flex-wrap justify-center w-full">
        <StakeCardSide
          orderPostionMobile={2}
          orderPostion={1}
          marketName={marketName}
          isLong={true}
          apy={longApy}
          floatApy={longFloatApy->Ethers.Utils.formatEther->Js.Float.fromString}
        />
        <div className="w-full md:w-1/2 flex items-center flex-col order-1 md:order-2">
          <div className="flex flex-row items-center justify-between w-full ">
            <div>
              <div>
                <h2 className="text-xxs mt-1">
                  <span className="font-bold"> {`📈 Long`->React.string} </span>
                  {" staked"->React.string}
                </h2>
              </div>
              <div className="text-sm font-alphbeta tracking-wider py-1">
                {`$${longDollarValueStaked->FormatMoney.formatEther}`->React.string}
              </div>
            </div>
            <div>
              <div>
                <h2 className="text-xs mt-1">
                  <span className="font-bold"> {`TOTAL`->React.string} </span>
                  {" Staked"->React.string}
                </h2>
              </div>
              <div className="text-3xl font-alphbeta tracking-wider py-1">
                {`$${totalDollarValueStake->FormatMoney.formatEther}`->React.string}
              </div>
            </div>
            <div className="text-right">
              <div>
                <h2 className="text-xxs mt-1">
                  <span className="font-bold"> {`Short`->React.string} </span>
                  {` staked 📉`->React.string}
                </h2>
              </div>
              <div className="text-sm font-alphbeta tracking-wider py-1">
                {`$${shortDollarValueStaked->FormatMoney.formatEther}`->React.string}
              </div>
            </div>
          </div>
          {liquidityRatio()}
          <div className="md:block hidden w-full flex justify-around"> {stakeButtons()} </div>
        </div>
        <StakeCardSide
          orderPostionMobile={3}
          orderPostion={3}
          marketName={marketName}
          isLong={false}
          apy={shortApy}
          floatApy={shortFloatApy->Ethers.Utils.formatEther->Js.Float.fromString}
        />
        <div className="block md:hidden pt-5 order-4 w-full"> {stakeButtons()} </div>
      </div>
      {switch stakeButtonPressState {
      | Form(tokenAddress) =>
        <div className="w-96 mx-auto relative">
          {closeStakeFormButton()} <StakeForm tokenId=tokenAddress />
        </div>
      | Loading => <Loader />
      | _ => React.null
      }}
    </div>
  </>
}
