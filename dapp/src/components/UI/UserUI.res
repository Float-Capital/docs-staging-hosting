open Globals

module UserContainer = {
  @react.component
  let make = (~children) => {
    <div className=`min-w-3/4 flex flex-col items-center`> {children} </div>
  }
}

module UserTotalValue = {
  @react.component
  let make = (~totalValueNameSup, ~totalValueNameSub, ~totalValue) => {
    let isABaller = totalValue->Ethers.BigNumber.gte(CONSTANTS.oneHundredThousandInWei) // in the 100 000+ range
    let isAWhale = totalValue->Ethers.BigNumber.gte(CONSTANTS.oneMillionInWei) // in the 1 000 000+ range
    let shouldBeSmallerText = isABaller
    let shouldntHaveDecimals = isAWhale
    <div
      className=`p-5 mb-5 flex items-center justify-between bg-white bg-opacity-75 rounded-lg shadow-lg`>
      <div className="flex flex-col">
        <span className=`text-lg font-bold leading-tight`> {totalValueNameSup->React.string} </span>
        <span className=`text-lg font-bold leading-tight`> {totalValueNameSub->React.string} </span>
      </div>
      <div>
        <span className={`${shouldBeSmallerText ? "text-xl" : "text-2xl"} text-primary`}>
          {`$${totalValue->FormatMoney.formatEther(
              ~digits={shouldntHaveDecimals ? 1 : 2},
            )}`->React.string}
        </span>
      </div>
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

let threeDotsSvg =
  <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24">
    <path
      fillRule="evenodd"
      d="M12 7a2 2 0 1 1 0-4 2 2 0 0 1 0 4zm0 7a2 2 0 1 1 0-4 2 2 0 0 1 0 4zm0 7a2 2 0 1 1 0-4 2 2 0 0 1 0 4z"
    />
  </svg>

module MetamaskMenu = {
  type doc
  type event = {target: Dom.element}

  @scope("document") @val
  external addDocumentEventListner: (string, event => unit) => unit = "addEventListener"
  @scope("document") @val
  external removeDocumentEventListner: (string, event => unit) => unit = "removeEventListener"
  @send
  external contains: (Dom.element, Dom.element) => bool = "contains"

  let addClickListener = addDocumentEventListner("mousedown")
  let removeClickListener = removeDocumentEventListner("mousedown")

  @react.component
  let make = (~tokenAddress, ~tokenName) => {
    let (show, setShow) = React.useState(_ => false)
    let router = Next.Router.useRouter()

    let initialShowPing = switch Js.Dict.get(router.query, `minted`) {
    | None => false
    | Some(addr) => addr == tokenAddress
    }

    let (showPing, setShowPing) = React.useState(_ => false)

    React.useEffect1(_ => {
      if initialShowPing {
        setShowPing(_ => true)
        let _ = Js.Global.setTimeout(_ => setShowPing(_ => false), 6000)
        None
      } else {
        None
      }
    }, [initialShowPing])

    let wrapper = React.useRef(Js.Nullable.null)
    let dots = React.useRef(Js.Nullable.null)
    React.useEffect1(_ => {
      let handleMousedown = ({target}) => {
        let _ =
          wrapper.current
          ->Js.Nullable.toOption
          ->Option.mapWithDefault((), element => {
            let _ =
              dots.current
              ->Js.Nullable.toOption
              ->Option.mapWithDefault((), dotsElement => {
                if !(element->contains(target)) && !(dotsElement->contains(target)) {
                  setShow(_ => false)
                } else {
                  ()
                }
              })
          })
      }
      addClickListener(handleMousedown)
      Some(_ => removeClickListener(handleMousedown))
    }, [wrapper])
    if InjectedEthereum.isMetamask() {
      <div className="relative">
        <div
          className="absolute top-1 w-4 h-4 cursor-pointer z-20"
          onClick={_ => {
            setShow(show => !show)
            setShowPing(_ => false)
          }}
          ref={ReactDOM.Ref.domRef(dots)}>
          {threeDotsSvg}
        </div>
        {if show {
          <div
            className="absolute bottom-full left-1 rounded-lg z-30 text-xs py-1 px-1 w-20 bg-white shadow-lg flex justify-center cursor-pointer"
            ref={ReactDOM.Ref.domRef(wrapper)}>
            <AddToMetamask tokenAddress tokenSymbol={tokenName} callback={_ => setShow(_ => false)}>
              {"Add to "->React.string} <img src="/icons/metamask.svg" className="h-5 ml-1" />
            </AddToMetamask>
          </div>
        } else {
          React.null
        }}
        {if showPing {
          <div
            className={`absolute left-1 top-1 z-0 animate-ping inline-flex h-3 w-3 mr-4 rounded-full bg-green-500 opacity-90`}
          />
        } else {
          React.null
        }}
      </div>
    } else {
      React.null
    }
  }
}

module UserMarketBox = {
  @react.component
  let make = (
    ~name,
    ~isLong,
    ~tokens,
    ~value,
    ~tokenAddress=CONSTANTS.zeroAddress,
    ~metamaskMenu=false,
    ~symbol="",
    ~children,
  ) => {
    <div
      className=`flex w-11/12 mx-auto p-2 mb-2 border-2 border-light-purple rounded-lg z-10 shadow relative`>
      {if metamaskMenu {
        <div className="absolute left-1 top-2">
          <MetamaskMenu
            tokenAddress={tokenAddress->Ethers.Utils.ethAdrToStr}
            tokenName={`${isLong ? "fu" : "fd"}${symbol}`}
          />
        </div>
      } else {
        React.null
      }}
      <div className=`pl-3 w-1/3 text-sm self-center`>
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
  let make = (~synthAddress, ~isLong) => {
    let marketIdResponse = DataHooks.useTokenMarketId(~tokenId=synthAddress)

    let marketId =
      DataHooks.Util.graphResponseToOption(marketIdResponse)->Option.getWithDefault("1")

    let router = Next.Router.useRouter()
    let stake = _ =>
      router->Next.Router.push(
        `/markets?marketIndex=${marketId}&actionOption=${isLong ? "long" : "short"}&tab=stake`,
      )
    let redeem = _ =>
      router->Next.Router.push(
        `/markets?marketIndex=${marketId}&actionOption=${isLong ? "long" : "short"}&tab=redeem`,
      )

    <div className=`flex flex-col`>
      <Button.Tiny onClick={stake}> {`stake`} </Button.Tiny>
      <Button.Tiny onClick={redeem}> {`redeem`} </Button.Tiny>
    </div>
  }
}

module UserMarketUnstake = {
  @react.component
  let make = (~synthAddress, ~userId, ~isLong, ~whenStr, ~creationTxHash) => {
    let synthAddressStr = synthAddress->ethAdrToLowerStr

    let marketIdResponse = DataHooks.useTokenMarketId(~tokenId=synthAddressStr)

    let marketId =
      DataHooks.Util.graphResponseToOption(marketIdResponse)->Option.getWithDefault("1")

    let router = Next.Router.useRouter()
    let unstake = _ =>
      router->Next.Router.push(
        `/markets?marketIndex=${marketId}&tab=unstake&actionOption=${isLong ? "long" : "short"}`,
      )

    let optLoggedInUser = RootProvider.useCurrentUser()
    let isCurrentUser =
      optLoggedInUser->Option.mapWithDefault(false, user => user->ethAdrToLowerStr == userId)

    <div className=`flex flex-col`>
      <a
        href={`${Config.blockExplorer}/tx/${creationTxHash}`}
        target="_"
        rel="noopener noreferrer"
        className="inline text-xxs self-center hover:opacity-75">
        <i> {`${whenStr} ago`->React.string} </i>
      </a>
      {isCurrentUser ? <Button.Tiny onClick={unstake}> {`unstake`} </Button.Tiny> : React.null}
    </div>
  }
}

module UserStakesCard = {
  @react.component
  let make = (~stakes, ~userId) => {
    let stakeBoxes = Js.Array.mapi((stake: Queries.CurrentStakeDetailed.t, i) => {
      let key = `user-stakes-${Belt.Int.toString(i)}`
      let syntheticToken = stake.currentStake.syntheticToken
      let addr = syntheticToken.id->Ethers.Utils.getAddressUnsafe
      let name = syntheticToken.syntheticMarket.symbol
      let tokens = stake.currentStake.amount->FormatMoney.formatEther
      let isLong = syntheticToken.tokenType->Obj.magic == "Long"
      let price = syntheticToken.latestPrice.price.price
      let whenStr =
        stake.currentStake.timestamp
        ->Ethers.BigNumber.toNumber
        ->Js.Int.toFloat
        ->DateFns.fromUnixTime
        ->DateFns.formatDistanceToNow
      let value =
        stake.currentStake.amount
        ->Ethers.BigNumber.mul(price)
        ->Ethers.BigNumber.div(CONSTANTS.tenToThe18)
      let creationTxHash = stake.currentStake.creationTxHash

      <UserMarketBox key name isLong tokens value={value->FormatMoney.formatEther}>
        <UserMarketUnstake synthAddress={addr} userId isLong whenStr creationTxHash />
      </UserMarketBox>
    }, stakes)->React.array

    <UserColumnCard>
      <UserColumnHeader> {`Staked assets 🔐`->React.string} </UserColumnHeader> {stakeBoxes}
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
              <div className="flex">
                <UserColumnText head=`Float accruing` body={floatAccrued} />
                <span className="ml-1">
                  <Tooltip
                    tip="This is an estimate at the current time, the amount issued may differ due to changes in market liquidity and asset prices."
                  />
                </span>
              </div>
              <UserColumnText head=`Float balance` body={floatBalance} />
              <UserColumnText head=`Float minted` body={floatMinted} />
            </UserColumnTextList>
            {isCurrentUser
              ? <div className=`flex justify-around flex-row my-1`>
                  {`🌊`->React.string}
                  <ClaimFloat tokenAddresses=synthTokens />
                  {`🌊`->React.string}
                </div>
              : React.null}
          </div>
        }
      }}
    </UserColumnCard>
  }
}
