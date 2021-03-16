open UserUI
open DataHooks

module UsersBalances = {
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
          ->Array.map(({name, isLong, tokenBalance, tokensValue}) =>
            <UserMarketBox
              name
              isLong
              tokens={FormatMoney.formatEther(tokenBalance)}
              value={FormatMoney.formatEther(tokensValue)}>
              <UserMarketStakeOrRedeem />
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

module User = {
  @ocaml.doc(`Represents all the data required to render the user page.`)
  type userData = {
    user: string,
    stakes: array<Queries.UsersStakes.UsersStakes_inner.t_currentStakes>,
  }

  let onQueryError = (msg: string) => {
    <UserContainer> {`Error: ${msg}`->React.string} </UserContainer>
  }

  let onQuerySuccess = ({stakes, user}: userData) => {
    <UserContainer>
      <UserBanner />
      <UserColumnContainer>
        <UserColumn>
          <UserColumnCard>
            <UserProfileHeader name="moose-code" level="1" />
            <UserColumnTextList>
              <UserColumnText head=`📮 Address` body=`0x1234...1234` />
              <UserColumnText head=`🎉 Joined` body=`03/02/2021` />
              <UserColumnText head=`⛽ Gas used` body=`6,789,000` />
              <UserColumnText head=`🏃 No. txs` body=`11` />
              <UserColumnText icon="/img/discord.png" head=`Discord` body=`✅` />
            </UserColumnTextList>
          </UserColumnCard>
        </UserColumn>
        <UserColumn>
          <UsersBalances userId=user /> <br /> <UserStakesCard stakes={stakes} />
        </UserColumn>
        <UserColumn>
          <UserColumnCard>
            <UserColumnHeader> {`Float rewards 🔥`->React.string} </UserColumnHeader>
            <UserFloatBox accruing=`3.14159265` balance=`100.04` minted=`107.83` />
          </UserColumnCard>
        </UserColumn>
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

    let activeStakes = useStakesForUser(~userId=user)

    switch activeStakes {
    | Response(stakes) => onQuerySuccess({user: user, stakes: stakes})
    | GraphError(msg) => onQueryError(msg)
    | Loading => <Loader />
    }
  }
}

let default = () => <User />
