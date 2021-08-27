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

let initialInput: StakeForm.input = {
  amount: "",
}

module StakeFormInput = {
  @react.component
  let make = (
    ~onSubmit=_ => (),
    ~value="",
    ~optBalance=None,
    ~buttonDisabled=false,
    ~disabled=false,
    ~onChange=_ => (),
    ~onBlur=_ => (),
    ~onMaxClick=_ => (),
    ~synthetic: Queries.SyntheticTokenInfo.t,
    ~txStatusModals=React.null,
    ~resetFormButton=_ => React.null,
    ~tokenToStake="",
    ~txStateStake=ContractActions.UnInitialised,
  ) => {
    let _ = StakeTxStatusModal.useStakeTxModal(~txStateStake, ~resetFormButton, ~tokenToStake)
    <Form className="mx-auto w-full" onSubmit>
      <AmountInput value optBalance disabled onBlur onChange onMaxClick />
      <Button disabled=buttonDisabled onClick={_ => ()}>
        {`Stake ${synthetic.tokenType->Obj.magic} ${synthetic.syntheticMarket.name}`}
      </Button>
      {txStatusModals}
    </Form>
  }
}

module ConnectedStakeForm = {
  @react.component
  let make = (~tokenId, ~signer, ~synthetic: Queries.SyntheticTokenInfo.t) => {
    let (contractExecutionHandler, txState, setTxState) = ContractActions.useContractFunction(
      ~signer,
    )

    let user = RootProvider.useCurrentUserExn()
    let optTokenBalance =
      DataHooks.useSyntheticTokenBalance(
        ~user,
        ~tokenAddress=synthetic.tokenAddress,
      )->DataHooks.Util.graphResponseToOption

    let toastDispatch = React.useContext(ToastProvider.DispatchToastContext.context)

    React.useEffect1(() => {
      switch txState {
      | Created =>
        toastDispatch(
          ToastProvider.Show(`Confirm the transaction to stake`, "", ToastProvider.Info),
        )
      | SignedAndSubmitted(_) =>
        toastDispatch(ToastProvider.Show(`Staking transaction pending`, "", ToastProvider.Info))
      | Complete(_) =>
        toastDispatch(
          ToastProvider.Show(`Staking transaction confirmed`, "", ToastProvider.Success),
        )
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

    let form = StakeForm.useForm(~initialInput, ~onSubmit=({amount}, _form) => {
      contractExecutionHandler(
        ~makeContractInstance=Contracts.Synth.make(~address=tokenId->Ethers.Utils.getAddressUnsafe),
        ~contractFunction=Contracts.Synth.stake(~amount),
      )
    })

    let formAmount = switch form.amountResult {
    | Some(Ok(amount)) => Some(amount)
    | _ => None
    }

    let buttonDisabled = {
      let baseFormDisabled = form.submitting || !form.valid()
      switch (formAmount, optTokenBalance) {
      | (Some(amount), Some(amountStaked)) =>
        let greaterThanBalance = amount->Ethers.BigNumber.gt(amountStaked)
        switch greaterThanBalance {
        | true => true
        | false => baseFormDisabled
        }
      | _ => baseFormDisabled
      }
    }

    let tokenToStake = `${synthetic.tokenType->Obj.magic} ${synthetic.syntheticMarket.name}`

    let resetFormButton = () =>
      <Button
        onClick={_ => {
          form.reset()
          setTxState(_ => ContractActions.UnInitialised)
        }}>
        {"Reset & Stake Again"}
      </Button>

    <StakeFormInput
      onSubmit=form.submit
      value={form.input.amount}
      optBalance={optTokenBalance}
      disabled={form.submitting}
      buttonDisabled
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
      synthetic
      resetFormButton
      tokenToStake
      txStateStake=txState
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
            <StakeFormInput disabled=true synthetic />
          </div>
    }
  | {data: None, error: None, loading: false}
  | {data: Some({syntheticToken: None}), error: None, loading: false} => <>
      {"Could not find this market - please check the URL carefully."->React.string}
    </>
  }
}
