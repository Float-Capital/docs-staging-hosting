module Tab = {
  @react.component
  let make = (~selected=false, ~text, ~onClick=_ => ()) => {
    let bg = selected ? "bg-white" : "bg-gray-100"
    let opacity = selected ? "bg-opacity-70" : "opacity-70"
    let margin = !selected ? "mb-0.5" : "pb-1.5"
    <li className="mr-3 mb-0">
      <div
        className={`${bg}  ${opacity}  ${margin} cursor-pointer inline-block rounded-t-lg py-1 px-4`}
        onClick>
        {text->React.string}
      </div>
    </li>
  }
}

let onlyIfAllSomeWithDefault4 = (list, default, fn) =>
  switch list {
  | (None, _, _, _)
  | (_, None, _, _)
  | (_, _, None, _)
  | (_, _, _, None) => default
  | (Some(a), Some(b), Some(c), Some(d)) => fn(a, b, c, d)
  }

let onlyIfAllSomeWithDefault3 = (list, default, fn) =>
  switch list {
  | (None, _, _)
  | (_, None, _)
  | (_, _, None) => default
  | (Some(a), Some(b), Some(c)) => fn(a, b, c)
  }

let optAddressWithDefaultZero = optAddress =>
  optAddress->Option.getWithDefault(CONSTANTS.zeroAddress)

module MarketInteractionCard = {
  type tab = Mint | Redeem | Stake | Unstake

  let allTabs = [Mint, Redeem, Stake, Unstake]

  let tabToStr = tab =>
    switch tab {
    | Mint => "Mint"
    | Redeem => "Redeem"
    | Stake => "Stake"
    | Unstake => "Unstake"
    }

  type marketInfo = {
    longId: string,
    shortId: string,
    marketName: string,
    marketSymbol: string,
    longAddress: Ethers.ethAddress,
    shortAddress: Ethers.ethAddress,
  }

  type userHasPositionsForMarket = {
    hasLong: bool,
    hasShort: bool,
  }

  let defaultUserHasPositions = {
    hasLong: false,
    hasShort: false,
  }

  let useUserHasBalances = (~user, ~marketInfo) => {
    let userOrZeroAddress = user->optAddressWithDefaultZero
    let (longAddressOrZeroAddress, shortAddressOrZeroAddress) =
      marketInfo->Option.mapWithDefault((CONSTANTS.zeroAddress, CONSTANTS.zeroAddress), ({
        longAddress,
        shortAddress,
      }) => (longAddress, shortAddress))

    let hasLongBalance =
      DataHooks.useSyntheticTokenBalanceOrZero(
        ~user=userOrZeroAddress,
        ~tokenAddress=longAddressOrZeroAddress,
      )->DataHooks.Util.graphResponseToOption
    let hasShortBalance =
      DataHooks.useSyntheticTokenBalanceOrZero(
        ~user=userOrZeroAddress,
        ~tokenAddress=shortAddressOrZeroAddress,
      )->DataHooks.Util.graphResponseToOption

    (user, marketInfo, hasShortBalance, hasLongBalance)->onlyIfAllSomeWithDefault4(None, (
      _,
      _,
      longBalance,
      shortBalance,
    ) => {
      Some({
        hasLong: longBalance->Ethers.BigNumber.gt(CONSTANTS.zeroBN),
        hasShort: shortBalance->Ethers.BigNumber.gt(CONSTANTS.zeroBN),
      })
    })
  }

  let useUserHasStakes = (~user, ~marketInfo) => {
    let userOrZeroAddress = user->optAddressWithDefaultZero
    let userStakes =
      DataHooks.useStakesForUser(
        ~userId=userOrZeroAddress->Ethers.Utils.ethAdrToLowerStr,
      )->DataHooks.Util.graphResponseToOption
    (user, marketInfo, userStakes)->onlyIfAllSomeWithDefault3(None, (_, marketInfo, stakes) => {
      Some(
        stakes->Array.reduce({hasLong: false, hasShort: false}, (
          previousAnswer,
          {currentStake: {syntheticToken: {tokenAddress}}},
        ) => {
          hasLong: previousAnswer.hasLong || tokenAddress == marketInfo.longAddress,
          hasShort: previousAnswer.hasShort || tokenAddress == marketInfo.shortAddress,
        }),
      )
    })
  }

  let useMarketInfo = () => {
    let markets = Queries.MarketDetails.use()
    let router = Next.Router.useRouter()
    let marketIndex = router.query->Js.Dict.get("marketIndex")->Option.getWithDefault("1")

    markets
    ->DataHooks.Util.queryToResponse
    ->(
      (response: DataHooks.graphResponse<Queries.MarketDetails.MarketDetails_inner.t>) =>
        switch response {
        | Loading => {
            let loading: DataHooks.graphResponse<marketInfo> = Loading
            loading
          }
        | GraphError(s) => GraphError(s)
        | Response({syntheticMarkets}) =>
          let optFirstMarket =
            syntheticMarkets[marketIndex->Belt.Int.fromString->Option.getWithDefault(1) - 1]
          optFirstMarket->Option.mapWithDefault(
            {
              let error: DataHooks.graphResponse<marketInfo> = GraphError("Market doesn't exist")
              error
            },
            market => {
              let {
                name: marketName,
                symbol: marketSymbol,
                syntheticLong: {id: longId, tokenAddress: longAddress},
                syntheticShort: {id: shortId, tokenAddress: shortAddress},
              } = market
              Response({
                longId: longId,
                shortId: shortId,
                marketName: marketName,
                marketSymbol: marketSymbol,
                longAddress: longAddress,
                shortAddress: shortAddress,
              })
            },
          )
        }
    )
  }

  let isActuallyLong = (userPositions, isLong) => {
    switch userPositions {
    | None => false
    | Some(positions) =>
      if positions.hasLong && positions.hasShort {
        isLong
      } else if positions.hasLong {
        true
      } else {
        false
      }
    }
  }

  let onlyIfSomeTokensWithDefault = (~userHasPositions, ~component, ~default) => {
    userHasPositions->Option.mapWithDefault(<MiniLoader />, userPos => {
      if userPos.hasLong || userPos.hasShort {
        component
      } else {
        default
      }
    })
  }

  let header = (~marketInfo: DataHooks.graphResponse<marketInfo>) => {
    switch marketInfo {
    | Response({marketName, marketSymbol}) =>
      <div className="flex justify-between mb-2 pt-6 pl-6">
        {`${marketName} (${marketSymbol})`->React.string}
      </div>
    | _ => React.null
    }
  }

  module MaybeSelectOptions = {
    @react.component
    let make = (~userHasPositions, ~isLong, ~marketInfo) => {
      let hasBothTokens = userHasPositions.hasLong && userHasPositions.hasShort
      let router = Next.Router.useRouter()
      marketInfo->Option.mapWithDefault(React.null, marketInfo => {
        let onChangeSide = event => {
          router.query->Js.Dict.set("mintOption", (event->ReactEvent.Form.target)["value"])
          router.query->Js.Dict.set(
            "token",
            isLong
              ? marketInfo.longAddress->Ethers.Utils.ethAdrToLowerStr
              : marketInfo.shortAddress->Ethers.Utils.ethAdrToLowerStr,
          )
          router->Next.Router.pushObjShallow({pathname: router.pathname, query: router.query})
        }
        hasBothTokens
          ? <div className="px-6">
              <select
                name="longshort"
                className="trade-select"
                onChange=onChangeSide
                value={isLong ? "long" : "short"}>
                <option value="long"> {`Long 🐮`->React.string} </option>
                <option value="short"> {`Short 🐻`->React.string} </option>
              </select>
            </div>
          : React.null
      })
    }
  }

  let wrapper = (~children) => <div className="pb-6 px-6"> {children} </div>

  module StakeInteractionWrapper = {
    @react.component
    let make = (~isLong, ~marketInfo: DataHooks.graphResponse<marketInfo>, ~user) => {
      let optMarketInfo = marketInfo->DataHooks.Util.graphResponseToOption
      let userHasPositions = useUserHasBalances(~marketInfo=optMarketInfo, ~user)
      let actuallyLong = isActuallyLong(userHasPositions, isLong)
      <>
        {onlyIfSomeTokensWithDefault(
          ~userHasPositions,
          ~component=<>
            {userHasPositions->Option.mapWithDefault(React.null, userPos =>
              <MaybeSelectOptions userHasPositions={userPos} isLong marketInfo=optMarketInfo />
            )}
            {switch marketInfo {
            | Response({longId, shortId}) => {
                let tokenId = actuallyLong ? longId : shortId
                wrapper(~children=<StakeForm tokenId={tokenId} />)
              }
            | Loading => <MiniLoader />
            | GraphError(s) => <div> {s->React.string} </div>
            }}
          </>,
          ~default=<div className="pl-6">
            {"No tokens in this market to stake"->React.string}
          </div>,
        )}
      </>
    }
  }

  module UnstakeInteractionWrapper = {
    @react.component
    let make = (~isLong, ~marketInfo: DataHooks.graphResponse<marketInfo>, ~user) => {
      let optMarketInfo = marketInfo->DataHooks.Util.graphResponseToOption
      let userHasPositions = useUserHasStakes(~marketInfo=optMarketInfo, ~user)
      let actuallyLong = isActuallyLong(userHasPositions, isLong)

      <>
        {onlyIfSomeTokensWithDefault(
          ~userHasPositions,
          ~component=<>
            {userHasPositions->Option.mapWithDefault(React.null, userPos =>
              <MaybeSelectOptions userHasPositions={userPos} isLong marketInfo=optMarketInfo />
            )}
            {switch marketInfo {
            | Response({longId, shortId}) => {
                let tokenId = actuallyLong ? longId : shortId
                wrapper(~children=<Unstake tokenId={tokenId} />)
              }
            | Loading => <MiniLoader />
            | GraphError(s) => <div> {s->React.string} </div>
            }}
          </>,
          ~default=<div className="pl-6">
            {"No stakes in this market to unstake"->React.string}
          </div>,
        )}
      </>
    }
  }

  @react.component
  let make = () => {
    let router = Next.Router.useRouter()
    let user = RootProvider.useCurrentUser()
    let (selected, setSelected) = React.useState(_ => Mint)
    let mintOption = router.query->Js.Dict.get("mintOption")->Option.getWithDefault("short")
    let longSelected = mintOption == "long"
    let marketInfo = useMarketInfo()
    <div className="flex-1 p-1 mb-2 ">
      <ul className="list-reset flex items-end">
        {allTabs
        ->Array.map(tab => {
          <Tab
            text={tab->tabToStr}
            key={tab->tabToStr}
            selected={tab == selected}
            onClick={_ => setSelected(_ => tab)}
          />
        })
        ->React.array}
      </ul>
      <div
        className="rounded-b-lg min-h-market-interaction-card rounded-r-lg flex flex-col bg-white bg-opacity-70 shadow-lg">
        {selected != Mint ? header(~marketInfo) : React.null}
        {switch selected {
        | Mint => <Mint.Mint />
        | Redeem => wrapper(~children=<Redeem />)
        | Stake => <StakeInteractionWrapper isLong=longSelected marketInfo user />
        | Unstake => <UnstakeInteractionWrapper isLong=longSelected marketInfo user />
        }}
      </div>
    </div>
  }
}
@react.component
let make = (~marketData: Queries.MarketDetails.t_syntheticMarkets) => {
  <div>
    <Next.Link href="/markets">
      <div className="uppercase text-sm text-gray-600 hover:text-gray-500 cursor-pointer mt-2">
        {`◀`->React.string} <span className="text-xs"> {" Back to markets"->React.string} </span>
      </div>
    </Next.Link>
    <div className="flex flex-col md:flex-row justify-center items-stretch">
      <MarketInteractionCard />
      <div
        className="flex-1 w-full min-h-10 p-1 mb-2 ml-8 rounded-lg flex flex-col bg-white bg-opacity-70 shadow-lg">
        <PriceGraph marketName={marketData.name} />
      </div>
    </div>
    <MarketCard marketData />
  </div>
}
