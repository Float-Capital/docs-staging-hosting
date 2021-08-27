type marketInfo = {
  name: string,
  description: string,
  oracleHeartbeat: int,
  icon: string,
  oracleDecimals: int,
}

let marketsInfoData: array<marketInfo> = %raw(`require('./market-data.json')`)

let getMarketInfoUnsafe = index =>
  marketsInfoData[index - 1]->Option.getWithDefault({
    name: "",
    description: "",
    oracleHeartbeat: 300,
    icon: "/",
    oracleDecimals: 8,
  })

// NOTE: no validation happens on the marketsInfoData. IT IS NOT TYPE SAFE.
