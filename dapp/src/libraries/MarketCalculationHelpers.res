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

let xor = (a, b) => (!a && b) || (b && !a)

let calcPaymentTokenFloatPerSecondUnscaled = (
  ~tokenType,
  ~longVal,
  ~shortVal,
  ~equibOffset,
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

  if xor(tokenType == "long", longIsSideWithMoreValAfterOffset) {
    // token is for side with less val after offset
    CONSTANTS.tenToThe18->sub(rewardsForSideMoreValAfterOffset)
  } else {
    rewardsForSideMoreValAfterOffset
  }
}

let calculateFloatAPY = (
  longVal: Ethers.BigNumber.t,
  shortVal: Ethers.BigNumber.t,
  kperiod: Ethers.BigNumber.t,
  kmultiplier: Ethers.BigNumber.t,
  initialTimestamp: Ethers.BigNumber.t,
  currentTimestamp: Ethers.BigNumber.t,
  equilibriumOffset: Ethers.BigNumber.t,
  balanceIncentiveExponent: Ethers.BigNumber.t,
  floatTokenDollarWorth: Ethers.BigNumber.t,
  tokenType,
) => {
  open Ethers.BigNumber
  let k = kCalc(kperiod, kmultiplier, initialTimestamp, currentTimestamp)
  k
  ->mul(
    calcPaymentTokenFloatPerSecondUnscaled(
      ~tokenType,
      ~longVal,
      ~shortVal,
      ~equibOffset=equilibriumOffset,
      ~balanceIncentiveExponent,
    ),
  )
  ->mul(CONSTANTS.oneYearInSecondsMulTenToThe18) // one dai staked for a year at current price and fps
  ->div(CONSTANTS.tenToThe42) // divided by float issuance decimal
  ->mul(floatTokenDollarWorth) // gives this much float
  ->div(CONSTANTS.tenToThe18) // converted back to dai
}

let calculateLendingProviderAPYForSide = (collateralTokenApy, longVal, shortVal, tokenType) => {
  switch tokenType {
  // TODO: account for different gradients once contracts have
  //        the functionality to set gradients that aren't 1
  | "long" =>
    if longVal >= shortVal {
      0.0
    } else {
      collateralTokenApy *. (shortVal -. longVal) /. (shortVal +. longVal)
    }

  | "short" =>
    if shortVal >= longVal {
      0.0
    } else {
      collateralTokenApy *. (longVal -. shortVal) /. (shortVal +. longVal)
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
