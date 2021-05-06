let tokenPrice = (~totalLocked, ~tokenSupply) =>
  totalLocked->Ethers.BigNumber.mul(CONSTANTS.tenToThe18)->Ethers.BigNumber.div(tokenSupply)

let valueChange = (~totalLockedLong, ~totalLockedShort, ~percentageChange) => {
  if totalLockedShort->Ethers.BigNumber.gte(totalLockedLong) {
    totalLockedShort
    ->Ethers.BigNumber.mul(percentageChange)
    ->Ethers.BigNumber.div(CONSTANTS.tenToThe18)
  } else {
    totalLockedLong
    ->Ethers.BigNumber.mul(percentageChange)
    ->Ethers.BigNumber.div(CONSTANTS.tenToThe18)
  }
}

let simulateMarketPriceChange = (
  ~oldPrice,
  ~newPrice,
  ~totalLockedLong,
  ~totalLockedShort,
  ~tokenSupply,
  ~tokenIsLong,
) => {
  switch (oldPrice, newPrice) {
  | (a, b) if a->Ethers.BigNumber.eq(b) =>
    if tokenIsLong {
      tokenPrice(~totalLocked=totalLockedLong, ~tokenSupply)
    } else {
      tokenPrice(~totalLocked=totalLockedShort, ~tokenSupply)
    }
  | (oldPrice, newPrice) if oldPrice->Ethers.BigNumber.lt(newPrice) => {
      let percentageChange =
        newPrice
        ->Ethers.BigNumber.sub(oldPrice)
        ->Ethers.BigNumber.mul(CONSTANTS.tenToThe18)
        ->Ethers.BigNumber.div(oldPrice)

      if percentageChange->Ethers.BigNumber.gte(CONSTANTS.tenToThe18) {
        let totalLocked = totalLockedLong->Ethers.BigNumber.add(totalLockedShort)
        if tokenIsLong {
          tokenPrice(~totalLocked, ~tokenSupply)
        } else {
          CONSTANTS.zeroBN
        }
      } else {
        let changeInValue = valueChange(~percentageChange, ~totalLockedLong, ~totalLockedShort)
        if tokenIsLong {
          tokenPrice(
            ~totalLocked=totalLockedLong->Ethers.BigNumber.add(changeInValue),
            ~tokenSupply,
          )
        } else {
          tokenPrice(
            ~totalLocked=totalLockedShort->Ethers.BigNumber.sub(changeInValue),
            ~tokenSupply,
          )
        }
      }
    }
  | (oldPrice, newPrice) => {
      let percentageChange =
        oldPrice
        ->Ethers.BigNumber.sub(newPrice)
        ->Ethers.BigNumber.mul(CONSTANTS.tenToThe18)
        ->Ethers.BigNumber.div(oldPrice)
      if percentageChange->Ethers.BigNumber.gte(CONSTANTS.tenToThe18) {
        let totalLocked = totalLockedLong->Ethers.BigNumber.add(totalLockedShort)
        if tokenIsLong {
          CONSTANTS.zeroBN
        } else {
          tokenPrice(~totalLocked, ~tokenSupply)
        }
      } else {
        let changeInValue = valueChange(~percentageChange, ~totalLockedLong, ~totalLockedShort)
        if tokenIsLong {
          tokenPrice(
            ~totalLocked=totalLockedLong->Ethers.BigNumber.sub(changeInValue),
            ~tokenSupply,
          )
        } else {
          tokenPrice(
            ~totalLocked=totalLockedLong->Ethers.BigNumber.add(changeInValue),
            ~tokenSupply,
          )
        }
      }
    }
  }
}

// TO DO - INCLUDE YIELD (MAYBE), FEES, ETC.
