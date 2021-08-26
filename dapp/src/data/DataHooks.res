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

@ocaml.doc(`Combines three graphql responses into a single tuple response.`)
let liftGraphResponse3 = (a, b, c) => {
  switch a {
  | Response(ar) =>
    switch b {
    | Response(br) =>
      switch c {
      | Response(cr) => Response((ar, br, cr))
      | GraphError(x) => GraphError(x)
      | Loading => Loading
      }
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
        | Response((totalClaimable, totalPredicted)) =>
          if stake.currentStake.withdrawn {
            Response((totalClaimable, totalPredicted))
          } else {
            let amount = stake.currentStake.amount
            let timestamp = stake.lastMintState.timestamp
            let isLong = stake.syntheticToken.id == stake.lastMintState.longToken.id
            let lastAccumulativeFloatPerToken = isLong
              ? stake.lastMintState.accumulativeFloatPerTokenLong
              : stake.lastMintState.accumulativeFloatPerTokenShort
            let accumulativeFloatPerToken = isLong
              ? stake.syntheticMarket.latestStakerState.accumulativeFloatPerTokenLong
              : stake.syntheticMarket.latestStakerState.accumulativeFloatPerTokenShort
            let floatRatePerTokenOverInterval = isLong
              ? stake.syntheticMarket.latestStakerState.floatRatePerTokenOverIntervalLong
              : stake.syntheticMarket.latestStakerState.floatRatePerTokenOverIntervalShort

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
  | {data: Some({currentStakes})} =>
    Response(currentStakes->Array.keep(x => x.currentStake.withdrawn == false))
  | {error: Some({message})} => GraphError(message)
  | _ => Loading
  }
}

@ocaml.doc(`Returns a sumary of the users synthetic tokens`)
let useUsersBalances = (~userId) => {
  let usersTokensQuery = Queries.UsersBalances.use({userId: userId})

  switch usersTokensQuery {
  | {data: Some({user: Some({tokenBalances})})} => Response(tokenBalances)
  | {data: Some({user: None})} => Response([])
  | {error: Some({message})} => GraphError(message)
  | _ => Loading
  }
}

type userPendingAction = {
  isLong: bool,
  amount: Ethers.BigNumber.t,
  marketIndex: Ethers.BigNumber.t,
  confirmedTimestamp: Ethers.BigNumber.t,
}

@ocaml.doc(`Returns a summary of the users synthetic tokens`)
let useUsersPendingMints = (~userId) => {
  let usersPendingMintsQuery = Queries.UsersPendingMints.use({userId: userId})
  switch usersPendingMintsQuery {
  | {data: Some({user: Some({pendingNextPriceActions})})} =>
    let result: array<userPendingAction> =
      pendingNextPriceActions
      ->Array.keep(pendingNextPriceAction =>
        pendingNextPriceAction.amountPaymentTokenForDepositShort->Ethers.BigNumber.gt(
          CONSTANTS.zeroBN,
        ) ||
          pendingNextPriceAction.amountPaymentTokenForDepositLong->Ethers.BigNumber.gt(
            CONSTANTS.zeroBN,
          )
      )
      ->Array.map(pendingNextPriceAction => {
        let isLong =
          pendingNextPriceAction.amountPaymentTokenForDepositLong->Ethers.BigNumber.gt(
            CONSTANTS.zeroBN,
          )

        {
          isLong: isLong,
          amount: isLong
            ? pendingNextPriceAction.amountPaymentTokenForDepositLong
            : pendingNextPriceAction.amountPaymentTokenForDepositShort,
          marketIndex: pendingNextPriceAction.marketIndex,
          confirmedTimestamp: pendingNextPriceAction.confirmedTimestamp,
        }
      })

    Response(result)
  | {data: Some({user: None})} =>
    Response([
      {
        isLong: false,
        amount: CONSTANTS.zeroBN,
        marketIndex: CONSTANTS.zeroBN,
        confirmedTimestamp: CONSTANTS.zeroBN,
      },
    ])
  | {error: Some({message})} => GraphError(message)
  | _ => Loading
  }
}

@ocaml.doc(`Returns a summary of the users synthetic tokens`)
let useUsersPendingRedeems = (~userId) => {
  let usersPendingRedeemsQuery = Queries.UsersPendingRedeems.use({userId: userId})
  switch usersPendingRedeemsQuery {
  | {data: Some({user: Some({pendingNextPriceActions})})} =>
    let result: array<userPendingAction> =
      pendingNextPriceActions
      ->Array.keep(pendingNextPriceAction =>
        pendingNextPriceAction.amountSynthTokenForWithdrawalShort->Ethers.BigNumber.gt(
          CONSTANTS.zeroBN,
        ) ||
          pendingNextPriceAction.amountSynthTokenForWithdrawalLong->Ethers.BigNumber.gt(
            CONSTANTS.zeroBN,
          )
      )
      ->Array.map(pendingNextPriceAction => {
        let isLong =
          pendingNextPriceAction.amountSynthTokenForWithdrawalLong->Ethers.BigNumber.gt(
            CONSTANTS.zeroBN,
          )

        {
          isLong: isLong,
          amount: isLong
            ? pendingNextPriceAction.amountSynthTokenForWithdrawalLong
            : pendingNextPriceAction.amountSynthTokenForWithdrawalShort,
          marketIndex: pendingNextPriceAction.marketIndex,
          confirmedTimestamp: pendingNextPriceAction.confirmedTimestamp,
        }
      })

    Response(result)
  | {data: Some({user: None})} =>
    Response([
      {
        isLong: false,
        amount: CONSTANTS.zeroBN,
        marketIndex: CONSTANTS.zeroBN,
        confirmedTimestamp: CONSTANTS.zeroBN,
      },
    ])
  | {error: Some({message})} => GraphError(message)
  | _ => Loading
  }
}

type userConfirmedButNotYetSettledAction = {
  isLong: bool,
  amount: Ethers.BigNumber.t,
  marketIndex: Ethers.BigNumber.t,
  updateIndex: Ethers.BigNumber.t,
}

@ocaml.doc(`Returns a sumary of the users synthetic tokens`)
let useUsersConfirmedMints = (~userId) => {
  let usersConfirmedMintsQuery = Queries.UsersConfirmedMints.use(
    {userId: userId},
    ~fetchPolicy=NetworkOnly,
  )
  switch usersConfirmedMintsQuery {
  | {data: Some({user: Some({confirmedNextPriceActions})})} =>
    let result: array<userConfirmedButNotYetSettledAction> =
      confirmedNextPriceActions
      ->Array.keep(confirmedNextPriceAction =>
        confirmedNextPriceAction.amountPaymentTokenForDepositShort->Ethers.BigNumber.gt(
          CONSTANTS.zeroBN,
        ) ||
          confirmedNextPriceAction.amountPaymentTokenForDepositLong->Ethers.BigNumber.gt(
            CONSTANTS.zeroBN,
          )
      )
      ->Array.map(confirmedNextPriceAction => {
        let isLong =
          confirmedNextPriceAction.amountPaymentTokenForDepositLong->Ethers.BigNumber.gt(
            CONSTANTS.zeroBN,
          )

        {
          isLong: isLong,
          amount: isLong
            ? confirmedNextPriceAction.amountPaymentTokenForDepositLong
            : confirmedNextPriceAction.amountPaymentTokenForDepositShort,
          marketIndex: confirmedNextPriceAction.marketIndex,
          updateIndex: confirmedNextPriceAction.updateIndex,
        }
      })

    Response(result)
  | {data: Some({user: None})} =>
    Response([
      {
        isLong: false,
        amount: CONSTANTS.zeroBN,
        marketIndex: CONSTANTS.zeroBN,
        updateIndex: CONSTANTS.zeroBN,
      },
    ])
  | {error: Some({message})} => GraphError(message)
  | _ => Loading
  }
}

type batchedSynthPrices = {
  redeemPriceSnapshotLong: Ethers.BigNumber.t,
  redeemPriceSnapshotShort: Ethers.BigNumber.t,
}

@ocaml.doc(`Returns the prices of the synths for that market at that update index`)
let useBatchedSynthPrices = (~marketIndex, ~updateIndex) => {
  let batchedExecsSynthPricesQuery = Queries.BatchedSynthPrices.use(
    {
      batchId: `batched-${marketIndex->Ethers.BigNumber.toString}-${updateIndex->Ethers.BigNumber.toString}`,
    },
    ~fetchPolicy=NetworkOnly,
  )
  switch batchedExecsSynthPricesQuery {
  | {
      data: Some({batchedNextPriceExec: Some({redeemPriceSnapshotLong, redeemPriceSnapshotShort})}),
    } =>
    Response({
      redeemPriceSnapshotLong: redeemPriceSnapshotLong,
      redeemPriceSnapshotShort: redeemPriceSnapshotShort,
    })
  | {data: Some({batchedNextPriceExec: None})} =>
    Response({
      redeemPriceSnapshotLong: CONSTANTS.zeroBN,
      redeemPriceSnapshotShort: CONSTANTS.zeroBN,
    })
  | {error: Some({message})} => GraphError(message)
  | _ => Loading
  }
}

@ocaml.doc(`Returns a summary of the users pending redeems`)
let useUsersConfirmedRedeems = (~userId) => {
  let usersConfirmedRedeemsQuery = Queries.UsersConfirmedRedeems.use(
    {userId: userId},
    ~fetchPolicy=NetworkOnly,
  )
  switch usersConfirmedRedeemsQuery {
  | {data: Some({user: Some({confirmedNextPriceActions})})} =>
    let result: array<userConfirmedButNotYetSettledAction> =
      confirmedNextPriceActions
      ->Array.keep(confirmedNextPriceAction =>
        confirmedNextPriceAction.amountSynthTokenForWithdrawalLong->Ethers.BigNumber.gt(
          CONSTANTS.zeroBN,
        ) ||
          confirmedNextPriceAction.amountSynthTokenForWithdrawalLong->Ethers.BigNumber.gt(
            CONSTANTS.zeroBN,
          )
      )
      ->Array.map(confirmedNextPriceAction => {
        let isLong =
          confirmedNextPriceAction.amountSynthTokenForWithdrawalLong->Ethers.BigNumber.gt(
            CONSTANTS.zeroBN,
          )

        {
          isLong: isLong,
          amount: isLong
            ? confirmedNextPriceAction.amountSynthTokenForWithdrawalLong
            : confirmedNextPriceAction.amountSynthTokenForWithdrawalShort,
          marketIndex: confirmedNextPriceAction.marketIndex,
          updateIndex: confirmedNextPriceAction.updateIndex,
        }
      })

    Response(result)
  | {data: Some({user: None})} =>
    Response([
      {
        isLong: false,
        amount: CONSTANTS.zeroBN,
        marketIndex: CONSTANTS.zeroBN,
        updateIndex: CONSTANTS.zeroBN,
      },
    ])
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
        }),
      }),
    } =>
    Response(
      ExistingUser({
        id: id,
        joinedAt: timestampJoined->Ethers.BigNumber.toNumberFloat->DateFns.fromUnixTime,
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

let useTokenPriceAtTime = (~tokenAddress, ~timestamp) => {
  let query = Queries.TokenPrice.use({
    tokenAddress: tokenAddress->Ethers.Utils.ethAdrToLowerStr,
    timestamp: timestamp->Ethers.BigNumber.toNumber,
  })

  switch query {
  | {data: Some({prices: [{price}]})} => Response(price)
  | {data: Some(_)} => GraphError(`Couldn't find price with that timestamp.`)
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

  let apyToResponse = (a: APYProvider.t<'a>) => {
    switch a {
    | Loaded(a) => Response(a)
    | Error(a) => GraphError(a)
    | _ => Loading
    }
  }
}

let useStakingAPYs = () => {
  let marketsQuery = Queries.MarketDetails.use()
  let globalQuery = Queries.GlobalState.use()
  let apy = APYProvider.useBnApy()

  switch liftGraphResponse3(
    Util.queryToResponse(marketsQuery),
    Util.queryToResponse(globalQuery),
    Util.apyToResponse(apy),
  ) {
  | Response({syntheticMarkets}, {globalStates: [global]}, apy) =>
    APYProvider.Loaded(
      MarketCalculationHelpers.calculateStakeAPYS(~syntheticMarkets, ~global, ~apy),
    )
  | GraphError(a) => Error(a)
  | _ => Loading
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

@send external getTime: Js_date.t => int = "getTime"

let getUnixTime = date => date->getTime / 1000

@send external toFixed: (float, int) => string = "toFixed"

@ocaml.doc(`Returns the oracles last price update timestamp`)
let useOracleLastUpdate = (~marketIndex) => {
  let oracleLastUpdateQuery = Queries.OraclesLastUpdate.use(
    {marketIndex: marketIndex},
    ~fetchPolicy=NetworkOnly,
  )

  switch oracleLastUpdateQuery {
  | {data: Some({underlyingPrices: [{timeUpdated}]})} => Response(timeUpdated)
  | {error: Some({message})} => GraphError(message)
  | _ => Loading
  }
}
