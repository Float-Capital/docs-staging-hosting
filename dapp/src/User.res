open UserUI
open DataHooks

module UserBalancesCard = {
  @react.component
  let make = (~userId) => {
    /*
    TODO:
    * Use the nicer way to get token prices: https://github.com/avolabs-io/longshort/issues/228
    * calculate the correct estimated value
    * get the total value of the users tokens
 */
    let usersTokensQuery = DataHooks.useUsersBalances(~userId)

    <UserColumnCard>
      <UserColumnHeader>
        {`Synthetic Assets`->React.string} <img className="inline h-5 ml-2" src="/img/coin.png" />
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
          ->Array.map(({addr, name, isLong, tokenBalance, tokensValue}) =>
            <UserMarketBox
              key={`${name}-${isLong ? "long" : "short"}`}
              name
              isLong
              tokens={FormatMoney.formatEther(tokenBalance)}
              value={FormatMoney.formatEther(tokensValue)}>
              <UserMarketStakeOrRedeem synthAddress={addr} />
            </UserMarketBox>
          )
          ->React.array}
        </>
      }}
      <br />
      <UserColumnTextCenter>
        <span className="text-sm"> {`💸 Why not mint some more? 💸`->React.string} </span>
      </UserColumnTextCenter>
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
    let joinedStr = userInfo.joinedAt->DateFns.format("P")
    let txStr = userInfo.transactionCount->Ethers.BigNumber.toString
    let gasStr = userInfo.gasUsed->Ethers.BigNumber.toString->FormatMoney.formatInt

    <UserColumnCard>
      <UserProfileHeader />
      <UserColumnTextList>
        <UserColumnText head=`📮 Address` body={addressStr} />
        <UserColumnText head=`🎉 Joined` body={joinedStr} />
        <UserColumnText head=`⛽ Gas used` body={gasStr} />
        <UserColumnText head=`🏃 No. txs` body={txStr} />
        // TODO: fetch from graph somehow
        <UserColumnText icon="/img/discord.png" head=`Discord` body=`✅` />
      </UserColumnTextList>
    </UserColumnCard>
  }
}

module User = {
  @ocaml.doc(`Represents all the data required to render the user page.`)
  type userData = {
    user: string,
    userInfo: DataHooks.basicUserInfo,
    stakes: array<Queries.UsersStakes.UsersStakes_inner.t_currentStakes>,
  }

  let onQueryError = (msg: string) => {
    <UserContainer> {`Error: ${msg}`->React.string} </UserContainer>
  }

  let onQuerySuccess = (data: userData) => {
    <UserContainer>
      // <UserBanner />
      <UserColumnContainer>
        <UserColumn> <UserProfileCard userInfo={data.userInfo} /> </UserColumn>
        <UserColumn>
          <UserBalancesCard userId={data.user} />
          <br />
          <UserStakesCard stakes={data.stakes} userId={data.user} />
        </UserColumn>
        <UserColumn> <UserFloatCard userId={data.user} stakes={data.stakes} /> </UserColumn>
      </UserColumnContainer>
    </UserContainer>
  }

  @react.component
  let make = () => {
    let router = Next.Router.useRouter()
    let user = switch Js.Dict.get(router.query, `user`) {
    | None => `no user provided` // TODO: something more useful!
    | Some(userStr) => userStr->Js.String.toLowerCase
    }

    let stakesQuery = useStakesForUser(~userId=user)
    let userInfoQuery = useBasicUserInfo(~userId=user)

    switch liftGraphResponse2(stakesQuery, userInfoQuery) {
    | Response((_stakes, NewUser)) => <>
        <a target="_" href={`${Config.defaultBlockExplorer}address/${user}`}>
          <h1> {"This user has never interacted with float.capital"->React.string} </h1>
        </a>
      </>
    | Response((stakes, ExistingUser(userInfo))) =>
      onQuerySuccess({user: user, stakes: stakes, userInfo: userInfo})
    | GraphError(msg) => onQueryError(msg)
    | Loading => <Loader />
    }
  }
}

let default = () => <User />
