open APYProvider

let calculateDollarValue = (~tokenPrice: Ethers.BigNumber.t, ~amountStaked: Ethers.BigNumber.t) => {
  tokenPrice->Ethers.BigNumber.mul(amountStaked)->Ethers.BigNumber.div(CONSTANTS.tenToThe18)
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
) => {
  let router = Next.Router.useRouter()

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

  let longFloatApy = MarketCalculationHelpers.calculateFloatAPY(
    totalLockedLong,
    totalLockedShort,
    CONSTANTS.kperiodHardcode,
    CONSTANTS.kmultiplierHardcode,
    timestampCreated,
    currentTimestamp,
    "long",
  )

  let shortFloatApy = MarketCalculationHelpers.calculateFloatAPY(
    totalLockedLong,
    totalLockedShort,
    CONSTANTS.kperiodHardcode,
    CONSTANTS.kmultiplierHardcode,
    timestampCreated,
    currentTimestamp,
    "short",
  )

  let stakeButtons = () =>
    <div className="flex flex-wrap justify-evenly">
      <Button.Small
        onClick={event => {
          ReactEvent.Mouse.preventDefault(event)
          router->Next.Router.pushOptions(
            `/stake?marketIndex=${marketIndex->Ethers.BigNumber.toString}&actionOption=long&tokenId=${longTokenAddress->Ethers.Utils.ethAdrToLowerStr}`,
            None,
            {shallow: true, scroll: false},
          )
        }}>
        "Stake Long"
      </Button.Small>
      <Button.Small
        onClick={event => {
          ReactEvent.Mouse.preventDefault(event)
          router->Next.Router.pushOptions(
            `/stake?marketIndex=${marketIndex->Ethers.BigNumber.toString}&actionOption=short&tokenId=${shortTokenAddress->Ethers.Utils.ethAdrToLowerStr}`,
            None,
            {shallow: true, scroll: false},
          )
        }}>
        "Stake Short"
      </Button.Small>
    </div>

  let liquidityRatio = () =>
    <div className={`w-full`}>
      {switch !(totalValueLocked->Ethers.BigNumber.eq(CONSTANTS.zeroBN)) {
      | true => <MarketBar totalLockedLong totalValueLocked />
      | false => React.null
      }}
    </div>

  <Next.Link href={`/?marketIndex=${marketIndex->Ethers.BigNumber.toString}&tab=stake`}>
    <div
      className="p-1 mb-8 rounded-lg flex flex-col bg-light-gold bg-opacity-75 hover:bg-opacity-60 cursor-pointer my-5 shadow-lg">
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
                {`$${longDollarValueStaked->Misc.NumberFormat.formatEther}`->React.string}
              </div>
            </div>
            <div>
              <div>
                <h2 className="text-xs mt-1 flex justify-center">
                  <span className="font-bold pr-1"> {`TOTAL`->React.string} </span>
                  {" Staked"->React.string}
                </h2>
              </div>
              <div className="text-3xl font-alphbeta tracking-wider py-1">
                {`$${totalDollarValueStake->Misc.NumberFormat.formatEther}`->React.string}
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
                {`$${shortDollarValueStaked->Misc.NumberFormat.formatEther}`->React.string}
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
    </div>
  </Next.Link>
}
