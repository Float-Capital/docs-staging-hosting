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

let calculateFloatAPY = (
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
    | 0.0 => CONSTANTS.zeroBN
    | _ => k->Ethers.BigNumber.mul(shortVal)->Ethers.BigNumber.div(total)
    }
  | "short" =>
    switch shortVal->Ethers.Utils.formatEther->Js.Float.fromString {
    | 0.0 => CONSTANTS.zeroBN
    | _ => k->Ethers.BigNumber.mul(longVal)->Ethers.BigNumber.div(total)
    }
  | _ => CONSTANTS.oneHundredEth
  }
}

let calculateLendingProviderAPYForSide = (apy, longVal, shortVal, tokenType) =>
  switch apy {
  | APYProvider.Loaded(collateralTokenApy) =>
    APYProvider.Loaded(
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
      },
    )
  | a => a
  }
