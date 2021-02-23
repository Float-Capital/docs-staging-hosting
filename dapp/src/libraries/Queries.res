open GqlConverters

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
    }
  }
}
`)

module SyntheticTokens = %graphql(`
{
  syntheticTokens{
    id
    syntheticMarket {
      id
      name
    }
    tokenType
  }
}
`)

module SyntheticToken = %graphql(`
query ($tokenId: String!){
  syntheticToken(id: $tokenId){
    id
    syntheticMarket {
      id
      name
    }
    tokenType
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
      tokenType {
        tokenAddress
        totalStaked
        tokenType
        syntheticMarket {
          name
          symbol
        }
      }
      amount
      withdrawn
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
      tokenType {
        tokenAddress
        totalStaked
        tokenType
        syntheticMarket {
          name
          symbol
        }
      }
      amount
    }
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
