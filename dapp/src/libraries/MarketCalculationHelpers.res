let {min: minBn, div, mul, sub, add, fromInt, eq, lt, lte, pow, abs} = module(Ethers.BigNumber)

let calculateBeta = (
  ~totalValueLocked: Ethers.BigNumber.t,
  ~totalLockedLong,
  ~totalLockedShort,
  ~isLong,
) => {
  // TODO: NOT HARDCODE THE BETA AS WITH A LEVERAGE OF 3
  if (
    totalValueLocked->eq(CONSTANTS.zeroBN) ||
    totalLockedLong->eq(CONSTANTS.zeroBN) ||
    totalLockedShort->eq(CONSTANTS.zeroBN)
  ) {
    "0"
  } else if totalLockedLong->eq(totalLockedShort) {
    "100"
  } else if isLong && totalLockedShort->lt(totalLockedLong) {
    Globals.percentStr(~n=totalLockedShort, ~outOf=totalLockedLong)
  } else if !isLong && totalLockedLong->lt(totalLockedShort) {
    Globals.percentStr(~n=totalLockedLong, ~outOf=totalLockedShort)
  } else {
    "100"
  }
}

let kCalc = (
  kperiod: Ethers.BigNumber.t,
  kmultiplier: Ethers.BigNumber.t,
  initialTimestamp: Ethers.BigNumber.t,
  currentTimestamp: Ethers.BigNumber.t,
) => {
  if currentTimestamp->sub(initialTimestamp)->lte(kperiod) {
    kmultiplier->sub(
      kmultiplier
      ->sub(CONSTANTS.tenToThe18)
      ->mul(currentTimestamp->sub(initialTimestamp))
      ->div(kperiod),
    )
  } else {
    CONSTANTS.tenToThe18
  }
}

let xoredAssignment = (condition, a, b) => {
  let first = condition ? a : b
  let second = condition ? b : a
  (first, second)
}

let calcLongAndShortDollarFloatPerSecondUnscaled = (
  ~longVal,
  ~shortVal,
  ~equibOffset,
  ~initialTimestamp,
  ~currentTimestamp,
  ~kperiod,
  ~kmultiplier,
  ~balanceIncentiveExponent,
) => {
  let totalLocked = longVal->add(shortVal)
  let equibOffsetScaled =
    equibOffset->mul(totalLocked)->div(CONSTANTS.tenToThe18)->div(CONSTANTS.twoBN)

  let shortValAfterOffset = shortVal->sub(equibOffsetScaled)

  let longIsSideWithMoreValAfterOffset = shortValAfterOffset->sub(equibOffsetScaled)->lt(longVal)

  let sideWithLessValAfterEquibOffset = longIsSideWithMoreValAfterOffset
    ? shortValAfterOffset
    : longVal->add(equibOffsetScaled)

  let rewardsForSideMoreValAfterOffset = if sideWithLessValAfterEquibOffset->lte(CONSTANTS.zeroBN) {
    CONSTANTS.zeroBN
  } else {
    let numerator =
      sideWithLessValAfterEquibOffset
      ->div(CONSTANTS.stakeDivisorForSafeExponentiationDiv2)
      ->pow(balanceIncentiveExponent)

    let denominator =
      totalLocked->div(CONSTANTS.stakeDivisorForSafeExponentiation)->pow(balanceIncentiveExponent)

    numerator->mul(CONSTANTS.tenToThe18Div2)->div(denominator)
  }

  let rewardsForSideWithLessValAfterOffset =
    CONSTANTS.tenToThe18->sub(rewardsForSideMoreValAfterOffset)

  let k = kCalc(kperiod, kmultiplier, initialTimestamp, currentTimestamp)
  xoredAssignment(
    longIsSideWithMoreValAfterOffset,
    k->mul(rewardsForSideMoreValAfterOffset),
    k->mul(rewardsForSideWithLessValAfterOffset),
  )
}

let calculateFloatAPY = (
  longVal,
  shortVal,
  kperiod,
  kmultiplier,
  initialTimestamp,
  currentTimestamp,
  equibOffset,
  balanceIncentiveExponent,
  tokenType,
) => {
  let (longApy, shortApy) = calcLongAndShortDollarFloatPerSecondUnscaled(
    ~longVal,
    ~shortVal,
    ~equibOffset,
    ~initialTimestamp,
    ~currentTimestamp,
    ~kperiod,
    ~kmultiplier,
    ~balanceIncentiveExponent,
  )

  if tokenType == "long" {
    longApy->mul(CONSTANTS.twoBN)->div(CONSTANTS.tenToThe18)
  } else {
    shortApy->mul(CONSTANTS.twoBN)->div(CONSTANTS.tenToThe18)
  }
}

let calculateFloatMintedOverPeriod = (~dollarFloatPerSecond, ~amount, ~period, ~price) => {
  dollarFloatPerSecond
  ->mul(price)
  ->div(CONSTANTS.tenToThe18)
  ->mul(period)
  ->mul(amount)
  ->div(CONSTANTS.threeE44)
}

let calculateStakeAPYS = (
  ~syntheticMarkets: array<Queries.SyntheticMarketInfo.t>,
  ~global: Queries.GlobalStateInfo.t,
  ~apy: Ethers.BigNumber.t,
) => {
  /*
    Formula for APY:
      stake APY = totalYieldForTreasuryAfterAYear 
                  * percentOfTotalFloatMintedByStakingInThatSideAfterAYear
                  / totalStakedForSideInDollars

      = totalYieldForTreasuryAfterAYear * 
        (totalFloatMintedForMarketSideDuringAYear / totalFloatMintedAllTimeAfterAYear) 
        / totalStakedInThatMarket

      Basically assuming that 
        a) all yield from treasury goes to FLT token holders, and goes to them equally 
           depending on how much FLT they have.
        b) treating the yield like a dividend yield (if we just sent the cash 
           to token holders).

      b) is obviously strictly incorrect as we're using buybacks not dividends.
    
      but it kinda makes sense to me that in perfect markets they'd be sort of the same
 */

  let totalTreasuryYieldAfterYear = ref(CONSTANTS.zeroBN)
  let totalFloatMintedAfterAYear = ref(global.totalFloatMinted)
  let tokenFloatMintedAfterAYearDict: HashMap.String.t<Ethers.BigNumber.t> = HashMap.String.make(
    ~hintSize=10,
  )
  let tokenAPYDict: HashMap.String.t<float> = HashMap.String.make(~hintSize=10)

  syntheticMarkets->Array.forEach(market => {
    let {
      timestampCreated: initialTimestamp,
      latestSystemState: {
        timestamp: currentTimestamp,
        totalValueLocked,
        totalLockedLong,
        totalLockedShort,
      },
      syntheticLong: {
        id: longId,
        latestPrice: {price: {price: longPrice}},
        totalStaked: totalStakedLong,
      },
      syntheticShort: {
        id: shortId,
        latestPrice: {price: {price: shortPrice}},
        totalStaked: totalStakedShort,
      },
    } = market

    let marketsShareOfYield =
      totalLockedLong
      ->sub(totalLockedShort)
      ->abs // compiler error if not fully qualified
      ->mul(CONSTANTS.yieldGradientHardcode)
      ->div(totalValueLocked)
      ->minBn(CONSTANTS.tenToThe18)

    totalTreasuryYieldAfterYear :=
      totalTreasuryYieldAfterYear.contents->add(
        CONSTANTS.tenToThe18
        ->sub(marketsShareOfYield)
        ->mul(apy)
        ->mul(totalValueLocked)
        ->div(CONSTANTS.tenToThe18)
        ->div(CONSTANTS.tenToThe18),
      )

    let (longFPS, shortFPS) = calcLongAndShortDollarFloatPerSecondUnscaled(
      ~currentTimestamp,
      ~initialTimestamp,
      ~longVal=totalLockedLong,
      ~shortVal=totalLockedShort,
      ~equibOffset=CONSTANTS.equilibriumOffsetHardcode,
      ~kperiod=CONSTANTS.kperiodHardcode,
      ~kmultiplier=CONSTANTS.kmultiplierHardcode,
      ~balanceIncentiveExponent=CONSTANTS.balanceIncentiveExponentHardcode,
    )

    let longFloatOverYear = calculateFloatMintedOverPeriod(
      ~dollarFloatPerSecond=longFPS,
      ~period=CONSTANTS.oneYearInSeconds->fromInt,
      ~amount=totalStakedLong,
      ~price=longPrice,
    )

    let shortFloatOverYear = calculateFloatMintedOverPeriod(
      ~dollarFloatPerSecond=shortFPS,
      ~period=CONSTANTS.oneYearInSeconds->fromInt,
      ~amount=totalStakedShort,
      ~price=shortPrice,
    )

    totalFloatMintedAfterAYear :=
      totalFloatMintedAfterAYear.contents->add(shortFloatOverYear)->add(longFloatOverYear)

    tokenFloatMintedAfterAYearDict->HashMap.String.set(longId, longFloatOverYear)
    tokenFloatMintedAfterAYearDict->HashMap.String.set(shortId, shortFloatOverYear)
  })

  // Account for Float percent minted for investors
  totalFloatMintedAfterAYear :=
    totalFloatMintedAfterAYear.contents
    ->mul(CONSTANTS.tenToThe18->add(CONSTANTS.floatCapitalPercentE18HardCode))
    ->div(CONSTANTS.tenToThe18)

  let floatAfterYearToAPYE18 = (floatAfterYear, totalStaked, price) => {
    if totalStaked->eq(CONSTANTS.zeroBN) {
      // escape hatch, ill defined.
      CONSTANTS.zeroBN
    } else {
      floatAfterYear
      ->mul(CONSTANTS.tenToThe18)
      ->div(totalFloatMintedAfterAYear.contents)
      ->mul(totalTreasuryYieldAfterYear.contents)
      ->div(totalStaked->mul(price)->div(CONSTANTS.tenToThe18))
    }
  }

  syntheticMarkets->Array.forEach(market => {
    let {
      syntheticLong: {
        id: longId,
        latestPrice: {price: {price: longPrice}},
        totalStaked: totalStakedLong,
      },
      syntheticShort: {
        id: shortId,
        latestPrice: {price: {price: shortPrice}},
        totalStaked: totalStakedShort,
      },
    } = market

    let longApy =
      tokenFloatMintedAfterAYearDict
      ->HashMap.String.get(longId)
      ->Option.getUnsafe
      ->floatAfterYearToAPYE18(totalStakedLong, longPrice)

    let shortApy =
      tokenFloatMintedAfterAYearDict
      ->HashMap.String.get(shortId)
      ->Option.getUnsafe
      ->floatAfterYearToAPYE18(totalStakedShort, shortPrice)

    tokenAPYDict->HashMap.String.set(longId, longApy->Ethers.Utils.formatEther->Js.Float.fromString)
    tokenAPYDict->HashMap.String.set(
      shortId,
      shortApy->Ethers.Utils.formatEther->Js.Float.fromString,
    )
  })
  tokenAPYDict
}

let calculateLendingProviderAPYForSide = (collateralTokenApy, longVal, shortVal, tokenType) => {
  switch tokenType {
  // TODO: account for different gradients once contracts have
  //        the functionality to set gradients that aren't 1
  | "long" =>
    if longVal >= shortVal {
      0.0
    } else {
      // apy = lending apy * marketApy * totalLocked / long
      //      = lendingApy * ((short - long) / totalLocked) * totalLocked / long
      //      = lendingApy * (short - long) / long
      collateralTokenApy *. (shortVal -. longVal) /. longVal
    }

  | "short" =>
    if shortVal >= longVal {
      0.0
    } else {
      collateralTokenApy *. (longVal -. shortVal) /. shortVal
    }
  | _ => collateralTokenApy
  }
}

let calculateLendingProviderAPYForSideMapped = (apy, longVal, shortVal, tokenType) =>
  switch apy {
  | APYProvider.Loaded(collateralTokenApy) =>
    APYProvider.Loaded(
      calculateLendingProviderAPYForSide(collateralTokenApy, longVal, shortVal, tokenType),
    )
  | a => a
  }

let mapStakeApy = (apyDict, key) => {
  switch apyDict {
  | APYProvider.Loaded(a) => APYProvider.Loaded(a->HashMap.String.get(key)->Option.getExn)
  | Loading => Loading
  | Error(e) => Error(e)
  }
}
