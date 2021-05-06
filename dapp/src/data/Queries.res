@@ocaml.warning("-20") // The ppx generates code with unused parameters

open GqlConverters

%graphql(`
# Used in:
#   Queries: StateChangePoll, UserQuery
fragment BasicUserInfo on User {
  id
  totalMintedFloat
  floatTokenBalance
  numberOfTransactions
  totalGasUsed
  timestampJoined
  tokenMints {
    tokensMinted
  }
}

# Used in: 
#   Fragments: SyntheticTokenInfo, SyntheticMarketInfo, UserTokenBalance, CurrentStakesDetailed
fragment LatestSynthPrice on LatestPrice {
  id
  price {
    price
  }
}

# Used in:
#   Fragments: SyntheticMarketBasic
fragment LatestSystemStateBasic on SystemState {
  totalLockedLong
  totalLockedShort
}

# Used in:
#  Fragments: SyntheticMarketInfo
fragment LatestSystemStateInfo on SystemState {
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

# Used in:
#   Fragments: SyntheticTokenBasic
fragment SyntheticMarketIdentifiers on SyntheticMarket {
  id
  name
  symbol
}

# Used in:
#   Fragments: SyntheticTokenInfo
fragment SyntheticMarketBasic on SyntheticMarket {
  id
  name
  symbol
  latestSystemState {
    ...LatestSystemStateBasic
  }
}

# Used in:
#   Fragments: UserTokenBalance
fragment SyntheticTokenBasic on SyntheticToken {
  id
  tokenType
  syntheticMarket {
    ...SyntheticMarketIdentifiers
  }
  latestPrice {
    ...LatestSynthPrice
  }
}

# Used in:
#   Fragments: CurrentStakeHighLevel
fragment SyntheticTokenStakeInfo on SyntheticToken {
  id
  latestStakerState {
    accumulativeFloatPerToken
    floatRatePerTokenOverInterval
    timestamp
  }
}

# Used in:
#   Fragments: SyntheticMarketInfo, StakeDetailed, CurrentStakesDetailed
#   Queries: SyntheticToken, SyntheticTokens
fragment SyntheticTokenInfo on SyntheticToken {
  id
  totalStaked
  syntheticMarket {
    ...SyntheticMarketBasic
  }
  latestPrice {
    ...LatestSynthPrice
  }
  tokenType
  tokenAddress
}


# Used in: 
#   Queries: MarketDetails
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
    ...LatestSystemStateInfo
  }
}

# Used in:
#   Queries: UsersBalance, UserBalances
fragment UserTokenBalance on UserSyntheticTokenBalance {
  id
  tokenBalance
  syntheticToken {
    ...SyntheticTokenBasic
  }
}

# TODO: Break this up into smaller fragments, find more overlap between 'CurrentStakeDetailed' and 'CurrentStakeHighLevel'
# Used in: 
#   Queries: StateChangePoll, UserFloatDetails
fragment CurrentStakeHighLevel on CurrentStake {
  id
  lastMintState {
    timestamp
    accumulativeFloatPerToken
  }
  currentStake {
    amount
  }
  syntheticToken {
    ...SyntheticTokenStakeInfo
  }
}

# Used in:
#   Queries: UsersStakes, StateChangePoll
fragment CurrentStakeDetailed on CurrentStake {
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

# Used in:
#   Queries: GlobalState
fragment GlobalStateInfo on GlobalState {
  totalFloatMinted,
  totalTxs,
  totalUsers,
  totalGasUsed,
  timestampLaunched,
  txHash @ppxCustom(module: "Bytes")
}
`)

// Used externally in FloatManagement.res, UserUI.res
module UserQuery = %graphql(`
query ($userId: String!) {
  user (id: $userId) {
    ...BasicUserInfo
  }
}`)

// Used externally in: MarketInteractionCard.res, RedeemForm.res, StakeForm.res,
module UsersBalance = %graphql(`
query ($userId: String!, $tokenAdr: String!) {
  user (id: $userId) {
    tokenBalances (where: {syntheticToken: $tokenAdr}) {
      ...UserTokenBalance
    }
  }
}`)

// Used externally in: useUsersBalances (datahook), User.res, StakeList.res
module UsersBalances = %graphql(`
query ($userId: String!) {
  user (id: $userId) {
    tokenBalances { # Maybe we can filter to only get balances greater than 0? Probably not worth it.
      ...UserTokenBalance
    }
  }
}`)

// Used externally in: StateChangeMonitor.res
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
    affectedStakes (where: {user: $userId}) {
      ...CurrentStakeDetailed
      ...CurrentStakeHighLevel
    }
  }
}`)

// Used externally in Dashboard.res, Market.res, MarketCard.res, MarketInteractionCard.res, MarketsList.res, Redeem.res, RedeemForm.res, MintForm.res
module MarketDetails = %graphql(`
query {
  syntheticMarkets {
    ...SyntheticMarketInfo
  }
}
`)

// Used externally in: Profile.res
module SyntheticTokens = %graphql(`
query {
  syntheticTokens {
    ...SyntheticTokenInfo
  }
}
`)

// Used externally in: Unstake.res, StakeForm.res
module SyntheticToken = %graphql(`
query ($tokenId: String!){
  syntheticToken(id: $tokenId){
    ...SyntheticTokenInfo
  }
}
`)

// Used externally in: DataHooks.useStakesForUser, Unstake.res, User.res, MarketInteractionCard.res
module UsersStakes = %graphql(`
query ($userId: String!){
  currentStakes (where: {user: $userId}) {
    ...CurrentStakeDetailed
  }
}
`)

// Used externally in: DataHooks.useTotalClaimableFloatForUser, UserUI
module UsersFloatDetails = %graphql(`
query ($userId: String!, $synthTokens: [String!]!) {
  currentStakes(where: {user: $userId, syntheticToken_in: $synthTokens}) {
    ...CurrentStakeHighLevel
  }
}
`)

// Used externally in: UserUI.res
module TokenMarketId = %graphql(`
query ($tokenId: String!) {
  syntheticToken(id: $tokenId){
    id
    syntheticMarket{
      id
    }
  }
}
`)

// Used externally in: Dashboard.res
module GlobalState = %graphql(`
query {
  globalStates(first: 1){
    ...GlobalStateInfo
  }
}
`)
