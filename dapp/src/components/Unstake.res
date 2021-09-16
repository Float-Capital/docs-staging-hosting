module ApproxDollarFeeUnstake = {
  open Ethers.BigNumber

  @react.component
  let make = (~tokenPrice, ~value) => {
    switch (tokenPrice, value) {
    | (Some(tokenPrice), Some(value)) => {
        let dollarValue =
          tokenPrice->mul(value)->mul(CONSTANTS.unstakeFeeHardCode)->div(CONSTANTS.tenToThe36)

        let dollarValueStr = dollarValue->Misc.NumberFormat.formatEther

        if dollarValueStr != "0.00" {
          <div className="flex flex-row items-center justify-end mb-2 w-full text-right">
            <span className="text-xxs text-gray-500 pr-2"> {`unstake fee`->React.string} </span>
            <span className="text-xxs text-gray-500 pr-2"> {`approx`->React.string} </span>
            <span className="text-sm text-gray-500"> {`~$`->React.string} </span>
            <span className="text-sm text-gray-800"> {dollarValueStr->React.string} </span>
          </div>
        } else {
          React.null
        }
      }
    | _ => React.null
    }
  }
}

module StakeForm = %form(
  type input = {amount: string}
  type output = {amount: Ethers.BigNumber.t}

  let validators = {
    amount: {
      strategy: OnFirstSuccessOrFirstBlur,
      validate: ({amount}) => Form.Validators.etherNumberInput(amount),
    },
  }
)

let {toNumber} = module(Ethers.BigNumber)

let useUnstakeModal = (~txStateUnstake) => {
  let {showModal, hideModal} = ModalProvider.useModalDisplay()

  React.useEffect1(_ => {
    switch txStateUnstake {
    | ContractActions.Created =>
      showModal(
        <div className="text-center m-3">
          <p> {`Confirm unstake transaction in your wallet `->React.string} </p>
        </div>,
      )
    | ContractActions.SignedAndSubmitted(txHash) =>
      showModal(
        <div className="text-center m-3">
          <Loader.Mini />
          <p> {"Unstake transaction pending... "->React.string} </p>
          <ViewOnBlockExplorer txHash />
        </div>,
      )
    | ContractActions.Complete({transactionHash}) =>
      showModal(
        <div className="text-center m-3">
          <p> {`Transaction complete 🎉`->React.string} </p>
          <ViewOnBlockExplorer txHash=transactionHash />
          <ViewProfileButton />
        </div>,
      )
    | ContractActions.Failed(txHash) =>
      showModal(
        <div className="text-center m-3">
          <p> {`The transaction failed.`->React.string} </p>
          {if txHash != "" {
            <ViewOnBlockExplorer txHash />
          } else {
            React.null
          }}
          <MessageUsOnDiscord />
        </div>,
      )
    | _ => hideModal()
    }
    None
  }, [txStateUnstake])
}

module StakeFormInput = {
  @react.component
  let make = (
    ~onSubmit=_ => (),
    ~value="",
    ~optBalance=None,
    ~disabled=false,
    ~onChange=_ => (),
    ~onBlur=_ => (),
    ~onMaxClick=_ => (),
    ~resetButton=_ => React.null,
    ~buttonDisabled=false,
    ~buttonText,
    ~tokens=None,
    ~tokenPrice=None,
    ~txState=ContractActions.UnInitialised,
  ) => {
    <Form className="" onSubmit>
      <AmountInput value optBalance={optBalance} disabled onBlur onChange onMaxClick />
      <ApproxDollarFeeUnstake tokenPrice={tokenPrice} value={tokens} />
      {switch txState {
      | ContractActions.UnInitialised
      | ContractActions.Created
      | ContractActions.Declined(_) =>
        <Button onClick={_ => onSubmit()} disabled={buttonDisabled}> {buttonText} </Button>
      | _ => resetButton()
      }}
      {value == ""
        ? React.null
        : <p
            className="text-xxs text-yellow-600 text-center mt-3 flex justify-center items-center w-full">
            <span> {`⚡ We charge a small unstake fee on your tokens`->React.string} </span>
            <span className="text-black mx-1 "> <Tooltip tip={"5 basis points"} /> </span> // TODO: Not hardcode
            <span> {`⚡`->React.string} </span>
          </p>}
    </Form>
  }
}

module ConnectedStakeForm = {
  @react.component
  let make = (
    ~synthetic as {
      id: tokenId,
      syntheticMarket: {marketIndex, name: syntheticMarketName},
      tokenType,
      latestPrice: {price: {price}},
    }: Queries.SyntheticTokenInfo.t,
    ~contractExecutionHandler,
    ~txState: ContractActions.transactionState,
    ~setTxState,
  ) => {
    let user = RootProvider.useCurrentUserExn()

    let optTokenBalance =
      DataHooks.useStakesForUser(~userId=user->Ethers.Utils.ethAdrToLowerStr)
      ->DataHooks.Util.graphResponseToOption
      ->Option.flatMap(a =>
        (
          a->Array.keep(({currentStake: {syntheticToken: {id}}}) => id == tokenId)
        )[0]->Option.flatMap(({currentStake: {amount}}) => Some(amount))
      )

    let initialInput: StakeForm.input = {
      amount: "",
    }

    let form = StakeForm.useForm(~initialInput, ~onSubmit=({amount}, _form) => {
      let stakeAndEarnImmediatlyFunction = () =>
        contractExecutionHandler(
          ~makeContractInstance=Contracts.Staker.make(~address=Config.staker),
          ~contractFunction=Contracts.Staker.withdraw(
            ~marketIndex=marketIndex->toNumber,
            ~isWithdrawFromLong=tokenType == #Long,
            ~amount,
          ),
        )

      stakeAndEarnImmediatlyFunction()
    })

    let toastDispatch = React.useContext(ToastProvider.DispatchToastContext.context)
    let router = Next.Router.useRouter()
    let optCurrentUser = RootProvider.useCurrentUser()

    let userPage = switch optCurrentUser {
    | Some(address) => `/app/user/${address->Ethers.Utils.ethAdrToLowerStr}`
    | None => `/`
    }

    React.useEffect1(() => {
      switch txState {
      | Created =>
        toastDispatch(
          ToastProvider.Show(`Confirm the transaction to unstake`, "", ToastProvider.Info),
        )
      | SignedAndSubmitted(_) =>
        toastDispatch(ToastProvider.Show(`Unstake transaction pending`, "", ToastProvider.Info))
      | Complete(_) =>
        toastDispatch(
          ToastProvider.Show(`Unstake transaction confirmed`, "", ToastProvider.Success),
        )
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

    let resetFormButton = () =>
      <Button
        onClick={_ => {
          form.reset()
          setTxState(_ => ContractActions.UnInitialised)
        }}>
        {"Reset & Unstake Again"}
      </Button>

    let formAmount = switch form.amountResult {
    | Some(Ok(amount)) => Some(amount)
    | _ => None
    }

    let (_optAdditionalErrorMessage, buttonText, buttonDisabled) = {
      let defaultButtonText = `Unstake ${tokenType->Obj.magic} ${syntheticMarketName}`
      switch (formAmount, optTokenBalance) {
      | (Some(amount), Some(balance)) => {
          let greaterThanBalance = amount->Ethers.BigNumber.gt(balance)
          switch greaterThanBalance {
          | true => (Some("Amount is greater than your balance"), `Insufficient balance`, true)
          | false => (None, defaultButtonText, form.submitting || !form.valid())
          }
        }

      | _ => (None, defaultButtonText, true)
      }
    }

    let formAmount = switch form.amountResult {
    | Some(Ok(amount)) => Some(amount)
    | _ => None
    }

    <StakeFormInput
      onSubmit=form.submit
      value={form.input.amount}
      optBalance={optTokenBalance}
      disabled=form.submitting
      onBlur={_ => form.blurAmount()}
      tokens={formAmount}
      tokenPrice={Some(price)}
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
      resetButton={resetFormButton}
      txState
      buttonDisabled
      buttonText
    />
  }
}

@react.component
let make = (~tokenId, ~contractExecutionHandler, ~txState, ~setTxState) => {
  let token = Queries.SyntheticToken.use({tokenId: tokenId})
  let (showLogin, setShowLogin) = React.useState(() => false)
  let optSigner = ContractActions.useSigner()

  switch token {
  | {error: Some(_error)} => {
      Js.log("Unable to fetch token")
      <> {"Unable to fetch token"->React.string} </>
    }
  | {loading: true} => <Loader.Mini />
  | {data: Some({syntheticToken: Some(synthetic)})} =>
    switch optSigner {
    | Some(_) => <ConnectedStakeForm synthetic contractExecutionHandler txState setTxState />
    | None =>
      showLogin
        ? <Login />
        : <div onClick={_ => setShowLogin(_ => true)}>
            <StakeFormInput
              disabled=true
              buttonText={`Unstake ${synthetic.tokenType->Obj.magic} ${synthetic.syntheticMarket.name}`}
            />
          </div>
    }
  | {data: None, error: None, loading: false}
  | {data: Some({syntheticToken: None}), error: None, loading: false} => <>
      {"Could not find this market - please check the URL carefully."->React.string}
    </>
  }
}
