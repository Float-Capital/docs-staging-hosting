module Tab = {
  @react.component
  let make = (~selected=false, ~text, ~onClick=_ => ()) => {
    let bg = selected ? "bg-white" : "bg-gray-100"
    let opacity = selected ? "bg-opacity-70" : "opacity-70"
    let margin = !selected ? "mb-0.5" : "pb-1.5"
    <li className="mr-1 md:mr-2 mb-0">
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

type tab = Mint | Redeem | Stake | Unstake

let allTabs = [Mint, Redeem, Stake, Unstake]

let tabToStr = tab =>
  switch tab {
  | Mint => "Mint"
  | Redeem => "Redeem"
  | Stake => "Stake"
  | Unstake => "Unstake"
  }

let strToTab = tab =>
  switch tab->Js.String.toLowerCase {
  | "mint" => Mint
  | "redeem" => Redeem
  | "stake" => Stake
  | "unstake" => Unstake
  | _ => Mint
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
    shortBalance,
    longBalance,
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

let header = (~marketInfo: DataHooks.graphResponse<marketInfo>) => {
  switch marketInfo {
  | Response({marketName, marketSymbol}) =>
    <div className="flex justify-between mb-2 pt-6 pl-6">
      {`${marketName} (${marketSymbol})`->React.string}
    </div>
  | _ => React.null
  }
}

module SelectOptions = {
  @react.component
  let make = (~isLong, ~marketInfo, ~disabled=false) => {
    let router = Next.Router.useRouter()
    marketInfo->Option.mapWithDefault(React.null, marketInfo => {
      let onChangeSide = newPosition => {
        router.query->Js.Dict.set("actionOption", newPosition)
        router.query->Js.Dict.set(
          "token",
          isLong
            ? marketInfo.longAddress->Ethers.Utils.ethAdrToLowerStr
            : marketInfo.shortAddress->Ethers.Utils.ethAdrToLowerStr,
        )
        router->Next.Router.pushObjShallow({pathname: router.pathname, query: router.query})
      }
      <div className="px-6">
        <LongOrShortSelect isLong selectPosition={val => onChangeSide(val)} disabled />
      </div>
    })
  }
}

let wrapper = (~children) => <div className="pb-6 px-6"> {children} </div>

module NoBalancesView = {
  @react.component
  let make = (~interaction=_ => (), ~text, ~buttonText="") => <>
    <div className="py-4 mx-auto flex flex-col items-center">
      {text->React.string}
      <div className="py-2 w-24">
        {<Button.Small onClick={interaction}> {buttonText} </Button.Small>}
      </div>
    </div>
  </>
}

module UnstakeOrStakeInteractionWrapper = {
  type showable = Show | DontShow

  type display =
    Loading | Default | Form({selectOptions: showable, tokenId: string}) | Error(string)

  let determineDisplay = (
    ~user,
    ~userHasPositions,
    ~isLong,
    ~marketInfo: DataHooks.graphResponse<marketInfo>,
  ) => {
    switch user {
    | Some(_) =>
      switch marketInfo {
      | Response({longId, shortId}) => {
          let chosenTokenId = isLong ? longId : shortId
          switch userHasPositions {
          | Some(positions) =>
            switch positions {
            | {hasLong: true, hasShort: true} => Form({selectOptions: Show, tokenId: chosenTokenId})
            | {hasLong: false, hasShort: false} => Default
            | {hasLong: true, hasShort: false} => Form({tokenId: longId, selectOptions: DontShow})
            | {hasLong: false, hasShort: true} => Form({tokenId: shortId, selectOptions: DontShow})
            }
          | None => Loading
          }
        }
      | Loading => Loading
      | GraphError(s) => Error(s)
      }
    | None => Default
    }
  }

  type formProps = {"tokenId": string}
  @react.component
  let make = (
    ~isLong,
    ~marketInfo: DataHooks.graphResponse<marketInfo>,
    ~user,
    ~userHasPositions,
    ~form: React.component<formProps>,
    ~default: React.element,
  ) => {
    let optMarketInfo = marketInfo->DataHooks.Util.graphResponseToOption
    let display = determineDisplay(~user, ~userHasPositions, ~marketInfo, ~isLong)
    switch display {
    | Form({selectOptions, tokenId}) => <>
        {switch selectOptions {
        | Show => <SelectOptions isLong marketInfo=optMarketInfo />
        | DontShow => React.null
        }}
        {wrapper(~children=React.createElement(form, {"tokenId": tokenId}))}
      </>
    | Default => default
    | Loading => <MiniLoader />
    | Error(s) => <div className="p-6"> {s->React.string} </div>
    }
  }
}

@react.component
let make = () => {
  let router = Next.Router.useRouter()
  let user = RootProvider.useCurrentUser()

  let selectedTab = router.query->Js.Dict.get("tab")->Option.getWithDefault("Mint")
  let (selected, setSelected) = React.useState(_ => selectedTab->strToTab)
  let actionOption = router.query->Js.Dict.get("actionOption")->Option.getWithDefault("short")
  let longSelected = actionOption == "long"
  let marketInfo = useMarketInfo()
  let userHasBalances = useUserHasBalances(
    ~user,
    ~marketInfo=marketInfo->DataHooks.Util.graphResponseToOption,
  )
  let userHasStakes = useUserHasStakes(
    ~user,
    ~marketInfo=marketInfo->DataHooks.Util.graphResponseToOption,
  )
  <div className="flex-1">
    <ul className="list-reset flex items-end">
      {allTabs
      ->Array.map(tab => {
        <Tab
          text={tab->tabToStr}
          key={tab->tabToStr}
          selected={tab == selected}
          onClick={_ => {
            setSelected(_ => tab)
            router.query->Js.Dict.set("tab", tab->tabToStr->Js.String.toLowerCase)
            router->Next.Router.pushObjShallow({pathname: router.pathname, query: router.query})
          }}
        />
      })
      ->React.array}
    </ul>
    <div
      className="rounded-b-lg min-h-market-interaction-card rounded-r-lg flex flex-col bg-white bg-opacity-70 shadow-lg">
      {header(~marketInfo)}
      {switch selected {
      | Mint =>      
      <Mint.Mint withHeader={false} />
      | Redeem => {
          let {determineDisplay} = module(UnstakeOrStakeInteractionWrapper)
          let display = determineDisplay(
            ~marketInfo,
            ~userHasPositions=userHasBalances,
            ~user,
            ~isLong=longSelected,
          )
          if display !== Default {
            wrapper(~children=<Redeem />)
          } else {
            <NoBalancesView
              text="No tokens for this market."
              interaction={_ => setSelected(_ => Mint)}
              buttonText={"Mint"}
            />
          }
        }
      | Stake =>
        <UnstakeOrStakeInteractionWrapper
          userHasPositions={userHasBalances}
          isLong=longSelected
          marketInfo
          user
          form={StakeForm.make}
          default={<NoBalancesView
            text="No tokens for this market."
            interaction={_ => setSelected(_ => Mint)}
            buttonText={"Mint"}
          />}
        />
      | Unstake => {
          let userHasNoStakesAndNoBalances = switch (user, userHasBalances) {
          | (None, _)
          | (_, Some({hasLong: false, hasShort: false})) => true
          | _ => false
          }

          <UnstakeOrStakeInteractionWrapper
            userHasPositions={userHasStakes}
            isLong=longSelected
            marketInfo
            default={<NoBalancesView
              text={userHasNoStakesAndNoBalances
                ? "No tokens or stakes for this market."
                : "No stakes for this market."}
              interaction={_ =>
                userHasNoStakesAndNoBalances ? setSelected(_ => Mint) : setSelected(_ => Stake)}
              buttonText={userHasNoStakesAndNoBalances ? "MINT" : "STAKE"}
            />}
            user
            form={Unstake.make}
          />
        }
      }}
    </div>
  </div>
}
