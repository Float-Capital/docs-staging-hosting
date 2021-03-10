open GqlConverters

%graphql(`
fragment BasicUserInfo on User {
  id
  totalMintedFloat
  floatTokenBalance
  numberOfTransactions
  totalGasUsed
}
fragment SyntheticInfo on SyntheticToken {
  id
  totalStaked
  syntheticMarket {
    id
    name
    symbol
    latestSystemState {
      totalLockedLong
      totalLockedShort
    }
  }
  tokenType
  tokenAddress
}
`)

module UserQuery = %graphql(`
query ($userId: String!) {
  user (id: $userId) {
    ...BasicUserInfo
  }
}`)

module StateChangePoll = %graphql(`
query($userId: String!, $timestamp: BigInt!) {
  stateChanges (where: {timestamp_gt: $timestamp}) {
    timestamp
    affectedUsers (where: {id: $userId}) {
      ...BasicUserInfo
    }
  }
}`)

%graphql(`
fragment LongSynth on SyntheticToken {
  floatMintedLong: floatMintedFromSpecificToken
  longAddress: tokenAddress
}`)

module LatestSystemState = %graphql(`
{
  systemStates (first:1, orderBy:timestamp, orderDirection: desc) {
    timestamp
    txHash 
    blockNumber
    syntheticPrice
    longTokenPrice
    shortTokenPrice
    totalValueLocked
    setBy
  }
}`)

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

// https://test.graph.float.capital/subgraphs/name/avolabs-io/float-capital/graphql?query=%7B%0A%20%20syntheticMarkets%20%7B%0A%20%20%20%20name%0A%20%20%20%20symbol%0A%20%20%20%20marketIndex%0A%20%20%20%20oracleAddress%0A%20%20%20%20syntheticLong%20%7B%0A%20%20%20%20%20%20id%0A%20%20%20%20%20%20tokenAddress%0A%20%20%20%20%20%20totalStaked%0A%20%20%20%20%7D%0A%20%20%20%20syntheticShort%20%7B%0A%20%20%20%20%20%20id%0A%20%20%20%20%20%20tokenAddress%0A%20%20%20%20%20%20totalStaked%0A%20%20%20%20%7D%0A%20%20%7D%0A%7D
module MarketDetails = %graphql(`
{
  syntheticMarkets {
    name
    symbol
    marketIndex
    oracleAddress
    syntheticLong {
      id
      tokenAddress
      totalStaked
    }
    syntheticShort {
      id
      tokenAddress
      totalStaked
    }
    latestSystemState {
      totalLockedLong
      totalLockedShort
      totalValueLocked
      longTokenPrice
      shortTokenPrice
    }
  }
}
`)

// https://test.graph.float.capital/subgraphs/name/avolabs-io/float-capital/graphql?query=%7B%0A%20%20syntheticMarkets%20%7B%0A%20%20%20%20name%0A%20%20%20%20symbol%0A%20%20%20%20marketIndex%0A%20%20%20%20oracleAddress%0A%20%20%20%20syntheticLong%20%7B%0A%20%20%20%20%20%20id%0A%20%20%20%20%20%20tokenAddress%0A%20%20%20%20%20%20totalStaked%0A%20%20%20%20%7D%0A%20%20%20%20syntheticShort%20%7B%0A%20%20%20%20%20%20id%0A%20%20%20%20%20%20tokenAddress%0A%20%20%20%20%20%20totalStaked%0A%20%20%20%20%7D%0A%20%20%20%20latestSystemState%20%7B%0A%20%20%20%20%20%20totalLockedLong%0A%20%20%20%20%20%20totalLockedShort%0A%20%20%20%20%20%20totalValueLocked%0A%20%20%20%20%20%20longTokenPrice%0A%20%20%20%20%20%20shortTokenPrice%0A%20%20%20%20%7D%0A%20%20%7D%0A%7D%0A
module StakingDetails = %graphql(`
{
  syntheticMarkets {
    name
    symbol
    marketIndex
    timestampCreated
    oracleAddress
    syntheticLong {
      longTokenAddress: id
      tokenAddress
      longTotalStaked: totalStaked
    }
    syntheticShort {
      shortTokenAddress: id
      tokenAddress
      shortTotalStaked: totalStaked
    }
    latestSystemState {
      timestamp
      totalLockedLong
      totalLockedShort
      totalValueLocked
      longTokenPrice
      shortTokenPrice
    }
  }
}
`)

module SyntheticTokens = %graphql(`
{
  syntheticTokens{
    ...SyntheticInfo
  }
}
`)

module SyntheticToken = %graphql(`
query ($tokenId: String!){
  syntheticToken(id: $tokenId){
    ...SyntheticInfo
  }
}
`)

module UsersStakes = %graphql(`
query ($userId: String!){
  currentStakes (where: {user: $userId}) {
    id
    currentStake {
      id
      timestamp
      blockNumber
      creationTxHash  @ppxCustom(module: "Bytes")
      syntheticToken {
        ...SyntheticInfo
      }
      amount
      withdrawn
    }
    lastMintState {
      id
    }
  }
}
`)

module UsersActiveStakes = %graphql(`
query ($userId: String!){
  currentStakes (where: {user: $userId, withdrawn: false}) {
    id
    currentStake {
      id
      timestamp
      blockNumber
      creationTxHash
      syntheticToken {
        ...SyntheticInfo
      }
      amount
    }
  }
}
`)

module GlobalState = %graphql(`
query {
  globalStates(first: 1){
    totalFloatMinted,
    totalTxs,
    totalUsers,
    totalGasUsed
  }
}
`)
// syntheticMarkets {
//   name
//   symbol
//   marketIndex
//   totalValueLockedInMarket
//   oracleAddress
//   syntheticLong {
//     id
//     tokenAddress
//     totalValueLocked
//     tokenSupply
//     tokenPrice
//   }
//   syntheticShort {
//     id
//     tokenAddress
//     totalValueLocked
//     tokenSupply
//     tokenPrice
//   }
// }
// module LatestStateChanges = %graphql(`
// {
//   stateChanges (first:5, orderBy:timestamp, orderDirection: desc) {
//     txEventParamList {
//       eventName
//       index
//       params {
//         index
//         param
//         paramType
//       }
//     }
//   }
// }
// `)
