let {mapStakeApy} = module(MarketCalculationHelpers)

@react.component
let make = (
  ~syntheticMarket as {
    marketIndex,
    name: marketName,
    timestampCreated,
    latestSystemState: {
      timestamp: currentTimestamp,
      totalValueLocked,
      totalLockedLong,
      totalLockedShort,
    },
    syntheticLong: {id: longId},
    syntheticShort: {id: shortId},
  }: Queries.SyntheticMarketInfo.t,
) => {
  let longBeta = MarketCalculationHelpers.calculateBeta(
    ~totalLockedLong,
    ~totalLockedShort,
    ~totalValueLocked,
    ~isLong=true,
  )

  let shortBeta = MarketCalculationHelpers.calculateBeta(
    ~totalLockedLong,
    ~totalLockedShort,
    ~totalValueLocked,
    ~isLong=false,
  )

  let apy = APYProvider.useAPY()

  let longApy = MarketCalculationHelpers.calculateLendingProviderAPYForSideMapped(
    apy,
    totalLockedLong->Ethers.Utils.formatEther->Js.Float.fromString,
    totalLockedShort->Ethers.Utils.formatEther->Js.Float.fromString,
    "long",
  )
  let shortApy = MarketCalculationHelpers.calculateLendingProviderAPYForSideMapped(
    apy,
    totalLockedLong->Ethers.Utils.formatEther->Js.Float.fromString,
    totalLockedShort->Ethers.Utils.formatEther->Js.Float.fromString,
    "short",
  )

  let stakeApys = DataHooks.useStakingAPYs()

  let longFloatApy = MarketCalculationHelpers.calculateFloatAPY(
    totalLockedLong,
    totalLockedShort,
    CONSTANTS.kperiodHardcode,
    CONSTANTS.kmultiplierHardcode,
    timestampCreated,
    currentTimestamp,
    CONSTANTS.equilibriumOffsetHardcode,
    CONSTANTS.balanceIncentiveExponentHardcode,
    "long",
  )

  let shortFloatApy = MarketCalculationHelpers.calculateFloatAPY(
    totalLockedLong,
    totalLockedShort,
    CONSTANTS.kperiodHardcode,
    CONSTANTS.kmultiplierHardcode,
    timestampCreated,
    currentTimestamp,
    CONSTANTS.equilibriumOffsetHardcode,
    CONSTANTS.balanceIncentiveExponentHardcode,
    "short",
  )

  let marketInfo = marketIndex->Ethers.BigNumber.toNumber->Backend.getMarketInfoUnsafe

  <div
    className="p-4 rounded-lg flex flex-col justify-center bg-white bg-opacity-75 shadow-lg h-full">
    <div className="flex flex-wrap justify-center w-full">
      <MarketStakeCardSide
        orderPostionMobile={2}
        orderPostion={1}
        marketName={marketName}
        isLong={true}
        apy={longApy}
        stakeApy={stakeApys->mapStakeApy(longId)}
        floatApy={longFloatApy->Ethers.Utils.formatEther->Js.Float.fromString}
        beta={longBeta}
      />
      <div className="w-full md:w-1/2 flex items-center justify-center flex-col order-1 md:order-2">
        <div className="flex justify-center w-full mb-2">
          <h1 className="font-bold text-xl font-alphbeta"> {marketInfo.name->React.string} </h1>
        </div>
        <div className="flex flex-row items-center justify-center w-full mb-4">
          <div>
            <div>
              <h2 className="text-xs mt-1 text-center">
                <span className="font-bold pr-1"> {`TOTAL`->React.string} </span>
                {"Liquidity"->React.string}
              </h2>
            </div>
            <div className="text-2xl font-alphbeta tracking-wider ">
              {`$${totalValueLocked->Misc.NumberFormat.formatEther}`->React.string}
            </div>
          </div>
        </div>
        <div className={`w-full`}>
          {switch !(totalValueLocked->Ethers.BigNumber.eq(CONSTANTS.zeroBN)) {
          | true => <MarketBar totalLockedLong totalValueLocked />
          | false => React.null
          }}
        </div>
        <div className="flex flex-row items-center justify-between w-full">
          <div>
            <div>
              <h2 className="text-xs mt-1">
                <span className="font-bold mr-1"> {`📈 Long`->React.string} </span>
                {"Liquidity"->React.string}
              </h2>
            </div>
            <div className="text-md font-alphbeta tracking-wider py-1 text-gray-600">
              {`$${totalLockedLong->Misc.NumberFormat.formatEther}`->React.string}
            </div>
          </div>
          <div className="text-right">
            <div>
              <h2 className="text-xs mt-1">
                <span className="font-bold mr-1"> {`Short`->React.string} </span>
                {`Liquidity 📉`->React.string}
              </h2>
            </div>
            <div className="text-md font-alphbeta tracking-wider py-1 text-gray-600">
              {`$${totalLockedShort->Misc.NumberFormat.formatEther}`->React.string}
            </div>
          </div>
        </div>
      </div>
      <MarketStakeCardSide
        orderPostionMobile={3}
        orderPostion={3}
        marketName={marketName}
        isLong={false}
        apy={shortApy}
        stakeApy={stakeApys->mapStakeApy(shortId)}
        floatApy={shortFloatApy->Ethers.Utils.formatEther->Js.Float.fromString}
        beta={shortBeta}
      />
    </div>
  </div>
}
