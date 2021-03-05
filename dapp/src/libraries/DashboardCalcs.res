
type syntheticMarketsType =  array<
  Queries.MarketDetails.MarketDetails_inner.t_syntheticMarkets,
>


type totalValueLockedAndTotalStaked = {
    totalValueLocked: Ethers.BigNumber.t,
    totalValueStaked: Ethers.BigNumber.t
}


let zero = Ethers.BigNumber.fromInt(0) // get these in from the constants at some stage
let tenToThe18 = Ethers.BigNumber.fromUnsafe("1000000000000000000")

let tokenSupplyToTokenValue = (
    ~tokenPrice,
    ~tokenSupply) => 
        ~tokenSupply
            ->Ethers.BigNumber.mul(tokenPrice)
            ->Ethers.BigNumber.div(tenToThe18)


let getTotalSynthValue = (~totalValueLocked, ~totalValueStaked) => totalValueLocked->Ethers.BigNumber.sub(totalValueStaked)

let getTotalValueLockedAndTotalStaked = 
    (syntheticMarkets: syntheticMarketsType) => syntheticMarkets->Array.reduce(
        {
            totalValueLocked: zero,
            totalValueStaked: zero
        },
        (previous, {
            syntheticLong: {
                totalStaked: longStaked
            },
            syntheticShort: {
                totalStaked: shortStaked
            },
            latestSystemState: { 
                totalValueLocked,
                longTokenPrice,
                shortTokenPrice
            },
        }) => ({
            totalValueLocked: previous.totalValueLocked->Ethers.BigNumber.add(totalValueLocked),
            totalValueStaked: (
                previous.totalValueStaked
                    ->Ethers.BigNumber.add(
                        tokenSupplyToTokenValue(
                            ~tokenPrice=longTokenPrice, ~tokenSupply=longStaked)
                    )
                    ->Ethers.BigNumber.add(
                        tokenSupplyToTokenValue(
                            ~tokenPrice=shortTokenPrice, ~tokenSupply=shortStaked)
                    )
            )
        })
)

