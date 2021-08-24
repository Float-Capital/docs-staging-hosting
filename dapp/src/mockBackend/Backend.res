type marketInfo = {
  name: string,
  description: string,
  oracleHeartbeat: int,
  icon: string,
}

let marketsInfoData: array<marketInfo> = %raw(`require('./market-data.json')`)

let getMarketInfoUnsafe = index =>
  marketsInfoData[index - 1]->Option.getWithDefault({
    name: "",
    description: "",
    oracleHeartbeat: 300,
    icon: "/",
  })

// NOTE: no validation happens on the marketsInfoData. IT IS NOT TYPE SAFE.
