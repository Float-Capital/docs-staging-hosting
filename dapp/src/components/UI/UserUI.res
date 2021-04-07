open Globals

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
    <div className=`bg-white w-full bg-opacity-75 rounded-lg shadow-lg p-2 mb-2 md:mb-4`>
      {children}
    </div>
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
  let make = (~address: string) => {
    // let name = `moose-code` // TODO: get from graph
    // let level = Ethers.BigNumber.fromInt(1) // TODO: get from graph

    <div className="w-full flex flex-row justify-around">
      <div
        className="w-24 h-24 rounded-full border-2 border-light-purple flex items-center justify-center">
        // <img className="inline h-10" src="/img/mario.png" />
        <img className="inline h-10 rounded" src={Blockies.makeBlockie(address)} />
      </div>
      // <div className="flex flex-col text-center justify-center">
      //   <div> {name->React.string} </div>
      //   <div> {`Lvl. ${level->Ethers.BigNumber.toString}`->React.string} </div>
      // </div>
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
    <div className=`mb-1`>
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
        {(isLong ? `Long↗️` : `Short↘️`)->React.string}
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
  let make = (~synthAddress) => {
    // TODO: fix these URLs once redeeming gets implemented
    let router = Next.Router.useRouter()
    let stake = _ =>
      router->Next.Router.push(`/stake?tokenAddress=${synthAddress->Ethers.Utils.ethAdrToLowerStr}`)
    let redeem = _ =>
      router->Next.Router.push(
        `/redeem?tokenAddress=${synthAddress->Ethers.Utils.ethAdrToLowerStr}`,
      )

    <div className=`flex flex-col`>
      <Button.Tiny onClick={stake}> {`stake`} </Button.Tiny>
      <Button.Tiny onClick={redeem}> {`redeem`} </Button.Tiny>
    </div>
  }
}

module UserMarketUnstake = {
  @react.component
  let make = (~synthAddress, ~userId) => {
    // TODO: fix these URLs once unstaking gets implemented
    let router = Next.Router.useRouter()
    let synthAddressStr = synthAddress->ethAdrToLowerStr
    let showUnstakeModal =
      router.query
      ->Js.Dict.get("unstake")
      ->Option.mapWithDefault(false, address => address == synthAddressStr)

    let openUnstakeModal = _ => {
      router.query->Js.Dict.set("unstake", synthAddressStr)
      router->Next.Router.pushObjShallow({pathname: router.pathname, query: router.query})
    }
    let closeUnstakeModal = _ => {
      Js.Dict.unsafeDeleteKey(. router.query, "unstake")
      router->Next.Router.pushObjShallow({pathname: router.pathname, query: router.query})
    }

    let optLoggedInUser = RootProvider.useCurrentUser()
    let isCurrentUser =
      optLoggedInUser->Option.mapWithDefault(false, user => user->ethAdrToLowerStr == userId)

    <div className=`flex flex-col`>
      <span className="text-xxs self-center"> <i> {`4 days ago`->React.string} </i> </span>
      {isCurrentUser
        ? <>
            <Button.Tiny onClick={openUnstakeModal}> {`unstake`} </Button.Tiny>
            {showUnstakeModal
              ? <Modal closeModal=closeUnstakeModal> <Unstake tokenId=synthAddressStr /> </Modal>
              : React.null}
          </>
        : React.null}
    </div>
  }
}

module UserStakesCard = {
  @react.component
  let make = (~stakes, ~userId) => {
    let totalValue = ref(CONSTANTS.zeroBN)
    let stakeBoxes = Js.Array.mapi((stake: Queries.CurrentStakeDetailed.t, i) => {
      let key = `user-stakes-${Belt.Int.toString(i)}`
      let syntheticToken = stake.currentStake.syntheticToken
      let addr = syntheticToken.id->Ethers.Utils.getAddressUnsafe
      let name = syntheticToken.syntheticMarket.symbol
      let tokens = syntheticToken.totalStaked->FormatMoney.formatEther
      let isLong = syntheticToken.tokenType->Obj.magic == "Long"
      let price = syntheticToken.latestPrice.price.price
      let value =
        stake.currentStake.syntheticToken.totalStaked
        ->Ethers.BigNumber.mul(price)
        ->Ethers.BigNumber.div(CONSTANTS.tenToThe18)
      totalValue := Ethers.BigNumber.add(totalValue.contents, value)

      <UserMarketBox key name isLong tokens value={value->FormatMoney.formatEther}>
        <UserMarketUnstake synthAddress={addr} userId />
      </UserMarketBox>
    }, stakes)->React.array

    <UserColumnCard>
      <UserColumnHeader> {`Staked assets 🔐`->React.string} </UserColumnHeader>
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

module UserFloatCard = {
  @react.component
  let make = (~userId, ~stakes) => {
    let synthTokens = stakes->Array.map((stake: Queries.CurrentStakeDetailed.t) => {
      stake.currentStake.syntheticToken.id
    })

    let floatBalances = DataHooks.useFloatBalancesForUser(~userId)
    let claimableFloat = DataHooks.useTotalClaimableFloatForUser(~userId, ~synthTokens)
    let optLoggedInUser = RootProvider.useCurrentUser()
    let isCurrentUser =
      optLoggedInUser->Option.mapWithDefault(false, user => user->ethAdrToLowerStr == userId)

    <UserColumnCard>
      <UserColumnHeader>
        <div className="flex flex-row items-center justify-center">
          <h3> {`Float rewards`->React.string} </h3>
          <img src="/img/float-token-coin-v3.svg" className="ml-2 h-5" />
        </div>
      </UserColumnHeader>
      {switch DataHooks.liftGraphResponse2(floatBalances, claimableFloat) {
      | Loading => <MiniLoader />
      | GraphError(msg) => msg->React.string
      | Response((floatBalances, (totalClaimable, totalPredicted))) => {
          let floatBalance = floatBalances.floatBalance->FormatMoney.formatEther(~digits=6)
          let floatMinted = floatBalances.floatMinted->FormatMoney.formatEther(~digits=6)
          let floatAccrued =
            totalClaimable->Ethers.BigNumber.add(totalPredicted)->FormatMoney.formatEther(~digits=6)

          <div
            className=`w-11/12 px-2 mx-auto mb-2 border-2 border-light-purple rounded-lg z-10 shadow`>
            <UserColumnTextList>
              <UserColumnText head=`Float accruing` body={floatAccrued} />
              <UserColumnText head=`Float balance` body={floatBalance} />
              <UserColumnText head=`Float minted` body={floatMinted} />
            </UserColumnTextList>
            {isCurrentUser
              ? <div className=`flex justify-around flex-row my-1`>
                  {`🌊`->React.string}
                  <ClaimFloat tokenAddresses=synthTokens />
                  <Tooltip
                    tip={`Claiming float is still under development, only partial withdrawals are possible currently`}
                  />
                  {`🌊`->React.string}
                </div>
              : React.null}
          </div>
        }
      }}
    </UserColumnCard>
  }
}
