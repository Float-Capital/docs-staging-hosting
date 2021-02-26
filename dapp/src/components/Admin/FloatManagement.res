open Globals
open GqlConverters

module FloatBreakdown = %graphql(`
{
  syntheticMarkets {
    name
    symbol
    syntheticLong {
      floatMintedFromSpecificToken
    }
    syntheticShort {
      floatMintedFromSpecificToken
    }
  }
}
`)

module LatestFloatIssuance = %graphql(`
query ($synthToken: String!) {
  states (first:1, orderBy: stateIndex, orderDirection:desc, where: {syntheticToken: $synthToken}) {
    stateIndex
    accumulativeFloatPerSecond
    floatRatePerSecondOverInterval
  }
}
`)

@react.component
let make = () => {
  let user = RootProvider.useCurrentUserExn()
  let floatTokenAddress = Config.useFloatAddress()
  let userQuery = Queries.UsersState.use({userId: user->ethAdrToLowerStr})
  let floatBreakdown = FloatBreakdown.use()

  Js.log(("Query", userQuery))
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
        syntheticLong: {floatMintedFromSpecificToken: mintedLong},
        syntheticShort: {floatMintedFromSpecificToken: mintedShort},
      }) =>
        <div>
          {`${name} (${symbol}) float minted:`->React.string}
          <br />
          {`-from LONG side: ${mintedLong->FormatMoney.formatEther}`->React.string}
          <br />
          {`-from SHORT side: ${mintedShort->FormatMoney.formatEther}`->React.string}
          <hr />
        </div>
      )
      ->React.array
    | {error: Some(_)} => "Error"->React.string
    | _ => "Loading total minted by user"->React.string
    }}
  </div>
}
