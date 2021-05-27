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

module UnstakeTxStatusModal = {
  @react.component
  let make = (~txStateUnstake, ~resetFormButton) => {
    switch txStateUnstake {
    | ContractActions.Created =>
      <Modal id={"unstake-1"}>
        <div className="text-center m-3">
          <p> {`Confirm unstake transaction in your wallet `->React.string} </p>
        </div>
      </Modal>
    | ContractActions.SignedAndSubmitted(txHash) =>
      <Modal id={"unstake-2"}>
        <div className="text-center m-3">
          <Loader.Mini />
          <p> {"Unstake transaction pending... "->React.string} </p>
          <ViewOnBlockExplorer txHash />
        </div>
      </Modal>
    | ContractActions.Complete({transactionHash: _}) =>
      <Modal id={"unstake-3"}>
        <div className="text-center m-3">
          <p> {`Transaction complete 🎉`->React.string} </p> {resetFormButton()}
        </div>
      </Modal>
    | ContractActions.Declined(_message) => <> {resetFormButton()} </>
    | ContractActions.Failed(txHash) =>
      <Modal id={"unstake-4"}>
        <div className="text-center m-3">
          <p> {`The transaction failed.`->React.string} </p>
          {if txHash != "" {
            <ViewOnBlockExplorer txHash />
          } else {
            React.null
          }}
          <MessageUsOnDiscord />
          {resetFormButton()}
        </div>
      </Modal>
    | _ => React.null
    }
  }
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
    ~txStateModal=React.null,
    ~buttonDisabled=false,
    ~buttonText,
  ) =>
    <Form className="" onSubmit>
      <AmountInput value optBalance={optBalance} disabled onBlur onChange onMaxClick />
      <Button onClick={_ => onSubmit()} disabled={buttonDisabled}> {buttonText} </Button>
      {txStateModal}
    </Form>
}

module ConnectedStakeForm = {
  @react.component
  let make = (~tokenId, ~signer, ~synthetic: Queries.SyntheticTokenInfo.t) => {
    let (contractExecutionHandler, txState, setTxState) = ContractActions.useContractFunction(
      ~signer,
    )

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
            ~tokenAddress=tokenId->Ethers.Utils.getAddressUnsafe,
            ~amount,
          ),
        )

      stakeAndEarnImmediatlyFunction()
    })

    let toastDispatch = React.useContext(ToastProvider.DispatchToastContext.context)
    let router = Next.Router.useRouter()
    let optCurrentUser = RootProvider.useCurrentUser()

    let userPage = switch optCurrentUser {
    | Some(address) => `/user/${address->Ethers.Utils.ethAdrToLowerStr}`
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
      let defaultButtonText = `Unstake ${synthetic.tokenType->Obj.magic} ${synthetic.syntheticMarket.name}`
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

    <StakeFormInput
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
      txStateModal={<UnstakeTxStatusModal resetFormButton txStateUnstake=txState />}
      buttonDisabled
      buttonText
    />
  }
}

@react.component
let make = (~tokenId) => {
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
    | Some(signer) => <ConnectedStakeForm signer tokenId synthetic />
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
