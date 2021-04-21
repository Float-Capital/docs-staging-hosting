@ocaml.doc(`Represents a graphql query response.`)
type graphResponse<'a> = Loading | GraphError(string) | Response('a)

@ocaml.doc(`Combines two graphql responses into a single tuple response.`)
let liftGraphResponse2 = (a, b) => {
  switch a {
  | Response(ar) =>
    switch b {
    | Response(br) => Response((ar, br))
    | GraphError(x) => GraphError(x)
    | Loading => Loading
    }
  | GraphError(x) => GraphError(x)
  | Loading => Loading
  }
}

@ocaml.doc(`Returns details of the given user's staked tokens.`)
let {ethAdrToLowerStr} = module(Globals)

let useGetMarkets = () => {
  let marketDetailsQuery = Queries.MarketDetails.use()
  let client = Client.useApolloClient()

  React.useEffect0(() => {
    let _ = client.query(~query=module(Queries.MarketDetails), ())->JsPromise.map(queryResult =>
      switch queryResult {
      | Ok({data: {syntheticMarkets}}) =>
        let _ = syntheticMarkets->Array.map(({syntheticLong, syntheticShort}) => {
          let _ = client.writeQuery(
            ~query=module(Queries.SyntheticToken),
            ~data={syntheticToken: Some(syntheticLong)},
            {tokenId: syntheticLong.id},
          )
          let _ = client.writeQuery(
            ~query=module(Queries.SyntheticToken),
            ~data={syntheticToken: Some(syntheticShort)},
            {tokenId: syntheticShort.id},
          )
        })
      | Error(_) => ()
      }
    )
    None
  })

  switch marketDetailsQuery {
  | {data: Some({syntheticMarkets})} => Response(syntheticMarkets)
  | {error: Some({message})} => GraphError(message)
  | _ => Loading
  }
}

@ocaml.doc(`Returns a live estimate of how much total float the user is owed for the given synthetic tokens.`)
let useTotalClaimableFloatForUser = (~userId, ~synthTokens) => {
  let currentTimestamp = Misc.Time.useCurrentTimeBN(~updateInterval=1000)
  let floatQuery = Queries.UsersFloatDetails.use({
    userId: userId,
    synthTokens: synthTokens,
  })

  switch floatQuery {
  | {data: Some({currentStakes: stakes})} => {
      let initialState = Response((CONSTANTS.zeroBN, CONSTANTS.zeroBN))
      stakes->Array.reduce(initialState, (curState, stake) => {
        switch curState {
        | Loading => Loading
        | GraphError(msg) => GraphError(msg)
        | Response((totalClaimable, totalPredicted)) => {
            let amount = stake.currentStake.amount
            let timestamp = stake.lastMintState.timestamp
            let lastAccumulativeFloatPerToken = stake.lastMintState.accumulativeFloatPerToken
            let accumulativeFloatPerToken = stake.syntheticToken.latestStakerState.accumulativeFloatPerToken
            let floatRatePerTokenOverInterval = stake.syntheticToken.latestStakerState.floatRatePerTokenOverInterval

            // The amount of float the user is owed up to the last staker state.
            // Note that accumulativeFloatPerToken is in e42 scale (see Staker.sol).
            let claimableFloat =
              Ethers.BigNumber.sub(accumulativeFloatPerToken, lastAccumulativeFloatPerToken)
              ->Ethers.BigNumber.mul(amount)
              ->Ethers.BigNumber.div(CONSTANTS.tenToThe42)
              ->Ethers.BigNumber.add(totalClaimable)

            // The amount of float the user is predicted to earn between the last
            // staker state and now. This is an estimate, as we don't have data
            // from the LongShort contract to compute the true float rate.
            let predictedFloat =
              Ethers.BigNumber.sub(currentTimestamp, timestamp)
              ->Ethers.BigNumber.mul(floatRatePerTokenOverInterval)
              ->Ethers.BigNumber.mul(amount)
              ->Ethers.BigNumber.div(CONSTANTS.tenToThe42)
              ->Ethers.BigNumber.add(totalPredicted)

            Response((claimableFloat, predictedFloat))
          }
        }
      })
    }
  | {error: Some({message})} => GraphError(message)
  | _ => Loading
  }
}

@ocaml.doc(`Returns a live estimate of how much float the user is owed for the given synthetic token stake.`)
let useClaimableFloatForUser = (~userId, ~synthToken) => {
  useTotalClaimableFloatForUser(~userId, ~synthTokens=[synthToken])
}

@ocaml.doc(`Returns a list of stakes for the given user.`)
let useStakesForUser = (~userId) => {
  let activeStakesQuery = Queries.UsersStakes.use({
    userId: userId,
  })

  switch activeStakesQuery {
  | {data: Some({currentStakes})} => Response(currentStakes)
  | {error: Some({message})} => GraphError(message)
  | _ => Loading
  }
}

type userSynthBalance = {
  addr: Ethers.ethAddress,
  name: string,
  symbol: string,
  isLong: bool,
  tokenBalance: Ethers.BigNumber.t,
  tokensValue: Ethers.BigNumber.t,
}

type usersBalanceSummary = {
  totalBalance: Ethers.BigNumber.t,
  balances: array<userSynthBalance>,
}

@ocaml.doc(`Returns a sumary of the users synthetic tokens`)
let useUsersBalances = (~userId) => {
  let usersTokensQuery = Queries.UsersBalances.use({userId: userId})

  switch usersTokensQuery {
  | {data: Some({user: Some({tokenBalances})})} =>
    let result = tokenBalances->Array.reduce({totalBalance: CONSTANTS.zeroBN, balances: []}, (
      {totalBalance, balances},
      {
        tokenBalance,
        syntheticToken: {
          id,
          tokenType,
          syntheticMarket: {name, symbol},
          latestPrice: {price: {price}},
        },
      },
    ) => {
      let isLong = tokenType == #Long
      let newToken = {
        addr: id->Ethers.Utils.getAddressUnsafe,
        name: name,
        isLong: isLong,
        tokenBalance: tokenBalance,
        symbol: symbol,
        tokensValue: price
        ->Ethers.BigNumber.mul(tokenBalance)
        ->Ethers.BigNumber.div(CONSTANTS.tenToThe18),
      }
      {
        totalBalance: totalBalance->Ethers.BigNumber.add(newToken.tokensValue),
        balances: balances->Array.concat([newToken]),
      }
    })
    Response(result)
  | {data: Some({user: None})} => Response({totalBalance: CONSTANTS.zeroBN, balances: []})
  | {error: Some({message})} => GraphError(message)
  | _ => Loading
  }
}

type floatBalancesData = {
  floatBalance: Ethers.BigNumber.t,
  floatMinted: Ethers.BigNumber.t,
}

@ocaml.doc(`Returns held and minted float token balances for the given user.`)
let useFloatBalancesForUser = (~userId) => {
  let usersStateQuery = Queries.UserQuery.use({
    userId: userId,
  })

  switch usersStateQuery {
  | {data: Some({user})} =>
    switch user {
    | Some(userData) =>
      Response({
        floatBalance: userData.floatTokenBalance,
        floatMinted: userData.totalMintedFloat,
      })
    | None =>
      Response({
        floatBalance: CONSTANTS.zeroBN,
        floatMinted: CONSTANTS.zeroBN,
      })
    }
  | {error: Some({message})} => GraphError(message)
  | _ => Loading
  }
}

type basicUserInfo = {
  id: string,
  joinedAt: Js.Date.t,
  gasUsed: Ethers.BigNumber.t,
  floatMinted: Ethers.BigNumber.t,
  floatBalance: Ethers.BigNumber.t,
  transactionCount: Ethers.BigNumber.t,
}
type userInfo = ExistingUser(basicUserInfo) | NewUser
@ocaml.doc(`Returns basic user info for the given user.`)
let useBasicUserInfo = (~userId) => {
  let userQuery = Queries.UserQuery.use({
    userId: userId,
  })

  switch userQuery {
  | {
      data: Some({
        user: Some({
          id,
          timestampJoined,
          totalMintedFloat,
          floatTokenBalance,
          numberOfTransactions,
          totalGasUsed,
        }),
      }),
    } =>
    Response(
      ExistingUser({
        id: id,
        joinedAt: timestampJoined->Ethers.BigNumber.toNumberFloat->DateFns.fromUnixTime,
        gasUsed: totalGasUsed,
        floatMinted: totalMintedFloat,
        floatBalance: floatTokenBalance,
        transactionCount: numberOfTransactions,
      }),
    )
  | {data: Some({user: None})} => Response(NewUser)
  | {error: Some({message})} => GraphError(message)
  | _ => Loading
  }
}

let useSyntheticTokenBalance = (~user, ~tokenAddress) => {
  let syntheticBalanceQuery = Queries.UsersBalance.use({
    userId: user->ethAdrToLowerStr,
    tokenAdr: tokenAddress->ethAdrToLowerStr,
  })

  switch syntheticBalanceQuery {
  | {data: Some({user: Some({tokenBalances: [{tokenBalance}]})})} => Response(tokenBalance)
  | {error: Some({message})} => GraphError(message)
  | _ => Loading
  }
}

let useSyntheticTokenBalanceOrZero = (~user, ~tokenAddress) => {
  let syntheticBalanceQuery = Queries.UsersBalance.use({
    userId: user->ethAdrToLowerStr,
    tokenAdr: tokenAddress->ethAdrToLowerStr,
  })

  switch syntheticBalanceQuery {
  | {data: Some({user: Some({tokenBalances: [{tokenBalance}]})})} => Response(tokenBalance)
  | {data: Some(_)} => Response(CONSTANTS.zeroBN)
  | {error: Some({message})} => GraphError(message)
  | _ => Loading
  }
}

@ocaml.doc(`Utilities and helpers for react hooks that fetch data from graphql`)
module Util = {
  @ocaml.doc(`Convert a graphResponse into an option`)
  let graphResponseToOption: graphResponse<'a> => option<'a> = maybeData =>
    switch maybeData {
    | Response(data) => Some(data)
    | GraphError(_)
    | Loading =>
      None
    }

  type potentialData<'a> = Data('a) | Loading

  @ocaml.doc(`Convert a graphResponse into a result type`)
  let graphResponseToResult: graphResponse<'a> => result<potentialData<'a>, string> = maybeData =>
    switch maybeData {
    | Response(data) => Ok(Data(data))
    | Loading => Ok(Loading)
    | GraphError(error) => Error(error)
    }

  @ocaml.doc(`Convert an Apollo useQuery into a graphResponse type`)
  let queryToResponse = (
    query: ApolloClient__React_Hooks_UseQuery.QueryResult.t<'a, 'b, 'c, 'd>,
  ) => {
    switch query {
    | {error: Some({message})} => GraphError(message)
    | {data: Some(response)} => Response(response)
    | _ => Loading
    }
  }
}

let useTokenMarketId = (~tokenId) => {
  let marketIdQuery = Queries.TokenMarketId.use({tokenId: tokenId})
  switch marketIdQuery {
  | {data: Some({syntheticToken: Some({syntheticMarket: {id}})})} => Response(id)
  | {data: Some(_)} => Response("1")
  | {error: Some({message})} => GraphError(message)
  | _ => Loading
  }
}
