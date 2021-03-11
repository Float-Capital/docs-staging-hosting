open Globals

// Big numbers
let zero = Ethers.BigNumber.fromUnsafe("0")
let oneHundred = Ethers.BigNumber.fromUnsafe("100000000000000000000") // 10 ^ 20
let oneInWei = Ethers.BigNumber.fromUnsafe("1000000000000000000") // 10 ^ 18

// Helper calculation functions
let percentStr = (~n: Ethers.BigNumber.t, ~outOf: Ethers.BigNumber.t) =>
  if outOf->Ethers.BigNumber.eq(zero) {
    "0.00"
  } else {
    n
    ->Ethers.BigNumber.mul(oneHundred)
    ->Ethers.BigNumber.div(outOf)
    ->Ethers.Utils.formatEtherToPrecision(2)
  }

let calculateDollarValue = (~tokenPrice: Ethers.BigNumber.t, ~amountStaked: Ethers.BigNumber.t) => {
  tokenPrice->Ethers.BigNumber.mul(amountStaked)->Ethers.BigNumber.div(oneInWei)
}

let basicApyCalc = (busdApy: float, longVal: float, shortVal: float, tokenType) => {
  switch tokenType {
  | "long" =>
    switch longVal {
    | 0.0 => busdApy
    | _ => busdApy *. shortVal /. longVal
    }
  | "short" =>
    switch shortVal {
    | 0.0 => busdApy
    | _ => busdApy *. longVal /. shortVal
    }
  | _ => busdApy
  }
}

// TODO: emit and pull these from graph. "kperiod, kInitialMultiplier."
// For now going to hardcode them.
let kperiodHardcode = Ethers.BigNumber.fromUnsafe("1664000") // ~20 days
let kmultiplierHardcode = Ethers.BigNumber.fromUnsafe("5000000000000000000")

let kCalc = (
  kperiod: Ethers.BigNumber.t,
  kmultiplier: Ethers.BigNumber.t,
  initialTimestamp: Ethers.BigNumber.t,
  currentTimestamp: Ethers.BigNumber.t,
) => {
  if currentTimestamp->Ethers.BigNumber.sub(initialTimestamp)->Ethers.BigNumber.lte(kperiod) {
    kmultiplier->Ethers.BigNumber.sub(
      kmultiplier
      ->Ethers.BigNumber.sub(oneInWei)
      ->Ethers.BigNumber.mul(currentTimestamp->Ethers.BigNumber.sub(initialTimestamp))
      ->Ethers.BigNumber.div(kperiod),
    )
  } else {
    oneInWei
  }
}

let myfloatCalc = (
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
    | 0.0 => zero
    | _ => k->Ethers.BigNumber.mul(shortVal)->Ethers.BigNumber.div(total)
    }
  | "short" =>
    switch shortVal->Ethers.Utils.formatEther->Js.Float.fromString {
    | 0.0 => zero
    | _ => k->Ethers.BigNumber.mul(longVal)->Ethers.BigNumber.div(total)
    }
  | _ => oneHundred
  }
}

@react.component
let make = (
  ~syntheticMarket as {
    name: marketName,
    timestampCreated,
    latestSystemState: {
      timestamp: currentTimestamp,
      totalLockedLong,
      totalLockedShort,
      longTokenPrice,
      shortTokenPrice,
    },
    syntheticShort: {totalStaked: shortTotalStaked, tokenAddress: shortTokenAddress},
    syntheticLong: {totalStaked: longTotalStaked, tokenAddress: longTokenAddress},
  }: Queries.SyntheticMarketInfo.t,
) => {
  let router = Next.Router.useRouter()

  let longDollarValueStaked = calculateDollarValue(
    ~tokenPrice=longTokenPrice,
    ~amountStaked=longTotalStaked,
  )
  let shortDollarValueStaked = calculateDollarValue(
    ~tokenPrice=shortTokenPrice,
    ~amountStaked=shortTotalStaked,
  )
  let totalDollarValueStake = longDollarValueStaked->Ethers.BigNumber.add(shortDollarValueStaked)

  let percentStrLong = percentStr(~n=longDollarValueStaked, ~outOf=totalDollarValueStake)
  let percentStrShort =
    (100.0 -. percentStrLong->Float.fromString->Option.getExn)
      ->Js.Float.toFixedWithPrecision(~digits=2)

  // TODO: pull in APY from venus api
  let longApy = basicApyCalc(
    0.12,
    totalLockedLong->Ethers.Utils.formatEther->Js.Float.fromString,
    totalLockedShort->Ethers.Utils.formatEther->Js.Float.fromString,
    "long",
  )
  let shortApy = basicApyCalc(
    0.12,
    totalLockedLong->Ethers.Utils.formatEther->Js.Float.fromString,
    totalLockedShort->Ethers.Utils.formatEther->Js.Float.fromString,
    "short",
  )
  let longFloatApy = myfloatCalc(
    totalLockedLong,
    totalLockedShort,
    kperiodHardcode,
    kmultiplierHardcode,
    timestampCreated,
    currentTimestamp,
    "long",
  )

  let shortFloatApy = myfloatCalc(
    totalLockedLong,
    totalLockedShort,
    kperiodHardcode,
    kmultiplierHardcode,
    timestampCreated,
    currentTimestamp,
    "short",
  )

  <div className="p-1 mb-8 rounded-lg flex flex-col bg-white bg-opacity-75 my-5 shadow-lg">
    <div className="flex justify-center w-full my-1">
      <h1 className="font-bold text-xl font-alphbeta">
        {marketName->React.string} <Tooltip tip={`This market tracks ${marketName}`} />
      </h1>
    </div>
    <div className="flex justify-center w-full">
      <StakeCardSide
        marketName={marketName}
        isLong={true}
        apy={longApy}
        floatApy={longFloatApy->Ethers.Utils.formatEther->Js.Float.fromString}
      />
      <div className="w-1/2 flex items-center flex-col">
        <h2 className="text-xs mt-1">
          <span className="font-bold"> {`📈 TOTAL`->React.string} </span>
          {" Staked"->React.string}
        </h2>
        <div className="text-3xl font-alphbeta tracking-wider py-1">
          {`$${totalDollarValueStake->FormatMoney.formatEther}`->React.string}
        </div>
        {switch !(totalDollarValueStake->Ethers.BigNumber.eq(zero)) {
        | true => <StakeBar percentStrLong={percentStrLong} percentStrShort={percentStrShort} />
        | false => React.null
        }}
        <div className="w-full flex justify-around">
          <Button
            onClick={_ => {
              router->Next.Router.push(`/stake?tokenAddress=${longTokenAddress->ethAdrToLowerStr}`)
            }}
            variant="small">
            "Stake Long"
          </Button>
          <Button
            onClick={_ => {
              router->Next.Router.push(`/stake?tokenAddress=${shortTokenAddress->ethAdrToLowerStr}`)
            }}
            variant="small">
            "Stake Short"
          </Button>
        </div>
      </div>
      <StakeCardSide
        marketName={marketName}
        isLong={false}
        apy={shortApy}
        floatApy={shortFloatApy->Ethers.Utils.formatEther->Js.Float.fromString}
      />
    </div>
  </div>
}
