let ethAdrToStr = Ethers.Utils.ethAdrToStr
let ethAdrToLowerStr = Ethers.Utils.ethAdrToLowerStr
let timestampToDuration = timestamp =>
  timestamp->Ethers.BigNumber.toNumberFloat->DateFns.fromUnixTime->DateFns.formatDistanceToNow
let percentStr = (~n: Ethers.BigNumber.t, ~outOf: Ethers.BigNumber.t) =>
  if outOf->Ethers.BigNumber.eq(CONSTANTS.zeroBN) {
    "0.00"
  } else {
    n
    ->Ethers.BigNumber.mul(CONSTANTS.oneHundredEth)
    ->Ethers.BigNumber.div(outOf)
    ->Ethers.Utils.formatEtherToPrecision(2)
  }
let amountForApproval = amount =>
  if amount->Ethers.BigNumber.gt(CONSTANTS.oneHundredThousandInWei) {
    amount
  } else {
    CONSTANTS.oneHundredThousandInWei
  }

@val external parseFloat: string => float = "parseFloat"
