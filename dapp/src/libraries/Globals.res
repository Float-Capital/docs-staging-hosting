let ethAdrToStr = Ethers.Utils.ethAdrToStr
let ethAdrToLowerStr = Ethers.Utils.ethAdrToLowerStr
let timestampToDuration = timestamp =>
  timestamp->Ethers.BigNumber.toNumberFloat->DateFns.fromUnixTime->DateFns.formatDistanceToNow
