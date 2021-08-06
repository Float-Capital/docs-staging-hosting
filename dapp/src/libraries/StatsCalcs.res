type syntheticMarketsType = array<Queries.SyntheticMarketInfo.t>

type totalValueLockedAndTotalStaked = {
  totalValueLocked: Ethers.BigNumber.t,
  totalValueStaked: Ethers.BigNumber.t,
}

type stakeApyType = {
  marketName: string,
  isLong: bool,
  apy: float,
  floatApy: float,
  stakeApy: float,
}

let trendingStakes = (~syntheticMarkets: array<Queries.SyntheticMarketInfo.t>, ~apy, ~global, ~bnApy) => {
  let stakeApys = MarketCalculationHelpers.calculateStakeAPYS(~syntheticMarkets, ~global, ~apy=bnApy)
  syntheticMarkets
  ->Array.reduce([], (
    previous,
    {
      name: marketName,
      timestampCreated,
      latestSystemState: {timestamp: currentTimestamp, totalLockedLong, totalLockedShort},
      syntheticLong: {id: longId},
      syntheticShort: {id: shortId}
    },
  ) => {
    let longApy = MarketCalculationHelpers.calculateLendingProviderAPYForSide(
      apy,
      totalLockedLong->Ethers.Utils.formatEther->Js.Float.fromString,
      totalLockedShort->Ethers.Utils.formatEther->Js.Float.fromString,
      "long",
    )
    let shortApy = MarketCalculationHelpers.calculateLendingProviderAPYForSide(
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

    previous->Array.concat([
      {
        marketName: marketName,
        isLong: true,
        apy: longApy,
        floatApy: longFloatApy->Ethers.Utils.formatEther->Js.Float.fromString,
        stakeApy: stakeApys->HashMap.String.get(longId)->Option.getExn
      },
      {
        marketName: marketName,
        isLong: false,
        apy: shortApy,
        floatApy: shortFloatApy->Ethers.Utils.formatEther->Js.Float.fromString,
        stakeApy: stakeApys->HashMap.String.get(shortId)->Option.getExn
      },
    ])
  })
  ->SortArray.stableSortBy((token1, token2) => 
    switch (token1.apy +. token1.floatApy +. token1.stakeApy, token2.apy +. token2.floatApy +. token2.stakeApy) {
    | (a, b) if a < b => 1
    | (a, b) if b > a => -1
    | _ => 0
    }
  )
  ->Array.slice(~offset=0, ~len=3)
}

let tokenSupplyToTokenValue = (~tokenPrice, ~tokenSupply) =>
  tokenSupply->Ethers.BigNumber.mul(tokenPrice)->Ethers.BigNumber.div(CONSTANTS.tenToThe18)

let getTotalSynthValue = (~totalValueLocked, ~totalValueStaked) =>
  totalValueLocked->Ethers.BigNumber.sub(totalValueStaked)

let getTotalValueLockedAndTotalStaked = (syntheticMarkets: syntheticMarketsType) =>
  syntheticMarkets->Array.reduce(
    {
      totalValueLocked: CONSTANTS.zeroBN,
      totalValueStaked: CONSTANTS.zeroBN,
    },
    (
      previous,
      {
        syntheticLong: {totalStaked: longStaked},
        syntheticShort: {totalStaked: shortStaked},
        latestSystemState: {
          totalValueLocked,
          longTokenPrice: {price: {price: longTokenPrice}},
          shortTokenPrice: {price: {price: shortTokenPrice}},
        },
      },
    ) => {
      totalValueLocked: previous.totalValueLocked->Ethers.BigNumber.add(totalValueLocked),
      totalValueStaked: previous.totalValueStaked
      ->Ethers.BigNumber.add(
        tokenSupplyToTokenValue(~tokenPrice=longTokenPrice, ~tokenSupply=longStaked),
      )
      ->Ethers.BigNumber.add(
        tokenSupplyToTokenValue(~tokenPrice=shortTokenPrice, ~tokenSupply=shortStaked),
      ),
    },
  )
