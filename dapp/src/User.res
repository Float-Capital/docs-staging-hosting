open UserUI

module User = {
  let onQueryError = user => {
    <UserContainer> {`Error loading user data for: ${user}`->React.string} </UserContainer>
  }

  let onQuerySuccess = (_, _) => {
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
        </UserColumn>
        <UserColumn>
          <UserColumnCard>
            <UserColumnHeader> {`Staking 🔥`->React.string} </UserColumnHeader>
            <UserFloatBox accruing=`3.14159265` balance=`100.04` minted=`107.83` />
            <UserColumnTextCenter>
              <UserColumnText head=`💰 Staked value` body=`$15,678` />
            </UserColumnTextCenter>
            <br />
            <UserColumnHeader subheader={true}> {`Stakes`->React.string} </UserColumnHeader>
            <UserMarketBox name=`FTSE 100` isLong={true} tokens=`2.81` value=`450`>
              <UserMarketUnstake />
            </UserMarketBox>
            <UserMarketBox name=`FTSE 100` isLong={false} tokens=`21.24` value=`400`>
              <UserMarketUnstake />
            </UserMarketBox>
          </UserColumnCard>
        </UserColumn>
      </UserColumnContainer>
    </UserContainer>
  }

  @react.component
  let make = () => {
    let router = Next.Router.useRouter()
    let user = switch Js.Dict.get(router.query, `user`) {
    | None => `no user provided`
    | Some(userStr) => userStr
    }
    let userQuery = Queries.UserQuery.use({
      userId: user,
    })

    switch userQuery {
    | {error: Some(_)} => onQueryError(user)
    | {data: Some(_)} => onQuerySuccess(user, `asdf`)
    | _ => <Loader />
    }
  }
}

let default = () => <User />
