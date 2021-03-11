module UserContainer = {
  @react.component
  let make = (~children) => {
    <div className=`min-w-3/4 flex flex-col items-center`> {children} </div>
  }
}

module UserBanner = {
  @react.component
  let make = () => {
    <div className=`p-5 mt-7 flex bg-white bg-opacity-75 rounded-lg shadow-lg`>
      <span className=`text-sm`> {`💲 BUSD Balance: $1234.todo`->React.string} </span>
      <span className=`text-sm ml-20`>
        {`🏦 Total Value in Float: $1234.todo`->React.string}
      </span>
    </div>
  }
}

module UserColumnContainer = {
  @react.component
  let make = (~children) => {
    <div className=`w-full flex mt-1`> {children} </div>
  }
}

module UserColumn = {
  @react.component
  let make = (~children) => {
    <div className=`m-4 w-1/3`> {children} </div>
  }
}

module UserColumnCard = {
  @react.component
  let make = (~children) => {
    <div className=`bg-white w-full bg-opacity-75 rounded-lg shadow-lg p-4`> {children} </div>
  }
}

module UserColumnHeader = {
  @react.component
  let make = (~children, ~subheader=false) => {
    <h1 className={`text-center ${subheader ? "text-base" : "text-lg"} font-alphbeta mb-4 mt-2`}>
      {children}
    </h1>
  }
}

module UserProfileHeader = {
  @react.component
  let make = (~name, ~level) => {
    <div className="w-full flex flex-row justify-around">
      <div
        className="w-24 h-24 rounded-full border-2 border-light-purple flex items-center justify-center">
        <img className="inline h-10" src="/img/mario.png" />
      </div>
      <div className="flex flex-col text-center justify-center">
        <div> {name->React.string} </div> <div> {`Lvl. ${level}`->React.string} </div>
      </div>
    </div>
  }
}

module UserColumnTextList = {
  @react.component
  let make = (~children) => {
    <div className=`flex flex-col mt-3`> {children} </div>
  }
}

module UserColumnTextCenter = {
  @react.component
  let make = (~children) => {
    <div className=`flex flex-col items-center`> {children} </div>
  }
}

module UserColumnText = {
  @react.component
  let make = (~icon=?, ~head, ~body=``) => {
    <div className=`ml-4 mb-1`>
      {switch icon {
      | Some(path) => <img className=`inline mr-1 h-5` src={path} />
      | None => ""->React.string
      }}
      <span className=`text-sm`> {`${head}: `->React.string} </span>
      {body->React.string}
    </div>
  }
}

module UserMarketBox = {
  @react.component
  let make = (~name, ~isLong, ~tokens, ~value, ~children) => {
    <div
      className=`flex w-11/12 mx-auto p-2 mb-2 border-2 border-light-purple rounded-lg z-10 shadow`>
      <div className=`w-1/3 text-sm self-center`>
        {name->React.string}
        <br className=`mt-1` />
        {(isLong ? `Long ↗️` : `Short ↘️`)->React.string}
      </div>
      <div className=`w-1/3 text-sm mx-2 text-center self-center`>
        <span className=`text-sm`> {tokens->React.string} </span>
        <span className=`text-xs`> {`tkns`->React.string} </span>
        <br className=`mt-1` />
        <span className=`text-xs`> {Js.String.concat(value, `~$`)->React.string} </span>
      </div>
      <div className=`w-1/3 self-center`> {children} </div>
    </div>
  }
}

module UserMarketStakeOrRedeem = {
  @react.component
  let make = () => {
    <div className=`flex flex-col`>
      <Button variant="tiny" onClick={_ => ()}> {`stake`} </Button>
      <Button variant="tiny" onClick={_ => ()}> {`redeem`} </Button>
    </div>
  }
}

module UserMarketUnstake = {
  @react.component
  let make = () => {
    <div className=`flex flex-col`>
      <span className="text-xxs self-center"> <i> {`4 days ago`->React.string} </i> </span>
      <Button variant="tiny" onClick={_ => ()}> {`redeem`} </Button>
    </div>
  }
}

module UserStakesCard = {
  @react.component
  let make = (~stakes) => {
    let totalValue = ref(CONSTANTS.zeroBN)
    let stakeBoxes =
      Js.Array.mapi((stake: Queries.UsersStakes.UsersStakes_inner.t_currentStakes, i) => {
        let key = `user-stakes-${Belt.Int.toString(i)}`
        let name = stake.currentStake.syntheticToken.syntheticMarket.symbol
        let tokens = stake.currentStake.syntheticToken.totalStaked->FormatMoney.formatEther
        let isLong = stake.currentStake.syntheticToken.tokenType->Obj.magic == "Long"
        let state = stake.currentStake.syntheticToken.syntheticMarket.latestSystemState
        let value =
          stake.currentStake.syntheticToken.totalStaked
          ->Ethers.BigNumber.mul(isLong ? state.longTokenPrice : state.shortTokenPrice)
          ->Ethers.BigNumber.div(CONSTANTS.tenToThe18)
        totalValue := Ethers.BigNumber.add(totalValue.contents, value)

        <UserMarketBox key name isLong tokens value={value->FormatMoney.formatEther}>
          <UserMarketUnstake />
        </UserMarketBox>
      }, stakes)->React.array

    <UserColumnCard>
      <UserColumnHeader> {`Staking`->React.string} </UserColumnHeader>
      <UserColumnTextCenter>
        <UserColumnText
          head=`💰 Staked value` body={`$${totalValue.contents->FormatMoney.formatEther}`}
        />
      </UserColumnTextCenter>
      <br />
      {stakeBoxes}
    </UserColumnCard>
  }
}

module UserFloatBox = {
  @react.component
  let make = (~accruing, ~balance, ~minted) => {
    <div className=`w-11/12 mx-auto mb-2 border-2 border-light-purple rounded-lg z-10 shadow`>
      <UserColumnTextList>
        <UserColumnText head=`float accruing` body={accruing} />
        <UserColumnText head=`float balance` body={balance} />
        <UserColumnText head=`float minted` body={minted} />
      </UserColumnTextList>
      <div className=`flex justify-around flex-row my-1`>
        {`🌊`->React.string}
        <Button variant="tiny" onClick={_ => ()}> {`claim float`} </Button>
        {`🌊`->React.string}
      </div>
    </div>
  }
}
