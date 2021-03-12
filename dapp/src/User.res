open UserUI
open DataHooks

module User = {
  @ocaml.doc(`Represents all the data required to render the user page.`)
  type userData = {
    user: string,
    stakes: array<Queries.UsersStakes.UsersStakes_inner.t_currentStakes>,
  }

  let onQueryError = (msg: string) => {
    <UserContainer> {`Error: ${msg}`->React.string} </UserContainer>
  }

  let onQuerySuccess = (data: userData) => {
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
          <UserColumnCard>
            <UserColumnHeader>
              {`Synthetic Assets`->React.string}
              <img className="inline h-5 ml-2" src="/img/coin.png" />
            </UserColumnHeader>
            <UserColumnTextCenter>
              <UserColumnText head=`💰 Synth value` body=`$9,123` />
            </UserColumnTextCenter>
            <br />
            <UserMarketBox name=`FTSE 100` isLong={true} tokens=`23.81` value=`450`>
              <UserMarketStakeOrRedeem />
            </UserMarketBox>
            <br />
            <UserColumnTextCenter>
              <span className="text-sm"> {`💸 Why not mint some more? 💸`->React.string} </span>
            </UserColumnTextCenter>
          </UserColumnCard>
          <br />
          <UserStakesCard stakes={data.stakes} />
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
