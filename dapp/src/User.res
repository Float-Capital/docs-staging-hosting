open UserUI
open DataHooks
open Masonry

module UserBalancesCard = {
  @react.component
  let make = (~userId) => {
    /*
    TODO:
    * Use the nicer way to get token prices: https://github.com/float-capital/monorepo/issues/228
    * calculate the correct estimated value
    * get the total value of the users tokens
 */
    let usersTokensQuery = DataHooks.useUsersBalances(~userId)

    <UserColumnCard>
      <UserColumnHeader>
        {`Synthetic assets`->React.string} <img className="inline h-5 ml-2" src="/img/coin.png" />
      </UserColumnHeader>
      {switch usersTokensQuery {
      | Loading => <div className="m-auto"> <MiniLoader /> </div>
      | GraphError(string) => string->React.string
      | Response({totalBalance, balances}) => <>
          <UserColumnTextCenter>
            <UserColumnText
              head=`💰 Synth value` body={`$${totalBalance->FormatMoney.formatEther}`}
            />
          </UserColumnTextCenter>
          <br />
          {balances
          ->Array.keep(({tokenBalance}) => !(tokenBalance->Ethers.BigNumber.eq(CONSTANTS.zeroBN)))
          ->Array.map(({addr, name, isLong, tokenBalance, tokensValue}) =>
            <UserMarketBox
              key={`${name}-${isLong ? "long" : "short"}`}
              name
              isLong
              tokens={FormatMoney.formatEther(tokenBalance)}
              value={FormatMoney.formatEther(tokensValue)}>
              <UserMarketStakeOrRedeem synthAddress={addr->Ethers.Utils.ethAdrToLowerStr} isLong />
            </UserMarketBox>
          )
          ->React.array}
        </>
      }}
    </UserColumnCard>
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
    let joinedStr = userInfo.joinedAt->DateFns.format("do MMM ''yy")
    let txStr = userInfo.transactionCount->Ethers.BigNumber.toString
    let gasStr = userInfo.gasUsed->Ethers.BigNumber.toString->FormatMoney.formatInt

    <UserColumnCard>
      <UserProfileHeader address={addressStr} />
      <UserColumnTextList>
        <div className="p-4">
          <UserColumnText head=`📮 Address` body={addressStr} />
          <UserColumnText head=`🎉 Joined` body={joinedStr} />
          <UserColumnText head=`⛽ Gas used` body={gasStr} />
          <UserColumnText head=`🏃 No. txs` body={txStr} />
        </div>
        // TODO: fetch from graph somehow
        // <UserColumnText icon="/img/discord.png" head=`Discord` body=`✅` />
      </UserColumnTextList>
    </UserColumnCard>
  }
}

module User = {
  @ocaml.doc(`Represents all the data required to render the user page.`)
  type userData = {
    user: string,
    userInfo: DataHooks.basicUserInfo,
    stakes: array<Queries.CurrentStakeDetailed.t>,
  }

  let onQueryError = (msg: string) => {
    <UserContainer> {`Error: ${msg}`->React.string} </UserContainer>
  }

  let onQuerySuccess = (data: userData) => {
    <UserContainer>
      // <UserBanner />
      <Container>
        <Divider>
          <UserProfileCard userInfo={data.userInfo} />
          <UserFloatCard userId={data.user} stakes={data.stakes} />
        </Divider>
        <Divider> <UserBalancesCard userId={data.user} /> </Divider>
        <Divider> <UserStakesCard stakes={data.stakes} userId={data.user} /> </Divider>
      </Container>
    </UserContainer>
  }

  @react.component
  let make = () => {
    let optCurrentUser = RootProvider.useCurrentUser()
    let router = Next.Router.useRouter()
    let user = switch Js.Dict.get(router.query, `user`) {
    | None => `no user provided` // TODO: something more useful!
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
    | Response((_stakes, NewUser)) => <>
        <UserColumnCard>
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
                    <Next.Link href="/markets">
                      <Button.Small> {`MARKETS`} </Button.Small>
                    </Next.Link>
                  </div>
                </>
              : notCurrentUserMessage()
          | None => notCurrentUserMessage()
          }}
        </UserColumnCard>
      </>
    | Response((stakes, ExistingUser(userInfo))) =>
      onQuerySuccess({user: user, stakes: stakes, userInfo: userInfo})
    | GraphError(msg) => onQueryError(msg)
    | Loading => <Loader />
    }
  }
}

let default = () => <User />
