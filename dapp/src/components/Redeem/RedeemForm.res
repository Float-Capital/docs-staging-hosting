module RedeemForm = %form(
  type input = {amount: string}
  type output = {amount: Ethers.BigNumber.t}

  let validators = {
    amount: {
      strategy: OnFirstBlur,
      validate: ({amount}) => Form.Validators.etherNumberInput(amount),
    },
  }
)

let useBalance = (~erc20Address) => {
  let {Swr.data: optBalance} = ContractHooks.useErc20BalanceRefresh(~erc20Address)
  optBalance
}

module RedeemFormInput = {
  @react.component
  let make = (
    ~onSubmit=_ => (),
    ~value="",
    ~optBalance=None,
    ~disabled=false,
    ~onChange=_ => (),
    ~onBlur=_ => (),
    ~onMaxClick=_ => (),
    ~onChangeSide=_ => (),
    ~isLong=false,
    ~hasBothTokens=false,
    ~market: Queries.SyntheticMarketInfo.t,
  ) => {
    let tokenType = isLong ? "long" : "short"
    <Form className="" onSubmit>
      {hasBothTokens
        ? <LongOrShortSelect isLong selectPosition={val => onChangeSide(val)} disabled />
        : React.null}
      <AmountInput value optBalance disabled onBlur onChange placeholder={"Redeem"} onMaxClick />
      <Button onClick={_ => onSubmit()}> {`Redeem ${tokenType} ${market.name}`} </Button>
    </Form>
  }
}

let tokenRedeemPosition = (
  ~market: Queries.SyntheticMarketInfo.t,
  ~isLong,
  ~longTokenBalance,
  ~shortTokenBalance,
) => {
  let hasLongTokens = longTokenBalance->Ethers.BigNumber.gt(CONSTANTS.zeroBN)
  let hasShortTokens = shortTokenBalance->Ethers.BigNumber.gt(CONSTANTS.zeroBN)

  let hasTokens = hasShortTokens || hasLongTokens
  let hasBothTokens = hasShortTokens && hasLongTokens

  let (isActuallyLong, syntheticTokenAddress) = switch hasBothTokens {
  | true =>
    isLong ? (true, market.syntheticLong.tokenAddress) : (false, market.syntheticShort.tokenAddress)
  | false =>
    hasLongTokens
      ? (true, market.syntheticLong.tokenAddress)
      : (false, market.syntheticShort.tokenAddress)
  }

  (isActuallyLong, syntheticTokenAddress, hasTokens, hasBothTokens)
}

let isGreaterThanApproval = (~amount, ~amountApproved) => {
  amount->Ethers.BigNumber.gt(amountApproved)
}
let isGreaterThanBalance = (~amount, ~balance) => {
  amount->Ethers.BigNumber.gt(balance)
}

let useBalanceAndApproved = (~erc20Address, ~spender) => {
  let {Swr.data: optBalance} = ContractHooks.useErc20BalanceRefresh(~erc20Address)
  let {data: optAmountApproved} = ContractHooks.useERC20ApprovedRefresh(~erc20Address, ~spender)
  (optBalance, optAmountApproved)
}

module ConnectedRedeemForm = {
  @react.component
  let make = (~signer, ~market: Queries.SyntheticMarketInfo.t, ~isLong) => {
    let router = Next.Router.useRouter()

    let user = RootProvider.useCurrentUserExn()

    let longTokenBalance =
      DataHooks.useSyntheticTokenBalance(~user, ~tokenAddress=market.syntheticLong.tokenAddress)
      ->DataHooks.Util.graphResponseToOption
      ->Option.getWithDefault(Ethers.BigNumber.fromUnsafe("0"))

    let shortTokenBalance =
      DataHooks.useSyntheticTokenBalance(~user, ~tokenAddress=market.syntheticShort.tokenAddress)
      ->DataHooks.Util.graphResponseToOption
      ->Option.getWithDefault(Ethers.BigNumber.fromUnsafe("0"))

    let (isActuallyLong, syntheticTokenAddress, hasTokens, hasBothTokens) = tokenRedeemPosition(
      ~market,
      ~isLong,
      ~longTokenBalance,
      ~shortTokenBalance,
    )

    let (contractExecutionHandler, txState, _setTxState) = ContractActions.useContractFunction(
      ~signer,
    )

    let (
      contractExecutionHandlerApprove,
      txStateApprove,
      setTxStateApprove,
    ) = ContractActions.useContractFunction(~signer)
    let (
      contractActionToCallAfterApproval,
      setContractActionToCallAfterApproval,
    ) = React.useState(((), ()) => ())

    let initialInput: RedeemForm.input = {
      amount: "",
    }

    let marketIndex = market.marketIndex

    let (optTokenBalance, optTokenAmountApproved) = useBalanceAndApproved(
      ~erc20Address=syntheticTokenAddress,
      ~spender=Config.longShort,
    )

    let form = RedeemForm.useForm(~initialInput, ~onSubmit=({amount}, _form) => {
      let approveFunction = () =>
        contractExecutionHandlerApprove(
          ~makeContractInstance=Contracts.Erc20.make(~address=syntheticTokenAddress),
          ~contractFunction=Contracts.Erc20.approve(
            ~amount=amount->Ethers.BigNumber.mul(Ethers.BigNumber.fromUnsafe("2")),
            ~spender=Config.longShort,
          ),
        )
      let redeemFunction = () =>
        contractExecutionHandler(
          ~makeContractInstance=Contracts.LongShort.make(~address=Config.longShort),
          ~contractFunction={
            isActuallyLong
              ? Contracts.LongShort.redeemLong(~marketIndex, ~tokensToRedeem=amount)
              : Contracts.LongShort.redeemShort(~marketIndex, ~tokensToRedeem=amount)
          },
        )
      let needsToApprove = isGreaterThanApproval(
        ~amount,
        ~amountApproved=optTokenAmountApproved->Option.getWithDefault(
          Ethers.BigNumber.fromUnsafe("0"),
        ),
      )

      switch needsToApprove {
      | true =>
        setContractActionToCallAfterApproval(_ => redeemFunction)
        approveFunction()
      | false => redeemFunction()
      }
    })

    let toastDispatch = React.useContext(ToastProvider.DispatchToastContext.context)

    let optCurrentUser = RootProvider.useCurrentUser()
    let userPage = switch optCurrentUser {
    | Some(address) => `/user/${address->Ethers.Utils.ethAdrToLowerStr}`
    | None => `/`
    }

    // Execute the call after approval has completed
    React.useEffect1(() => {
      switch txStateApprove {
      | Created =>
        toastDispatch(
          ToastProvider.Show(
            `Please approve your ${Config.paymentTokenName} token`,
            "",
            ToastProvider.Info,
          ),
        )
      | Declined(reason) =>
        toastDispatch(
          ToastProvider.Show(
            `The transaction was rejected by your wallet`,
            reason,
            ToastProvider.Error,
          ),
        )
      | SignedAndSubmitted(_) =>
        toastDispatch(ToastProvider.Show(`Approval transaction processing`, "", ToastProvider.Info))
      | Complete(_) =>
        contractActionToCallAfterApproval()
        setTxStateApprove(_ => ContractActions.UnInitialised)
        toastDispatch(
          ToastProvider.Show(`Approve transaction confirmed`, "", ToastProvider.Success),
        )
      | Failed(_) =>
        toastDispatch(ToastProvider.Show(`The transaction failed`, "", ToastProvider.Error))
      | _ => ()
      }
      None
    }, [txStateApprove])

    React.useEffect1(() => {
      switch txState {
      | Created =>
        toastDispatch(
          ToastProvider.Show(`Confirm the transaction to redeem tokens`, "", ToastProvider.Info),
        )
      | SignedAndSubmitted(_) =>
        toastDispatch(ToastProvider.Show(`Redeem transaction pending`, "", ToastProvider.Info))
      | Complete(_) =>
        toastDispatch(ToastProvider.Show(`Redeem transaction confirmed`, "", ToastProvider.Success))
        router->Next.Router.push(userPage)
      | Failed(_) =>
        toastDispatch(ToastProvider.Show(`The transaction failed`, "", ToastProvider.Error))
      | Declined(reason) =>
        toastDispatch(
          ToastProvider.Show(
            `The transaction was rejected by your wallet`,
            reason,
            ToastProvider.Warning,
          ),
        )
      | _ => ()
      }
      None
    }, [txState])

    hasTokens
      ? <RedeemFormInput
          onSubmit=form.submit
          value={form.input.amount}
          optBalance={optTokenBalance}
          disabled=form.submitting
          onBlur={_ => form.blurAmount()}
          onChange={event => form.updateAmount((_, amount) => {
              amount: amount,
            }, (event->ReactEvent.Form.target)["value"])}
          onMaxClick={_ =>
            form.updateAmount(
              (_, amount) => {
                amount: amount,
              },
              switch optTokenBalance {
              | Some(tokenBalance) => tokenBalance->Ethers.Utils.formatEther
              | _ => "0"
              },
            )}
          onChangeSide={newPosition => {
            router.query->Js.Dict.set("actionOption", newPosition)
            router.query->Js.Dict.set(
              "token",
              isActuallyLong
                ? market.syntheticLong.tokenAddress->Ethers.Utils.ethAdrToLowerStr
                : market.syntheticShort.tokenAddress->Ethers.Utils.ethAdrToLowerStr,
            )
            router->Next.Router.pushObjShallow({pathname: router.pathname, query: router.query})
          }}
          market
          isLong={isActuallyLong}
          hasBothTokens
        />
      : <p> {"No tokens in this market to redeem"->React.string} </p>
    // TODO
  }
}

@react.component
let make = (~market: Queries.SyntheticMarketInfo.t, ~isLong) => {
  let optSigner = ContractActions.useSigner()
  let router = Next.Router.useRouter()

  switch optSigner {
  | Some(signer) => <ConnectedRedeemForm signer market isLong />
  | None =>
    <div onClick={_ => router->Next.Router.push(`/login?nextPath=${router.asPath}`)}>
      <RedeemFormInput market isLong hasBothTokens={false} />
    </div>
  }
}
