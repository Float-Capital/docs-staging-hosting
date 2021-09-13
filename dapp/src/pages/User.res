open UserUI
open DataHooks
open Masonry

let {add, mul, div, toNumber, eq, toString} = module(Ethers.BigNumber)

let getUsersTotalTokenBalance = (balancesResponse: array<Queries.UserTokenBalance.t>) =>
  balancesResponse->Array.reduce(CONSTANTS.zeroBN, (totalBalanceSum, balanceDataResponse) =>
    totalBalanceSum->add(
      balanceDataResponse.syntheticToken.latestPrice.price.price
      ->mul(balanceDataResponse.tokenBalance)
      ->div(CONSTANTS.tenToThe18),
    )
  )

module UserPendingMintItem = {
  @react.component
  let make = (~userId, ~pendingMint) => {
    let (refetchAttempt, setRefetchAttempt) = React.useState(_ => 0.)

    let _ = Refetchers.useRefetchConfirmedSynths(~userId, ~stateForRefetchExecution=refetchAttempt)
    let _ = Refetchers.useRefetchPendingSynths(~userId, ~stateForRefetchExecution=refetchAttempt)

    <>
      {pendingMint->Array.length > 0
        ? <UserColumnTextCenter>
            <UserColumnText head=`⏳ Pending synths` body={``} /> <br />
          </UserColumnTextCenter>
        : React.null}
      {pendingMint
      ->Array.map(({marketIndex, isLong, amount, confirmedTimestamp: _}) =>
        <UserPendingBox
          name={(marketIndex->toNumber->Backend.getMarketInfoUnsafe).name}
          isLong
          daiSpend=amount
          marketIndex
          refetchCallback=setRefetchAttempt
        />
      )
      ->React.array}
    </>
  }
}

module UserBalancesCard = {
  @react.component
  let make = (~userId) => {
    let usersTokensQuery = DataHooks.useUsersBalances(~userId)
    let usersPendingMintsQuery = DataHooks.useUsersPendingMints(~userId)

    <UserColumnCard>
      <UserColumnHeader> {`Synthetic assets`->React.string} </UserColumnHeader>
      {switch usersPendingMintsQuery {
      | Loading => <div className="mx-auto"> <Loader.Mini /> </div>
      | GraphError(string) => string->React.string
      | Response(pendingMint) => <UserPendingMintItem userId pendingMint />
      }}
      {switch usersTokensQuery {
      | Loading => <div className="m-auto"> <Loader.Mini /> </div>
      | GraphError(string) => string->React.string
      | Response(balancesQueryResponse) => {
          let totalBalance = getUsersTotalTokenBalance(balancesQueryResponse)
          let usersBalancesComponents =
            balancesQueryResponse
            ->Array.keep(({tokenBalance}) => !(tokenBalance->eq(CONSTANTS.zeroBN)))
            ->Array.map(userBalanceData => {
              <UserTokenBox userBalanceData>
                <UserMarketStakeOrRedeem
                  synthId=userBalanceData.syntheticToken.id
                  syntheticSide=userBalanceData.syntheticToken.tokenType
                />
              </UserTokenBox>
            })
          <>
            <UserColumnTextCenter>
              <UserColumnText
                head=`💰 Synth value` body={`$${totalBalance->Misc.NumberFormat.formatEther}`}
              />
            </UserColumnTextCenter>
            {usersBalancesComponents->React.array}
          </>
        }
      }}
    </UserColumnCard>
  }
}

let getUsersTotalStakeValue = (~stakes) => {
  let totalStakedValue = ref(CONSTANTS.zeroBN)

  Array.forEach(stakes, (stake: Queries.CurrentStakeDetailed.t) => {
    let syntheticToken = stake.currentStake.syntheticToken
    let price = syntheticToken.latestPrice.price.price
    let value = stake.currentStake.amount->mul(price)->div(CONSTANTS.tenToThe18)
    totalStakedValue := totalStakedValue.contents->add(value)
  })

  totalStakedValue
}

module UserTotalInvestedCard = {
  @react.component
  let make = (~stakes, ~userId) => {
    let usersTokensQuery = DataHooks.useUsersBalances(~userId)
    let totalStakedValue = getUsersTotalStakeValue(~stakes)

    <>
      {switch usersTokensQuery {
      | Loading => <div className="m-auto"> <Loader.Mini /> </div>
      | GraphError(string) => string->React.string
      | Response(usersBalanceData) =>
        let totalBalance = getUsersTotalTokenBalance(usersBalanceData)
        <UserTotalValue
          totalValueNameSup=`Portfolio`
          totalValueNameSub=`Value`
          totalValue={totalBalance->add(totalStakedValue.contents)}
        />
      }}
    </>
  }
}

module UserTotalStakedCard = {
  @react.component
  let make = (~stakes) => {
    let totalStakedValue = getUsersTotalStakeValue(~stakes)

    <UserTotalValue
      totalValueNameSup=`Staked` totalValueNameSub=`Value` totalValue={totalStakedValue.contents}
    />
  }
}

module PendingRedeemItem = {
  @react.component
  let make = (~pendingRedeem, ~userId) => {
    let {marketIndex, confirmedTimestamp} = pendingRedeem

    let (timerFinished, setTimerFinished) = React.useState(_ => false)

    let client = Client.useApolloClient()
    let reqVariables = {
      Queries.UsersConfirmedRedeems.userId: userId,
    }

    React.useEffect1(() => {
      let timeForGraphToUpdate = 1000 // Give the graph a chance to capture the data before making the request
      let timeout = Js.Global.setTimeout(() => {
        let _ = client.query(
          ~query=module(Queries.UsersConfirmedRedeems),
          ~fetchPolicy=NetworkOnly,
          reqVariables,
        )->JsPromise.map(queryResult => {
          switch queryResult {
          | Ok({data: {user}}) =>
            switch user {
            | Some(usr) => {
                let _ = client.writeQuery(
                  ~query=module(Queries.UsersConfirmedRedeems),
                  ~data={
                    user: Some({
                      __typename: usr.__typename,
                      confirmedNextPriceActions: usr.confirmedNextPriceActions,
                    }),
                  },
                )
              }
            | None => ()
            }

          | _ => ()
          }
        })
      }, timeForGraphToUpdate)
      Some(() => Js.Global.clearTimeout(timeout))
    }, [timerFinished])

    let lastOracleTimestamp = DataHooks.useOracleLastUpdate(
      ~marketIndex=marketIndex->Ethers.BigNumber.toString,
    )

    let oracleHeartbeatForMarket = Backend.getMarketInfoUnsafe(
      marketIndex->Ethers.BigNumber.toNumber,
    ).oracleHeartbeat

    switch lastOracleTimestamp {
    | Loading => <Loader.Tiny />
    | GraphError(error) => <p> {error->React.string} </p>
    | Response(lastOracleUpdateTimestamp) => {
        let nextPriceUpdate =
          lastOracleUpdateTimestamp->Ethers.BigNumber.toNumber + oracleHeartbeatForMarket
        <ProgressBar
          txConfirmedTimestamp={confirmedTimestamp->Ethers.BigNumber.toNumber}
          nextPriceUpdateTimestamp={nextPriceUpdate}
          setTimerFinished
        />
      }
    }
  }
}

module IncompleteWithdrawalItem = {
  @react.component
  let make = (
    ~marketIndex,
    ~updateIndex,
    ~amount,
    ~isLong,
    ~txState,
    ~contractExecutionHandler,
  ) => {
    let syntheticPricesQuery = DataHooks.useBatchedSynthPrices(~marketIndex, ~updateIndex)

    switch syntheticPricesQuery {
    | Loading => <div className="m-auto"> <Loader.Tiny /> </div>
    | GraphError(string) => string->React.string
    | Response(syntheticPrices) => {
        let marketName = (marketIndex->toNumber->Backend.getMarketInfoUnsafe).name

        let syntheticTokenPrice = isLong
          ? syntheticPrices.priceSnapshotLong
          : syntheticPrices.priceSnapshotShort

        let daiAmount =
          amount
          ->Ethers.BigNumber.mul(syntheticTokenPrice)
          ->Ethers.BigNumber.div(CONSTANTS.tenToThe18)

        <div className=`flex items-center justify-between `>
          <p> {marketName->React.string} </p>
          <span className="flex flex-row items-center">
            <img src={CONSTANTS.daiDisplayToken.iconUrl} className="h-4 mr-1" />
            {daiAmount->Misc.NumberFormat.formatEther->React.string}
          </span>
          <Withdraw marketIndex txState contractExecutionHandler />
        </div>
      }
    }
  }
}

module IncompleteWithdrawalsCard = {
  @react.component
  let make = (~userId) => {
    let usersPendingRedeemsQuery = DataHooks.useUsersPendingRedeems(~userId)
    let usersConfirmedRedeemsQuery = DataHooks.useUsersConfirmedRedeems(~userId)

    let signer = ContractActions.useSigner()
    let (contractExecutionHandler, txState, _setTxState) = ContractActions.useContractFunction(
      ~signer=switch signer {
      | Some(s) => s
      | None => None->Obj.magic
      },
    )

    let _ = WithdrawTxStatusModal.useWithdrawTxModal(~txState)

    <>
      {switch usersPendingRedeemsQuery {
      | Loading => <div className="m-auto"> <Loader.Tiny /> </div>
      | GraphError(string) => string->React.string
      | Response(pendingRedeems) =>
        pendingRedeems->Array.length > 0
          ? <div className=`p-5 mb-5 bg-white bg-opacity-75 rounded-lg shadow-lg`>
              <h1 className={`text-center text-lg font-alphbeta mb-4 mt-2`}>
                {"Pending redeems"->React.string}
              </h1>
              <div className=`flex flex-col`>
                {pendingRedeems
                ->Array.map(pendingRedeem => {
                  <PendingRedeemItem pendingRedeem userId />
                })
                ->React.array}
              </div>
            </div>
          : React.null
      }}
      {switch usersConfirmedRedeemsQuery {
      | Loading => <div className="m-auto"> <Loader.Tiny /> </div>
      | GraphError(string) => string->React.string
      | Response(confirmedRedeems) =>
        confirmedRedeems->Array.length > 0
          ? <div className=`p-5 mb-5 bg-white bg-opacity-75 rounded-lg shadow-lg`>
              <h1 className={`text-center text-lg font-alphbeta mb-4 mt-2`}>
                {"Available withdrawals"->React.string}
              </h1>
              <div className=`flex flex-col`>
                {confirmedRedeems
                ->Array.map(({amount, marketIndex, isLong, updateIndex}) => {
                  <IncompleteWithdrawalItem
                    amount marketIndex updateIndex isLong contractExecutionHandler txState
                  />
                })
                ->React.array}
              </div>
            </div>
          : React.null
      }}
    </>
  }
}

module UserProfileCard = {
  @react.component
  let make = (~userInfo: DataHooks.basicUserInfo) => {
    let addressStr = DisplayAddress.ellipsifyMiddle(
      ~inputString=userInfo.id,
      ~maxLength=8,
      ~trailingCharacters=3,
    )
    let joinedStr = userInfo.joinedAt->DateFns.format(#"do MMM ''yy")
    let txStr = userInfo.transactionCount->toString
    let {Swr.data: optDaiBalance} = ContractHooks.useErc20BalanceRefresh(
      ~erc20Address=Config.config.contracts.dai,
    )

    // let usersGems = DataHooks.useUserGems(~userId=userInfo.id)

    <UserColumnCard>
      <UserProfileHeader address={addressStr} />
      <UserColumnTextList>
        <div className="px-4">
          <UserColumnText head=`📮 Address` body={addressStr} />
          {switch optDaiBalance {
          | Some(daiBalance) =>
            <UserColumnText
              icon=CONSTANTS.daiDisplayToken.iconUrl
              head=`DAI balance`
              body={`$${daiBalance->Misc.NumberFormat.formatEther(~digits=2)}`}
            />
          | None => React.null
          }}
          /* {switch usersGems {
          | Loading => <div className="m-auto"> <Loader.Tiny /> </div>
          | GraphError(string) => {
              Js.log(string)
              <> </>
            }
          | Response({balance, streak}) => <>
              <UserColumnText
                icon="/img/gem.gif"
                head=`Gems collected`
                body={balance->Misc.NumberFormat.formatEther(~digits=2)}
              />
              <UserColumnText
                head=`⚡ Gem streak` body={`${streak->Ethers.BigNumber.toString} days`}
              />
            </>
          }} */
          <UserColumnText head=`🎉 Joined` body={joinedStr} />
          <UserColumnText head=`🏃 No. txs` body={txStr} />
        </div>
      </UserColumnTextList>
    </UserColumnCard>
  }
}

@ocaml.doc(`Represents all the data required to render the user page.`)
type userData = {
  user: string,
  userInfo: DataHooks.basicUserInfo,
  stakes: array<Queries.CurrentStakeDetailed.t>,
}

let onQueryError = (msg: string) => {
  <div className="w-full max-w-5xl mx-auto">
    <UserContainer> {`Error: ${msg}`->React.string} </UserContainer>
  </div>
}

let onQuerySuccess = (data: userData) => {
  <UserContainer>
    <Container>
      <Divider>
        <UserProfileCard userInfo={data.userInfo} />
        <IncompleteWithdrawalsCard userId={data.user} />
        <UserFloatCard userId={data.user} stakes={data.stakes} />
      </Divider>
      <Divider>
        <UserTotalInvestedCard stakes={data.stakes} userId={data.user} />
        <UserBalancesCard userId={data.user} />
      </Divider>
      <Divider>
        <UserTotalStakedCard stakes={data.stakes} />
        <UserStakesCard stakes={data.stakes} userId={data.user} />
      </Divider>
    </Container>
  </UserContainer>
}

@react.component
let make = () => {
  let optCurrentUser = RootProvider.useCurrentUser()
  let router = Next.Router.useRouter()
  let user = switch Js.Dict.get(router.query, `user`) {
  | None => `No user provided`
  | Some(userStr) => userStr->Js.String.toLowerCase
  }

  let stakesQuery = useStakesForUser(~userId=user)
  let userInfoQuery = useBasicUserInfo(~userId=user)

  let notCurrentUserMessage = () =>
    <UserColumnTextCenter>
      <a
        className="mt-4 hover:text-gray-600"
        target="_"
        rel="noopener noreferrer"
        href={`${Config.blockExplorer}address/${user}`}>
        <h1> {"This user has not interacted with float.capital yet"->React.string} </h1>
      </a>
    </UserColumnTextCenter>

  switch liftGraphResponse2(stakesQuery, userInfoQuery) {
  | Response((_stakes, NewUser)) =>
    <div className="w-full max-w-5xl mx-auto">
      <div className="max-w-xl mx-auto">
        <UserColumnCard>
          <div className="p-4">
            <UserProfileHeader address={user} />
            {switch optCurrentUser {
            | Some(currentUser) =>
              currentUser->Ethers.Utils.ethAdrToLowerStr == user
                ? <>
                    <UserColumnTextCenter>
                      <p className="my-2">
                        {`Mint a position to see data on your profile`->React.string}
                      </p>
                    </UserColumnTextCenter>
                    <div className="w-40 mx-auto">
                      <Next.Link href="/app/markets">
                        <Button.Small> {`MARKETS`} </Button.Small>
                      </Next.Link>
                    </div>
                  </>
                : notCurrentUserMessage()
            | None => notCurrentUserMessage()
            }}
          </div>
        </UserColumnCard>
      </div>
    </div>
  | Response((stakes, ExistingUser(userInfo))) =>
    onQuerySuccess({user: user, stakes: stakes, userInfo: userInfo})
  | GraphError(msg) => onQueryError(msg)
  | Loading => <Loader />
  }
}

let default = make
