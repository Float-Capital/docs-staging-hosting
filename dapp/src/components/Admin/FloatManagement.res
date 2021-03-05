open Globals
open GqlConverters

module FloatBreakdown = %graphql(`
{
  syntheticMarkets {
    name
    symbol
    syntheticLong {
      floatMintedLong: floatMintedFromSpecificToken
      longAddress: tokenAddress
    }
    syntheticShort {
      floatMintedShort: floatMintedFromSpecificToken
      shortAddress: tokenAddress
    }
  }
}
`)
/*
0x374252d2c9f0075b7e2ca2a9868b44f1f62fba80
totalMintedFloat: BigInt!
floatTokenBalance: BigInt!
timestampJoined: BigInt!
totalGasUsed: BigInt!
numberOfTransactions: BigInt!
currentStakes: [CurrentStake!]
stateChangesAffectingUser: [StateChange!]
tokenBalances: [UserSyntheticTokenBalance!]
tokenMints: [UserSyntheticTokenMinted!]
*/

module UsersState = %graphql(`
query ($userId: String!){
  user(id: $userId) {
    totalMintedFloat
    floatTokenBalance
    tokenMints {
      tokensMinted
    }
  }
}`)

// module LatestFloatIssuance = %graphql(`
// query ($synthToken: String!) {
//   states (first:1, orderBy: stateIndex, orderDirection:desc, where: {syntheticToken: $synthToken, timeSinceLastUpdate_gt: 0}) {
//     stateIndex
//     accumulativeFloatPerSecond
//     floatRatePerSecondOverInterval
//   }
// }
// `)

module LastUserStakeUpdate = %graphql(`
query ($synthToken: String!, $userAddress: String!) {
  currentStakes (where: {userAddress: $userAddress, syntheticToken: $synthToken}) {
    lastMintState {
      timestamp
      accumulativeFloatPerSecond
    }
    currentStake {
      amount
    }
  }
  states (first:1, orderBy: stateIndex, orderDirection:desc, where: {syntheticToken: $synthToken, timeSinceLastUpdate_gt: 0}) {
    stateIndex
    accumulativeFloatPerSecond
    floatRatePerSecondOverInterval
  }
}
`)

module Claimable = {
  @react.component
  let make = (~userAddress, ~synthToken) => {
    let claimableQuery = LastUserStakeUpdate.use({
      userAddress: userAddress,
      synthToken: synthToken,
    })
    let currentTimestamp = Misc.Time.useCurrentTimeBN(~updateInterval=1000)

    Js.log((
      "params",
      {
        LastUserStakeUpdate.userAddress: userAddress,
        synthToken: synthToken,
      },
    ))

    /*
accumulativeFloatPerSecond,
floatRatePerSecondOverInterval,
​​
stateIndex
*/

    {
      switch claimableQuery {
      | {
          data: Some({
            states: [{accumulativeFloatPerSecond, floatRatePerSecondOverInterval, stateIndex}],
            currentStakes: [
              {
                lastMintState: {accumulativeFloatPerSecond: currentUserAccumulative, timestamp},
                currentStake: {amount},
              },
            ],
          }),
        } =>
        Js.log((
          "heey",
          accumulativeFloatPerSecond->FormatMoney.formatEther,
          currentUserAccumulative->FormatMoney.formatEther,
        ))
        // TODO: check - is the divide by 10^18 necessary. We should make a field in the graph where the value is already pre-divided by 10^18
        let amountOfFloatToClaim =
          Ethers.BigNumber.sub(accumulativeFloatPerSecond, currentUserAccumulative)
          ->Ethers.BigNumber.mul(amount)
          ->Ethers.BigNumber.div(CONSTANTS.tenToThe18)

        // NOTE: we are using the previous `floatRatePerSecondOverInterval` here as an approximation of the current value - it shouldn't change much
        let predictedAmountOfFloatToClaim =
          currentTimestamp->Ethers.BigNumber.mul(
            Ethers.BigNumber.mul(amount, floatRatePerSecondOverInterval)->Ethers.BigNumber.div(
              CONSTANTS.tenToThe18,
            ),
          )
        let totalAmountOfFloatToClaim = Ethers.BigNumber.add(
          amountOfFloatToClaim,
          predictedAmountOfFloatToClaim,
        )

        <>
          {`You have generated ${totalAmountOfFloatToClaim->FormatMoney.formatEther} FLOAT since your last mint`->React.string}
        </>
      | {error: Some(_)} => "Error loading users float data"->React.string
      | _ => "Loading stake due"->React.string
      }
    }
  }
}

@react.component
let make = () => {
  let user = RootProvider.useCurrentUserExn()
  let floatTokenAddress = Config.useFloatAddress()
  let userQuery = UsersState.use({userId: user->ethAdrToLowerStr})
  let floatBreakdown = FloatBreakdown.use()

  <div>
    {switch userQuery {
    | {data: Some({user: Some({totalMintedFloat, floatTokenBalance})})} => <>
        {`you have minted ${totalMintedFloat->FormatMoney.formatEther} FLOAT, and currently have a balance of ${floatTokenBalance->FormatMoney.formatEther}`->React.string}
        <AddToMetamask tokenAddress={floatTokenAddress->ethAdrToStr} tokenSymbol="FLOAT" />
      </>
    | {error: Some(_)} => "Error loading users float data"->React.string
    | _ => "Loading total minted by user"->React.string
    }}
    <hr />
    <hr />
    {switch floatBreakdown {
    | {data: Some({syntheticMarkets})} =>
      syntheticMarkets
      ->Array.map(({
        name,
        symbol,
        syntheticLong: {floatMintedLong, longAddress},
        syntheticShort: {floatMintedShort, shortAddress},
      }) =>
        <div>
          {`${name} (${symbol}) float minted:`->React.string}
          <br />
          {`-from LONG side: ${floatMintedLong->FormatMoney.formatEther}`->React.string}
          <br />
          {`-from SHORT side: ${floatMintedShort->FormatMoney.formatEther}`->React.string}
          <br />
          {Ethers.BigNumber.gt(floatMintedLong, CONSTANTS.zeroBN)
            ? <Claimable
                synthToken={longAddress->ethAdrToLowerStr} userAddress={user->ethAdrToLowerStr}
              />
            : React.null}
          <br />
          {Ethers.BigNumber.gt(floatMintedShort, CONSTANTS.zeroBN)
            ? <Claimable
                synthToken={shortAddress->ethAdrToLowerStr} userAddress={user->ethAdrToLowerStr}
              />
            : React.null}
          <hr />
        </div>
      )
      ->React.array
    | {error: Some(_)} => "Error"->React.string
    | _ => "Loading total minted by user"->React.string
    }}
  </div>
}
