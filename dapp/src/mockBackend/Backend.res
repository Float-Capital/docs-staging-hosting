type marketInfo = {
  name: string,
  description: string,
}

let marketsInfoData: array<marketInfo> = %raw(`require('./market-data.json')`)

let getMarketInfoUnsafe = index =>
  marketsInfoData[index - 1]->Option.getWithDefault({name: "", description: ""})

// NOTE: no validation happens on the marketsInfoData. IT IS NOT TYPE SAFE.
