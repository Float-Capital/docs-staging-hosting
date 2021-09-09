module RedeemForm = %form(
  type input = {amount: string}
  type output = {amount: Ethers.BigNumber.t}

  let validators = {
    amount: {
      strategy: OnFirstSuccessOrFirstBlur,
      validate: ({amount}) => Form.Validators.etherNumberInput(amount),
    },
  }
)

module ApproxDollarReturns = {
  @react.component
  let make = (~tokenPrice, ~value) => {
    let numberStrRegex = %re(`/^[+]?\d+(\.\d+)?$/`)
    let tokenPriceBN =
      numberStrRegex->Js.Re.test_(tokenPrice)
        ? tokenPrice->Ethers.BigNumber.fromUnsafe
        : CONSTANTS.zeroBN
    let valueBN =
      numberStrRegex->Js.Re.test_(value)
        ? Ethers.Utils.parseEtherUnsafe(~amount=value)
        : CONSTANTS.zeroBN
    let dollarValue =
      valueBN->Ethers.BigNumber.mul(tokenPriceBN)->Ethers.BigNumber.div(CONSTANTS.tenToThe18)

    <>
      {numberStrRegex->Js.Re.test_(value)
        ? <div className="flex flex-row items-center justify-end mb-2 w-full text-right">
            <span className="text-xxs text-gray-500 pr-2"> {`approx`->React.string} </span>
            <span className="text-sm text-gray-500"> {`~$`->React.string} </span>
            <span className="text-sm text-gray-800">
              {dollarValue->Misc.NumberFormat.formatEther->React.string}
            </span>
          </div>
        : React.null}
    </>
  }
}

module RedeemFormInput = {
  @react.component
  let make = (
    ~tokenPrice="",
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
    ~submitButton=React.null,
  ) => {
    <Form className="" onSubmit>
      {hasBothTokens
        ? <LongOrShortSelect isLong selectPosition={val => onChangeSide(val)} disabled />
        : React.null}
      <AmountInput value optBalance disabled onBlur onChange onMaxClick />
      <ApproxDollarReturns tokenPrice value />
      {submitButton}
      {value == ""
        ? React.null
        : <p className="text-xxs text-yellow-600 text-center mt-3">
            {`⚡ Redeeming your position requires a second withdraw transaction once the oracle price has updated ⚡`->React.string}
          </p>}
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

let isGreaterThanBalance = (~amount, ~balance) => {
  amount->Ethers.BigNumber.gt(balance)
}

module ConnectedRedeemForm = {
  @react.component
  let make = (
    ~market: Queries.SyntheticMarketInfo.t,
    ~isLong,
    ~contractExecutionHandler,
    ~txState,
    ~setTxState,
  ) => {
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

    let initialInput: RedeemForm.input = {
      amount: "",
    }

    let marketIndex = market.marketIndex

    let {Swr.data: optTokenBalance} = ContractHooks.useErc20BalanceRefresh(
      ~erc20Address=syntheticTokenAddress,
    )

    let form = RedeemForm.useForm(~initialInput, ~onSubmit=({amount}, _form) => {
      contractExecutionHandler(
        ~makeContractInstance=Contracts.LongShort.make(~address=Config.longShort),
        ~contractFunction={
          isActuallyLong
            ? Contracts.LongShort.redeemLongNextPrice(~marketIndex, ~tokensToRedeem=amount)
            : Contracts.LongShort.redeemShortNextPrice(~marketIndex, ~tokensToRedeem=amount)
        },
      )
    })

    let toastDispatch = React.useContext(ToastProvider.DispatchToastContext.context)

    let resetFormButton = () =>
      <Button
        onClick={_ => {
          form.reset()
          setTxState(_ => ContractActions.UnInitialised)
        }}>
        {"Reset & Redeem Again"}
      </Button>

    let formAmount = switch form.amountResult {
    | Some(Ok(amount)) => Some(amount)
    | _ => None
    }

    let (_optAdditionalErrorMessage, buttonText, buttonDisabled) = {
      let position = isLong ? "long" : "short"
      switch (formAmount, optTokenBalance) {
      | (Some(amount), Some(balance)) =>
        let greaterThanBalance = isGreaterThanBalance(~amount, ~balance)
        switch greaterThanBalance {
        | true => (Some("Amount is greater than your balance"), `Insufficient balance`, true)
        | false => (None, `Redeem ${position} ${market.name}`, !form.valid())
        }
      | _ => (None, `Redeem ${position} ${market.name}`, true)
      }
    }

    React.useEffect1(() => {
      switch txState {
      | ContractActions.Created =>
        toastDispatch(
          ToastProvider.Show(`Confirm the transaction to redeem tokens`, "", ToastProvider.Info),
        )
      | SignedAndSubmitted(_) =>
        toastDispatch(ToastProvider.Show(`Redeem transaction pending`, "", ToastProvider.Info))
      | Complete(_) =>
        toastDispatch(ToastProvider.Show(`Redeem transaction confirmed`, "", ToastProvider.Success))
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

    let tokenPrice = isLong
      ? market.latestSystemState.longTokenPrice.price.price->Ethers.BigNumber.toString
      : market.latestSystemState.shortTokenPrice.price.price->Ethers.BigNumber.toString

    hasTokens
      ? <RedeemFormInput
          tokenPrice
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
          isLong={isActuallyLong}
          hasBothTokens
          submitButton={<RedeemSubmitButtonAndTxStatusModal
            buttonText resetFormButton txStateRedeem=txState buttonDisabled
          />}
        />
      : <p> {"No tokens in this market to redeem"->React.string} </p>
  }
}

@react.component
let make = (
  ~market: Queries.SyntheticMarketInfo.t,
  ~isLong,
  ~txState,
  ~setTxState,
  ~contractExecutionHandler,
) => {
  let optSigner = ContractActions.useSigner()
  let router = Next.Router.useRouter()

  switch optSigner {
  | Some(_) => <ConnectedRedeemForm market isLong txState setTxState contractExecutionHandler />
  | None =>
    <div onClick={_ => router->Next.Router.push(`/app/login?nextPath=${router.asPath}`)}>
      <RedeemFormInput isLong hasBothTokens={false} />
    </div>
  }
}
