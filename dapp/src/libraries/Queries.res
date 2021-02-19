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
    totalLockedLong
    totalLockedShort
    totalValueLocked
    setBy
  }
}`)

module MarketDetails = %graphql(`
{
  syntheticMarkets {
    name
    symbol
    marketIndex
    oracleAddress
    syntheticLong {
      id
      tokenAddress @ppxCustom(module: "Address")
    }
    syntheticShort {
      id
      tokenAddress @ppxCustom(module: "Address")
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

module UsersStakes = %graphql(`
query ($userId: String!){
  currentStakes (where: {user: $userId}) {
    id
    currentStake {
      id
      timestamp
      blockNumber
      creationTxHash
      tokenType {
        tokenAddress
        totalStaked
      }
      amount
      withdrawn
    }
    user {
      id
      address
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
//     tokenAddress @ppxCustom(module: "Address")
//     totalValueLocked
//     tokenSupply
//     tokenPrice
//   }
//   syntheticShort {
//     id
//     tokenAddress @ppxCustom(module: "Address")
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
