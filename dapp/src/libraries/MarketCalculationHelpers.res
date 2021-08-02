let calculateBeta = (
  ~totalValueLocked: Ethers.BigNumber.t,
  ~totalLockedLong,
  ~totalLockedShort,
  ~isLong,
) => {
  if (
    totalValueLocked->Ethers.BigNumber.eq(CONSTANTS.zeroBN) ||
    totalLockedLong->Ethers.BigNumber.eq(CONSTANTS.zeroBN) ||
    totalLockedShort->Ethers.BigNumber.eq(CONSTANTS.zeroBN)
  ) {
    "0"
  } else if totalLockedLong->Ethers.BigNumber.eq(totalLockedShort) {
    "100"
  } else if isLong && totalLockedShort->Ethers.BigNumber.lt(totalLockedLong) {
    Globals.percentStr(~n=totalLockedShort, ~outOf=totalLockedLong)
  } else if !isLong && totalLockedLong->Ethers.BigNumber.lt(totalLockedShort) {
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
  if currentTimestamp->Ethers.BigNumber.sub(initialTimestamp)->Ethers.BigNumber.lte(kperiod) {
    kmultiplier->Ethers.BigNumber.sub(
      kmultiplier
      ->Ethers.BigNumber.sub(CONSTANTS.tenToThe18)
      ->Ethers.BigNumber.mul(currentTimestamp->Ethers.BigNumber.sub(initialTimestamp))
      ->Ethers.BigNumber.div(kperiod),
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
  open Ethers.BigNumber

  let totalLocked = longVal->add(shortVal)
  let equibOffsetScaled = equibOffset->mul(totalLocked)->div(CONSTANTS.tenToThe18)

  let shortValAfterOffset = shortVal->sub(equibOffsetScaled)

  let longIsSideWithMoreValAfterOffset = shortValAfterOffset->lt(longVal)

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
  open Ethers.BigNumber
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
  open Ethers.BigNumber
  dollarFloatPerSecond
  ->mul(price)
  ->div(CONSTANTS.tenToThe18)
  ->mul(period)
  ->mul(amount)
  ->div(CONSTANTS.tenToThe42)
}

let calculateStakeAPYS = (
  ~syntheticMarkets: array<Queries.SyntheticMarketInfo.t>,
  ~global: Queries.GlobalStateInfo.t,
  ~apy: Ethers.BigNumber.t,
) => {
  open Ethers.BigNumber
  let totalTreasuryYield = ref(CONSTANTS.zeroBN)
  let totalFloatMintedAfterAYear = ref(global.totalFloatMinted)
  let tokenFloatMintedDict: HashMap.String.t<Ethers.BigNumber.t> = HashMap.String.make(~hintSize=10)
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

    let floatMarketShare =
      totalLockedLong
      ->sub(totalLockedShort)
      ->Ethers.BigNumber.abs // compiler error if not fully qualified
      ->mul(CONSTANTS.yieldGradientHardcode)
      ->div(totalValueLocked)
      ->min(CONSTANTS.tenToThe18)

    totalTreasuryYield :=
      totalTreasuryYield.contents->add(
        CONSTANTS.tenToThe18
        ->sub(floatMarketShare)
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

    tokenFloatMintedDict->HashMap.String.set(longId, longFloatOverYear)
    tokenFloatMintedDict->HashMap.String.set(shortId, shortFloatOverYear)
  })

  let floatAfterYearToAPYE18 = (floatAfterYear, totalStaked, price) => {
    floatAfterYear
    ->mul(CONSTANTS.tenToThe18)
    ->div(totalFloatMintedAfterAYear.contents)
    ->mul(totalTreasuryYield.contents)
    ->div(totalStaked->mul(price)->div(CONSTANTS.tenToThe18))
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
      tokenFloatMintedDict
      ->HashMap.String.get(longId)
      ->Option.getUnsafe
      ->floatAfterYearToAPYE18(totalStakedLong, longPrice)

    let shortApy =
      tokenFloatMintedDict
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
