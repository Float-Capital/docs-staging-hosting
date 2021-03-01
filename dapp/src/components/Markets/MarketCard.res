let zero = Ethers.BigNumber.fromUnsafe("0")
let oneHundred = Ethers.BigNumber.fromUnsafe("100000000000000000000") // 10 ^ 20
let percentStr = (
    ~n: Ethers.BigNumber.t,
    ~outOf: Ethers.BigNumber.t,
) => if(outOf->Ethers.BigNumber.eq(zero)){
        "0.00"
    }else{
        n->Ethers.BigNumber.mul(oneHundred)
         ->Ethers.BigNumber.div(outOf)
         ->Ethers.Utils.formatEtherToPrecision(2)
    }

let calculateBeta = (
                     ~totalValueLocked: Ethers.BigNumber.t, 
                     ~totalLockedLong,
                     ~totalLockedShort,
                     ~isLong
                     ) => {
                        if(totalValueLocked -> Ethers.BigNumber.eq(zero)
                           || totalLockedLong -> Ethers.BigNumber.eq(zero)
                           || totalLockedShort->Ethers.BigNumber.eq(zero)){
                            "0"
                        }
                        else if(totalLockedLong -> Ethers.BigNumber.eq(totalLockedShort)){
                            "100"
                        }else if(isLong && totalLockedShort -> Ethers.BigNumber.lt(totalLockedLong)){
                            percentStr(~n=totalLockedShort, ~outOf=totalLockedLong)
                        }else if(!isLong && totalLockedLong -> Ethers.BigNumber.lt(totalLockedShort)){
                            percentStr(~n=totalLockedLong, ~outOf=totalLockedShort)
                        }else{
                            "100"
                        }
                     }

@react.component
let make = (
    ~marketName,
    ~totalLockedLong,
    ~totalLockedShort,
    ~totalValueLocked,
    ~marketIndex,
    ~router
    ) => {  

    let percentStrLong = percentStr(
                ~n=totalLockedLong, 
                ~outOf=totalValueLocked)
    let percentStrShort = (100.0 -. percentStrLong->Float.fromString->Option.getExn)
                        ->Js.Float.toFixedWithPrecision(~digits=2)


    let longBeta = calculateBeta(
        ~totalLockedLong,
        ~totalLockedShort,
        ~totalValueLocked, 
        ~isLong=true);

    let shortBeta = calculateBeta(
        ~totalLockedLong,
        ~totalLockedShort,
        ~totalValueLocked,
        ~isLong=false)
    <div className="p-1 mb-8 rounded-lg flex flex-col bg-white bg-opacity-75 my-5 shadow-lg">
        <div className="flex justify-center w-full my-1">
        <h1 className="font-bold text-xl font-alphbeta">
            {marketName->React.string}
            <Tooltip tip=`This market tracks ${marketName}`/>
        </h1>
        </div>

        <div className="flex justify-center w-full">
            <MarketCardSide 
                marketName={marketName}
                isLong={true}
                value={totalLockedLong}
                beta={~longBeta}
            />

            <div className="w-1/2 flex items-center flex-col">
            <h2 className="text-xs mt-1">          
            <span className="font-bold">{"TOTAL"->React.string}
            </span>{" Liquidity"->React.string}
            </h2>
            <div className="text-3xl font-alphbeta tracking-wider py-1">
                {`$${totalValueLocked->FormatMoney.formatEther}`->React.string}
            </div>

            {
                switch(
                    !(totalValueLocked->Ethers.BigNumber.eq(zero)) ){
                    | true => <MarketBar percentStrLong={percentStrLong} percentStrShort={percentStrShort}/>
                    | false => React.null
                    }
            }

            <div className="w-full flex justify-around">
            <Button
                onClick={_ => {
                  router->Next.Router.push(
                    `/mint?marketIndex=${marketIndex->Ethers.BigNumber.toString}&mintOption=long`,
                  )
                }}
                variant="small">
                "Mint Long"
            </Button>

            <Button
                onClick={_ => {
                  router->Next.Router.push(
                    `/mint?marketIndex=${marketIndex->Ethers.BigNumber.toString}&mintOption=short`,
                  )
                }}
                variant="small">
                "Mint Short"
            </Button>
            </div>
            </div>

            <MarketCardSide 
                marketName={marketName} 
                isLong={false}
                value={totalLockedShort} 
                beta={~shortBeta}
            />

        </div>
    </div>
}