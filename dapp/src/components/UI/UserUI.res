open Globals

let {add, mul, div, toNumber, eq, toString} = module(Ethers.BigNumber)

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

module UserContainer = {
  @react.component
  let make = (~children) => {
    <div className=`min-w-3/4 mx-auto max-w-7xl flex flex-col items-center`> {children} </div>
  }
}

module UserTotalValue = {
  @react.component
  let make = (
    ~totalValueNameSup,
    ~totalValueNameSub,
    ~totalValue,
    ~tokenIconUrl=None,
    ~children=React.null,
  ) => {
    let isABaller = totalValue->Ethers.BigNumber.gte(CONSTANTS.oneHundredThousandInWei) // in the 100 000+ range
    let isAWhale = totalValue->Ethers.BigNumber.gte(CONSTANTS.oneMillionInWei) // in the 1 000 000+ range
    let shouldBeSmallerText = isABaller
    let shouldntHaveDecimals = isAWhale
    <div
      className=`relative p-5 mb-5 flex items-center justify-between bg-white bg-opacity-75 rounded-lg shadow-lg`>
      <div className="flex flex-col">
        <span className=`text-lg font-bold leading-tight`> {totalValueNameSup->React.string} </span>
        <span className=`text-lg font-bold leading-tight`> {totalValueNameSub->React.string} </span>
      </div>
      <div>
        <span
          className={`flex flex-row items-center  ${shouldBeSmallerText
              ? "text-xl"
              : "text-2xl"} text-primary`}>
          {`$${totalValue->Misc.NumberFormat.formatEther(
              ~digits={shouldntHaveDecimals ? 1 : 2},
            )}`->React.string}
          {switch tokenIconUrl {
          | Some(iconUrl) => <img src={iconUrl} className="h-6 pl-1" />
          | None => React.null
          }}
        </span>
      </div>
      {children}
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
    <div className="w-full flex flex-row justify-around">
      <div
        className="w-20 h-20 rounded-full border-2 border-light-purple flex items-center justify-center">
        <img className="inline h-10 rounded" src={Blockies.makeBlockie(address)} />
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
    <div className=`mb-1`>
      {switch icon {
      | Some(path) => <img className=`inline mr-2 h-4` src={path} />
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
            <Metamask.AddToken
              tokenAddress tokenSymbol={tokenName} callback={_ => setShow(_ => false)}>
              {"Add to "->React.string} <img src="/icons/metamask.svg" className="h-5 ml-1" />
            </Metamask.AddToken>
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

module UserPercentageGains = {
  type direction = Up | Down | Same
  @send external toFixed: (float, int) => string = "toFixed"
  let directionAndPercentageString = (oldPrice, newPrice) => {
    let priceDirection = if newPrice->Ethers.BigNumber.eq(oldPrice) {
      Same
    } else if newPrice->Ethers.BigNumber.gt(oldPrice) {
      Up
    } else {
      Down
    }

    let diff = switch priceDirection {
    | Up => Ethers.BigNumber.sub(newPrice, oldPrice)
    | Down => Ethers.BigNumber.sub(oldPrice, newPrice)
    | Same => CONSTANTS.zeroBN
    }

    let initialPercentStr = Globals.percentStr(~n=diff, ~outOf=oldPrice)
    let initialPercentFloat = initialPercentStr->Globals.parseFloat
    let flooredPercentFloat =
      Js_math.floor_float((initialPercentFloat +. epsilon_float) *. 100.) /. 100.
    let percentStr = flooredPercentFloat->toFixed(2)
    let percentFloat = percentStr->Globals.parseFloat

    let displayDirection = switch percentFloat {
    | f if f == 0. => Same
    | _ => priceDirection
    }

    (displayDirection, percentStr)
  }
  @react.component
  let make = (~tokenPositionLastUpdated, ~currentSyntheticPrice, ~tokenAddress) => {
    let initialTokenPriceResponse = DataHooks.useTokenPriceAtTime(
      ~tokenAddress,
      ~timestamp=tokenPositionLastUpdated,
    )

    <div className=`flex flex-col items-center justify-center`>
      {switch initialTokenPriceResponse {
      | Response(oldPrice) => {
          let (displayDirection, percentStr) = directionAndPercentageString(
            oldPrice,
            currentSyntheticPrice,
          )

          let (symbol, textClassName) = switch displayDirection {
          | Up => ("+", "text-green-500")
          | Down => ("-", "text-red-500")
          | Same => ("", "text-gray-400")
          }
          <div className={`${textClassName} text-center text-lg`}>
            {`${symbol}${percentStr}%`->React.string}
          </div>
        }
      | Loading => <Loader.Tiny />
      | _ => ``->React.string
      }}
    </div>
  }
}
module UserTokenBox = {
  @react.component
  let make = (~userBalanceData: Queries.UserTokenBalance.t, ~children) => {
    let {
      tokenBalance,
      timeLastUpdated,
      syntheticToken: {
        id,
        tokenType,
        syntheticMarket: {name, symbol},
        latestPrice: {price: {price}},
      },
    } = userBalanceData

    let tokenAddress = id->Ethers.Utils.getAddressUnsafe

    let isLong = tokenType == #Long
    let tokens = Misc.NumberFormat.formatEther(tokenBalance)
    let tokensValue = price->mul(tokenBalance)->div(CONSTANTS.tenToThe18)
    let value = Misc.NumberFormat.formatEther(tokensValue)

    <div
      className=`flex justify-between w-11/12 mx-auto p-2 mb-2 border-2 border-light-purple rounded-lg z-10 shadow relative`>
      <div className="absolute left-1 top-2">
        <MetamaskMenu
          tokenAddress={tokenAddress->Ethers.Utils.ethAdrToStr}
          tokenName={`${isLong ? "fu" : "fd"}${symbol}`}
        />
      </div>
      <div className=`pl-3 text-xs self-center`>
        {name->React.string}
        <br className=`mt-1` />
        {(isLong ? `Long↗️` : `Short↘️`)->React.string}
      </div>
      <div className=`text-sm text-center self-center`>
        <span className=`text-sm`> {tokens->React.string} </span>
        <span className=`text-xs`> {`tkns`->React.string} </span>
        <br className=`mt-1` />
        <span className=`text-xs`> {Js.String.concat(value, `~$`)->React.string} </span>
      </div>
      <div className=`flex flex-col items-center justify-center`>
        <div className=`text-xs text-center text-gray-400`>
          {timeLastUpdated->Globals.formatTimestamp->React.string}
        </div>
        <UserPercentageGains
          tokenPositionLastUpdated=timeLastUpdated currentSyntheticPrice=price tokenAddress
        />
      </div>
      <div className=`self-center`> {children} </div>
    </div>
  }
}
module UserPendingBox = {
  @react.component
  let make = (~name, ~isLong, ~daiSpend, ~marketIndex, ~refetchCallback) => {
    <div
      className=`flex flex-col justify-between w-11/12 mx-auto p-2 mb-2 border-2 border-primary rounded-lg shadow relative`>
      <div className="flex flex-row justify-between">
        <div className=` text-sm self-center`> {name->React.string} </div>
        <div className=` text-sm self-center`> {(isLong ? "Long" : "Short")->React.string} </div>
        <div className=`flex  text-sm self-center`>
          <img src={CONSTANTS.daiDisplayToken.iconUrl} className="h-5 pr-1" />
          {daiSpend->Ethers.Utils.formatEtherToPrecision(2)->React.string}
        </div>
      </div>
      <PendingBar marketIndex refetchCallback />
    </div>
  }
}

module UserFloatEarnedFromStake = {
  @react.component
  let make = (~userId, ~tokenAddress) => {
    let claimableFloat = DataHooks.useTotalClaimableFloatForUser(
      ~userId,
      ~synthTokens=[tokenAddress->Ethers.Utils.ethAdrToLowerStr],
    )
    switch claimableFloat {
    | Response((totalClaimable, totalPredicted)) =>
      <div className="text-xs flex flex-col items-center justify-center">
        <div className="text-gray-500"> {`${Config.floatTokenName} Accruing`->React.string} </div>
        {`~${totalClaimable
          ->Ethers.BigNumber.add(totalPredicted)
          ->Misc.NumberFormat.formatEther(~digits=5)}`->React.string}
      </div>
    | _ => <Loader.Tiny />
    }
  }
}

module UserStakeBox = {
  @react.component
  let make = (~stake: Queries.CurrentStakeDetailed.t, ~children) => {
    let syntheticToken = stake.currentStake.syntheticToken
    let tokenAddress = syntheticToken.id->Ethers.Utils.getAddressUnsafe
    let name = syntheticToken.syntheticMarket.name
    let tokens = stake.currentStake.amount->Misc.NumberFormat.formatEther
    let isLong = syntheticToken.tokenType->Obj.magic == "Long"
    let price = syntheticToken.latestPrice.price.price

    let value =
      stake.currentStake.amount
      ->Ethers.BigNumber.mul(price)
      ->Ethers.BigNumber.div(CONSTANTS.tenToThe18)
      ->Misc.NumberFormat.formatEther
    let creationTxHash = stake.currentStake.creationTxHash

    <div
      className=`flex justify-between w-11/12 mx-auto p-2 mb-2 border-2 border-light-purple rounded-lg z-10 shadow relative`>
      <div className=`pl-3 text-sm self-center`>
        {name->React.string}
        <br className=`mt-1` />
        {(isLong ? `Long↗️` : `Short↘️`)->React.string}
      </div>
      <div className=`text-sm text-center self-center`>
        <span className=`text-sm`> {tokens->React.string} </span>
        <span className=`text-xs`> {`tkns`->React.string} </span>
        <br className=`mt-1` />
        <span className=`text-xs`> {Js.String.concat(value, `~$`)->React.string} </span>
      </div>
      <div className=`flex flex-col items-center justify-center`>
        <a
          href={`${Config.blockExplorer}/tx/${creationTxHash}`}
          target="_"
          rel="noopener noreferrer"
          className="text-xs text-center text-gray-400 hover:opacity-75">
          {stake.currentStake.timestamp->Globals.formatTimestamp->React.string}
        </a>
        <UserPercentageGains
          tokenAddress
          tokenPositionLastUpdated=stake.currentStake.timestamp
          currentSyntheticPrice=price
        />
      </div>
      <div className=`self-center`> {children} </div>
    </div>
  }
}

module UserMarketStakeOrRedeem = {
  @react.component
  let make = (~synthId, ~syntheticSide) => {
    let marketIdResponse = DataHooks.useTokenMarketId(~tokenId=synthId)

    let marketId =
      DataHooks.Util.graphResponseToOption(marketIdResponse)->Option.getWithDefault("1")

    let router = Next.Router.useRouter()
    let stake = _ =>
      router->Next.Router.push(
        `/app/markets?marketIndex=${marketId}&actionOption=${syntheticSide->Obj.magic}&tab=stake`,
      )
    let redeem = _ =>
      router->Next.Router.push(
        `/app/markets?marketIndex=${marketId}&actionOption=${syntheticSide->Obj.magic}&tab=redeem`,
      )

    <div className=`flex flex-col`>
      <Button.Tiny onClick={stake}> {`stake`} </Button.Tiny>
      <Button.Tiny onClick={redeem}> {`redeem`} </Button.Tiny>
    </div>
  }
}

module UserMarketUnstake = {
  @react.component
  let make = (~synthAddress, ~userId, ~isLong) => {
    let synthAddressStr = synthAddress->ethAdrToLowerStr

    let marketIdResponse = DataHooks.useTokenMarketId(~tokenId=synthAddressStr)

    let marketId =
      DataHooks.Util.graphResponseToOption(marketIdResponse)->Option.getWithDefault("1")

    let router = Next.Router.useRouter()
    let unstake = _ =>
      router->Next.Router.push(
        `/app/markets?marketIndex=${marketId}&tab=unstake&actionOption=${isLong
            ? "long"
            : "short"}`,
      )

    let optLoggedInUser = RootProvider.useCurrentUser()
    let isCurrentUser =
      optLoggedInUser->Option.mapWithDefault(false, user => user->ethAdrToLowerStr == userId)

    <div className=`flex flex-col`>
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
      let isLong = syntheticToken.tokenType->Obj.magic == "Long"

      <UserStakeBox key stake>
        // <UserFloatEarnedFromStake tokenAddress={addr} userId />
        <UserMarketUnstake synthAddress={addr} userId isLong />
      </UserStakeBox>
    }, stakes)->React.array

    let totalStakedValue = getUsersTotalStakeValue(~stakes)

    <UserColumnCard>
      <UserColumnHeader> {`Staked assets`->React.string} </UserColumnHeader>
      <UserColumnTextCenter>
        <UserColumnText
          head=`🔐 Staked value`
          body={`$${totalStakedValue.contents->Misc.NumberFormat.formatEther}`}
        />
      </UserColumnTextCenter>
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
    let synthTokensMarketIndexes = stakes->Array.map((stake: Queries.CurrentStakeDetailed.t) => {
      stake.currentStake.syntheticToken.syntheticMarket.id
    })

    let uniqueMarketIndexes = Set.String.fromArray(synthTokensMarketIndexes)

    let uniqueMarketIndexesBigInts =
      uniqueMarketIndexes
      ->Set.String.toArray
      ->Array.map(item => item->Int.fromString->Option.getWithDefault(0)->Ethers.BigNumber.fromInt)

    let floatBalances = DataHooks.useFloatBalancesForUser(~userId)
    let claimableFloat = DataHooks.useTotalClaimableFloatForUser(~userId, ~synthTokens)
    let optLoggedInUser = RootProvider.useCurrentUser()
    let isCurrentUser =
      optLoggedInUser->Option.mapWithDefault(false, user => user->ethAdrToLowerStr == userId)

    <UserColumnCard>
      <UserColumnHeader>
        <div className="flex flex-row items-center justify-center">
          <h3> {`${Config.floatTokenName} rewards`->React.string} </h3>
          <img src="/icons/alpha-float-token.svg" className="ml-2 h-5" />
        </div>
      </UserColumnHeader>
      {switch DataHooks.liftGraphResponse2(floatBalances, claimableFloat) {
      | Loading => <Loader.Mini />
      | GraphError(msg) => msg->React.string
      | Response((floatBalances, (totalClaimable, totalPredicted))) => {
          let floatBalance = floatBalances.floatBalance->Misc.NumberFormat.formatEther(~digits=6)
          let floatMinted = floatBalances.floatMinted->Misc.NumberFormat.formatEther(~digits=6)

          let floatAccrued =
            totalClaimable
            ->Ethers.BigNumber.add(totalPredicted)
            ->Ethers.BigNumber.div(CONSTANTS.twoBN) // TODO: Hackiest hack of hacks temp solution to ensure its understated.
            ->Misc.NumberFormat.formatEther(~digits=6)

          <div
            className=`w-11/12 px-2 mx-auto mb-2 border-2 border-light-purple rounded-lg z-10 shadow`>
            <UserColumnTextList>
              <div className="flex">
                <UserColumnText head={`${Config.floatTokenName} accruing`} body={floatAccrued} />
                <span className="ml-1">
                  <Tooltip
                    tip="This is an estimate at the current time, the amount issued may differ due to changes in market liquidity and asset prices."
                  />
                </span>
              </div>
              <UserColumnText head={`${Config.floatTokenName} balance`} body={floatBalance} />
              <UserColumnText head={`${Config.floatTokenName} minted`} body={floatMinted} />
            </UserColumnTextList>
            {isCurrentUser
              ? <div className=`flex justify-around flex-row my-1`>
                  {`🌊`->React.string}
                  <ClaimFloat marketIndexes=uniqueMarketIndexesBigInts />
                  {`🌊`->React.string}
                </div>
              : React.null}
          </div>
        }
      }}
    </UserColumnCard>
  }
}
