open UserUI
open DataHooks
open Masonry

module UserBalancesCard = {
  //create your forceUpdate hook
  let useRerender = () => {
    let (_value, setValue) = React.useState(_ => 0) // integer state
    () => setValue(value => value + 1) // update the state to force render
  }

  @react.component
  let make = (~userId) => {
    let usersTokensQuery = DataHooks.useUsersBalances(~userId)
    let usersPendingMintsQuery = DataHooks.useUsersPendingMints(~userId)
    let usersConfirmedMintsQuery = DataHooks.useUsersConfirmedMints(~userId)

    let rerender = useRerender()
    let oracleHeartbeatForMarket = 300 // 5min // TODO
    // let lastOracleTimestamp = (Js.Date.now() /. 1000.)->int_of_float // TODO

    <UserColumnCard>
      <UserColumnHeader>
        {`Synthetic assets`->React.string} <img className="inline h-5 ml-2" src="/img/coin.png" />
      </UserColumnHeader>
      {switch usersConfirmedMintsQuery {
      | Loading => <div className="m-auto"> <Loader.Mini /> </div>
      | GraphError(string) => string->React.string
      | Response(confirmedMint) => <>
          {confirmedMint->Array.length > 0
            ? <UserColumnTextCenter>
                <UserColumnText head=`✅ Confirmed synths` body={``} /> <br />
              </UserColumnTextCenter>
            : React.null}
          {confirmedMint
          ->Array.map(({marketIndex, isLong, amount}) =>
            <UserSynthConfirmedBox
              name={(marketIndex->Ethers.BigNumber.toNumber->Backend.getMarketInfoUnsafe).name}
              isLong
              daiSpend=amount
              marketIndex
            />
          )
          ->React.array}
        </>
      }}
      {switch usersPendingMintsQuery {
      | Loading => <div className="m-auto"> <Loader.Mini /> </div>
      | GraphError(string) => string->React.string
      | Response(pendingMint) => <>
          {pendingMint->Array.length > 0
            ? <UserColumnTextCenter>
                <UserColumnText head=`⏳ Pending synths` body={``} /> <br />
              </UserColumnTextCenter>
            : React.null}
          {pendingMint
          ->Array.map(({marketIndex, isLong, amount, confirmedTimestamp}) =>
            <UserPendingBox
              name={(marketIndex->Ethers.BigNumber.toNumber->Backend.getMarketInfoUnsafe).name}
              isLong
              daiSpend=amount
              txConfirmedTimestamp={confirmedTimestamp->Ethers.BigNumber.toNumber}
              nextPriceUpdateTimestamp={confirmedTimestamp->Ethers.BigNumber.toNumber +
                oracleHeartbeatForMarket} // TODO: pull approx oracle next timestamp
              rerenderCallback=rerender
            />
          )
          ->React.array}
        </>
      }}
      {switch usersTokensQuery {
      | Loading => <div className="m-auto"> <Loader.Mini /> </div>
      | GraphError(string) => string->React.string
      | Response({totalBalance, balances}) => <>
          <UserColumnTextCenter>
            <UserColumnText
              head=`💰 Synth value` body={`$${totalBalance->Misc.NumberFormat.formatEther}`}
            />
          </UserColumnTextCenter>
          {balances
          ->Array.keep(({tokenBalance}) => !(tokenBalance->Ethers.BigNumber.eq(CONSTANTS.zeroBN)))
          ->Array.map(({addr, name, symbol, isLong, tokenBalance, tokensValue, metadata}) =>
            <UserTokenBox
              key={`${name}-${isLong ? "long" : "short"}`}
              name
              isLong
              tokenAddress={addr}
              symbol
              tokens={Misc.NumberFormat.formatEther(tokenBalance)}
              value={Misc.NumberFormat.formatEther(tokensValue)}
              metadata>
              <UserMarketStakeOrRedeem synthAddress={addr->Ethers.Utils.ethAdrToLowerStr} isLong />
            </UserTokenBox>
          )
          ->React.array}
        </>
      }}
    </UserColumnCard>
  }
}

let getUsersTotalStakeValue = (~stakes) => {
  let totalStakedValue = ref(CONSTANTS.zeroBN)

  Array.forEach(stakes, (stake: Queries.CurrentStakeDetailed.t) => {
    let syntheticToken = stake.currentStake.syntheticToken
    let price = syntheticToken.latestPrice.price.price
    let value =
      stake.currentStake.amount
      ->Ethers.BigNumber.mul(price)
      ->Ethers.BigNumber.div(CONSTANTS.tenToThe18)
    totalStakedValue := totalStakedValue.contents->Ethers.BigNumber.add(value)
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
      | Response({totalBalance}) =>
        <UserTotalValue
          totalValueNameSup=`Portfolio`
          totalValueNameSub=`Value`
          totalValue={totalBalance->Ethers.BigNumber.add(totalStakedValue.contents)}
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

module UserProfileCard = {
  @react.component
  let make = (~userInfo) => {
    let addressStr = DisplayAddress.ellipsifyMiddle(
      ~inputString=userInfo.id,
      ~maxLength=8,
      ~trailingCharacters=3,
    )
    let joinedStr = userInfo.joinedAt->DateFns.format(#"do MMM ''yy")
    let txStr = userInfo.transactionCount->Ethers.BigNumber.toString
    let gasStr = userInfo.gasUsed->Ethers.BigNumber.toString->Misc.NumberFormat.formatInt

    <UserColumnCard>
      <UserProfileHeader address={addressStr} />
      <UserColumnTextList>
        <div className="p-4">
          <UserColumnText head=`📮 Address` body={addressStr} />
          <UserColumnText head=`🎉 Joined` body={joinedStr} />
          <UserColumnText head=`⛽ Gas used` body={gasStr} />
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
                      <Next.Link href="/"> <Button.Small> {`MARKETS`} </Button.Small> </Next.Link>
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
