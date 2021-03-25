open GqlConverters

%graphql(`
fragment BasicUserInfo on User {
  id
  totalMintedFloat
  floatTokenBalance
  numberOfTransactions
  totalGasUsed
  timestampJoined
}
fragment LatestSynthPrice on LatestPrice {
  id
  price {
    price
  }
}
fragment SyntheticTokenInfo on SyntheticToken {
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
  latestPrice {
    ...LatestSynthPrice
  }
  tokenType
  tokenAddress
}
fragment SyntheticMarketInfo on SyntheticMarket {
  name
  symbol
  marketIndex
  timestampCreated
  oracleAddress
  syntheticLong {
    ...SyntheticTokenInfo
  }
  syntheticShort {
    ...SyntheticTokenInfo
  }
  latestSystemState {
    timestamp
    totalLockedLong
    totalLockedShort
    totalValueLocked
    longTokenPrice {
      ...LatestSynthPrice
    }
    shortTokenPrice {
      ...LatestSynthPrice
    }
  }
}
fragment SyntheticMarketPrice on SyntheticMarket {
  id
  name
  symbol
}
fragment UserTokenBalance on UserSyntheticTokenBalance {
  id
  tokenBalance
  syntheticToken {
    id
    tokenType
    syntheticMarket {
      ...SyntheticMarketPrice
    }
    latestPrice {
      ...LatestSynthPrice
    }
  }
}
`)

module UserQuery = %graphql(`
query ($userId: String!) {
  user (id: $userId) {
    ...BasicUserInfo
  }
}`)

module UsersBalance = %graphql(`
query ($userId: String!, $tokenAdr: String!) {
  user (id: $userId) {
    tokenBalances (where: {syntheticToken: $tokenAdr}) {
      ...UserTokenBalance
    }
  }
}`)

module UsersBalances = %graphql(`
query ($userId: String!) {
  user (id: $userId) {
    tokenBalances { # Maybe we can filter to only get balances greater than 0? Probably not worth it.
      ...UserTokenBalance
    }
  }
}`)

module StateChangePoll = %graphql(`
query($userId: String!, $timestamp: BigInt!) {
  stateChanges (where: {timestamp_gt: $timestamp}) {
    timestamp
    affectedUsers (where: {id: $userId}) {
      ...BasicUserInfo
      tokenBalances (where: {timeLastUpdated_gt: $timestamp}) {
        ...UserTokenBalance
      }
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
    longTokenPrice {
      ...LatestSynthPrice
    }
    shortTokenPrice {
      ...LatestSynthPrice
    }
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
      longTokenPrice  {
        ...LatestSynthPrice
      }
      shortTokenPrice {
        ...LatestSynthPrice
      }
    }
  }
}
`)

module StakingDetails = %graphql(`
{
  syntheticMarkets {
    ...SyntheticMarketInfo
  }
}
`)

module SyntheticTokens = %graphql(`
{
  syntheticTokens {
    ...SyntheticTokenInfo
  }
}
`)

module SyntheticToken = %graphql(`
query ($tokenId: String!){
  syntheticToken(id: $tokenId){
    ...SyntheticTokenInfo
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
        ...SyntheticTokenInfo
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

module UsersFloatDetails = %graphql(`
query ($userId: String!, $synthTokens: [String!]!) {
  currentStakes(where: {user: $userId, syntheticToken_in: $synthTokens}) {
    lastMintState {
      timestamp
      accumulativeFloatPerToken
    }
    currentStake {
      amount
    }
    syntheticToken {
      id
      latestStakerState {
        accumulativeFloatPerToken
        floatRatePerTokenOverInterval
        timestamp
      }
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
    totalGasUsed,
    timestampLaunched,
    txHash @ppxCustom(module: "Bytes")
  }
}
`)
