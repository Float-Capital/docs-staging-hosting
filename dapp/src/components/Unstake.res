module StakeForm = %form(
  type input = {amount: string}
  type output = {amount: Ethers.BigNumber.t}

  let validators = {
    amount: {
      strategy: OnFirstBlur,
      validate: ({amount}) => Form.Validators.etherNumberInput(amount),
    },
  }
)

let useBalanceAndApproved = (~erc20Address, ~spender) => {
  let {Swr.data: optBalance} = ContractHooks.useErc20BalanceRefresh(~erc20Address)
  let {data: optAmountApproved} = ContractHooks.useERC20ApprovedRefresh(~erc20Address, ~spender)
  (optBalance, optAmountApproved)
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
    ~synthetic: Queries.SyntheticTokenInfo.t,
  ) =>
    <Form className="" onSubmit>
      // optBalance Todo
      <AmountInput
        value optBalance={None} disabled onBlur onChange placeholder={"Unstake"} onMaxClick
      />
      <Button onClick={_ => onSubmit()}>
        {`Unstake ${synthetic.tokenType->Obj.magic} ${synthetic.syntheticMarket.name}`}
      </Button>
    </Form>
}

module ConnectedStakeForm = {
  @react.component
  let make = (~tokenId, ~signer, ~synthetic: Queries.SyntheticTokenInfo.t) => {
    let (contractExecutionHandler, _txState, _setTxState) = ContractActions.useContractFunction(
      ~signer,
    )

    let stakerContractAddress = Config.useStakerAddress()

    let user = RootProvider.useCurrentUserExn()
    let optTokenBalance =
      DataHooks.useSyntheticTokenBalance(
        ~user,
        ~tokenAddress=synthetic.tokenAddress,
      )->DataHooks.Util.graphResponseToOption

    let initialInput: StakeForm.input = {
      amount: "",
    }

    let form = StakeForm.useForm(~initialInput, ~onSubmit=({amount}, _form) => {
      let stakeAndEarnImmediatlyFunction = () =>
        contractExecutionHandler(
          ~makeContractInstance=Contracts.Staker.make(~address=stakerContractAddress),
          ~contractFunction=Contracts.Staker.withdraw(
            ~tokenAddress=tokenId->Ethers.Utils.getAddressUnsafe,
            ~amount,
          ),
        )

      stakeAndEarnImmediatlyFunction()
    })

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
      synthetic
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
  | {loading: true} => <Loader />
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
