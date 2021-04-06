open Globals
open GqlConverters

%graphql(`
fragment LongSynth on SyntheticToken {
  floatMintedLong: floatMintedFromSpecificToken
  longAddress: tokenAddress
}
fragment ShortSynth on SyntheticToken {
   floatMintedShort: floatMintedFromSpecificToken
   shortAddress: tokenAddress
}
`)

module FloatBreakdown = %graphql(`
{
  syntheticMarkets {
    name
    symbol
    syntheticLong {
      ...LongSynth
    }
    syntheticShort {
      ...ShortSynth
    }
  }
}
`)

module LastUserStakeUpdate = %graphql(`
query ($synthToken: String!, $userAddress: String!) {
  currentStakes (where: {userAddress: $userAddress, syntheticToken: $synthToken}) {
    lastMintState {
      timestamp
      accumulativeFloatPerToken
    }
    currentStake {
      amount
    }
  }
  stakeStates (first:1, orderBy: stateIndex, orderDirection:desc, where: {syntheticToken: $synthToken, timeSinceLastUpdate_gt: 0}) {
    stateIndex
    accumulativeFloatPerToken
    floatRatePerTokenOverInterval
  }
}
`)

module Claimable = {
  @react.component
  let make = (~userAddress, ~synthToken) => {
    let floatDetails = DataHooks.useClaimableFloatForUser(~userId=userAddress, ~synthToken)

    switch floatDetails {
    | Response((claimableFloat, predictedFloat)) => {
        let totalFloat =
          Ethers.BigNumber.add(claimableFloat, predictedFloat)->FormatMoney.formatEther(~digits=6)

        <div> {`You have accrued ${totalFloat} FLOAT since your last mint!`->React.string} </div>
      }
    | GraphError(msg) => `Error: ${msg}`->React.string
    | Loading => `Loading float details...`->React.string
    }
  }
}

@react.component
let make = () => {
  let user = RootProvider.useCurrentUserExn()
  let floatTokenAddress = Config.useFloatAddress()
  let userQuery = Queries.UserQuery.use({userId: user->ethAdrToLowerStr})
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
          {<Claimable
            synthToken={longAddress->ethAdrToLowerStr} userAddress={user->ethAdrToLowerStr}
          />}
          {`-from SHORT side: ${floatMintedShort->FormatMoney.formatEther}`->React.string}
          <br />
          {<Claimable
            synthToken={shortAddress->ethAdrToLowerStr} userAddress={user->ethAdrToLowerStr}
          />}
          <hr />
        </div>
      )
      ->React.array
    | {error: Some(_)} => "Error"->React.string
    | _ => "Loading total minted by user"->React.string
    }}
  </div>
}
